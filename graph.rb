class EquationVertex
	attr_accessor :actual, :connecting_vertices, :visited
	def initialize actual
		@actual, @connecting_vertices, @visited = actual, [], false
	end
	def is? another_equation
		params = @connecting_vertices.map { |v| v.parameter }
		other_params = 	another_equation.connecting_vertices.map { |v| v.parameter }
		return (params - other_params).empty?
	end
	def add_connection *equation_connection
		@connecting_vertices.concat equation_connection
	end
	def include? parameter
		@connecting_vertices.each do |v| 
			return true if v.is? parameter 
		end
		return false
	end
	def to_s
		puts "_______________________________________"
		puts "Equation: #{actual}"
		puts "visited: #{visited}"
		
		puts  
		puts " ------------ CONNECTED TO ------ "
		connecting_vertices.each { |x| x.inspect }
		puts "_______________________________________"
	end
end

class ComponentVertex
	attr_accessor :parameter, :connecting_vertices, :visited
	def initialize parameter
		@parameter, @visited, @connecting_vertices = parameter, false, []
	end
	def add_connection *equation_connection
		@connecting_vertices.concat equation_connection
	end
	def is? another_component_vertex
		return @parameter == another_component_vertex.parameter
	end
	def to_s
		puts "Component: #{parameter}"
		puts "visited: #{visited}"
	end
end



class Graph 
	attr_accessor :vertices
	def initialize 
		@vertices = {ComponentVertex => [], EquationVertex => []}
	end

	def insert vertex
		@vertices[vertex.class] << vertex
	end
	def to_s
		puts "__________ EQUATION LIST ___________"
		@vertices[EquationVertex].each do |equation|
			puts equation.actual
		end
		puts "__________ COMPONENT LIST ___________"
		@vertices[ComponentVertex].each do |comp|
			puts comp.parameter
		end
		puts "_______________________________________"
	end
	#Checks whether an EquationVertex or a ComponentVertex already
	#exist within the graph
	def already_contains? vertex
		@vertices[vertex.class].each do |another_vertex|
			return another_vertex if another_vertex.is? vertex
		end
		return false
	end
	def set_all_vertices_unvisited
		vertices[ComponentVertex].each { |x| x.visited = false}
		vertices[EquationVertex].each { |x| x.visited = false}
	end
	#Returns an array of EquationVertex that contain the given 
	#parameter
	def search_for(for_what) 
		if for_what.has_key? :equation_vertex_with_parameter
			return @vertices[EquationVertex].inject([]) do |result,equation_vertex|
				result << equation_vertex if equation_vertex.include? 
			end
		elsif for_what.has_key? :component_vertex_with_parameter
			temp = already_contains?(ComponentVertex.new(for_what[:component_vertex_with_parameter]))
			return temp if temp
		end
		return nil
	end
end
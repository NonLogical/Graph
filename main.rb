require 'pry'
def main
	require './fetch_data'
	include FetchData
	graph = Graph.new
	FetchData::fetch_data_into graph
	puts "What do you want to find?"
	# find_me = gets.chomp.strip
	puts "What are you given? (Seperate each parameter by ',' [comma])"
	# given = gets.chomp.split(',').map(&:strip)
	$FIND_ME = 'DeltaVelocity'
	$GIVEN = ['DeltaDistance', 'TimeFinal','TimeInitial']
	puts find_component(graph,graph.search_for(component_vertex_with_parameter:$FIND_ME))
end


def given? component
	# 
	return $GIVEN.include? component.parameter 
end
def find_component(graph,component)
	binding.pry
	puts "__________________"
	puts "AT"
	component.inspect
	puts "__________________"
	unless component.visited
		component.visited = true
		if given? component
			puts "__________________"
			puts "This component was given"
			component.inspect 
			puts "__________________"
			return true
		else 
			component.connecting_vertices.each do |equation|
				binding.pry
				puts "__________________"
				puts "Looking at equation"
				equation.inspect
				puts "__________________"
				unless equation.visited
					equation.visited = true
					success = false
					puts "__________________"
					puts "Going to start iterating through the element"
					puts "__________________"
					equation.connecting_vertices.each do |new_component|
						unless new_component.parameter == component.parameter
							puts "__________________"
							puts "looking at this"
							new_component.inspect
							puts "__________________"
							success = find_component(graph,new_component) 
							puts "Was there success finding the component? #{success}"
							break unless success
						end
					end
					if success
						graph.set_all_vertices_unvisited
						return true
					end
				else
					puts "__________________"
					puts "The following equation was already visited"
					equation.inspect
					puts "__________________"

				end
			end
		end
	else 
		puts "__________________"
		puts "Already visited:  "
		component.inspect
		puts "__________________"
	end
	puts "NO PATH COULD BE WORKED OUT"
	return false
end
main #Call main
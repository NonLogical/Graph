module FetchData
	require './graph'
	def fetch_data_into graph
		File.readlines("equations.txt").each do |equation|	
			eq = EquationVertex.new equation
			parameters = equation.scan(/[A-Za-z]+/).map
			unless graph.already_contains? eq
				parameters.each do |parameter|
					comp = ComponentVertex.new(parameter) 
					binding.pry
					temp = graph.already_contains?(comp)
					unless temp then graph.insert(comp) else comp = temp end
					binding.pry
					eq.add_connection comp
					binding.pry
					comp.add_connection eq
					binding.pry
				end
				graph.insert eq
			end
		end
			binding.pry
	end 
end


class HumanPlayer
	def initialize(color)
		@color = color
	end

	def move_cursor
		display
		key_input = show_single_key
		intended_location = transpose_delta(cursor, KEY_PRESSES[key_input])
		until onboard?(intended_location)
		  display
		  key_input = show_single_key
		  intended_location = transpose_delta(cursor, KEY_PRESSES[key_input])
		end

		intended_location
	end

	def make_selection(color)
  	place_holder = @cursor
  	@cursor = move_cursor
  	until place_holder == @cursor
  	  place_holder = @cursor
  	  @cursor = move_cursor
  	end

  	place_holder
  end

end
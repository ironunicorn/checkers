require_relative 'board'

class Game
  attr_accessor :board

  def initialize
  	@board = Board.new
  	@players = [:w, :b]
  end

  def play
  	board.display

  	until board.over?
  	  start_pos = first_move
  	  end_pos = second_move
  	  board.move(start_pos, end_pos)
  	  
  	  while board.jump?(start_pos, end_pos) && !board[*end_pos].jump(end_pos).empty?
	  	  continued_pos = end_pos
	  	  board.selection = continued_pos
	  	  end_pos = second_move
	  	  board.move(continued_pos, end_pos)
	  	end
	  	board[*end_pos].king if [0, 7].include?(end_pos[0])

  	  @players.rotate!
  	end

  	board.display
  end

  def first_move
		intended = board.make_selection 
		until board[*intended].color == @players.first
			puts "Hey! That's not yours."
			sleep(1)
			intended = board.make_selection
		end
		board.selection = intended

		intended
	end

	def second_move
		intended = board.make_selection
		until board.available.include?(intended)
			puts "Invalid move"
			intended = board.make_selection
		end
		board.selection = false

		intended
	end

end

Game.new.play
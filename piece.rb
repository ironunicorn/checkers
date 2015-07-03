require 'colorize'
require 'byebug'

class EmptySquare
  attr_reader :color

  def initialize
  	@color = false
  end

  def display
  	"   "
  end

  def available_moves(arg)
  	[]
  end
end

class Piece
  attr_reader :color 
  attr_accessor :kinged, :board

  MOVES = { 
  	b: [ [-1, -1], [-1, 1] ], 
  	w: [ [1, -1], [1, 1] ]
  }

  

  def initialize(color, board)
  	@color = color
  	@board = board
  	@kinged = false
  	@opponent_color = color == :w ? :b : :w
  end

  def dup(new_board)
  	Piece.new(@color, new_board)
  end

  def display
  	set_color(" ◎ ")
  end

  def available_moves(coords)
  	slide(coords) + jump(coords)
  end

  def jump(coords)
		deltas = kinged ? MOVES[:b] + MOVES[:w] : MOVES[color]
		
		potential_jumps = []
		deltas.each do |delta|
			enemy, potential_jump = find_enemy_and_jump(delta, coords)
		  potential_jumps << potential_jump if jumpable?(enemy, potential_jump)
		end
		potential_jumps
	end

 protected

	def set_color(visual)
	  color == :w ? visual.colorize(:white) : visual.colorize(:black)
	end

	def jumpable?(middle_pos, jump)
	  empty_space_on_board?(jump) && board[*middle_pos].color == @opponent_color
	end

	def slide(coords)
		slides = []
		deltas = kinged ? MOVES[:b] + MOVES[:w] : MOVES[color]
		deltas.each do |delta|
		  potential_move = board.transpose_delta(coords, delta)
		  slides << potential_move if empty_space_on_board?(potential_move)
		end

		slides
	end

	def find_enemy_and_jump(delta, coords)
		jump_delta = delta.map { |coord| coord * 2 }
	  potential_jump = board.transpose_delta(coords, jump_delta)
	  potential_enemy = board.transpose_delta(coords, delta)

	  [potential_enemy, potential_jump]
	end

	def empty_space_on_board?(coords)
	  board.onboard?(coords) && board.is_empty?(coords)
	end
end



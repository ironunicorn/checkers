require 'colorize'

class EmptySquare
  attr_reader :color

  def initialize
  	@color = false
  end

  def to_view
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

  def to_view
  	set_color(" ◎ ")
  end

  def available_moves(coords)
  	slide(coords) + jump(coords)
  end

 protected
      def set_color(visual)
  	    color == :w ? visual.colorize(:white) : visual.colorize(:black)
      end

      def jumpable?(middle_pos, jump)
  	    empty_space_on_board?(jump) && board.enemy_piece?(middle_pos, @opponent_color)
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

	  def jump(coords)
	  	jumps = []
	  	deltas = kinged ? MOVES[:b] + MOVES[:w] : MOVES[color]
	  	deltas.each do |delta|
	  	  increment = 2
	  	  jump_delta = delta.map {|coord| coord * increment}
	  	  enemy_delta = delta.map { |coord| coord * (increment - 1) }
	  	  potential_jump = board.transpose_delta(coords, jump_delta)
	  	  potential_enempy = board.transpose_delta(coords, enemy_delta)
	  	  while jumpable?(potential_enempy, potential_jump)
	  	    jumps << potential_jump
	  	    increment *= 2
	  	    jump_delta = delta.map {|coord| coord * increment}
	  	    enemy_delta = delta.map { |coord| coord * (increment - 1) }
	  	    potential_jump = board.transpose_delta(coords, jump_delta)
	  	    potential_enempy = board.transpose_delta(coords, enemy_delta)
	  	  end
	  	end
	  	jumps
	  end

	  def empty_space_on_board?(coords)
  	    board.onboard?(coords) && board.is_empty?(coords)
      end
end
require 'colorize'

class EmptySquare
  attr_reader :color

  def initialize
  	@color = false
  end

  def to_view
  	"   "
  end
end

class Piece
  attr_reader :color 
  attr_accessor :kinged, :board

  def initialize(color, board)
  	@color = color
  	@board = board
  	@kinged = false
  end

  def to_view
  	set_color(" ◎ ")
  end

  def slide
  end

  def jump
  end

  def all_available_moves
  end

  private
    def display_color(visual)
  	  color == :w ? visual.colorize(:white) : visual.colorize(:black)
    end
end
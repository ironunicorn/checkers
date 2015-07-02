require_relative 'board'

class Game
  attr_accessor :board

  def initialize
  	@board = Board.new
  end

  def play
  	until over?
  	  system "clear"
  	  board.render
  	  board.move_cursor 
  	end
  end

  def over?
  	false
  end

end

Game.new.play
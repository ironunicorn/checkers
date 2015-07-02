require_relative 'board'

class Game
  attr_accessor :board

  def initialize
  	@board = Board.new
  	@players = [:w, :b]
  end

  def play
  	until board.over?
  	  board.render
  	  start_pos = board.make_selection(@players.first)
  	  board.selection = start_pos
  	  end_pos = board.make_selection(@players.first)
  	  board.move(start_pos, end_pos)
  	  board.selection = false
  	  @players.rotate
  	end
  	board.render
  end


end

Game.new.play
require 'byebug'
require 'colorize'
require_relative 'keypress'
require_relative 'piece'

class Board
  attr_accessor :grid, :cursor
  KEY_PRESSES = {
  	"UP ARROW" => [-1, 0],
  	"DOWN ARROW" => [1, 0],
  	"LEFT ARROW" => [0, -1],
  	"RIGHT ARROW" => [0, 1],
  	"RETURN" => [0, 0]
  }
  
  def initialize
  	@grid = Array.new(8) { Array.new(8) { EmptySquare.new }}
  	@cursor = [0, 0]
  end

  def [](row, col)
  	@grid[row][col]
  end

  def []=(row, col, piece)
  	@grid[row][col] = piece
  end

  def render
  	@grid.each_with_index do |row, idx1|
  	  row.each_with_index do |square, idx2|
 		if [idx1, idx2] == @cursor
 		  print square.to_view.colorize(background: :yellow)
 		elsif ( idx1 + idx2 ).even?
  		  print square.to_view.colorize(background: :red)
 		else
 		  print square.to_view.colorize(background: :black)
 		end
  	  end
  	  puts
  	end
  end

  def move_cursor
  	key_input = show_single_key
  	intended_location = transpose_delta(cursor, KEY_PRESSES[key_input])
  	until onboard?(intended_location)
  	  key_input = show_single_key
  	  intended_location = transpose_delta(cursor, KEY_PRESSES[key_input])
  	end
  	@cursor = intended_location
  end

  private

    def transpose_delta(current_pos, delta)
  	  [current_pos, delta].transpose.map {|coord| coord.reduce(:+) }
    end

    def onboard?(intended_location)
      intended_location.all? { |coord| coord.between?(0, 7) }
    end

end





require 'byebug'
require_relative 'keypress'
require_relative 'piece'

class Board
  attr_accessor :grid, :cursor, :selection
  KEY_PRESSES = {
  	"UP ARROW" => [-1, 0],
  	"DOWN ARROW" => [1, 0],
  	"LEFT ARROW" => [0, -1],
  	"RIGHT ARROW" => [0, 1],
  	"RETURN" => [0, 0]
  }
  
  def initialize(grid = [])
  	@grid = grid
  	@cursor = [0, 0]
  	load_board if grid.empty?
  end

  def [](row, col)
  	@grid[row][col]
  end

  def []=(row, col, piece)
  	@grid[row][col] = piece
  end

  def render
  	system "clear"
  	@grid.each_with_index do |row, idx1|
  	  row.each_with_index do |square, idx2|
 		if [idx1, idx2] == @selection 
 		  print_with_background(square, :green)
 		elsif [idx1, idx2] == @cursor
 		  print_with_background(square, :yellow)
 		elsif ( idx1 + idx2 ).even?
  		  print_with_background(square, :black)
 		else
 		  print_with_background(square, :red)
 		end
  	  end
  	  puts
  	end
  end

  def make_selection
  	place_holder = @cursor
  	@cursor = move_cursor
  	until place_holder == @cursor
  	  place_holder = @cursor
  	  @cursor = move_cursor
  	end
  	place_holder
  end

  def move(start_pos, end_pos)
  	piece = self[*start_pos]
  	self[*start_pos] = EmptySquare.new
  	self[*end_pos] = piece
  end

  def deep_dup
  	new_grid = []
  	grid.each do |row|
  	  new_line = []
  	  row.each do |square|
  	  	new_line << square.dup
  	  end
  	  new_grid << new_line
  	end
  	Board.new(new_grid)
  end

  def over?
  	grid.flatten.none? { |piece| piece.color == :w } ||
  		grid.flatten.none? { |piece| piece.color == :b }
  end

  protected
	  def transpose_delta(current_pos, delta)
	  	[current_pos, delta].transpose.map {|coord| coord.reduce(:+) }
	  end

	  def onboard?(intended_location)
	    intended_location.all? { |coord| coord.between?(0, 7) }
	  end

	  def populate_evens(color)
	  	arr = []
	  	(0..7).each do |number|
	  	  number.even? ? arr << Piece.new(color, self) : arr << EmptySquare.new
	  	end
	  	arr	
	  end

	  def populate_odds(color)
	  	arr = []
	  	(0..7).each do |number|
	  	  number.odd? ? arr << Piece.new(color, self) : arr << EmptySquare.new
	  	end
	  	arr	
	  end

	  def row_of_empty_squares
	  	Array.new(8) { EmptySquare.new }
	  end

	  def load_board
	  	grid << populate_odds(:w)
	  	grid << populate_evens(:w)
	  	grid << populate_odds(:w)
	  	grid << row_of_empty_squares
	  	grid << row_of_empty_squares
	  	grid << populate_evens(:b)
	  	grid << populate_odds(:b)
	  	grid << populate_evens(:b)
	  end

	  def move_cursor
	  	render
	  	key_input = show_single_key
	  	intended_location = transpose_delta(cursor, KEY_PRESSES[key_input])
	  	until onboard?(intended_location)
	  	  render
	  	  key_input = show_single_key
	  	  intended_location = transpose_delta(cursor, KEY_PRESSES[key_input])
	  	end
	  	intended_location
	  end

	  def print_with_background(square, color)
	  	print square.to_view.colorize(background: color)
	  end

end







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
  	@selection = false
  	load_board if grid.empty?
  end

  def [](row, col)
  	@grid[row][col]
  end

  def []=(row, col, piece)
  	@grid[row][col] = piece
  end

  def display
  	system "clear"
  	@grid.each_with_index do |row, idx1|
  	  row.each_with_index do |square, idx2|	
 		if [idx1, idx2] == @cursor
 		  print_with_background(square, :yellow)
 		elsif [idx1, idx2] == @selection 
 		  print_with_background(square, :green)
 		elsif available.include?([idx1, idx2])
 		  print_with_background(square, :blue)
 		elsif ( idx1 + idx2 ).even?
  		  print_with_background(square, :black)
 		else
 		  print_with_background(square, :red)
 		end
  	  end
  	  puts
  	end
  end

  def available
  	if selection 
  	  self[*selection].available_moves(selection)
  	else
  	  self[*cursor].available_moves(cursor)
  	end
  end

#TODO make this human player
  def make_selection(color)
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

  	kill_enemy(start_pos, end_pos) if jump?(start_pos, end_pos)
  end

  def jump?(start_pos, end_pos)
  	delta = [start_pos, end_pos].transpose.map { |numbers| numbers.inject(:-) }
  	
  	delta.all? { |change| change.abs == 2 }
  end

  def kill_enemy(start_pos, end_pos)
  	enemy_row = (start_pos[0] + end_pos[0]) / 2
    enemy_column = (start_pos[1] + end_pos[1]) / 2
    self[enemy_row, enemy_column] = EmptySquare.new
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

  def transpose_delta(current_pos, delta)
  	[current_pos, delta].transpose.map {|coord| coord.reduce(:+) }
  end

  def onboard?(intended_location)
    intended_location.all? { |coord| coord.between?(0, 7) }
  end

  def is_empty?(coord)
  	self[*coord].is_a?(EmptySquare)
  end

  protected

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

#TODO make this human player
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

	  def print_with_background(square, color)
	  	print square.display.colorize(background: color)
	  end

end

board = Board.new

p board[1, 4].move_values







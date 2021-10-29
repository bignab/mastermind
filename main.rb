# frozen-string-literal: true

require './input_output'

# Contains all the CodeRows and the primary game loop, and represents the whole board game.
class GameBoard
  include InputAndOutput

  NUMBERS_TO_COLOURS = { 1 => 'red', 2 => 'yellow', 3 => 'blue', 4 => 'green', 5 => 'purple', 6 => 'white' }.freeze
  attr_reader :master_code_colour_count

  def initialize(code_rows, master_code)
    @code_rows = Array.new(code_rows) { CodeRow.new }
    @master_code = CodeRow.new
    @master_code.enter_full_row(master_code)
    @master_code_colour_count = @master_code.colour_count
    @win_condition = false
  end

  def game_loop
    welcome_message
    @code_rows.each do |row|
      play_row(row) # add IO from player
      compare_row_to_master(row)
      print_current_board(@code_rows)
      if @win_condition
        win_event
        break
      end
    end
    lose_event unless @win_condition
  end

  # Method to fill in a CodeRow and all of its 4 CodeBalls
  def play_row(code_row)
    valid_input_check = false
    until valid_input_check
      round_input = receive_player_round_input
      valid_input_check = valid_input?(round_input)
      puts 'Invalid input' if valid_input_check == false
    end
    code_row.enter_full_row(convert_input_to_integers(round_input))
  end

  def compare_row_to_master(row)
    colour_location_match = 0
    colour_only_match = tally_colour_matches(row.colour_count, @master_code_colour_count)
    row.code_balls.each_with_index do |code_ball, index|
      colour_location_match += 1 if code_ball.colour == @master_code.code_balls[index].colour
    end
    colour_only_match -= colour_location_match
    row.enter_full_hint(create_hint_row(colour_location_match, colour_only_match))
    row.completed = true
    @win_condition = true if colour_location_match == 4 # Execute #win_event if all colours and locations match
  end

  # Creates an array of four integers that represent the hint states (0, 1 or 2) used for the CodeRow's HintBalls
  def create_hint_row(colour_location_match, colour_only_match)
    number_hints = colour_location_match + colour_only_match
    code_hints = []
    colour_location_match.times { code_hints.push(2) }
    colour_only_match.times { code_hints.push(1) }
    # All hint rows are 4 integers in length, so if there are less than 4 location&colour or colour matches, adds 0s.
    (4 - number_hints).times { code_hints.push(0) }
    code_hints
  end

  def tally_colour_matches(code_count, master_count)
    tally = 0
    temp_master_count = master_count.map(&:clone)
    code_count.each do |code_colour|
      temp_master_count.each_with_index do |master_colour, index|
        if master_colour == code_colour
          tally += 1
          temp_master_count.slice!(index)
          break
        end
      end
    end
    tally
  end

  def win_event
    # add win event stuff here
    win_message
  end

  def lose_event
    # add lose event stuff here
    lose_message
  end
end

# Represents each row of 4 CodeBalls and 4 HintBalls which will be used for one round of the game.
class CodeRow
  attr_reader :code_balls, :hint_balls
  attr_accessor :completed

  def initialize
    @code_balls = Array.new(4) { CodeBall.new }
    @hint_balls = Array.new(4) { HintBall.new }
    @completed = false
  end

  def change_ball_colour(colour, ball)
    @code_balls[ball].change_colour(colour)
  end

  def change_hint_state(state, ball)
    @hint_balls[ball].change_state(state)
  end

  def enter_full_hint(states)
    states.each_with_index do |state, index|
      change_hint_state(state, index)
    end
  end

  def enter_full_row(colours)
    colours.each_with_index do |ball_colour, index|
      change_ball_colour(ball_colour, index)
    end
  end

  def colour_count
    colour_count = []
    code_balls.each do |code_ball|
      colour_count.push(code_ball.colour)
    end
    colour_count
  end
end

# Represents each individual value of the code, and each value will range from 1 through 6.
class CodeBall
  attr_reader :colour

  def initialize
    @colour = 0
  end

  def change_colour(colour)
    @colour = colour if @colour.zero? && colour.between?(1, 6)
  end
end

# Represents each hint value, each value ranges from 1 (right colour) through 2 (right colour, location).
class HintBall
  attr_reader :state

  def initialize
    @state = 0
  end

  def change_state(state)
    @state = state if @state.zero? && state.between?(1, 2)
  end
end

testboard = GameBoard.new(5, [1, 5, 2, 6])
testboard.game_loop

# frozen-string-literal: true

# String methods to allow for colored text on the terminal.
class String
  def black
    "\e[30m#{self}\e[0m"
  end

  def red
    "\e[31m#{self}\e[0m"
  end

  def green
    "\e[32m#{self}\e[0m"
  end

  def brown
    "\e[33m#{self}\e[0m"
  end

  def blue
    "\e[34m#{self}\e[0m"
  end

  def magenta
    "\e[35m#{self}\e[0m"
  end

  def cyan
    "\e[36m#{self}\e[0m"
  end

  def gray
    "\e[37m#{self}\e[0m"
  end

  def bg_black
    "\e[40m#{self}\e[0m"
  end

  def bg_yellow
    "\e[43m#{self}\e[0m"
  end

  def bg_white
    "\e[37m#{self}\e[0m"
  end

  def bg_red
    "\e[41m#{self}\e[0m"
  end

  def bg_green
    "\e[42m#{self}\e[0m"
  end

  def bg_brown
    "\e[43m#{self}\e[0m"
  end

  def bg_blue
    "\e[44m#{self}\e[0m"
  end

  def bg_magenta
    "\e[45m#{self}\e[0m"
  end

  def bg_cyan
    "\e[46m#{self}\e[0m"
  end

  def bg_gray
    "\e[47m#{self}\e[0m"
  end

  def bold
    "\e[1m#{self}\e[22m"
  end

  def italic
    "\e[3m#{self}\e[23m"
  end

  def underline
    "\e[4m#{self}\e[24m"
  end

  def blink
    "\e[5m#{self}\e[25m"
  end

  def reverse_color
    "\e[7m#{self}\e[27m"
  end
end

# Module covering all input and output methods for the mastermind game.
module InputAndOutput
  def welcome_message
    puts 'Hello, and welcome to a friendly game of Mastermind!'
    puts 'We would like to remind you of the rules of the game:'
  end

  def receive_player_round_input
    puts 'Please type four numbers between (inclusive) 1 and 6 representing the following colors:'
    puts ' 1 '.bg_red + ' ' + ' 2 '.bg_yellow + ' ' + ' 3 '.bg_blue + ' ' + ' 4 '.bg_green + ' ' + ' 5 '.bg_magenta + ' ' + ' 6 '.bg_gray
    gets.chomp.gsub(/\s+/, '').split('')
  end

  def valid_input?(input)
    condition_one = input.length == 4
    condition_two = check_if_valid_integers(input)
    if condition_one && condition_two
      true
    else
      false
    end
  end

  def check_if_valid_integers(input_array)
    input_array.each do |number|
      return false unless number.to_i.between?(1, 6)
    rescue StandardError => e
      puts e
      return false
    end
    true
  end

  def convert_input_to_integers(input_array)
    output_array = []
    input_array.each do |number|
      output_array.push(number.to_i)
    end
    output_array
  end
end

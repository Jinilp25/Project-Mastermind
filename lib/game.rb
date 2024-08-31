# colors are red, green, blue, yellow, orange, pink, grey and white
# white indicates one of the color is correct, but in the wrong position
# black indicates one of the color is both correct and in the right position


class Game

  @@COLORS = ['red', 'green', 'blue', 'yellow', 'orange', 'pink', 'grey', 'white']
  @@MAX_SCORE = 10

  def initialize(name)
    @name = name
    @players_score = 0
    @computers_score = 0
  end

  # play the game for code breaking side
  def code_breaker
    answer = create_code
    loop do
      guess = choose_color_code
      if correct_answer?(guess, answer)
        puts "Correct! The total score of computer is #{@computers_score} points"
        return @computers_score
      else
        feedback_result = feedback(guess, answer)
        @computers_score += 1
        puts "\nIncorrect\nfeedback: "
        if (@@MAX_SCORE - @computers_score) == 0
          puts "The answer is: #{answer}, computer wins 11 points!"
          return @computers_score
        end
        4.times { |index| print "#{feedback_result[index]} " }
        puts "\n#{@@MAX_SCORE - @computers_score} attempts remaining\n"
      end
    end
  end

  def computers_turn
    answer = code_maker
    computer_code_breaker(answer)
  end
    

  # player creates code
  def code_maker
    display_color_options
    puts "\nPlease create four digit code of colors: "
    valid = false
    until valid
      valid = true
      code = gets.chomp.split("").map { |num| num.to_i}
      code.each do |val|
        unless (1..8).include?(val)
          puts "Input error, please try again:\n"
          valid = false
        end 
      end
    end
    code
  end

  def computer_code_breaker(answer)
    guess = create_code
    puts "The computer first guesses: "
    4.times { |index| print "#{guess[index]} " }

    loop do
      if correct_answer?(guess, answer)
        puts "Correct! The total score of player is #{@players_score} points"
        return @players_score
      else
        @players_score += 1
        puts "\nIncorrect!\n#{@@MAX_SCORE - @players_score} attempts left\n"
        if (@@MAX_SCORE - @players_score) == 0
          puts "The answer is: #{answer}, player wins 11 points!"
          return @players_score
        end
        computer_feedback = feedback(guess, answer)
        4.times { |index| print "#{computer_feedback[index]} " }
        guess = choose_code_computer(computer_feedback, guess)
        puts "\nThe computer guesses: "
        4.times { |index| print "#{guess[index]} " }
      end
    end
  end



  # pick four random colors, returns the code
  def create_code
    code = []
    4.times do 
      code << (rand(8) + 1)
    end
    code
  end

  # choose four color guess, returns array of guessed code
  def choose_color_code
    puts "Please guess the 4 color code by typing 4 numbers of your guess of the following:"
    display_color_options
    puts "\nType Code of 4 digit number here: "
    loop do
      guess = gets.chomp.split("").map { |num| num.to_i}
      if guess.length != 4 
        puts "incorrect value, please try again: "
      else
        return guess
      end
    end
  end

  def choose_code_computer(feedback_result, guess)
    white_index = []
    black_index = []
    new_feedback = []
    if feedback_result.all?("___")
      return create_code
    end

    feedback_result.each_with_index do |color, index|
      if color == "Black"
        black_index << index
      elsif color == "White"
        white_index << index
      end
    end

    guess.each_with_index do |num, idx|
      if black_index.include?(idx)
        new_feedback[idx] = num
      elsif white_index.include?(idx)
        rand_idx = rand(4)
        while black_index.include?(rand_idx) || rand_idx == idx
          rand_idx = rand(4)
        end
        new_feedback[rand_idx] = num 
        new_feedback[idx] = rand(8) + 1 if new_feedback[idx] == nil
      elsif new_feedback[idx] == nil
        rand_num = rand(8) + 1
        until rand_num != num
          rand_num = rand(8) + 1
        end
        new_feedback[idx] = rand_num
      end
    end
    new_feedback
  end
         
  def display_color_options
    @@COLORS.each_with_index do |color, index| 
      print "#{index + 1}. #{color} " 
      if index == 3
        print "\n"
      end
    end
  end

  # correct code?
  def correct_answer?(guess, answer)
    guess == answer
  end

  def feedback(guess, answer)
    feedback_result = []
    guess_copy = guess.clone
    answer_copy = answer.clone

    (0..3).each do |index|
      if guess_copy[index] == answer_copy[index]
        feedback_result << "Black"
        answer_copy[index] = nil
      elsif guess_copy[index] != answer_copy[index] && answer_copy.include?(guess_copy[index])
        feedback_result << "White"
      else
        feedback_result << "___"
      end
    end
    feedback_result
  end

end


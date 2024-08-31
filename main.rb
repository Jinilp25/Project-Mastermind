require_relative "lib/game.rb"

def play_mastermind
  puts "Enter nickname: "
  name = gets.chomp
  play_game = Game.new(name)
  computer_score = play_game.code_breaker
  puts "\nSwitching Turn...\n"
  players_score = play_game.computers_turn
  if computer_score > players_score
    puts "Computer Wins!"
  elsif players_score > computer_score
    puts "Player Wins!"
  else
    puts "It's a tie!"
  end
end

play_mastermind
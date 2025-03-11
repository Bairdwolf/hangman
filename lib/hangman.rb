require_relative('game')
require_relative('gamedisplay')
require('rainbow')
require('csv')
def get_valid_words(fname)
  valid_words = []
  File.readlines(fname).each do |line|
    word = line.delete("\n")
    valid_words.push(word) if word.length.between?(5, 12)
  end
  valid_words
end

def choose_game_type
  begin
    puts 'Would you like to START a new game or LOAD an old one?'
    input = gets.chomp.to_s.downcase
    raise StandardError.new 'Invalid input: Did not select one of these options' unless %w[start load].include?(input)
    if input == 'load' && (Dir.empty?('games') || !Dir.exist?('games'))
      raise StandardError.new 'Invalid input: No previous games'
    end
  rescue StandardError => e
    puts "\tError: #{e}"
    retry
  end
  input
end

def global_script_start
  choice = choose_game_type
  file_count = 0
  Dir.mkdir('games') unless Dir.exist?('games')
  Dir.foreach('games') { |_x| file_count += 1 }

  if choice == 'start'
    puts "Starting Game #{file_count - 1}"
    game = Game.new(get_valid_words('google-10000-english-no-swears.txt'), file_count - 1)

  elsif choice == 'load'
    begin
      puts "There are #{file_count - 2} games. Please type a number to continue"
      input = gets.chomp.to_i
      raise StandardError.new('Invalid input: Number out of range') if input > file_count - 1 || input < 1
    rescue StandardError => e
      puts "\tError: #{e}"
      retry
    end
    contents = CSV.open("games/game_#{input}.csv", headers: true, header_converters: :symbol)
    game = load_game(contents, input)
  end
  game.play
end

def load_game(contents, input)
  puts "Loading Game #{input}"
  output = Game.new(['a'], input)
  output.correct_guesses = []
  output.wrong_guesses = []
  output.winner = 'none'
  output.game_display.man = []
  contents.each do |row|
    output.secret_word = row[:secret_word]
    output.correct_guesses.push(row[:correct_guess]) unless row[:correct_guess].nil?
    output.wrong_guesses.push(row[:wrong_guess]) unless row[:wrong_guess].nil?
    output.game_display.man.push(row[:man]) unless row[:man].nil?
  end
  output.game_display.update_correct_guesses(output.correct_guesses, output.wrong_guesses)
  output
end

global_script_start

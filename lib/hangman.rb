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

def choose_game_type()
  begin
    puts 'Would you like to START a new game or LOAD an old one?'
    input = gets.chomp.to_s.downcase
    unless input=="start" || input=='load'
      raise StandardError.new 'Invalid input: Did not select one of these options'
    end
    if input=='load' && (Dir.empty?('games') || !Dir.exist?('games'))
      raise StandardError.new 'Invalid input: No previous games'
    end
  rescue StandardError => e
    puts "\tError: #{e}"
    retry
  end
  input
end

def global_script_start()
  choice=choose_game_type()
  file_count=0
  if !Dir.exist?('games')
    Dir.mkdir('games')
  end
  Dir.foreach('games'){|x| file_count+=1}

  if choice=='start'
    game = Game.new(get_valid_words('google-10000-english-no-swears.txt'), file_count+1)
  
  elsif choice=='load'
    begin
      puts "There are #{file_count} games. Please type a number to continue"
      input=gets.chomp.to_i
      if input>file_count || input<1
        raise StandardError.new('Invalid input: Number out of range')
      end
    rescue StandardError => e
      puts "\tError: #{e}"
      retry
    end
    contents=CSV.open("game_#{input}.csv", headers: true, header_converters: :symbol)
    game=load_game(contents, input)
  end
  game.play()
end

def load_game(contents, input)
  puts "Loading Game #{input}"
  output=Game
  output.game_number=input
  output.valid_words_list=[]
  output.wrong_guesses=[]
  output.winner='none'
  output.game_display=GameDisplay.new(['-', '-'])
  contents.each do |row|
    output.secret_word=row[:secret_word]
    output.valid_words_list.push(row[:valid_word])
    output.wrong_guesses.push(row[:wrong_guess])
    output.game_display.man.push(row[:man])
  end
end

global_script_start()
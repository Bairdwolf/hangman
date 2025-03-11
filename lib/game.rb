class Game
  attr_accessor :secret_word, :game_display, :winner, :game_number, :correct_guesses, :wrong_guesses

  def initialize(valid_words, game_number)
    @game_number = game_number
    @valid_words_list = valid_words
    @secret_word = @valid_words_list.sample.downcase
    @wrong_guesses = []
    @correct_guesses = Array.new(secret_word.length, '-')
    @game_display = GameDisplay.new(@correct_guesses)
    @winner = 'none'
    # cheat mode:
    # puts self.secret_word
  end

  def play
    saved = false
    until @winner != 'none' || saved === true
      begin
        puts 'PLAY another round? Or SAVE and exit?'
        input = gets.chomp.to_s.downcase
        raise StandardError.new 'Invalid input try again' if input != 'play' && input != 'save'
      rescue StandardError => e
        puts "\tError: #{e}"
        retry
      end
      if input == 'play'
        play_round
      elsif input == 'save'
        save_round
        saved = true
      end
    end
    game_display.display_winner(@correct_guesses, @wrong_guesses, @winner)
  end

  def play_round
    guess = make_guess
    if check_guess(guess) == true
      add_guess(@correct_guesses, guess)
      game_display.update_correct_guesses(@correct_guesses, @wrong_guesses)
    else
      add_guess(@wrong_guesses, guess)
      game_display.update_wrong_guesses(@wrong_guesses, @correct_guesses)
    end
    @winner = check_winner
  end

  def make_guess
    begin
      puts 'Select a letter'
      # input='blue'
      input = gets.chomp.to_s
      unless input.downcase >= 'a' && input.downcase <= 'z' && input.length == 1
        raise StandardError.new 'Invalid input: Input outside range'
      end
      raise StandardError.new 'Invalid input: Already guessed correctly' if @correct_guesses.any?(input)
      raise StandardError.new 'Invalid input: Already guessed incorrectly' if @wrong_guesses.any?(input)
    rescue StandardError => e
      puts "\tError: #{e}"
      retry
    end
    input.downcase
  end

  def check_guess(guess)
    secret_word.split('').any?(guess)
  end

  def add_guess(arr, guess)
    if arr == @correct_guesses
      arr.map!.with_index do |letter, index|
        if secret_word.split('')[index] == guess
          guess
        else
          letter
        end
      end

    else
      arr.push(guess)
    end
  end

  def check_winner
    return 'Player' if @correct_guesses.join('') == secret_word
    return 'Computer' if @wrong_guesses.length > 5

    'none'
  end

  def save_round
    info_list = []
    12.times do |i|
      info = { secret_word: secret_word, correct_guess: @correct_guesses[i],
               wrong_guess: @wrong_guesses[i], man: game_display.man[i] }
      info_list.push(info)
    end

    headers = %w[secret_word correct_guess wrong_guess man]
    CSV.open("games/game_#{game_number}.csv", 'w') do |csv|
      csv << headers
      info_list.each do |item|
        csv << CSV::Row.new(item.keys, item.values)
      end
    end
  end
end

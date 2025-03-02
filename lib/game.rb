class Game
  attr_reader :secret_word
  attr_accessor :game_display, :winner, :game_number

  def initialize(valid_words, game_number)
    @game_number=game_number
    @valid_words_list = valid_words
    @secret_word = @valid_words_list.sample.downcase
    @wrong_guesses = []
    @correct_guesses = Array.new(secret_word.length, '-')
    @game_display = GameDisplay.new(@correct_guesses)
    @winner = 'none'
    # cheat mode:
    #puts self.secret_word
  end

  def play()
    until winner != 'none'
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
    game_display.display_winner(@correct_guesses, @wrong_guesses, @winner)
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
end

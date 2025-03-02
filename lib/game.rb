class Game
  attr_reader :secret_word
  attr_accessor :game_display, :round, :winner, :wrong_guesses, :correct_guesses
  def initialize(valid_words)
    @valid_words_list=valid_words
    @secret_word=@valid_words_list.sample().downcase
    @wrong_guesses=[]
    @correct_guesses=Array.new(self.secret_word.length, '-')
    @game_display = GameDisplay.new(@correct_guesses)
    @winner="none"
    puts self.secret_word
  end

  def play()
    until self.winner!= "none"
      guess=make_guess()
      if check_guess(guess)==true
        add_guess(self.correct_guesses, guess)
        self.game_display.update_correct_guesses(self.correct_guesses)
      else
        add_guess(self.wrong_guesses, guess)
        self.game_display.update_wrong_guesses(self.wrong_guesses)
      end
      self.winner=check_winner()
    end
  end

  def make_guess()
    begin
      puts 'Select a letter'
      #input='blue'
      input = gets.chomp.to_s
      raise StandardError.new 'Invalid input: Input outside range' unless input.downcase>='a' && input.downcase<='z' && input.length==1
      raise StandardError.new 'Invalid input: Already guessed correctly' if correct_guesses.any?(input)
      raise StandardError.new 'Invalid input: Already guessed incorrectly' if wrong_guesses.any?(input)
    rescue StandardError => e
      puts "\tError: #{e}"
      retry
    end
    input.downcase
  end

  def check_guess(guess)
    self.secret_word.split('').any?(guess)
  end

  def add_guess(arr, guess)
    if arr==self.correct_guesses
      arr.map!.with_index do |letter, index|
        if self.secret_word.split('')[index]==guess
          guess
        else
          letter
        end
      end

    else
      arr.push(guess)
    end
  end

end
class Game
  attr_reader :secret_word
  attr_accessor :game_display, :round, :winner
  def initialize(valid_words)
    @round=1
    @valid_words_list=valid_words
    @secret_word=@valid_words_list.sample()
    @game_display = GameDisplay.new(@secret_word.length)
    @winner="none"
  end

  def play()

  end
end
require_relative('game')
require_relative('gamedisplay')
require('rainbow')
def get_valid_words(fname)
  valid_words=Array.new
  File.readlines(fname).each do |line|
    word=line.delete("\n")
    if word.length.between?(5,12)
      valid_words.push(word)
    end
  end
  valid_words
end

game=Game.new(get_valid_words("google-10000-english-no-swears.txt"))
game.play()
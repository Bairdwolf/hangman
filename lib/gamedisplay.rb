class GameDisplay
  def initialize(len)
    @secret_word_length=len
    @@padding="================"
    @@top=[@@padding, '|   HANG MAN   |', @@padding]
    @man=['   _________    ','   |/      |    ', '   |       o    ', 
    '   |      /|\    ', '   |      / \   ', '   |     /   \  ', '___|___       ' ]
    @@middle=[@@padding, '| YOUR GUESSES |', @@padding]
    @bottom=[[], justify(@secret_word_length), [], @@padding]
  end
  def justify(len)
    remainder=14-len
    leftside=""
    rightside=""
    if remainder.odd?
      rightside=' ' * ((remainder+1)/2)
      leftside=' ' * ((remainder-1)/2)
    else
      rightside=' ' * (remainder/2)
      leftside=rightside
    end
    empty="_" * len
    output='|'+leftside+empty+rightside+'|'
  end
end


#length=16

#====
#hangman
#=====
#   _________  
#   |/      |
#   |       o    
#   |      /|\
#   |      / \
#   |     /   \
#___|___                
#  ======
#  | YOUR GUESSES |
#  =======
#  correct stuff
#  ____________
#  | X X X  X X X |
#  ===============
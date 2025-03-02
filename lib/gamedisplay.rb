class GameDisplay
  def initialize(len)
    @secret_word_length=len
    @@padding="================"
    @@top=[@@padding, '|   HANG MAN   |', @@padding]
    @man=['   _________    ','   |/      |    ', '   |            ', 
    '   |             ', '   |            ', '   |            ', '___|___       ' ]
    @@middle=[@@padding, '| YOUR GUESSES |', @@padding]
    @bottom=[[], justify(@secret_word_length), [], @@padding]
    display_board()
  end

  def display_board()
    display_section(@@top)
    display_section(@man)
    display_section(@@middle)
    display_section(bottom_print(@bottom))
  end

  def display_section(arr)
    arr.each do |line|
      puts line
    end
  end

  def bottom_print(bottom)
    return bottom
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
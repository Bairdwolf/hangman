require 'pry-byebug'
class GameDisplay
  def initialize(guesses_length)
    @secret_word_correct=guesses_length
    @@padding="================"
    @@top=[@@padding, '|   HANG MAN   |', @@padding]
    @man=['   _________    ','   |/      |    ', '   |            ', 
    '   |             ', '   |            ', '   |            ', '___|___       ' ]
    @@middle=[@@padding, '| YOUR GUESSES |', @@padding]
    @secret_word_incorrect=[]
    @bottom=[@secret_word_correct, '|  ELIMINATED  |', @secret_word_incorrect, @@padding]
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
    output=bottom
    output[0]=justify(bottom[0])
    output[2]=wrong_justify(bottom[2])
    output
  end

  def justify(item)
    underline=item.map do |letter|
      if letter=='-'
        '_'
      else
        letter
      end
    end
    remainder=14-item.length
    leftside=""
    rightside=""
    if remainder.odd?
      rightside=' ' * ((remainder+1)/2)
      leftside=' ' * ((remainder-1)/2)
    else
      rightside=' ' * (remainder/2)
      leftside=rightside
    end
    output='|'+leftside+underline.join('')+rightside+'|'
  end

  def wrong_justify(arr)
    if arr.length<6
      (6-arr.length).times do
        arr.push(" ")
      end
    end
    left_side=Rainbow(arr[0..2].join(" ")).red
    right_side=Rainbow(arr[3..5].join(" ")).red
    output='| '+left_side+ '  '+right_side+" |"
    output
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
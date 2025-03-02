require 'pry-byebug'

class GameDisplay
  attr_accessor :bottom, :man, :wrong_guess_count
  def initialize(guesses_length)
    @wrong_guess_count=0
    @@padding="================"
    @@top=[@@padding, '|   HANG MAN   |', @@padding]
    @man=['   _________    ','   |/      |    ', '   |            ', 
    '   |             ', '   |            ', '   |            ', '___|___       ' ]
    @@middle=[@@padding, '| YOUR GUESSES |', @@padding]
    @bottom=[guesses_length, '|  ELIMINATED  |', [], @@padding]
    display_board()
  end

  def display_board()
    display_section(@@top)
    display_section(@man)
    display_section(@@middle)
    display_section(bottom_print(self.bottom))
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
    temp=arr.dup
    if temp.length<6
      (6-temp.length).times do
        temp.push(" ")
      end
    end
    left_side=Rainbow(temp[0..2].join(" ")).red
    right_side=Rainbow(temp[3..5].join(" ")).red
    output='| '+left_side+ '  '+right_side+" |"
    output
  end

  def update_correct_guesses(guesses, wrong_guesses)
    self.bottom[0]=guesses
    self.bottom[2]=wrong_guesses
    display_board()
  end

  def update_wrong_guesses(guesses, correct_guesses)
    self.bottom[2]=guesses
    self.bottom[0]=correct_guesses
    self.wrong_guess_count+=1
    build_hangman(self.wrong_guess_count)
    display_board()
  end

  def build_hangman(num)
    if num==0
      pass
    elsif num==1
      self.man[2]='   |       o  '
    elsif num==2
      self.man[3]='   |       |  '
    elsif num==3
      self.man[3]='   |      /|  '
    elsif num==4
      self.man[3]='   |      /|\ '
    elsif num==5
      self.man[4]='   |      /   '
      self.man[5]='   |     /    '
    elsif num==6
      self.man[4]='   |      / \\ '
      self.man[5]='   |     /   \\'
    end
  end

  def display_winner(correct, incorrect, winner)
    self.bottom[0]=correct
    self.bottom[2]=incorrect
    if winner=='Player'
      self.bottom.push('| PLAYER  WINS |')
    else
      self.bottom.push('|COMPUTER  WINS|')
    end
    self.bottom.push(@@padding)
    display_board()
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
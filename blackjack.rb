require './Cards.rb'

class BlackjackCard < Card
   # Making an array to tell the program what values we are using.
   Values = [2,3,4,5,6,7,8,9,10,10,10,10,11]

   attr_accessor :value
   
   def value
       self.value = Values[self.x % 13]
   end
end   

class BlackjackHand < Hand

    attr_accessor :count

    def cards
        cards = []
        raw_cards = settings.redis.lrange @hand, 0, -1
        raw_cards.each do |card|
            cards.push(BlackjackCard.new(card.to_i))        
	    end
        return cards
    end
    
	def count
	    count = 0 
		temp_hand = self.cards.sort_by {|card| card.value}
        temp_hand.each do |card|
		    if card.value == 11 and count + card.value > 21 then
			    count = count + 1
			else			
			    count = count + card.value
		    end	    
		end
	    return count   
	end
	def length
	    cards.to_a.length
	end	
	def show_hand(number_cards=cards.length)
	    number_cards.times do |i|
		    puts cards[i].name
		end
		puts count	
	end
end	

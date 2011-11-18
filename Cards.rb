class Card
    # Give the program arrays called "Numbers" and "Suits" to tell it what suits and numbers will 
    # appear for cards.
    Numbers = %w[2 3 4 5 6 7 8 9 10 j q k a]
    Suits = %w[spades hearts diamonds clubs]
     
    attr_accessor :number, :suit, :x, :name, :image
    
    
    
    def initialize(x)
        self.number = Numbers[x % 13]
        self.suit = Suits[x % 4]
        self.x = x
        self.name = "#{number} of #{suit}" 
        self.image = "#{suit}-#{number}-75.png"
    end
end    


class Deck
    attr_accessor :cards
    def initialize()
        @id = settings.id
        @deck = "user:#{@id}:deck"
    end
    
    def shuffle!
        keys = settings.redis.keys "user:#{@id}:*"
        if keys.length > 0 then
            settings.redis.del *keys
        end    
        self.cards = (0..51).to_a.shuffle.collect { |card| settings.redis.lpush @deck, card }    
    end
    
    def deal(x)
        cards = []
        x.times do
            cards.push(settings.redis.lpop @deck)
        end
        return cards    
    end
end    

class Hand
    attr_accessor :cards
    def initialize(player)
        @id = settings.id
        @hand = "user:#{@id}:player:#{player}:hand"
        self.cards = cards    
    end    
    def cards
        cards = []
        raw_cards = settings.redis.lrange @hand, 0, -1
        raw_cards.each do |card|
            cards.push(Card.new(card.to_i))        
        end
        return cards
    end
    
    def show_hand
        self.cards.each do |card|    
            puts card.name
        end    
    end
    
    def hit(cards)
        cards.each do |card|
            settings.redis.rpush @hand, card
        end
    end
end


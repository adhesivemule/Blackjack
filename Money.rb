class Bankroll
    
    attr_accessor :money, :chips
    
    #Using hashes to store chip colors and money values.
    CHIPS = Hash["White" => 1,
                 "Red" => 5,
                 "Green" => 25,
                 "Black" => 100]
    
    # I think this stores the money and chips into redis under "settings.id". Also it 
    # lets me input an amount of money players start with.
    def initialize()
      @bet = "user:#{settings.id}:bet"
      @redis = Redis.new
      @redis_money = "user:#{settings.id}:money"
      @redis_chips = "user:#{settings.id}:chips"
      @money = @redis.get @redis_money
      @money = @money.to_i
    end
    def chips(color)
      chips = @redis.hget @redis_chips, color
      return chips.to_i
    end  
      
    
   # Finds the color and the amount of chips then tells it the exchange rate in dollars.
   def exchange(amount, color)
        dollars = CHIPS[color]*amount
        return dollars
    end    

    def buy_chips(amount_chips, color_chips)
        dollars = exchange(amount_chips, color_chips)
        if CHIPS.has_key?(color_chips) then
          if amount_chips >= 0 and dollars <= @money then
              remaining_money = @money - dollars
              @redis.hset @redis_money, remaining_money
              @redis.hset @redis_chips, color_chips, self.chips(color_chips) + amount_chips.to_i    
          end    
        end
    end
    
    def sell_chips(amount_chips, color_chips)
        # Check to make sure the key exists:
        if CHIPS.has_key?(color_chips) then
          #Making sure you have chips to sell.
          if amount_chips >= 0 then
            #Making sure we have the chips we are trying to sell.
            if self.chips(color_chips) >= amount_chips then
              @redis.hset @redis_bet = "user:#{settings.id}:betchips, color_chips, self.chips(color_chips) - amount_chips.to_i"
              @redis.set @redis_money, @money + exchange(amount_chips, color_chips)
            end
          end  
      end
    end
    
    def bet_chips(amount_chips, color_chips)
        if self.chips(color_chips) >= amount_chips and amount_chips >= 0 then
          #Checking to see if we have enough chips.
          @redis.set @redis_chips, self.chips(color_chips) - amount_chips
        end  
    end
    def buy_in(amount_money)
      @redis.incrby @redis_money, amount_money
    end
    def bet(amount_chips, color_chips)
     @redis.hincrby @chips, color, -1
     @redis.hincr bet, color
    end 
    def getBet()
      return @redis.hgetall @bet
    end  
end    

          
class Bankroll
    
    attr_accessor :money, :chips
    
    #Using hashes to store chip colors and money values.
    CHIPS = Hash["White" => 1,
                 "Red" => 5,
                 "Green" => 25,
                 "Black" => 100]
    TABLE100 = Hash["White" =>  10,
                    "Red" =>  8,
                    "Green" => 2]  
    TABLE500 = Hash["White" => 50,
                    "Red" => 20, 
                    "Green" => 6,
                    "Black" => 2]
    TABLE1000 = Hash["White" => 100,
                     "Red" => 50,
                     "Green" => 18,
                     "Black" => 2]                       
    
    # I think this stores the money and chips into redis under "settings.id". Also it 
    # lets me input an amount of money players start with.
    def initialize()
      @bet = "user:#{settings.id}:bet"
      @redis = settings.redis
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
        dollars = CHIPS[color]*amount.to_i
        return dollars
    end    

    def buy_chips(amount_chips, color_chips)
        amount_chips = amount_chips.to_i
        dollars = exchange(amount_chips, color_chips)
        if CHIPS.has_key?(color_chips) then
        puts "That color chip exists"
          if amount_chips >= 0 and dollars <= @money then
          puts "The amount of chips is greater then 0"
              @redis.incrby @redis_money, -dollars
              @redis.hincrby @redis_chips, color_chips, amount_chips  
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
    
    def bankroll(amount_money) 
      @redis.incrby @redis_money, amount_money
    end
    def buy_in(table_value)
      table_value = table_value.to_i
      if table_value <= @money then
        self.bankroll(-table_value)
        if table_value == 100 then
          tablehash = TABLE100
        elsif table_value == 500 then
          tablehash = TABLE500
        elsif table_value == 500 then
          tablehash = TABLE1000
        end  
        if tablehash then
          tablehash.each do |color, amount|
            @redis.hincrby @redis_chips, color, amount 
          end
        end
      end        
    end    
        
      
      
      
    def bet(amount_chips, color_chips)
      amount_chips = amount_chips.to_i
      if self.chips(color_chips) >= amount_chips and amount_chips >= 0 then
        @redis.hincrby @redis_chips, color_chips, -amount_chips
        @redis.hincrby @bet, color_chips, amount_chips
      end  
    end
    
    def getBet()
      return @redis.hgetall @bet
    end  
end    


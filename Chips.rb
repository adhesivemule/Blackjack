class Wallet
	attr_accessor :chip_count
	def chip_count
	    return @chip_count
	end
	def initialize(n)
	       @chip_count = n
	end	   
end


class Bet
	attr_accessor :bet, :payout
	def payout
		return @bet*@odds
	end	
	def initialize(bet,odds)
		@bet = bet
		@odds = odds
	end	
end

	
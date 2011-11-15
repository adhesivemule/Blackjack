#Requiring all of the nessacerry files to run the Blackjack Game.
# blackjack.rb
require 'sinatra'
require 'haml'
require 'redis'
require './Cards.rb'
require './blackjack.rb'
require './Money.rb'

#Making a cookie that expires after 60*60 seconds (60 minutes).
use Rack::Session::Pool,
    :expire_after => 60 * 60

configure do
    uri = URI.parse(ENV["REDISTOGO_URL"])
    set :redis, Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end

# This gets the cookie we made from the persons computer to store the deck, player, dealer, the 
# players hand, and the dealers aswell.
before do
    set :id, request.cookies['rack.session']
    @deck = Deck.new
    @player = 1
    @dealer = 2
    @playerhand = BlackjackHand.new(@player)
    @dealerhand = BlackjackHand.new(@dealer)
    @bankroll = Bankroll.new
end

# Shuffles the decks deals the hands then makes sure nobody got blackjack, if they do gameover = true.    
get '/' do
    @deck.shuffle!
    @playerhand.hit(@deck.deal(2))
    @dealerhand.hit(@deck.deal(2))
	if @playerhand.count == 21 then
	  @blackjack = true
	  @gameover = true
	end
    if @dealerhand.count == 21 then
	  @dealer_blackjack = true
	  @gameover = true
	end
    haml :index
end

get '/buy_in/:amount' do |amount|
    @bankroll.buy_in(amount)
    puts "You bought in for #{amount}"
    puts "You have #{@bankroll.money} in your bank."
end

get '/buy_chips/:amount_chips/:color_chips' do |amount_chips, color_chips|
    @bankroll.buy_chips(amount_chips, color_chips)
end    

get '/bet/:color_chips/:amount_chips' do |color_chips, amount_chips|
    @bankroll.bet(amount_chips, color_chips)  
end

get '/sell_chips/:color_chips/:amount_chips' do |color_chips, amount_chips|
    @bankroll.sell_chips(amount_chips, color_chips)
end    

# This tells the game when someone types /hit or hits the hit button to deal 1 card from the deck, 
# if they get 21 from the card gameover = true
get '/hit' do
    @playerhand.hit(@deck.deal(1))
	if @playerhand.count > 21 then
	  @gameover = true
    end
	haml :index
end

#T his tells the game when someone types /stay or hits the button and hits of the dealers hand untill 
# the dealer gets > 16 then stops hitting the dealer. 
get '/stay' do
  until @dealerhand.count > 16
    @dealerhand.hit(@deck.deal(1))
  end  
  @gameover = true
  haml :stay
end
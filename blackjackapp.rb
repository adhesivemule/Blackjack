#Requiring all of the nessacerry files to run the Blackjack Game.
# blackjack.rb
require 'sinatra'
require 'haml'
require 'redis'
require 'json'
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
    @bankroll.bankroll(1000)
end

# Shuffles the decks deals the hands then makes sure nobody got blackjack, if they do gameover = true.    

get '/table/:buy_in' do |buy_in|
    haml :index
end

get '/buy_in/:amount' do |amount|
    @bankroll.buy_in(amount)
    puts "You bought in for #{amount}"
    puts "You have #{@bankroll.money} in your bank."
end

get '/buy_chips/:amount_chips/:color_chips' do |amount_chips, color_chips|
    @bankroll.buy_chips(amount_chips, color_chips)
    puts "You bought #{@bankroll.chips(color_chips)} #{color_chips}"
end    

get '/bet/:color_chips/:amount_chips' do |color_chips, amount_chips|
    @bankroll.bet(amount_chips, color_chips)  
end

get '/sell_chips/:color_chips/:amount_chips' do |color_chips, amount_chips|
    @bankroll.sell_chips(amount_chips, color_chips)
end    
get '/deal' do
  content_type :json
  @deck.shuffle!
  @playerhand.hit(@deck.deal(2))
  player_cards = []
  @playerhand.cards.each do |card|
    player_cards.push(card.image)
  end
  @dealerhand.hit(@deck.deal(2))
  dealer_cards = []
  @dealerhand.cards.each do |card|
    dealer_cards.push(card.image)
  end
  {"player_hand" => player_cards, "dealer_hand" => dealer_cards}.to_json
end
get '/' do
  haml :main_menu
end
  
# This tells the game when someone types /hit or hits the hit button to deal 1 card from the deck, 
# if they get 21 from the card gameover = true
get '/hit' do
    @playerhand.hit(@deck.deal(1))
    if @playerhand.count > 21 then
      @gameover = true
    end
    # Move the card to the left so it overlaps.
    cards = @playerhand.cards
    card_overlap = (cards.length - 1) * -20
    "<li style='left: #{card_overlap}px;'> <img src='/images/Cards/#{@playerhand.cards[-1].image}' \> <\li>"
end

get '/hit_check' do
  @html = ""
  if playerhand.count >= 21 
    @html = "You Busted"    
  end
  @html
end

#This tells the game when someone types /stay or hits the button and hits of the dealers hand untill 
# the dealer gets > 16 then stops hitting the dealer. 
get '/stay' do
  @list_cards = ""
  @dealerhand.cards.each do |card|
    @list_cards +=  "<li><img src='/images/Cards/#{card.image}' \><\li>"    
  end  
  until @dealerhand.count > 16
    @dealerhand.hit(@deck.deal(1))
    card_overlap = (@dealerhand.cards.length - 1) * -20
    @list_cards +=  "<li style='left: #{card_overlap}px;'><img src='/images/Cards/#{@dealerhand.cards[-1].image}' \><\li>"    
  end  
  @list_cards
end

get '/check' do
  if @playerhand.count == @dealerhand.count
  end
end

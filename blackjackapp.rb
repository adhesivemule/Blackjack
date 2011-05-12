# blackjack.rb
require 'sinatra'
require 'haml'
require 'redis'
require './Cards.rb'
require './blackjack.rb'

use Rack::Session::Pool,
    :expire_after => 60 * 60

configure do
    set :redis, Redis.new
end

before do
    @id = request.cookies['rack.session']
    @deck = Deck.new
    @player = 1
    @dealer = 2
    @playerhand = BlackjackHand.new(@player)
    @dealerhand = BlackjackHand.new(@dealer)
end
    
get '/' do
    @deck.shuffle!
    @playerhand.hit(@deck.deal(2))
    @dealerhand.hit(@deck.deal(2))
    haml :index
end

get '/hit' do
    @playerhand.hit(@deck.deal(1))
    haml :index
end

get '/stay' do
  until @dealerhand.count > 16
    @dealerhand.hit(@deck.deal(1))
  end  
  haml :stay
end
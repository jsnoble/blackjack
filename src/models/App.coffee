# TODO: Refactor this model to use an internal Game Model instead
# of containing the game logic directly.
class window.App extends Backbone.Model
  initialize: ->
    @set 'deck', deck = new Deck()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()
    @set 'gameMessage', null
    @get('playerHand').on 'stand', =>
      @runLogic()


  runLogic: ->
    playerScore = @get("playerHand").scores()[0]

    if playerScore < @get('playerHand').scores()[1] <= 21
      playerScore = @get('playerHand').scores()[1]

    if playerScore > 21
      @set 'gameMessage', 'You lost!'
      return @trigger 'gameover', @

    dealerHand = @get('dealerHand')
    dealerHand.first().flip()

    dealerScore = @get('dealerHand').scores()[0]
    if dealerScore < @get('dealerHand').scores()[1] < 21
      dealerScore = @get('dealerHand').scores()[1]

    while dealerScore < 17
      dealerHand.hit()
      dealerScore = @get('dealerHand').scores()[0]
      if dealerScore < @get('dealerHand').scores()[1] < 21
        dealerScore = @get('dealerHand').scores()[1]


    if dealerScore > 21
      @set 'gameMessage', 'You WIN!'
    else if playerScore > dealerScore
      @set 'gameMessage', 'You WIN!'
    else if playerScore < dealerScore
      @set 'gameMessage', 'You LOSE!'
    else
      @set 'gameMessage', 'You LOSE!'

    @trigger 'gameOver', @

    restart: ->
      @initialize() if @get('deck').length < 16
      @set 'playerHand', @get('deck').dealPlayer()
      @set 'dealerHand', @get('deck').dealDealer()
      @set 'gameMessage', null
      @get('playerHand').on 'stand', =>
        @endGame()
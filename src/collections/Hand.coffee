class window.Hand extends Backbone.Collection
  model: Card

  initialize: (array, @deck, @isDealer) ->

  hit: ->
    @add(@deck.pop())
    if @busted()
      @trigger 'bust', @

  busted: ->
    @scores()[0] > 21

  playToWin: ->
    @first().flip()
    while @scores()[0] < 17
      @hit()
    if !@busted()
      @stand()

  maxScore: ->
    scores  = @scores()
    if scores[1] <= 21 then scores[1] else scores[0]

  stand: ->
    @trigger 'stand', @

  hasAce: -> @reduce (memo, card) ->
    memo or card.get('value') is 1
  , 0

  minScore: -> @reduce (score, card) ->
    score + if card.get 'revealed' then card.get 'value' else 0
  , 0

  scores: ->
    # The scores are an array of potential scores.
    # Usually, that array contains one element. That is the only score.
    # when there is an ace, it offers you two scores - the original score, and score + 10.
    [@minScore(), @minScore() + 10 * @hasAce()]



class window.AppView extends Backbone.View
  template: _.template '
    <button class="hit-button">Hit</button>
    <button class="stand-button">Stand</button>
    <button class="reset-button displayOff">Reset</button>
    <div class="player-hand-container"></div>
    <div class="dealer-hand-container"></div>
  '


  events:
    'click .hit-button': ->
      @model.get('playerHand').hit()
      @model.finishGame() if @model.get('playerHand').scores()[0] >21

    'click .stand-button': -> @model.get('playerHand').stand()


    "click .reset-button": ->
      @model.restart()


  initialize: ->
    @model.on 'gameOver', =>
      $('button').toggleClass('displayOff')
      @$el.prepend '<h1>' + @model.get("gameMessage") + '</h1>'
    @render()

  render: ->
    @$el.children().detach()
    @$el.html @template()
    @$('.player-hand-container').html new HandView(collection: @model.get 'playerHand').el
    @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el


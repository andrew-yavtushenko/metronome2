'use strict'

window.Sequencer ||= {}
window.AudioContext = window.AudioContext or window.webkitAudioContext
window.context = new AudioContext()

window.sequencer = angular.module('sequencer', ['ngRoute'])
  .config ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html'
        controller: Sequencer.MainCtrl
      .otherwise
        redirectTo: '/'

Sequencer.setupDependencies(sequencer)

window.ang = ->
  angular.element(document.querySelector('[ng-app]')).injector()


isUnlocked = false
unlock = ->
  buffer = context.createBuffer(1, 1, 22050)
  source = context.createBufferSource()
  source.buffer = buffer
  source.connect context.destination
  source.noteOn 0
  
  # by checking the play state after some time, we know if we're really unlocked
  setTimeout (->
    isUnlocked = true  if source.playbackState is source.PLAYING_STATE or source.playbackState is source.FINISHED_STATE
    window.removeEventListener 'touchstart', unlock, true 
  ), 10

window.addEventListener 'touchstart', unlock, true
'use strict'

window.Sequencer ||= {}

Sequencer.trackModel = (track) ->

  (source, timingFunction) ->

    _.extend source,
      getTaskDuration: timingFunction
      moveToNextTask: ->
        if @currentPatternIndex+1 == @patterns.length
          @currentPatternIndex = 0
        else
          @currentPatternIndex++

    track(source)

Sequencer.patternModel = (bar) ->

  (source, timingFunction) ->

    _.extend source,
      getTaskDuration: timingFunction
      moveToNextTask: ->
        if @currentLineIndex+1 == @notes.length
          @currentLineIndex = 0
        else
          @currentLineIndex++

    bar(source)

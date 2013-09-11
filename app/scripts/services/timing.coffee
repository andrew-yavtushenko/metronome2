'use strict'

window.Sequencer ||= {}

Sequencer.timing = () ->

  (bpm) ->

    noteDuration = (note) ->
      60 / bpm() * 4000 / note.value

    patternDuration = (pattern) ->
      pattern.beat.value / pattern.noteValue.value * noteDuration({value: 1})

    noteDuration: noteDuration
    patternDuration: patternDuration

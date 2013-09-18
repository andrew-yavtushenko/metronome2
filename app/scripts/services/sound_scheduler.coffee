'use strict'

window.Sequencer ||= {}

Sequencer.scheduler = () ->

  schedule = (note, sound) ->
    if note.height
      source = context.createBufferSource()
      gainNode = context.createGain()
      gainNode.gain.value = note.height
      source.buffer = sound.buffer
      source.connect(gainNode)
      gainNode.connect(context.destination)
      source.start = source.noteOn if !source.start
      source.start 0

  schedule: schedule
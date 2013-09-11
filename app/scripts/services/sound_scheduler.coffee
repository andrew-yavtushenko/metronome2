'use strict'

window.Sequencer ||= {}

Sequencer.scheduler = () ->

  schedule = (note, sound, delay = 0, duration = 0) ->
    if note.height
      source = context.createBufferSource()
      source.buffer = sound.buffer
      source.connect(context.destination)
      source.start = source.noteOn if !source.start
      source.start context.currentTime + delay, 0, duration

  schedule: schedule
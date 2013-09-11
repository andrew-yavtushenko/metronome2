'use strict'

window.Sequencer ||= {}

Sequencer.MainCtrl = (s, rootScope, q, settings, bufferProvider) ->

  bufferProvider.getFiles().then (files) ->
    bufferProvider.createAudioFiles(files)
    rootScope.$on 'AllAudioBuffered', (event, response) ->
      s.audios = _.map response
      s.currentAudio = s.audios[0]

  s.beat = _.sortBy _.map(settings.beat), (beat) -> Math.min(beat.beatValue)

  s.noteValue = _.sortBy _.map(settings.noteValue), (note) -> Math.min(note.noteValue)

  s.subDivisions = _.map settings.subDivision
  s.currentBeat      = s.beat[3]
  s.currentNoteValue = s.noteValue[2]
  s.currentBpm       = settings.defaultBpm

  window.bpm = -> s.currentBpm

  s.meter =
    bpm: -> s.currentBpm
    beat: -> s.currentBeat
    noteValue: -> s.currentNoteValue


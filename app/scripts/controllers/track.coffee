'use strict'

window.Sequencer ||= {}

Sequencer.TrackCtrl = (s, rootScope, q, timing, taskModel, audioScheduler) ->
  s.tracks = {}
  s.trackAmmout = 0
  s.newTrackName = 'New track'
  s.currentTrack = null

  s.start = (track) ->
    track.start()
    console.profile(s.newTrackName)
  s.stop = (track) ->
    track.stop()
    console.profileEnd()

  s.createTrack = (name) ->
    s.currentTrack =
      name: name
      patterns: []
      looped: true
      currentPatternIndex: 0

    taskModel(
      s.currentTrack.patterns,
      timing(window.bpm).patternDuration,
      s.currentTrack.looped,
      s.currentTrack.currentPatternIndex
    ).then (response) ->
      s.currentTrack.patternWorker = response
      s.currentTrack.start = -> s.currentTrack.patternWorker.start()
      s.currentTrack.stop = -> s.currentTrack.patternWorker.stop()
      s.tracks[name] = s.currentTrack

  s.createPattern = (track, beat, noteValue) ->

    availableSubDivisions = _.compact(_.map s.subDivisions, (subDivision) -> subDivision if subDivision.value >= noteValue.value)
    s.currentTrack = _.find s.tracks, track
    pattern = 
      availableSubDivisions: availableSubDivisions
      currentSubDivision: availableSubDivisions[0]
      beat: beat
      noteValue: noteValue
      lines: []
      start: ->
        _.each @lines, (line) -> line.output.start()
      stop: ->
        _.each @lines, (line) -> line.output.stop()
    s.currentTrack.patterns.push pattern

  s.createLine = (pattern, sound, subDivision) ->
    notesArr = ->
      arr = new Array(Math.ceil(pattern.beat.value*subDivision.value/pattern.noteValue.value))
      arr = _.map arr, (num, key, array) ->
        if pattern.beat.value*subDivision.value % pattern.noteValue.value != 0 && ++key * subDivision.value > Math.floor(pattern.beat.value*subDivision.value/pattern.noteValue.value)* subDivision.value
          correctNote = _.find pattern.availableSubDivisions, (availableSubDivision) ->
            availableSubDivision if availableSubDivision.value == subDivision.value * 2
        else
          correctNote = subDivision
        height: 0
        value: correctNote.value
        sound: sound
        start: ->
          audioScheduler.schedule(@, @sound)
      arr
    currentLine =
      sound: sound
      subDivision: subDivision
      notes: notesArr()
      looped: false
      currentLineIndex: 0
    taskModel(
      currentLine.notes
      timing(window.bpm).noteDuration
      currentLine.looped
      currentLine.currentLineIndex
    ).then (response) ->
      currentLine.output = response
      pattern.lines.push currentLine

  s.deletePattern = (track, pattern) ->
    track.patterns.splice(track.patterns.indexOf(pattern),1)
    --track.currentPatternIndex

  s.deleteLine = (pattern, line) ->
    pattern.lines.splice(pattern.lines.indexOf(line),1)
    --pattern.currentLineIndex



  s.updateNote = (line, note) ->
    currentNote = _.find line.notes, (missingNote) -> missingNote == note
    if currentNote.height == 0
      currentNote.height = 0.4
    else if currentNote.height == 0.4
      currentNote.height = 1
    else
      currentNote.height = 0



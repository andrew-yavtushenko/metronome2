'use strict'

window.Sequencer ||= {}

Sequencer.TrackCtrl = (s, rootScope, q, timing, trackModel, patternModel, audioScheduler, bar) ->
  s.tracks = {}
  s.trackAmmout = 0
  s.newTrackName = 'New track'
  s.currentTrack = null

  s.start = (track) ->
    track.started = true
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
      started: false

    s.currentTrack.patternWorker = trackModel(s.currentTrack,timing(window.bpm).patternDuration)
    s.currentTrack.start = ->
      s.currentTrack.started = true
      s.currentTrack.patternWorker.start()
    s.currentTrack.stop = -> s.currentTrack.patternWorker.stop()
    s.tracks[name] = s.currentTrack

  s.createPattern = (track, beat, noteValue) ->

    availableSubDivisions = _.compact(_.map s.subDivisions, (subDivision) -> subDivision if subDivision.value >= noteValue.value)
    s.currentTrack = _.find s.tracks, track
    s.currentTrack.currentPatternIndex++ if s.currentTrack.currentPatternIndex != 0
    pattern = 
      availableSubDivisions: availableSubDivisions
      currentSubDivision: availableSubDivisions[0]
      beat: beat
      noteValue: noteValue
      lines: []
      start: ->
        _.each @lines, (line) ->
          line.started = true
          line.start()
      stop: ->
        _.each @lines, (line) ->
          line.started = false
          line.stop()
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
      started: false
      getTaskDuration: timing(window.bpm).noteDuration
      moveToNextTask: ->
        if @currentLineIndex+1 == @notes.length
          @currentLineIndex = 0
        else
          @currentLineIndex++
    
    extendedCurrentLine = bar(currentLine)
    _.extend currentLine, bar(currentLine)
    pattern.lines.push currentLine

  s.deletePattern = (track, pattern) ->
    pattern.stop()
    track.patterns.splice(track.patterns.indexOf(pattern),1)
    --track.currentPatternIndex

  s.deleteLine = (pattern, line) ->
    line.stop()
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



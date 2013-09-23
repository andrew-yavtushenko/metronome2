'use strict'

window.Sequencer ||= {}

Sequencer.TrackCtrl = (s, rootScope, q, timing, trackModel, patternModel, audioScheduler, bar) ->
  s.tracks = {}
  s.trackAmmout = 0
  s.newTrackName = 'New track'
  s.currentTrack = null
  s.state = 'stopped'

  s.start = (track) ->
    if s.state == 'stopped'
      s.state = 'playing'
      track.started = true
      track.startPattern()
      console.profile(s.newTrackName)
  s.stop = (track) ->
    if s.state = 'playing'
      s.state = 'stopped'
      track.stop()
      console.profileEnd()

  s.createTrack = (name) ->
    s.currentTrack =
      name: name
      patterns: []
      looped: true
      currentPatternIndex: 0
      started: false
      startPattern: ->
        @patterns[@currentPatternIndex].start().then moveToNextPattern
      stop: ->
        @patterns[@currentPatternIndex].stop()
    s.tracks[name] = s.currentTrack

  moveToNextPattern = (pattern) ->
    if s.currentTrack.currentPatternIndex+1 == s.currentTrack.patterns.length
      s.currentTrack.currentPatternIndex = 0
    else
      s.currentTrack.currentPatternIndex++
    s.currentTrack.startPattern()


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
        console.log @pace
        @pace.start()
      stop: -> @pace.stop()

    pace = buildLine(pattern, null, availableSubDivisions[0])
    pattern.pace = pace
    s.currentTrack.patterns.push pattern

  s.createLine = (pattern, sound, subDivision) ->
    line = buildLine(pattern, sound, subDivision)
    pattern.lines.push line

  buildLine = (pattern, sound, subDivision) ->
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
    currentLine

  s.deletePattern = (track, pattern) ->
    if s.state == 'playing'
      track.stop()
      pattern.stop()
    track.patterns.splice(track.patterns.indexOf(pattern),1)

  s.deleteLine = (pattern, line) ->
    if s.state == 'playing'
      line.stop()
    pattern.lines.splice(pattern.lines.indexOf(line),1)



  s.updateNote = (line, note) ->
    currentNote = _.find line.notes, (missingNote) -> missingNote == note
    if currentNote.height == 0
      currentNote.height = 0.4
    else if currentNote.height == 0.4
      currentNote.height = 1
    else
      currentNote.height = 0



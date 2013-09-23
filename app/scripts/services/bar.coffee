'use strict'

window.Sequencer ||= {}

Sequencer.track = (scheduler) ->

  (taskSource) ->
    currentTask = null
    source = null
    start = ->
      if taskSource.patterns.length
        if taskSource.started
          currentTask = taskSource.patterns[taskSource.currentPatternIndex]
          currentTask.start()
          taskDuration = (taskSource.getTaskDuration(currentTask))|0
          console.log taskDuration
          executeTask(taskDuration, start)
          taskSource.moveToNextTask()
          if !taskSource.looped && taskSource.currentPatternIndex == 0
            stop()
      else
        stop()

    executeTask = (duration, callback) ->
      buffer = context.createBuffer(1, parseFloat(duration)*23, 23000)
      source = context.createBufferSource()
      source.buffer = buffer
      source.connect(context.destination)
      source.onended = callback
      source.start = source.noteOn if !source.start
      console.log duration
      console.log buffer.duration
      source.start(0)

    stop = ->
      taskSource.started = false
      currentTask.stop()
      taskSource.currentPatternIndex = 0
      source.stop(0)

    start: start
    stop: stop

Sequencer.bar = (scheduler) ->

  (taskSource) ->
    source = null
    start = ->
      if taskSource.notes.length
        if taskSource.started
          currentTask = taskSource.notes[taskSource.currentLineIndex]
          currentTask.start()
          taskDuration = (taskSource.getTaskDuration(currentTask))|0
          taskSource.moveToNextTask()
          if !taskSource.looped && taskSource.currentLineIndex == 0
            stop()
          else
            executeTask(taskDuration, start)
      else
        stop()


    executeTask = (duration, callback) ->
      buffer = context.createBuffer(1, parseFloat(duration)*23, 23000)
      source = context.createBufferSource()
      source.buffer = buffer
      source.connect(context.destination)
      source.onended = callback
      source.start = source.noteOn if !source.start
      source.start(0)

    stop = ->
      taskSource.currentLineIndex = 0
      source.stop(0)
      taskSource.started = false

    start: start
    stop: stop
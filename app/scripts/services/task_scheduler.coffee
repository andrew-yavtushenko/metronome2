'use strice'

window.onload = ->

  window.parent.postMessage 'scheduler', '*'

  window.init = (source) ->
    timestamp = null
    taskDuration = null
    currentTask = null
    pm = window.postMessage
    now = null

    run = (event) ->
      now = Date.now()
      if timestamp < now
        currentTask = source.tasks[source.currentTaskIndex]
        currentTask.start()
        taskDuration = (source.getTaskDuration(currentTask))|0
        timestamp = now + taskDuration
        source.moveToNextTask()
        if !source.looped && source.currentTaskIndex == 0
          stop()
      pm 0, '*'

    start = () ->
      if source.tasks.length
        timestamp = Date.now()
        window.addEventListener 'message', run, true
        pm 0, '*'

    stop = ->
      currentTask.stop() if currentTask.stop
      source.currentTaskIndex = 0
      window.removeEventListener 'message', run, true


    start: start
    stop: stop

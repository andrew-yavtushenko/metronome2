'use strict'

window.Sequencer ||= {}

Sequencer.taskModel = (q, rootScope) ->

  createWorker = (name) ->
    resolveWorker = (event) ->
      if event.data == 'scheduler'
        deferred.resolve(frame.contentWindow)
        rootScope.$apply()
        window.removeEventListener 'message', resolveWorker, true

    deferred = q.defer()

    frame = document.createElement 'iframe'
    frame.src = name+'.html'
    document.body.appendChild frame

    window.addEventListener 'message', resolveWorker, true

    deferred.promise

  (sourceTasks, timingFunction, sourceIsLooped, sourceCurrentTaskIndex) ->

    deferred = q.defer()

    instance =
      tasks: sourceTasks
      getTaskDuration: timingFunction
      looped: sourceIsLooped
      currentTaskIndex: sourceCurrentTaskIndex
      moveToNextTask: ->
        if @currentTaskIndex+1 == @tasks.length
          @currentTaskIndex = 0
        else
          @currentTaskIndex++

    createWorker('task_scheduler').then (worker) ->
      deferred.resolve worker.init(instance)

    deferred.promise

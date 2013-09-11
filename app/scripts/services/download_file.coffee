'use strict'

window.Sequencer ||= {}

Sequencer.fileProvider = (q, http) ->

  getFile: (height) ->
    deferred = q.defer()
    request = http.get("audio/" + height + '.mp3', responseType: "arraybuffer")
    request.success (data) ->
      deferred.resolve data
    request.error (data) ->
      deferred.resolve data

    deferred.promise

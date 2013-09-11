'use strict'

window.Sequencer ||= {}
Sequencer.bufferProvider = (q, rootScope, settings, fileProvider) ->

  getFiles = () ->
    files = []
    deferred = q.defer()
    _.each settings.sounds, (sound) ->
      fileProvider.getFile(sound.fileName).then (response) ->
        window[sound.fileName] = response
        files.push
          'key': sound
          'value': response
        deferred.resolve(files) if files.length == settings.sounds.length

    deferred.promise

  createAudioFiles = (files) ->
    renderedSounds = {}
    _.each files, (sound, key, array) ->
      context.decodeAudioData sound.value, ((buffer) ->
        renderedSounds[sound.key.fileName] =
          title: sound.key.title
          buffer: buffer
        if key + 1 == array.length
          rootScope.$broadcast 'AllAudioBuffered', renderedSounds
      ), (error) ->
        console.error error

  getFiles: getFiles
  createAudioFiles: createAudioFiles
'use strict'

window.Sequencer ||= {}

Sequencer['setupDependencies'] = (app) ->
  app.factory 'timing', [Sequencer.timing]
  app.factory 'scheduler', [Sequencer.scheduler]
  app.factory 'settings', [Sequencer.settings]
  app.factory 'fileProvider', ['$q', '$http', Sequencer.fileProvider]
  app.factory 'bufferProvider', ['$q', '$rootScope', 'settings', 'fileProvider', Sequencer.bufferProvider]
  app.factory 'taskModel', ['$q', '$rootScope', Sequencer.taskModel]

Sequencer.MainCtrl.$inject = ['$scope', '$rootScope', '$q', 'settings', 'bufferProvider']
Sequencer.TrackCtrl.$inject = ['$scope', '$rootScope', '$q', 'timing', 'taskModel', 'scheduler']

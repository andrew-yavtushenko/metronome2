'use strict'

window.Sequencer ||= {}

Sequencer.settings = ->

  sounds = [
    fileName:'hat'
    title:'Hi-hat'
  ,
    fileName:'snare'
    title:'Snare drum'
  ,
    fileName:'kick'
    title:'Kick drum'
  ]

  defaultBpm = 120

  subDivision = [
    name: "Semibreve"
    value: 1
  ,
    name: "Minim"
    value: 2
  ,
    name: "Crochet"
    value: 4
  ,
    name: "Quaver"
    value: 8
  ,
    name: "Quaver triplet"
    value: 12
  ,
    name: "Semiquaver"
    value: 16
  ,
    name: "Semiquaver triplet"
    value: 24
  ,
    name: "Demiquaver"
    value: 32
  ,
    name: "Demiquaver triplet"
    value: 48
  ,
    name: "Hemidemisemiquaver"
    value: 64
  ]
  beat = [
    name: '1'
    value: 1
  ,
    name: '2'
    value: 2
  ,
    name: '3'
    value: 3
  ,
    name: '4'
    value: 4
  ,
    name: '5'
    value: 5
  ,
    name: '6'
    value: 6
  ,
    name: '7'
    value: 7
  ,
    name: '8'
    value: 8
  ,
    name: '9'
    value: 9
  ,
    name: '10'
    value: 10
  ,
    name: '11'
    value: 11
  ,
    name: '12'
    value: 12
  ,
    name: '13'
    value: 13
  ,
    name: '14'
    value: 14
  ,
    name: '15'
    value: 15
  ,
    name: '16'
    value: 16
  ]

  noteValue = [
    name: '1'
    value: 1
  ,
    name: '2'
    value: 2
  ,
    name: '4'
    value: 4
  ,
    name: '8'
    value: 8
  ,
    name: '16'
    value: 16
  ]

  beat: beat
  noteValue: noteValue
  sounds: sounds
  subDivision: subDivision
  defaultBpm: defaultBpm

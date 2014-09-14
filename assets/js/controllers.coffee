angular.module('PuntersBotApp.controllers', [])
  .controller 'HomeController', ->
    @why = ->
        $location.hash('why')
        $anchorScroll()
  .controller 'SimulationController', ['$http', ($http) ->
      @marketFilter = {}
      @scenarios = [{}]
      @exchanges = [{id: 1, name:'AUS'},{id: 2, name: 'UK'}]
      @eventTypes = [{id: 7, name: 'Horse Racing'},{id: 4339, name: 'Greyhound Racing'}]
      @marketTypes = [{name: 'WIN'}, {name: 'PLACE'}]
      @run ->
        $http.get('/simulate').success ->
           console.log('HELLO')
     ]
       

  

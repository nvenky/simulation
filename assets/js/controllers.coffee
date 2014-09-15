angular.module('PuntersBotApp.controllers', [])
  .controller 'HomeController', ->
    @why = ->
        $location.hash('why')
        $anchorScroll()
  .controller 'SimulationController', ['$http', '$log', '$scope', ($http, $log, $scope) ->
      $log.info('Inside the controller 2')
      @marketFilter = {}
      @scenario = {}
      $scope.exchanges = [{id: 1, name:'AUS'},{id: 2, name: 'UK'}]
      $scope.eventTypes = [{id: 7, name: 'Horse Racing'},{id: 4339, name: 'Greyhound Racing'}]
      $scope.marketTypes = [{name: 'WIN'}, {name: 'PLACE'}]
      @run = ->
        $log('Before')
        $http.get('/simulate').success ->
           $log('HELLO')
     ]
       

  

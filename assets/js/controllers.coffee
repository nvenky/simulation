angular.module('PuntersBotApp.controllers', [])
  .controller 'HomeController', ['$scope', ($scope) ->
      $('body').addClass('homepage')
      $scope.$on "$destroy", ->
         $('body').removeClass('homepage')
  ]
  .controller 'SimulationController', ['$scope', '$http', '$log', ($scope, $http, $log) ->
      $scope.exchanges = [{id: 1, name:'Australia'},{id: 2, name: 'International'}]
      $scope.eventTypes = [{id: 7, name: 'Horse Racing'},{id: 4339, name: 'Greyhound Racing'}]
      $scope.marketTypes = ['WIN', 'PLACE']
      $scope.ranges = ['ALL', 'TOP 1/2', 'TOP 1/3', 'BOTTOM 1/2', 'BOTTOM 1/3']
      $scope.betTypes= ['BACK', 'LAY', 'LAY (SP)']


      $scope.simulationParams = {
          commission: 6.5,
          scenarios: [{stake: 5}],
          marketFilter: {marketType: 'WIN', exchangeId: 1}
      }
      $scope.addScenario = ->
        $scope.simulationParams.scenarios.push({})
      $scope.deleteScenario = (index)->
        $scope.simulationParams.scenarios.splice(index, 1)
      $scope.run = ->
        $http.post('/scenario/simulate', $scope.simulationParams)
          .success (data, status)->
            new Highcharts.Chart
                chart:
                    animation: true,
                    renderTo: 'chart',
                    type: 'StockChart',
                    exporting:
                      enabled: true
                    ,
                   rangeSelector :
                       selected : 1,
                       inputEnabled: $('#container').width() > 480
                   ,
                   title : {
                       text : 'Simulation Result'
                   },
                   series : [{
                     name : 'Earnings',
                     data : data.response,
                     tooltip:
                      valueDecimals: 2
                  }]
                             
  ]
       

  

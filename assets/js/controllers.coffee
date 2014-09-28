angular.module('PuntersBotApp.controllers', [])
  .controller 'HomeController', ['$scope', ($scope) ->
      $('body').addClass('homepage')
      scrollHandler = ->
            if $(".navbar").offset().top > 30
              $(".navbar-fixed-top").addClass("top-nav-collapse")
            else
              $(".navbar-fixed-top").removeClass("top-nav-collapse")

      $scope.$on "$destroy", ->
         $('body').removeClass('homepage')
         #$(document).off('scroll', scrollHandler)


      $scope.$on "$viewContentLoaded", ->
        #$(document).on('scroll', scrollHandler)
         
         $('a.page-scroll').bind 'click', (event) ->
            $anchor = $(this)
            $('html, body').stop().animate({scrollTop: $($anchor.attr('href')).offset().top}, 1500, 'easeInOutExpo')
            event.preventDefault()
       
         $('.homepage .navbar-collapse ul li a').click ->
            $('.homepage .navbar-toggle:visible').click()
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
            $('#chart').innerHTML=''
            raceResultsSeries = []
            raceSummarySeries = []
            summaryAmount = 0
            series =  for result, i in data.response
              result = result.value.ret
              raceResultsSeries.push(result)
              summaryAmount += result
              raceSummarySeries.push(summaryAmount)
            
            new Highcharts.Chart
                  chart:
                    renderTo: 'chart',
                    zoomType: 'x'
                  animation: true
                  exporting:
                    enabled: true
                  title:
                       text: 'Simulation Result'
                  plotOptions:
                    series:
                      cursor: 'pointer'
                      pointStart: 1
                      negativeColor: '#FF0000'
                      marker:
                         lineWidth: 1
                      point:
                        events:
                          click: (e) ->
                            $('#race-details').html("Hurray.. Got it #{@x} - #{@y}")
                  series: [
                    name: 'Earnings'
                    data: raceResultsSeries
                    type: 'column'
                   ,
                    name: 'Summary'
                    data: raceSummarySeries
                    type: 'spline'
                  ]
  ]
       

  

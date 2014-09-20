angular.module('PuntersBotApp.simulationChart', [])

    $scope.renderChart (data) ->
        $('#chart').highcharts 'SimulationChart', {
            rangeSelector : {
                selected : 1,
                inputEnabled: $('#container').width() > 480
            },

            title : {
                text : 'Simulation Result'
            },

            series : [{
                name : 'Earnings',
                data : data.response,
                tooltip: {
                    valueDecimals: 2
                }
            }]
        }

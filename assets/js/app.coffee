angular.module('PuntersBotApp', [
  'ngRoute',
  'PuntersBotApp.filters',
  'PuntersBotApp.directives',
  'PuntersBotApp.controllers',
  'datePicker'
]).
config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when('/index', {templateUrl: 'assets/partials/homepage.html', controller: 'HomeController'})
  $routeProvider.when('/simulation', {templateUrl: 'assets/partials/simulation.html', controller: 'SimulationController'})
  $routeProvider.otherwise({redirectTo: '/index'})
 ]

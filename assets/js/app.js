'use strict';


// Declare app level module which depends on filters, and services
angular.module('PuntersBotApp', [
  'ngRoute',
  'PuntersBotApp.filters',
  'PuntersBotApp.services',
  'PuntersBotApp.directives',
  'PuntersBotApp.controllers'
]).
config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/index', {templateUrl: 'assets/partials/homepage.html', controller: 'HomeController'});
  $routeProvider.when('/simulation', {templateUrl: 'assets/partials/simulation.html', controller: 'SimulationController'});
  $routeProvider.otherwise({redirectTo: '/index'});
}]);

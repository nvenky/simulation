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
  $routeProvider.when('/', {templateUrl: 'templates/homepage.html', controller: 'HomePage'});
  $routeProvider.when('/view2', {templateUrl: 'partials/partial2.html', controller: 'MyCtrl2'});
  $routeProvider.otherwise({redirectTo: '/'});
}]);
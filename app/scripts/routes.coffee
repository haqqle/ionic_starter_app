
'use strict'

angular.module('appRoutes').config ($stateProvider, $urlRouterProvider) ->

  $stateProvider.state 'app',
    url: '/app'
    abstract: true
    templateUrl: 'views/layout.html'
    controller: 'AppController'

  .state 'app.start',
    cache: false
    url: '/start'
    views:
      mainContent:
        controller: 'StartController'
        templateUrl: 'views/start.html'


  $urlRouterProvider.otherwise "app/start"
  return



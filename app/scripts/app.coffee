'use strict'

#init modules
appServices = angular.module('appServices',[])
appRoutes = angular.module('appRoutes', [])
appFilters = angular.module('appFilters',[])
appControllers = angular.module('appControllers', ['appServices', 'ionic'])
appDirectives = angular.module('appDirectives',[])
appConstants = angular.module('appConstants',[])
phonegap = angular.module('phonegap',[])

angular.module('app', [
  'ionic'
  'appControllers'
  'appRoutes'
  'appFilters'
  'appDirectives'
  'appConstants'
  'phonegap'
]).config([() ->
  # $ionicConfigProvider.views.maxCache(11)
  # $ionicConfigProvider.views.transition('android')

]).run(($ionicPlatform, $rootScope) ->
  # use underscore in views, ng-repeat="x in _.range(3)"
  $rootScope._ = window._

  # init moment language"
  $ionicPlatform.ready ->
    cordova.plugins.Keyboard.hideKeyboardAccessoryBar true  if window.cordova and window.cordova.plugins.Keyboard
    StatusBar.styleDefault()  if window.StatusBar
  return
)

# init app if phonegap is ready on device
window.ionic.Platform.ready () ->
  angular.bootstrap(document, ['app'])


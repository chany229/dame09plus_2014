angular.module('my_routes', []).
config(['$routeProvider', function($routeProvider) {
	$routeProvider.
	when('/top', {templateUrl: '/top'}).
	//when('/phones/:phoneId', {templateUrl: 'partials/phone-detail.html', controller: PhoneDetailCtrl}).
	otherwise({redirectTo: '/top'});
}]);
//function TopCtrl($scope, $routeParams) {
//  $scope.phoneId = $routeParams.phoneId;
//}
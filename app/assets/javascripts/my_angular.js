angular.module('my_routes', []).
config(['$routeProvider', function($routeProvider) {
	$routeProvider.
	when('/top', {templateUrl: '/top'}).
	when('/logs', {templateUrl: '/logs'}).
	otherwise({redirectTo: '/top'});
}]);
function SideCtrl($scope, $location) {
	$scope.sideLiClass = function(path) {
		var cur_path = $location.path();
		console.log(cur_path);
		if (cur_path.indexOf(path) == 1) {
			return "current";
		} else {
			return "";
		}
	}
}
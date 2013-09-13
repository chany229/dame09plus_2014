angular.module('my_routes', []).
config(['$routeProvider', function($routeProvider) {
	$routeProvider.
	when('/top', {templateUrl: '/top?from_angular=1'}).
	when('/logs', {templateUrl: '/logs?from_angular=1'}).
	when('/logs/tag/:tag_name', {
		template: '<div ng-include src="templateUrl"><div class="loading"></div></div>',
		controller: TagCtrl
	}).
	when('/logs/tag/:tag_name/p:page', {
		template: '<div ng-include src="templateUrl"><div class="loading"></div></div>',
		controller: TagCtrl
	}).
	when('/logs/tags/:params', {
		template: '<div ng-include src="templateUrl"><div class="loading"></div></div>',
		controller: TagsCtrl
	}).
	when('/logs/tags/:params/p:page', {
		template: '<div ng-include src="templateUrl"><div class="loading"></div></div>',
		controller: TagsCtrl
	}).
	when('/logs/:date', {
		template: '<div ng-include src="templateUrl"><div class="loading"></div></div>',
		controller: DateCtrl
	}).
	when('/logs/:date/p:page', {
		template: '<div ng-include src="templateUrl"><div class="loading"></div></div>',
		controller: DateCtrl
	}).
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
function LoadPageCtrl($scope, $rootScope, $location) {
	$scope.isViewLoading = false;
	$scope.$on('$locationChangeStart', function(event, next, current) {
		console.log('location change');
	})

	$scope.$on('$routeChangeStart', function(event, next, current) {
		$scope.isViewLoading = true;
	});

	$scope.$on('$routeChangeError', function(event, next, current, error) {
		$scope.isViewLoading = false;
		if (error.status = 401) {
			alert(error.data);
			window.location = '/users/sign_in';
		}
	});

	$rootScope.$on('$routeChangeSuccess', function() {
		$scope.isViewLoading = false;
	});
}
function DateCtrl($scope, $routeParams, $templateCache) {
	$templateCache.removeAll();
	var date = $routeParams.date;
	var page = $routeParams.page;
	var params = date.split('-');
	console.log(date);
	console.log(params);
	if (page) {
		if (params.length == 3) {
			$scope.templateUrl = '/logs/date/' + params[0] + '/' + params[1] + '/' + params[2] + '/p' + page + "?from_angular=1";
		} else if (params.length == 2) {
			$scope.templateUrl = '/logs/date/' + params[0] + '/' + params[1] + '/p' + page + "?from_angular=1";
		} else if (params.length == 1) {
			$scope.templateUrl = '/logs/date/' + params[0] + '/p' + page + "?from_angular=1";
		} else {
			$scope.templateUrl = '/logs?from_angular=1';
		}
	} else {
		if (params.length == 3) {
			$scope.templateUrl = '/logs/date/' + params[0] + '/' + params[1] + '/' + params[2] + "?from_angular=1";
		} else if (params.length == 2) {
			$scope.templateUrl = '/logs/date/' + params[0] + '/' + params[1] + "?from_angular=1";
		} else if (params.length == 1) {
			$scope.templateUrl = '/logs/date/' + params[0] + "?from_angular=1";
		} else {
			$scope.templateUrl = '/logs?from_angular=1';
		}
	}
}
function TagCtrl($scope, $routeParams, $templateCache) {
	$templateCache.removeAll();
	var tag_name = $routeParams.tag_name;
	var page = $routeParams.page;
	if (page) {
		$scope.templateUrl = '/logs/tag/' + tag_name + '/p' + page + "?from_angular=1";
	} else {
		$scope.templateUrl = '/logs/tag/' + tag_name + "?from_angular=1";
	}
}
function TagsCtrl($scope, $routeParams, $templateCache) {
	$templateCache.removeAll();
	var params = $routeParams.params.split('-');
	$scope.templateUrl = '/logs/tags/' + params[0] + '/' +params[1] + "?from_angular=1";
}
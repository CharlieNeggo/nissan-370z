

angular.module('gaugesScreen', [])
.controller('GaugesScreenController', function($scope, $window) {
  var unit = null;
  $scope.data = {}
  // overwriting plain javascript function so we can access from within the controller
  $window.setUnits = (data) => {
    unit = data.unitType;
  }
  
  $window.updateData = (data) => {
    $scope.$evalAsync(function() {
      if (data.gear === -1) {
        $scope.data.gear = "R";
      }
      else if (data.gear === 0) {
        $scope.data.gear = "N";
      }
      else {
        $scope.data.gear = data.gear;
      }

      $scope.data.time = data.time;
      $scope.data.mode = data.mode;

      
      
	  document.getElementById("fuel").style.left = (data.fuel - 314) + "px";
	  document.getElementById("temp").style.left = (data.temp - 314) + "px";
    document.getElementById("mode").style.left = (data.mode - 314) + "px";
    })
  }
});    
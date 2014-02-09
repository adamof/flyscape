'use strict';

angular.module('angularApp')
  .controller('ResultsCtrl', function ($scope, $http) {
    $scope.results = [
        {
            flights: [
                {
                    from: "EDI",
                    from_full: "Edinburgh Airport",
                    from_city: "Edinburgh",

                    to: "MAD",
                    to_full: "Madrid Airport",
                    to_city: "Madrid",

                    time: "2014-03-12 09:30",
                    duration: 110,

                    company: "Easy Jet",
                    logo: "resources/easyjet.png",

                    price: 40,
                    currency: "GBP",
                },
                {
                    from: "MAD",
                    from_full: "Madrid Airport",
                    from_city: "Madrid",

                    to: "WIE",
                    to_full: "Wien Airport",
                    to_city: "Wien",

                    time: "2014-03-14 10:30",
                    duration: 70,

                    company: "Easy Jet",
                    logo: "resources/easyjet.png",

                    price: 30,
                    currency: "EUR",
                },
                {
                    from: "WIE",
                    from_full: "Wien Airport",
                    from_city: "Wien",

                    to: "SOF",
                    to_full: "Sofia Airport",
                    to_city: "Sofia",

                    time: "2014-03-15 11:20",
                    duration: 130,

                    company: "Easy Jet",
                    logo: "resources/easyjet.png",

                    price: 90,
                    currency: "EUR",
                },
                {
                    from: "SOF",
                    from_full: "Sofia Airport",
                    from_city: "Sofia",

                    to: "STD",
                    to_full: "Stansted Airport",
                    to_city: "London",

                    time: "2014-03-21 16:30",
                    duration: 110,

                    company: "Ryan Air",
                    logo: "resources/ryanair.png",

                    price: 80,
                    currency: "GBP",
                }
            ],
            currency: {
                main: "EUR",
                "GBP": 1.2
            }
        },
        {
            flights: [
                {
                    from: "EDI",
                    from_full: "Edinburgh Airport",
                    from_city: "Edinburgh",

                    to: "MAD",
                    to_full: "Madrid Airport",
                    to_city: "Madrid",

                    time: "2014-03-12 09:30",
                    duration: 110,

                    company: "Easy Jet",
                    logo: "resources/easyjet.png",

                    price: 40,
                    currency: "GBP",
                },
                {
                    from: "MAD",
                    from_full: "Madrid Airport",
                    from_city: "Madrid",

                    to: "WIE",
                    to_full: "Wien Airport",
                    to_city: "Wien",

                    time: "2014-03-14 10:30",
                    duration: 70,

                    company: "Easy Jet",
                    logo: "resources/easyjet.png",

                    price: 30,
                    currency: "EUR",
                },
                {
                    from: "WIE",
                    from_full: "Wien Airport",
                    from_city: "Wien",

                    to: "SOF",
                    to_full: "Sofia Airport",
                    to_city: "Sofia",

                    time: "2014-03-15 11:20",
                    duration: 130,

                    company: "Easy Jet",
                    logo: "resources/easyjet.png",

                    price: 90,
                    currency: "EUR",
                },
                {
                    from: "SOF",
                    from_full: "Sofia Airport",
                    from_city: "Sofia",

                    to: "STD",
                    to_full: "Stansted Airport",
                    to_city: "London",

                    time: "2014-03-21 16:30",
                    duration: 110,

                    company: "Ryan Air",
                    logo: "resources/ryanair.png",

                    price: 90,
                    currency: "GBP",
                }
            ],
            currency: {
                main: "EUR",
                "GBP": 1.2
            }
        }

    ];

    for (var i = 0; i < $scope.results.length; i++) {
        $scope.results[i].activeFlight = $scope.results[i].flights[0];
    };

    $scope.journeyHeight = function(journey) {
        return $scope.results[journey].flights.length * 38 + 1;
    }
    $scope.imgPadding = function(journey) {
        var padding =  ($scope.results[journey].flights.length * 38 - 55) / 2  ;
        return padding + "px"
    }
    $scope.pricePadding = function(journey) {
        var padding =  ($scope.results[journey].flights.length * 38 - 36) / 2  ;
        return padding + "px"
    }

    $scope.showInfo = function(journey, flight) {
        $scope.results[journey].activeFlight = $scope.results[journey].flights[flight];
    };

    $scope.isActive = function(journey, flight) {
        if ($scope.results[journey].activeFlight == $scope.results[journey].flights[flight]) {
            console.log('kur');
            return true;
        }
        return false;;
    };

    $scope.dateToString = function(date) {
        var time = ""
        var dateObj = moment(date);
        time += dateObj.format("HH:mm");
        time += " on ";
        time += dateObj.format("DD MMMM YYYY");
        return time;
    }

    $scope.totalPrice = function(index) {
        var price = 0;
        for (var i = 0; i < $scope.results[index].flights.length; i++) {
            if ($scope.results[index].flights[i].currency === $scope.results[index].currency.main) {
                price += $scope.results[index].flights[i].price;
            } else {
                price += $scope.results[index].flights[i].price * $scope.results[index].currency[$scope.results[index].flights[i].currency]
            }
        };
        return price;
    };

  });

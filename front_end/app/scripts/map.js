var geocoder,
    rec1 = true,
    rec2 = true;

function lookup_temp (lat,lng) {

  $("#lat").text(lat);
  $("#lng").text(lng);

  // $.ajax({
  //   url : "http://api.wunderground.com/api/bcf586eea1bd99b0/geolookup/conditions/forecast/q/"+lat+","+lng+".json",
  //   dataType : "jsonp",
  //   success : function(parsed_json) {
  //     var location = parsed_json['location']['city'];
  //     var temp_c = parsed_json['current_observation']['temp_c'];
  //     $("#city").text(location);
  //     $("#temp").text(temp_c);
  //   }
  // });
}

function gmaps_initialize() {
  min_stay = 2;
  max_stay = 6;

  markers = [];
  var mapDiv = document.getElementById('map-canvas');
  var myStyle = [
    {
      "featureType": "road",
      "stylers": [
        { "visibility": "off" }
      ]
    },{
      "featureType": "administrative.country",
      "stylers": [
        { "visibility": "on" }
      ]
    },{
      "featureType": "administrative.locality",
      "stylers": [
        { "visibility": "on" }
      ]
    },{
      "featureType": "administrative.province",
      "stylers": [
        { "visibility": "off" }
      ]
    }
  ];
  map = new google.maps.Map(mapDiv, {
    center: new google.maps.LatLng(49.41097319969587, -352.001953125),
    zoom: 4,
    mapTypeControlOptions: {
     mapTypeIds: ['mystyle', google.maps.MapTypeId.ROADMAP, google.maps.MapTypeId.TERRAIN]
    },
    mapTypeId: 'mystyle'
  });
  map.mapTypes.set('mystyle', new google.maps.StyledMapType(myStyle, { name: 'My Style' }));

  geocoder = new google.maps.Geocoder();

  getLocation();

  google.maps.event.addListener(map, 'click', function(event, mapz) {
    var zoom = map.getZoom();
    setTimeout(function(){
      add_pin(map, event.latLng, zoom);}, 300);
  });

  journey_date = format_date(new Date(2013, 02));

  $("#rec1").click(function() {
    if (rec1 == true){
      add_pin(map, new google.maps.LatLng(41.393294288784865, 2.1533203125), map.getZoom());
      rec1 = false;
    }
  });
  $("#rec2").click(function() {
    if (rec2 == true) {
      add_pin(map, new google.maps.LatLng(52.51454943590012, 13.39508056640625), map.getZoom());
      rec2 = false;
    }
  });

  $(".submit a").click(function() {
    // $(this).html('<img src="/static/img/ajax-loader.gif" width="100" height="100">')
    $(".submit a img").toggle();
    console.log($(this).html());
    send_route();
  });

}

function getLocation(){
  if (navigator.geolocation){
    navigator.geolocation.getCurrentPosition(setStart, handleError);
  }
  else{console.log("Geolocation is not supported by this browser.");}
}
function showPosition(position){
  x.innerHTML=  "Latitude: " + position.coords.latitude +
                "<br>Longitude: " + position.coords.longitude;
}

function handleError(argument) {
  var path = [];
  line = new google.maps.Polyline({
    path: path,
    strokeColor: '#800800',
    strokeOpacity: 0.6,
    strokeWeight: 0
  });

  line.setMap(map);
}

function setStart(position) {
  lat = position.coords.latitude;
  lng = position.coords.longitude;
  var startPosition = new google.maps.LatLng(lat, lng);

  codeLatLng(lat, lng);

  var path = [];

  line = new google.maps.Polyline({
    path: path,
    strokeColor: '#800800',
    strokeOpacity: 0.6,
    strokeWeight: 0
  });

  line.setMap(map);

  add_pin(map, startPosition, map.getZoom());
  // markers.push(new google.maps.Marker({
  //   map: map,
  //   position: startPosition,
  //   draggable: true
  // }))
}

function add_pin(map, latLng, mapZoom) {
  if (mapZoom != map.getZoom())
    return false;
  var path = line.getPath();
  path.push(latLng);
  var marker = new google.maps.Marker({
    map: map,
    position: latLng,
    // draggable: true,
    raiseOnDrag: false
  });

  markers.push(marker);

  google.maps.event.addListener(marker, 'click', function() {
    marker.setMap(null);
    for (var i = 0, I = markers.length; i < I && markers[i] != marker; ++i);
    markers.splice(i, 1);
    path.removeAt(i);
  });

  // google.maps.event.addListener(marker, 'dragend', function() {
  //   for (var i = 0, I = markers.length; i < I && markers[i] != marker; ++i);
  //   path.setAt(i, marker.getPosition());
  // });

  lookup_temp(latLng.lat(), latLng.lng());
}

// function send_route() {
//   var coordinates = line.getPath().getArray().map(function(elem, ind){
//     return elem.toString();
//   });
//   window.location = "/lala?coords=" + encodeURIComponent(coordinates);
// }
function send_route() {
  var coordinates = line.getPath().getArray().map(function(elem, ind){
    return elem.toString();
  });
  window.location = "/map/get_routes?" + $.param({
    date: journey_date,
    coords: line.getPath().getArray().map(function(v, i ) {
      return v.lat().toString() + ", " + v.lng().toString()
    }),
    min_stay: min_stay,
    max_stay: max_stay
  });
}

function format_date(date) {
  var year = date.getFullYear().toString(),
      month = date.getMonth()+1;

  return year + "-" + ( (month<10) ? ("0"+month.toString()) : month.toString() )
}

function codeLatLng(lat, lng) {
  var latlng = new google.maps.LatLng(lat, lng);
  geocoder.geocode({'latLng': latlng}, function(results, status) {
    if (status == google.maps.GeocoderStatus.OK) {
      if (results[1]) {
        // alert(results[0].formatted_address);

        var city;
        //find country name
        for (var i=0; i<results[0].address_components.length; i++) {
          for (var b=0;b<results[0].address_components[i].types.length;b++) {

            // there are different types that might hold a city admin_area_lvl_1 usually does in some cases
            // looking for sublocality type will be more appropriate
            if (results[0].address_components[i].types[b] == "locality") {
                //this is the object you are looking for
                city = results[0].address_components[i];
                break;
            }
          }
        }
        //city data
        city_name = city.short_name;
        $('input[name=start-location]').val(city_name);
        // console.log(city.short_name + " " + city.long_name);

      } else {
        console.log("No results found");
      }
    } else {
      console.log("Geocoder failed due to: " + status);
    }
  });
}

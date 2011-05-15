function map_initialize() {	

				// when first loading the window make sure map_canvas & map are set to appropriate
				// dimensions based on the iphone's orientation when loading the map
				if ((window.orientation == (-90)) || (window.orientation == (90))) {
					var width = 520; var height = 285;
					$('#map_canvas').css({width:width});
					$('#map_canvas').css({height:height});
					$('#map-overflow').css({width:width});
					$('#map-overflow').css({height:(height-10)});
					console.log("90");
				} else {
					var width = 360; var height = 435;
					$('#map_canvas').css({width:width});
					$('#map_canvas').css({height:height});
					$('#map-overflow').css({width:width});
					$('#map-overflow').css({height:(height-10)});
					console.log("not 90")
				}

				// create the map
				var latlng = new google.maps.LatLng(39.63465814,-79.95371237);
				var myOptions = {
					zoom: 16,
					center: latlng,
					disableDefaultUI: true,
					mapTypeId: google.maps.MapTypeId.ROADMAP
				};

				map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);

				// load the marker
				var image = new google.maps.MarkerImage("/themes/jqt/img/info.png",new google.maps.Size(32, 37));
				var shadowi = new google.maps.MarkerImage("/themes/jqt/img/shadow.png",new google.maps.Size(51, 37));
			  var myLatLng = new google.maps.LatLng(39.63465814,-79.95371237);
			  var beachMarker = new google.maps.Marker({
			      position: myLatLng,
			      map: map,
						shadow: shadowi,
			      icon: image
			  });

				// fixing a bug with setCenter which doesn't seem to do anything on second load
				if (map_loaded == true) {
					map.panBy(-180,-247); 
				} else {
					map_loaded = true;
				}

				return map;
			}
features.yelp = {
  
  YWSID: "e_6adL0Oud6XOPBGV3NgbQ",
  map:null,
  icon = null,
  
  init:function() {
    var self= this;
    self.map = new GMap2(document.getElementById("map"));
    GEvent.addListener(map, "load", function() {updateMap();});    
    self.map.setCenter(new GLatLng(pos.coords.latitude,pos.coords.longitude),13);
    self.map.addControl(new GLargeMapControl());
    self.map.addControl(new GMapTypeControl());
    self.map.setMapType(G_HYBRID_MAP);
            
    if (window.attachEvent) window.attachEvent("onresize", function() { self.map.checkResize()} );
    else if (window.addEventListener) window.addEventListener("resize", function() { self.map.checkResize()}, false);

    // setup our marker icon
    self.icon = new GIcon();
    self.icon.image = "images/marker_star.png";
    self.icon.shadow = "images/marker_shadow.png";
    self.icon.iconSize = new GSize(20, 29);
    self.icon.shadowSize = new GSize(38, 29);
    self.icon.iconAnchor = new GPoint(15, 29);
    self.icon.infoWindowAnchor = new GPoint(15, 3);
  },
  render:function() {
    
  },
  details:function() {
    
  },
  
  // private
  onstructYelpURL: function() {
      var mapBounds = map.getBounds();
      var URL = "http://api.yelp.com/" +
          "business_review_search?"+
          "callback=" + "handleResults" +
          "&term=" + document.getElementById("term").value + 
          "&num_biz_requested=10" +
          "&tl_lat=" + mapBounds.getSouthWest().lat() +
          "&tl_long=" + mapBounds.getSouthWest().lng() + 
          "&br_lat=" + mapBounds.getNorthEast().lat() + 
          "&br_long=" + mapBounds.getNorthEast().lng() +
          "&ywsid=" + YWSID;
      return encodeURI(URL);
  },
  updateMap:function() {
      // turn on spinner animation
      document.getElementById("spinner").style.visibility = 'visible';

      var yelpRequestURL = constructYelpURL();

      /* clear existing markers */
      map.clearOverlays();
      
      /* do the api request */
      var script = document.createElement('script');
      script.src = yelpRequestURL;
      script.type = 'text/javascript';
      var head = document.getElementsByTagName('head').item(0);
      head.appendChild(script);
      return false;
  },
  handleResults: function(data) {
      // turn off spinner animation
      document.getElementById("spinner").style.visibility = 'hidden';
      if(data.message.text == "OK") {
          if (data.businesses.length == 0) {
              alert("Error: No businesses were found near that location");
              return;
          }
          for(var i=0; i<data.businesses.length; i++) {
              biz = data.businesses[i];
              createMarker(biz, new GLatLng(biz.latitude, biz.longitude), i);
          }
      }
      else {
          alert("Error: " + data.message.text);
      }
  },
  generateInfoWindowHtml:function(biz) {
      var text = '<div class="marker">';

      // image and rating
      text += '<img class="businessimage" src="'+biz.photo_url+'"/>';

      // div start
      text += '<div class="businessinfo">';
      // name/url
      text += '<a href="'+biz.url+'" target="_blank">'+biz.name+'</a><br/>';
      // stars
      text += '<img class="ratingsimage" src="'+biz.rating_img_url_small+'"/>&nbsp;based&nbsp;on&nbsp;';
      // reviews
      text += biz.review_count + '&nbsp;reviews<br/><br />';
      // categories
      text += formatCategories(biz.categories);
      // neighborhoods
      if(biz.neighborhoods.length)
          text += formatNeighborhoods(biz.neighborhoods);
      // address
      text += biz.address1 + '<br/>';
      // address2
      if(biz.address2.length) 
          text += biz.address2+ '<br/>';
      // city, state and zip
      text += biz.city + ',&nbsp;' + biz.state + '&nbsp;' + biz.zip + '<br/>';
      // phone number
      if(biz.phone.length)
          text += formatPhoneNumber(biz.phone);
      // Read the reviews
      text += '<br/><a href="'+biz.url+'" target="_blank">Read the reviews »</a><br/>';
      // div end
      text += '</div></div>'
      return text;
  },
  formatCategories:function (cats) {
      var s = 'Categories: ';
      for(var i=0; i<cats.length; i++) {
          s+= cats[i].name;
          if(i != cats.length-1) s += ', ';
      }
      s += '<br/>';
      return s;
  },
  formatNeighborhoods:function(neighborhoods) {
      s = 'Neighborhoods: ';
      for(var i=0; i<neighborhoods.length; i++) {
          s += '<a href="' + neighborhoods[i].url + '" target="_blank">' + neighborhoods[i].name + '</a>';
          if (i != neighborhoods.length-1) s += ', ';
      }
      s += '<br/>';
      return s;
  },
  formatPhoneNumber:function(num) {
      if(num.length != 10) return '';
      return '(' + num.slice(0,3) + ') ' + num.slice(3,6) + '-' + num.slice(6,10) + '<br/>';
  },
  createMarker:function(biz, point, markerNum) {
      var infoWindowHtml = generateInfoWindowHtml(biz)
      var marker = new GMarker(point, icon);
      map.addOverlay(marker);
      GEvent.addListener(marker, "click", function() {
          marker.openInfoWindowHtml(infoWindowHtml, {maxWidth:400});
      });
      // automatically open first marker
      if (markerNum == 0)
          marker.openInfoWindowHtml(infoWindowHtml, {maxWidth:400});
  }
}
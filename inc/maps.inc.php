<?php

function googleMap ($key, $address) {

	// $key est la clef Google Maps
	// $address est l'adresse en langue naturelle
	$latitude = '';
	$longitude = '';
	$iframe_width = '300px';
	$iframe_height = '200px';
	$address = urlencode(($address));
	// $key = "AIzaSyCxKRdmaAlh0TBBpAiL0aEpid0xk0gqu14";
	$url = "http://maps.google.com/maps/geo?q=".$address."&output=json&key=".$key;
	$ch = curl_init();

	curl_setopt($ch, CURLOPT_URL, $url);
	curl_setopt($ch, CURLOPT_HEADER,0);
	curl_setopt($ch, CURLOPT_USERAGENT, $_SERVER["HTTP_USER_AGENT"]);
	// Comment out the line below if you receive an error on certain hosts that have security restrictions
	// curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);

	$data = curl_exec($ch);
	curl_close($ch);

	$geo_json = json_decode($data, true);

	// Uncomment the line below to see the full output from the API request
	// var_dump($geo_json);

	// If the Json request was successful (status 200) proceed
	if ($geo_json['Status']['code'] == '200') {

		$latitude = $geo_json['Placemark'][0]['Point']['coordinates'][0];
		$longitude = $geo_json['Placemark'][0]['Point']['coordinates'][1]; 
		
		$texteFrame = "<iframe width=$iframe_width height=$iframe_height frameborder='0' ";
		$texteFrame .= "scrolling='no' marginheight='0' marginwidth='0' src= 'http://maps.google.com/maps";
		$texteFrame .= "?f=q&amp;source=s_q&amp;hl=en&amp;geocode=&amp;q=$address";
		$texteFrame .= "&amp;aq=0&amp;ie=UTF8&amp;hq=&amp;hnear=$address&amp;t=m";
		$texteFrame .= "&amp;ll=$longitude,$latitude&amp;z=12&amp;iwloc=&amp;output=embed'>";
		$texteFrame .= "</iframe>";
		}
		 else $texteFrame = "";
	
	return $texteFrame;
	}
?>

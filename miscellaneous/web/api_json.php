<?php
	$xml = simplexml_load_file("http://api.openweathermap.org/data/2.5/weather?q=Los+Angeles&mode=xml&units=metric&APPID=e648971715d8148ded25c9f7fedb884b");
	$value = array();
	$value[0] = strtolower($xml->weather['value']);
	$value[1] = strtolower(number_format($xml->temperature['value'],2));
	$value[2] = strtolower(number_format($xml->wind->speed['value'],2));
	$value[3] = strtolower($xml->wind->direction['code']);
	echo("[ " . json_encode($value) . " ]");
?>
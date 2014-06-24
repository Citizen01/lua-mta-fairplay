<?php
	$xml = simplexml_load_file("http://api.openweathermap.org/data/2.5/weather?q=Los+Angeles&mode=xml&units=metric&APPID=e648971715d8148ded25c9f7fedb884b");
	$value = array();
	$value[] = strtolower($xml->weather['value']);
	$value[] = number_format((float)$xml->temperature['value'], 2);
	$value[] = number_format((float)$xml->wind->speed['value'], 2);
	$value[] = strtolower($xml->wind->direction['code']);
	echo("[ " . json_encode($value) . " ]");
?>

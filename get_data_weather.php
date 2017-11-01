<?php
/*
*  get data 
*
*	@pablo
*
*/
// set City Name
$city="Sermide";

// exe crawler
$result=system("/usr/bin/ruby /www/dev/the_one/OurBY/_main/_info/weather/crawler/get_data_weather.rb ".$city);
 
if( $result != "ok" ){
	// execute another time
	// exe crawler
 
$result=system("/usr/bin/ruby /www/dev/the_one/OurBY/_main/_info/weather/crawler/get_data_weather.rb ".$city);
 
}
?> 
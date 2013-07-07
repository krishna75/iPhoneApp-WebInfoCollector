<?php
/**
 * Created by JetBrains PhpStorm.
 * User: Krishna
 * Date: 06/07/13
 * Time: 08:51
 * To change this template use File | Settings | File Templates.
 */

$json_string =    file_get_contents("http://cnapp.co.uk/public/datesAndEvents.php");
$parsed_json = json_decode($json_string);
print_r($parsed_json);

echo "<ul>";


foreach($parsed_json  as $event) {
    echo "<li>".$event->date ." ".$event->day." ".$event->quantity."</li>";
}
echo "</ul>";
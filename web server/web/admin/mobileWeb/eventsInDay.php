<meta charset="utf-8">
<title>Events in a Date</title>
<link rel="stylesheet" href="css/ks-mobile.css"/>

<?php
/**
 * Created by JetBrains PhpStorm.
 * User: Krishna
 * Date: 07/07/13
 * Time: 22:46
 * To change this template use File | Settings | File Templates.
 */

$event_date = $_GET["event_date"];
$json_string =    file_get_contents("http://cnapp.co.uk/public/eventsOfADate.php?event_date=".$event_date);
$parsed_json = json_decode($json_string);
echo "<h1>".$parsed_json[0]->date." ".$parsed_json[0]->day." </h1>";
foreach($parsed_json  as $event) {
    $image_url =$event->venue_logo ;
    $title =$event->title;;
    $subtitle = $event->venue;

    $link_page ="eventDetail.php?event_id=".$event->id;
    include "includes/cell.php";
}
?>

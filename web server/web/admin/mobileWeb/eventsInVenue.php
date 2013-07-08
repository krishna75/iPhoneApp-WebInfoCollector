<meta charset="utf-8">
<title>Events in a Venue</title>
<link rel="stylesheet" href="css/ks-mobile.css"/>

<?php
/**
 * Created by JetBrains PhpStorm.
 * User: Krishna
 * Date: 07/07/13
 * Time: 22:46
 * To change this template use File | Settings | File Templates.
 */

$venue_id = $_GET["venue_id"];
$json_string =    file_get_contents("http://cnapp.co.uk/public/eventsOfAVenue.php?venue_id=".$venue_id);
$parsed_json = json_decode($json_string);

$header_image_url = "" ;
$header_title = $parsed_json[0]->venue_name;
$header_subtitle = $parsed_json[0]->venue_address;
$header_description= "";
include "includes/header-cell.php";

foreach($parsed_json  as $event) {
    $image_url ="http://www.cnapp.co.uk/images/logo.png" ; ;
    $title =$event->event_title;;
    $subtitle = $event->date;
    $description = $event->day;
    $link_page ="eventDetail.php?event_id=".$event->event_id;
    include "includes/cell.php";
}
?>

<meta charset="utf-8">
<title>Event Detail</title>
<link rel="stylesheet" href="css/ks-mobile.css"/>


<?php
/**
 * Created by JetBrains PhpStorm.
 * User: Krishna
 * Date: 08/07/13
 * Time: 20:29
 * To change this template use File | Settings | File Templates.
 */

$event_id = $_GET["event_id"];
$json_string =    file_get_contents("http://cnapp.co.uk/public/eventDetail.php?event_id=".$event_id);
$parsed_json = json_decode($json_string);
$event = $parsed_json[0];
?>
<div class="view">
   <div class="title">
        <?php echo $event->title; ?>
    </div>
    <div class="subtitle">
        <?php echo "on ".$event->day.", ".$event->date;?>
    </div>
    <div class="subtitle">
        <?php echo "at ".$event->venue;?>
   </div>
    <div class="image">
        <?php echo "<img src='".$event->photo."'/>";?>
   </div>
    <div class="description">
        <?php echo $event->description;?>
    </div>
</div>
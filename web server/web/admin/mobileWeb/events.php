<html>
<head>
    <meta charset="utf-8">
    <title>Events</title>
    <link rel="stylesheet" href="css/ks-mobile.css"/>
</head>
<body>
<h1>Events</h1>
<?php
    $json_string =    file_get_contents("http://cnapp.co.uk/public/datesAndEvents.php");
    $parsed_json = json_decode($json_string);
?>

<?php
    foreach($parsed_json  as $event) {
        $image_url ="http://www.cnapp.co.uk/images/logo.png" ;
        $title =$event->date;;
        $subtitle = $event->quantity." event(s)";
        $description = $event->day;
        $link_page ="eventsInDay.php?date=".$event->date;
        include "includes/cell.php";
    }
?>

</body>
</html>
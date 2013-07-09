<html>
<head>
    <meta charset="utf-8">
    <title>Events</title>
    <link rel="stylesheet" href="css/ks-mobile.css"/>
</head>
<body>

<?php
    $json_string =    file_get_contents("http://cnapp.co.uk/public/datesAndEvents.php");
    $parsed_json = json_decode($json_string);

    $header_title = "Events";
    include "includes/header-cell.php";
    foreach($parsed_json  as $event) {
        $image_url ="http://www.cnapp.co.uk/images/logo.png" ;
        $title =$event->date;;
        $subtitle = $event->quantity." event(s)";
        $description = $event->day;
        $link_page = getenv('MOBILE_WEB')."eventsInDay.php?event_date=".$event->date;
        include "includes/cell.php";
    }
?>

</body>
</html>
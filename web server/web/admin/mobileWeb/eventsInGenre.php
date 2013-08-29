<html>
<head>
    <meta charset="utf-8">
    <title>Events</title>
    <link rel="stylesheet" href="css/ks-mobile.css"/>
</head>
<body>

<?php
    $genre_id = $_GET["genre_id"];
    $json_string =    file_get_contents("http://cnapp.co.uk/public/eventsOfGenre.php?genre_id=".$genre_id);
    $parsed_json = json_decode($json_string);
    $header_title = "Events of Genre";
    include "includes/header-cell.php";
if ($parsed_json != null){
    foreach($parsed_json  as $event) {
        $image_url ="http://www.cnapp.co.uk/images/logo.png" ;
        $title =$event->event_title;
        $subtitle = $event->date;
        $description =$event->day;
        $link_page ="eventDetail.php?event_id=".$event->event_id;
        include "includes/cell.php";
    }
}
?>

</body>
</html>
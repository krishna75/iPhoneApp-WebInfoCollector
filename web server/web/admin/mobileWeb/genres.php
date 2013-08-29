<html>
<head>
    <meta charset="utf-8">
    <title>Events</title>
    <link rel="stylesheet" href="css/ks-mobile.css"/>
</head>
<body>

<?php
    $json_string =    file_get_contents("http://cnapp.co.uk/public/genres.php");
    $parsed_json = json_decode($json_string);

    $header_title = "Genres";
    include "includes/header-cell.php";
    foreach($parsed_json  as $event) {
        $image_url =$event->photo ;
        $title =$event->genre;;
        $subtitle = $event->description;
        $description = "";
        $link_page ="eventsInGenre.php?genre_id=".$event->id;
        include "includes/cell.php";
    }
?>

</body>
</html>
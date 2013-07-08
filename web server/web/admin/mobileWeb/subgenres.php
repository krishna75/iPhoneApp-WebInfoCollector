<html>
<head>
    <meta charset="utf-8">
    <title>Events</title>
    <link rel="stylesheet" href="css/ks-mobile.css"/>
</head>
<body>

<?php
    $genre_id = $_GET["genre_id"];
    $json_string =    file_get_contents("http://cnapp.co.uk/public/subgenres.php?genre_id=".$genre_id);
    $parsed_json = json_decode($json_string);

    $header_title = "Subgenres";
    include "includes/header-cell.php";
    foreach($parsed_json  as $event) {
        $image_url =$event->photo ;
        $title =$event->subgenre;
        $subtitle = $event->description;
        $description = "";
        $link_page ="eventsInGenre.php?subgenre_id=".$event->subgenre_id;
        include "includes/cell.php";
    }
?>

</body>
</html>
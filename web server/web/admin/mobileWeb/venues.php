<html>
<head>
    <meta charset="utf-8">
    <title>Venues</title>
    <link rel="stylesheet" href="css/ks-mobile.css"/>
</head>
<body>
<?php
    $json_string =    file_get_contents("http://cnapp.co.uk/public/venuesAndEvents.php");
    $parsed_json = json_decode($json_string);
    $header_title = "Venues";
    include "includes/header-cell.php";
    foreach($parsed_json  as $venue) {
        $image_url = $venue->logo ;
        $title =$venue->name;
        $subtitle = $venue->address;
        $description = "this is sample description";
        $link_page="eventsInVenue.php?venue_id=".$venue->venue_id;
        include "includes/cell.php";
    }
?>

</body>
</html>
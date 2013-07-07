<html>
<head>
    <meta charset="utf-8">
    <title>Venues</title>
    <link rel="stylesheet" href="css/ks-mobile.css"/>
</head>
<body>
<h1>Venues</h1>
<?php
    $json_string =    file_get_contents("http://cnapp.co.uk/public/venuesAndEvents.php");
    $parsed_json = json_decode($json_string);
?>
<?php
    foreach($parsed_json  as $venue) {
        $image_url ="" ;
        $title =$venue->name;;
        $subtitle = $venue->address;
        $description = "this is sample description";
        include "includes/cell.php";
    }
?>

</body>
</html>
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
echo $parsed_json;
?>


    <?php
    foreach($parsed_json  as $venue) {
        echo "<div class='cell'>";
            echo "<div class='cell-image'>";
            echo "</div>";
            echo "<div class='cell-title'>";
                echo $venue->name;
            echo "</div>";
            echo "<div class='cell-subtitle'>";
                echo $venue->address;
            echo "</div>";
            echo "<div class='cell-description'>";
                echo  "this is sample description";
            echo "</div>";
            echo "<div class='cell-next'/>";
            echo "</div>";
        echo "</div>";
    } ?>

</body>
</html>
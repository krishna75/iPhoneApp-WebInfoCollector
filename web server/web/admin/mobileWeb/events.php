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

<div class="row">
    <?php
    foreach($parsed_json  as $event) {
        echo "<div class='span12'>".$event->date ." ".$event->day." ".$event->quantity."</div>";
    } ?>
</div>
</body>
</html>
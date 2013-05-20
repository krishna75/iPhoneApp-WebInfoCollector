<?php

require_once("includes/db_connection.php");

$result = mysql_query("SELECT v.id as id,v.name as name
FROM Venues as v left join ( Users_Venues as uv)
ON (v.id=uv.venue_id)
WHERE uv.user_id='15';") or die(mysql_error());

$venueId = mysql_result($result, 0, "id");
$venueName = mysql_result($result, 0, "name");
echo $venueId." ".$venueName;


 mysql_close($con);

<?php
require_once("db_connection.php");
include("utilities.php");

$venue_id = $_GET["venue_id"];
 
$result = mysql_query("SELECT 
						v.id as venue_id,
						v.name AS venue_name,
						v.address as venue_address,
						e.id as event_id, 
						e.date AS date, 
						DATE_FORMAT(date, '%W') as day,
						e.title AS event_title
						
						FROM Venue AS v LEFT JOIN Events AS e ON v.id = e.venue_id 
						WHERE v.id = '$venue_id' AND date>= '$today' AND date<='$oneMonthLater' 

						ORDER BY date ASC
						;");

while($row = mysql_fetch_assoc($result)){
   $jsonResult[] = array(
					"venue_id"=> $row['venue_id'],
					"venue_name" => $row['venue_name'],
					"venue_address" => $row['venue_address'],
					"event_id" => $row['event_id'],
					"event_title" => $row['event_title'],
					"date" => $row['date'],
					"day" => $row['day']
					 );
  }

echo json_encode($jsonResult);

mysql_close($con);
?>
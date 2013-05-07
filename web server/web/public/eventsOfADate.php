<?php

require_once("db_connection.php");
include("utilities.php");

$event_date = $_GET["event_date"];

$result = mysql_query("SELECT 
						e.id as id, 
						e.date AS date, 
						DATE_FORMAT(date, '%W') as day, 
						e.title AS title, 
						v.name AS venue,
						v.id as venue_id,
						e.description AS description,
						v.logo as venue_logo
						
						FROM Venue AS v LEFT JOIN Events AS e ON v.id = e.venue_id 
						WHERE e.date = '$event_date';");

while($row = mysql_fetch_assoc($result))
  {
   $output[] = array("id"=> $row['id'],
					 "date" => $row['date'],
					 "day" =>$row['day'],
					 "title" => $row['title'],
					 "venue" => $row['venue'],
					 "venue_id" => $row['venue_id'],
					 "description" => $row['description'],
					 "venue_logo" => "http://www.chitwan-abroad.org/cloud9/images/".$row['venue_logo']
					 );
  }
  echo json_encode($output);

mysql_close($con);
?>
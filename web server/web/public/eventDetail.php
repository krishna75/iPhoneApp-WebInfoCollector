<?php
require_once("db_connection.php");
include("utilities.php");

$id = $_GET["event_id"];

$result = mysql_query("SELECT 
						e.id as id, 
						e.date AS date,
						DATE_FORMAT(date, '%W') as day,						 
						e.title AS title, 
						v.name AS venue,
						v.id as venue_id,
						e.description AS description,
						e.photo AS photo 
						
						FROM Venues AS v LEFT JOIN Events AS e ON v.id = e.venue_id
						WHERE e.id=$id;");

while($row = mysql_fetch_assoc($result)){

   $output[] = array("id"=> $row['id'],
					 "date" => $row['date'],
					 "day" =>$row['day'],
					  "title" => $row['title'],
					 "venue" => $row['venue'],
					 "venue_id" => $row['venue_id'],
					 "description" => $row['description'],
					 "photo" => "http://www.cnapp.co.uk/images/eventPhoto/".$row['photo']
					 );
  }
  echo json_encode($output);

mysql_close($con);
?>
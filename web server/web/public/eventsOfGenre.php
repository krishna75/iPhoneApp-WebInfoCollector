<?php
require_once("db_connection.php");
include("utilities.php");

$subgenre_id = $_GET["subgenre_id"];
 
$result = mysql_query("SELECT 

						e.id as event_id, 
						e.date AS date, 
						DATE_FORMAT(date, '%W') as day,
						e.title AS event_title
						
						FROM SubGenres AS sg
						INNER JOIN Genres_Events AS ge ON ge.subgenre_id = sg.id
						INNER JOIN Events AS e ON ge.event_id = e.id

						
						WHERE ge.subgenre_id = '$subgenre_id' AND date>= '$today' AND date<='$oneMonthLater'

						ORDER BY date ASC
						;");

while($row = mysql_fetch_assoc($result)){
   $jsonResult[] = array(
	
					"event_id" => $row['event_id'],
					"event_title" => $row['event_title'],
					"date" => $row['date'],
					"day" => $row['day']
					 );
  }

echo json_encode($jsonResult);

mysql_close($con);
?>
<?php
require_once("db_connection.php");
include("utilities.php");
 
$result = mysql_query("SELECT 
						v.id as venue_id,
						v.name as name,
						v.address as address,
						v.logo as logo,
						COUNT(e.id) as quantity
						
						FROM Venues AS v LEFT JOIN Events AS e ON v.id = e.venue_id
						WHERE date>= '$today' AND date<='$oneMonthLater'
						GROUP BY venue_id
						ORDER BY name ASC
						;");

while($row = mysql_fetch_assoc($result)){
   $jsonResult[] = array(
					 "venue_id" => $row['venue_id'],
					 "name" =>$row['name'],
					 "address" => $row['address'],
					 "quantity" =>$row['quantity'],
					 "logo" => "http://www.cnapp.co.uk/images/logo/".$row['logo']
					 );
  }

echo json_encode($jsonResult);

mysql_close($con);
?>
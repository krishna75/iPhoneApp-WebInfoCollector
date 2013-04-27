<?php
require_once("db_connection.php");
include("utilities.php");
 

$result = mysql_query("SELECT 
						date,
						DATE_FORMAT(date, '%W') as day,
						COUNT(id) as quantity
						
						FROM  Events 
						WHERE date>= '$today' AND date<='$oneMonthLater'
						
						GROUP BY date
						ORDER BY date ASC
						
						;");

while($row = mysql_fetch_assoc($result)){
   $jsonResult[] = array(
					 "date" => $row['date'],
					 "day" =>$row['day'],
					 "quantity" => $row['quantity']
				
					 );
  }

echo json_encode($jsonResult);
//echo json_encode($formatedJsonResult);

mysql_close($con);
?>
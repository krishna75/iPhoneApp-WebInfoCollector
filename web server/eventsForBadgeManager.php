<?php
require_once("db_connection.php");
include("utilities.php");
 

$result = mysql_query("SELECT 
						id, 
						date
						
						FROM  Events 
						WHERE date>= '$today' AND date<='$oneMonthLater'
						
						;");

while($row = mysql_fetch_assoc($result)){
   $jsonResult[] = array(
					 "id" => $row['id'],
					 "date" =>$row['date']	
					 );
  }

echo json_encode($jsonResult);

mysql_close($con);
?>
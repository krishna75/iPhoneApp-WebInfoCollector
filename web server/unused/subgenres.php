<?php
require_once("db_connection.php");
include("utilities.php");
$genre = $_GET["genre"];
 
$result = mysql_query("SELECT 
		id,
		subgenre
		FROM Genres
		where genre = '$genre'
		;");
		
while ($row = mysql_fetch_assoc($result)) {
	 $jsonResult[] = array("id"=> $row['id'],
							"subgenre"=> $row['subgenre']
						);
}


echo json_encode($jsonResult);

mysql_close($con);

?>
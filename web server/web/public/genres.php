<?php
require_once("db_connection.php");
include("utilities.php");
 
$result = mysql_query("SELECT 
						id,
						genre,
						description,
						photo
						FROM Genres
						;");

while($row = mysql_fetch_assoc($result)){
    $rows[] = array(
        "id" => $row['id'],
        "genre" =>$row['genre'],
        "description" => $row['description'],
        "photo" => "http://www.chitwan-abroad.org/cloud9/images/genres/".$row['photo']
    );
}

echo json_encode($rows);

mysql_close($con);



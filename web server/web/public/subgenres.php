<?php
require_once("db_connection.php");
include("utilities.php");
$genre_id = $_GET["genre_id"];
 
$result = mysql_query("SELECT 
		g.id as genre_id,
		sg.id as subgenre_id,
		g.genre as genre,
		sg.subgenre as subgenre,
		sg.description as description,
		sg.photo as photo

		FROM Genres AS g LEFT JOIN SubGenres sg ON sg.genre_id = g.id
		where g.id = '$genre_id'
		;");

while($row = mysql_fetch_assoc($result)){
    $rows[] = array(
        "genre_id" => $row['genre_id'],
        "subgenre_id" => $row['subgenre_id'],
        "genre" =>$row['genre'],
        "subgenre" =>$row['subgenre'],
        "description" => $row['description'],
        "photo" => "http://www.cnapp.co.uk/images/subgenres/".$row['photo']
    );
}

echo json_encode($rows);

mysql_close($con);
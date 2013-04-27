<?php
require_once("db_connection.php");
include("utilities.php");
 
$result = mysql_query("SELECT 
						id,
						genre
						FROM Genres
						;");

while($row = mysql_fetch_assoc($result)){
	$genres[]= $row['genre'];
 }
$uniqueGenres = array_unique($genres);

foreach ($uniqueGenres as $uniqueGenre) {
        $genre = $uniqueGenre;
        $jsonResult[] = array(
        "genre" => $genre,
        "subgenreList" => getSubGenres($genre)
    );
}


echo json_encode($jsonResult);

mysql_close($con);


// getting lists under a list
function getSubGenres($genre){
	$subResult = mysql_query("SELECT 
			id,
			subgenre
			FROM Genres
			where genre = '$genre'
			;");
			
	while ($subrow = mysql_fetch_assoc($subResult)) {
		 $subGenres[] = array(
			"id"=> $subrow['id'],
			"subgenre"=> $subrow['subgenre']
		 );
	}

return json_encode($subGenres);
}
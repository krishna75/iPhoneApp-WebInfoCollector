<?php
require_once("db_connection.php");
include("utilities.php");

$id = $_GET["event_id"];

$result = mysql_query("SELECT
	                    v.name AS venue,
						v.id as venue_id,
						v.logo as logo,

						DATE_FORMAT(date, '%W') as day,

						e.id as id,
						e.date AS date,
						e.title AS title,
						e.description AS description,
						e.voucher AS voucher,
						e.voucher_photo as voucher_photo,
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
					 "voucher" => $row['voucher'],
                     "voucher_photo" => "http://www.cnapp.co.uk/images/voucherPhoto/".$row['voucher_photo'],
					 "photo" => "http://www.cnapp.co.uk/images/eventPhoto/".$row['photo'],
                     "logo" => "http://www.cnapp.co.uk/images/logo/".$row['logo']
					 );
  }
  echo json_encode($output);

mysql_close($con);
?>
<?php
require_once("db_connection.php");
include("utilities.php");

$result = mysql_query("SELECT
						v.id as venue_id,
						v.name as name,
						v.address as address,
						v.logo as logo,
						e.id as event_id,
						e.title as event_title,
						e.voucher as voucher_description,
						e.voucher_photo as voucher_photo

						FROM Venues AS v LEFT JOIN Events AS e ON v.id = e.venue_id
						WHERE date = '$today'
						ORDER BY name ASC
						;");

while($row = mysql_fetch_assoc($result)){
    $jsonResult[] = array(
        "venue_id" => $row['venue_id'],
        "name" =>$row['name'],
        "address" => $row['address'],
        "logo" => "http://www.cnapp.co.uk/images/logo/".$row['logo'],
        "event_id" => $row['event_id'],
        "event_title" =>$row['event_title'],
        "voucher_description" => $row['voucher_description'],
        "voucher_photo" =>"http://www.cnapp.co.uk/images/voucherPhoto/".$row['voucher_photo']
    );
}

echo json_encode($jsonResult);

mysql_close($con);
?>
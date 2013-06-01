<?php
$id = $_GET["venue_id"];
//$id="1";
$con = mysql_connect("localhost","chitwana","As3a2v34hS");
if (!$con)
  {
  die('Could not connect to the mysql server: ' . mysql_error());
  }

$db = mysql_select_db("chitwana_cloud9", $con);
if (!$db)
  {
  die('Could not connect to the database: ' . mysql_error());
  }

$result = mysql_query("SELECT * FROM Venues where id=$id;");

while($row = mysql_fetch_assoc($result)){
   //echo $row['name'] . " -- " . $row['address']."<img src='http://www.chitwan-abroad.org/cloud9/images/".$row['logo']. "'/>";
  // echo "<br />";

   $output[] = array("id"=> $row['id'],
					 "name" => $row['name'],
					 "address" => $row['address'],
					 "phone" => $row['phone'],
					 "email" => $row['email'],
					 "web" => $row['web'],
					 "logo" => "http://www.chitwan-abroad.org/cloud9/images/".$row['logo'],
					 "photo" => "http://www.chitwan-abroad.org/cloud9/images/venue_".$row['photo']
					 );
  }
  echo json_encode($output);

mysql_close($con);
?>
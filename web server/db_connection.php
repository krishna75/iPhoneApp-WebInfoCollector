<?php

//connects to the server
$con = mysql_connect("localhost","chitwana","Krbn.Spkt.04");
if (!$con){
  die('Could not connect to the mysql server: ' . mysql_error());
}

// connects to the database
$db = mysql_select_db("chitwana_cloud9", $con);
if (!$db){
  die('Could not connect to the database: ' . mysql_error());
 }
  
?>
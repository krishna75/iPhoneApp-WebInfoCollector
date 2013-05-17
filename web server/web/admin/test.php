<?php

require_once("includes/db_connection.php");

$result = mysql_query("SELECT id,name FROM Venues;") or die(mysql_error());
while($row = mysql_fetch_assoc($result)){
    echo "<option value='".$row['id']."' >".$row['name']."</option>";
}


 mysql_close($con);

<?php
//security
$requiredRole =4;

//includes
include("includes/session.php");
$title = "Used Vouchers";
include_once("includes/header.php");
require_once("includes/db_connection.php");
include("../public/utilities.php");


// printing message if any
if (!empty($_GET['message'])) {
    $message= $_GET['message'];
    echo "<h3>".$message." </h3>";
}

//identify role and username
$role = $_SESSION['role'];
$user_id = $_SESSION['username'];

echo "username=".$user_id." role=".$role."<br/>";
if ($role ==3){

}
if ($role == 1){
 echo "welcome";



    $event_date = $_GET["2013/08/04"];

    $query = "SELECT
						name as venue,
						date,
						DATE_FORMAT(date, '%W') as day,
						title as event,
						voucher,
						count

						FROM  Events
						LEFT JOIN Venues ON Venues.id = Events.venue_id
						LEFT JOIN Vouchers ON Vouchers.event_id = Events.id
						WHERE date>= '$today' AND date<='$oneMonthLater'

						GROUP BY date
						ORDER BY date ASC

						;";



//    $query = mysql_query("SELECT
//						v.name AS venue,
//						e.date AS date,
//						DATE_FORMAT(date, '%W') as day,
//						e.title AS event,
//						FROM Venues AS v LEFT JOIN Events AS e ON v.id = e.venue_id
//						ORDER BY date ASC
//						;");

//    $query = mysql_query("SELECT * FROM Events;");
//
    $result = mysql_query($query) or die(mysql_error());
    while($row = mysql_fetch_assoc($result)){
        echo $row['venue'].", ";
        echo $row['date'].", ";
        echo $row['day'].", ";
        echo $row['event'].", ";
        echo $row['voucher'].", ";
        echo $row['count'].", ";
    }

}


include_once("../admin/includes/footer.php");





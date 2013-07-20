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

//echo "username=".$user_id." role=".$role."<br/>";
if ($role ==3){

}
if ($role == 1){
 echo "Vouchers Used";
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

    $result = mysql_query($query) or die(mysql_error());
    echo "<table border='1'>";
    echo "<thead><tr>";
    echo "<th>Venue</th><th>Date</th><th>Day</th><th>Event</th><th>Voucher</th><th>Used</th>";
    echo "</tr></thead>";

    while($row = mysql_fetch_assoc($result)){
        echo "<tr>";
            echo "<td>".$row['venue']."</td>";
            echo "<td>".$row['date']."</td>";
            echo "<td>".$row['day']."</td>";
            echo "<td>".$row['event']."</td>";
            echo "<td>".$row['voucher']."</td>";
            echo "<td>".$row['count']."</td>";
        echo "</tr>";
    }
    echo "</table>";

}


include_once("../admin/includes/footer.php");





<?php
$requiredRole =4;

include("includes/db_connection.php");
include("includes/session.php");
$title = "Portal";
include_once("includes/header.php");
echo "Dear ".$_SESSION['first_name']." ".  $_SESSION['last_name'].",<p>
Welcome to the portal page !!! </p>";
//$username = $_SESSION['username'];
$userId = $_SESSION['user_id'];
//$userId = "";
$venueId = "";

// printing message if any
if (!empty($_GET['message'])) {
    $message= $_GET['message'];
    echo "<h3>".$message." </h3>";
}

//sign out

echo "<div class='admin-link'><a href='signOut.php'  >sign out </a></div>";


    $role = $_SESSION['role'];
    if ($role == 0){
        $role = 999;
    }
    if ($role ==3){

        $result = mysql_query("SELECT v.id as id
                    FROM Venues as v left join ( Users_Venues as uv)
                    ON (v.id=uv.venue_id)
                    WHERE uv.user_id='$userId';") or die(mysql_error());
        $row = mysql_fetch_array($result);
        $num_results = mysql_num_rows($result);
        if ($num_results > 0){
            $venueId = mysql_result($result, 0, "id");
        }

        // add
        echo "<div class='admin-link'><a href='addEvent.php' target='_blank' >add an event </a></div>";
        echo "<div class='admin-link'><a href='crud/crud_event_client.php?access=21285&venue_id=".$venueId."' target='_blank'>edit events </a></div>";
        echo "<div class='admin-link'><a href='voucherUsed.php' target='_blank' >see used vouchers </a></div>";
    }
    if ($role ==2){
        //add
        echo "<div class='admin-link'><a href='addEvent.php' target='_blank'  >add an event </a></div>";
        echo "<div class='admin-link'><a href='addVenue.php' target='_blank' >add a venue </a></div>";
        // edit
        echo "<div class='admin-link'><a href='crud/crud.php?access=21285&table=Venues' target='_blank' >edit venues </a></div>";
        echo "<div class='admin-link'><a href='crud/crud.php?access=21285&table=Events'target='_blank' >edit events </a></div>";
        echo "<div class='admin-link'><a href='voucherUsed.php' target='_blank' >see used vouchers </a></div>";
    }

    if ($role == 1){
        echo "<div class='admin-link'><a href='voucherUsed.php' target='_blank' >see used vouchers </a></div>";
        //add
        echo "<div class='admin-link'><a href='addEvent.php' target='_blank' >add an event </a></div>";
        echo "<div class='admin-link'><a href='addVenue.php' target='_blank'>add a venue </a></div>";
        echo "<div class='admin-link'><a href='addClient.php' target='_blank' >add a client </a></div>";
        echo "<div class='admin-link'><a href='addPromoter.php' target='_blank'>add a promoter </a></div>";
        echo "<div class='admin-link'><a href='addAdmin.php' target='_blank' >add an admin </a></div>";
        // edit
        echo "<div class='admin-link'><a href='crud/crud.php?access=21285&table=Venues' target='_blank' >edit venues </a></div>";
        echo "<div class='admin-link'><a href='crud/crud.php?access=21285&table=Events' target='_blank' >edit events </a></div>";
        echo "<div class='admin-link'><a href='crud/crud.php?access=21285&table=Users' target='_blank' >edit users </a></div>";
        echo "<div class='admin-link'><a href='crud/crud.php?access=21285&table=Users_Venues' target='_blank'>edit users and venues </a></div>";
        //extra
        echo "<div class='admin-link'><a href='adminTasks.php' target='_blank' >GoDaddy </a></div>";
    }


include_once("../admin/includes/footer.php");





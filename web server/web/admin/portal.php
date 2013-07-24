<?php
$requiredRole =4;

include("includes/session.php");
$title = "Portal";
include_once("includes/header.php");
    echo "Dear ".$_SESSION['first_name']." ".  $_SESSION['last_name'].",<p>
    Welcome to the portal page !!! </p>";

// printing message if any
if (!empty($_GET['message'])) {
    $message= $_GET['message'];
    echo "<h3>".$message." </h3>";
}

//sign out

echo "<div class='admin-link'><a href='signOut.php.php'  >sign out </a></div>";


    $role = $_SESSION['role'];
    if ($role == 0){
        $role = 999;
    }
    if ($role <=3){
        // add event
        echo "<div class='admin-link'><a href='addEvent.php'  >add an event </a></div>";
        echo "<div class='admin-link'><a href='voucherUsed.php' ' >see used vouchers </a></div>";
        if ($role <=2){
        //add venue
            echo "<div class='admin-link'><a href='addVenue.php' >add a venue </a></div>";
        }
        if ($role == 1){
        //add client
        echo "<div class='admin-link'><a href='addClient.php' >add a client </a></div>";
        //add promoter
            echo "<div class='admin-link'><a href='addPromoter.php'>add a promoter </a></div>";
        //add admin
            echo "<div class='admin-link'><a href='addAdmin.php' >add an admin </a></div>";
            echo "<div class='admin-link'><a href='adminTasks.php' >GoDaddy </a></div>";
        }
    }


include_once("../admin/includes/footer.php");





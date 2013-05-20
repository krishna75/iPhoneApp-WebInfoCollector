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
echo "<p><a href='signOut.php'>Sign Out </a></p>";


    $role = $_SESSION['role'];
    if ($role == 0){
        $role = 999;
    }
    if ($role <=3){
        // add event
        echo "<a href='addEvent.php' class='admin-link' >add an event </a>";
        if ($role <=2){
        //add venue
            echo "<a href='addVenue.php' class='admin-link'>add a venue </a>";
        }
        if ($role == 1){
        //add client
        echo "<a href='addClient.php' class='admin-link'>add a client </a>";
        //add promoter
            echo "<a href='addPromoter.php' class='admin-link'>add a promoter </a>";
        //add admin
            echo "<a href='addAdmin.php' class='admin-link'>add an admin </a>";
        }
    }


include_once("../admin/includes/footer.php");





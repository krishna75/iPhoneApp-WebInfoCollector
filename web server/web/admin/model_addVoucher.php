<?php
$requiredRole = 3;
include("includes/session.php");
require_once("includes/db_connection.php");

// get the post params
//$eventId = $_POST['event_id'];
$event_id = 1;

// if event id does not  exist, create one and count one


// if event id exists, get count, add one, and update the row

$query = " SELECT  count FROM Vouchers WHERE event_id=''$event_id'';";
$eventIdResult = mysql_query($query) or die(mysql_error());


//if ( $photoValidated) {
//
//    // inserting data into mysql
//    $photoUrl = $photoPrefix.$_FILES[$photo]['name'];

//    $query = " INSERT INTO Events (
//      date,   title,   description,    venue_id,    photo )  VALUES (
//    STR_TO_DATE('$date', '%Y/%m/%d'), '$title', '$description', '$venue',  '$photoUrl'); ";
//    $eventResult = mysql_query($query) or die(mysql_error());
//
//    //    get event id (select id from events where title = $title)
//    $query = " SELECT id FROM Events  WHERE title = '$title'; ";
//    $eventIdResult = mysql_query($query) or die(mysql_error());
//    $eventId = "";
//    while($row = mysql_fetch_assoc($eventIdResult)){
//        echo "<option value='".$row['id']."' >".$row['subgenre']."</option>";
//        $eventId = $row['id'];
//    }
//
//    // set genres
//    $query = " INSERT INTO Genres_Events (
//      event_id,   subgenre_id )  VALUES (
//    '$eventId', '$genre' ); ";
//    $genreResult = mysql_query($query);
//
//   if ($genreResult && $eventResult){
//        //uploading
//       $photoUploadMessage = uploadImage($photoPrefix, $photo, $photoDir);
//       returnMessage('portal', '<b>Sucess !!!</b> <br/>'.$logoUploadMessage."<br/> ".$photoUploadMessage);
//    } else {
//       returnMessage("addEvent", "<b>Error.. on adding data </b> <br/>". mysql_error($con));
//   }
//}else {
//    //error message
//    $photoErrorMessage = $photo.": ".$photoMessage[0] . " " . $photoMessage[1] . $photoMessage[2];
//    returnMessage("addEvent", "<b>Error.. on image upload </b> <br/>".$logoErrorMessage."<br/>".$photoErrorMessage."<br/>". mysql_error($con));
//}
//
//function returnMessage($page,$message){
//   echo $message;
////    header('location:'.$page.'.php?message='. $message);
//}

mysql_close($con);
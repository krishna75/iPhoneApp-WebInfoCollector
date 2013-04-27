<?php

 
$today = today();
$oneMonthLater = oneMonthLater();

// provides the date of one month later from today
function oneMonthLater(){
 $date =  new DateTime();
 $date = (String) $date->format('Y-m-d');
 return changeDays($date , 30);
}

// adds a number of days to a date. (can be used for removing days by using negative days e.g. -7)
function changeDays($date, $days){
 return date('Y-m-d',strtotime($date) + (24*3600*$days));	
}

// returns the date of today
function today(){
 $date =  new DateTime();
 return (String) $date->format('Y-m-d');
}
  
?>
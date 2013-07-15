<?php
require_once("db_connection.php");
include("utilities.php");
 

$result = mysql_query("SELECT 
						date,
						DATE_FORMAT(date, '%W') as day,
						COUNT(id) as quantity
						
						FROM  Events 
						WHERE date>= '$today' AND date<='$oneMonthLater'
						
						GROUP BY date
						ORDER BY date ASC
						
						;");

while($row = mysql_fetch_assoc($result)){
   $jsonResult[] = array(
					 "date" => $row['date'],
					 "day" =>$row['day'],
					 "quantity" => $row['quantity']
				
					 );
  }

foreach ($jsonResult as $value){
for($i = 0; $i < 30; $i++){
        $date = mktime(0,0,0,date("m"),date("d")+$i,date("Y"));
        $aDate= date("Y-m-d", $date);


        if (!containsDate($aDate,$jsonResult,'date')){
            $value = array("date"=>$aDate,"day"=>date("D",$aDate),"count"=>"0");
            array_push($jsonResult, $value);
        }
    }
}

echo json_encode($jsonResult);
//echo json_encode($formatedJsonResult);

mysql_close($con);
?>
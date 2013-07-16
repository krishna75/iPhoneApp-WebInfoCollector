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


// including all the days in 30days  in the result
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

// sorting the result using date
usort($jsonResult,function ($a,$b){
    $t1 = strtotime($a["date"]);
    $t2 = strtotime($b["date"]);
    if ($t1 == $t2) {
        return 0;
    }
    return ($t1 < $t2) ? -1 : 1;
});

echo json_encode($jsonResult);

mysql_close($con);
?>
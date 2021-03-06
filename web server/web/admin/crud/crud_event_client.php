<?php

//http://sourceforge.net/projects/phpmysqlezedit
//
//published by williamconley of poundteam via sourceforge.net
//
//
//license: http://creativecommons.org/licenses/by-sa/3.0/
//
//credit: developed from a code sample published by Sergey Skudaev at http://www.configure-all.com/display_any_table.php
//        Sergey's code sample was in mysql, not mysqli, and was only for viewing based on a given query hard-coded into the file.
//        But it was a great start. I couldn't find anything published that would do the rest, so here it is.
//
/* Purpose: php/MySQL easy data editor. A single php page or with a single config file for security
 * to make it easy and safe for non programmers/web designers/mysql gurus to add, edit and delete records.
 * No need to create a new database interface for every table. Just add user/pwd/host! */

/* NOTES:
 * 1) Will not allow editing or deleting records if there is no primary key.
 * 2) Does not "page through" records or allow sorting or filtering of records.
*/

/* REQUIREMENTS FOR INSTALLATION / OPERATION
 *
 * 1) Place this file where it can be accessed by a web browser on an apache/php/mysql server
 * 2) In "Preferences" Below fill in the details to connect to the table (or see readme.txt to use an external file for credentials)
 *
 */

### PREFERENCES ###
//Get preferences before we begin
$script_name=$_SERVER["SCRIPT_NAME"];
session_start();
if ($test1=file_exists("/etc/$script_name")) include("/etc/$script_name");
if (!$preferences_loaded) {
    //Preferences and configuration settings can be loaded from a file with the same name as this one (including the .php) in /etc/poundteam/
    //OR you can change the preferences below, but that will leave a security hole if this file is exposed.
    //Sample content for that file is included in the readme.txt file

    //Access code to use page: (change to a number, crud.php?access=21285 or you will see just a blank page)
    include_once("../includes/header.php");
    include("../../public/utilities.php");
    include "../config.php";
    $table = "Events";
    $venue_id = $_GET['venue_id'];
    $title = $table;

    echo "<div class='admin-link'><a href='../portal.php'> << back to portal </a></div>";
    ?>
    <style>
        th {
        background: darkgray url("../../images/sort-arrows.gif") no-repeat right;
        }
    </style>

   <?php
    $access=21285;
    $hostname = $host;
    $dbuser = $username;
    $dbpassword = $password;
    $dbname = $db;

    $limit = "50";
    $can_add = '1';
    $can_mod = '1';
    $can_del = '1';
    $url = 'http://www.yahoo.com';
    ////Options: Uncomment to activate:
    ////lock to a specific table:
    //$tablelock = "table";
    ////run a script after specific activities:
    //$addscript='/usr/share/poundteam/goodguysstartup.php';
    //$editscript='/usr/share/poundteam/goodguysstartup.php';
    //$deletescript='/usr/share/poundteam/goodguysstartup.php';
}
//Debug mode (handy for troubleshooting)
if ( isset($_REQUEST['debug'])) { $debug=$_REQUEST['debug']; }
if ( isset($_REQUEST['debugphpmysqlezedit'])) { $debug=$_REQUEST['debugphpmysqlezedit']; }

if($_GET['access']==$access) {
    $_SESSION['has_access']=true;
}
if($_SESSION['has_access']==true) {
    $has_access = '1'; 
}

if($has_access == '1') {
//uncomment the following line if you placed your credentials in the following configuration file:
   // require_once('/etc/PTutilities.conf');
// Allows URL entries to override the stated defaults above or in the configuration file:
    if(isset($_REQUEST['table'])) {
        $_SESSION['table']=$_REQUEST['table'];
    } else {
        $_SESSION['table']=$table;
    }
    if(isset($_REQUEST['limit'])) {
        $_SESSION['limit']=$_REQUEST['limit'];
    } else {
        $_SESSION['limit']=$limit;
    }

   echo  "<h2>".$title."</h2>";

//Load table names for dropdown
        $DB1 = new mysqli($hostname,  $dbuser, $dbpassword, $dbname);
//    $DB1 = $db;
    if(!isset($tablelock)) {
        $Query = "SELECT distinct table_name FROM information_schema.columns WHERE table_schema = '$dbname'";
        $table_options='';
        if ($Result1 = $DB1->query($Query)) {
            while($Record1 = $Result1->fetch_assoc()) {
                $table_options .= "<option>{$Record1['table_name']}</option>\n";
            }
        }
    } else {
        $table_options = "<option>$tablelock</option>\n";
    }
    $Query = "SELECT distinct column_name, column_key FROM information_schema.columns WHERE table_schema = '$dbname' and table_name='{$_SESSION['table']}'";
    $column_options='';
    if ($Result1 = $DB1->query($Query)) {
        $i=0;
        while($Record1 = $Result1->fetch_assoc()) {
            if($i==0) {
                $i=1;
                //Used for "order by"
                $column=$Record1['column_name'];
                //Used for "Delete X and Modify Y" URL Generators
                $first_column=$Record1['column_name'];
                //Used for permission to delete or modify (only if 1st column is primary key or unique)
                if($Record1['column_key']=='PRI') $can_delete=true;
            }
            $column_options .= "<option>{$Record1['column_name']}</option>\n";
        }
    }
//Delete a record action set:
    if($_GET['action']=='del' && $_GET['conf']=='true' ) {
        $Query = "delete from {$_SESSION['table']} where {$_GET['col']}='{$_GET['rec']}' limit 1";
        $Result1 = $DB1->query($Query);
        if(strlen($deletescript)>'4'){
            include($deletescript);
        }
    }
    if($_GET['action']=='del') {
        if($_GET['conf']<>'true') {
            ?>
<script type="text/javascript">
    var conf=confirm("Are you sure you want to delete this record?")
    if (conf)
        window.location="<? echo curPageURL(); ?>&conf=true"
</script>
            <?
        }
    }


    $db_link=mysql_connect($hostname, $dbuser, $dbpassword)
            or die("Unable to connect to the server!");

    mysql_select_db($dbname)
            or die("Unable to connect to the database");

    $fields_array=array();
    $num_fields=0;
    $num_row=0;

// Build Search String
    if (isset($_POST['search']) || !empty($_POST['search'])) {
        $search = searchString($_POST['search']);
    }    else {
        $search = '';
    }
// Basic construct to "pull" the data using supplied variables (parsed below to "extract" the table name from an older version!
    $sql="select * from {$_SESSION['table']} $search WHERE venue_id='".$venue_id."' order by $column desc limit {$_SESSION['limit']}";
    if($_POST['search']=='test') echo $sql;

// find position of "FROM" in query
    $fpos=strpos($sql, 'from');

// get string starting from the first word after "FROM"
    $strfrom=substr($sql, $fpos+5, 50);

// Find position of the first space after the first word in the string
    $Opos=strpos($strfrom,' ');

//Get table name. If query pull data from more then one table only first table name will be read.
    $table=substr($strfrom, 0,$Opos);

    print('<html>');
    print('<head><title>');
    print('View Table: '.$table.'</title>');
    print('<link rel="stylesheet" href="style.css">');

    print("</head>");
    print("<body>\n<br>\n");
    ?>
<FORM method=post action="<?php echo $_SERVER['PHP_SELF']; ?>" >

<? if (!strlen($tablelock)>'1') {
    //Only show the following if $tablelock is NOT set
    ?>
    Table to View: <select name="table"><option selected><? echo $_SESSION['table']; ?></option>
            <? echo $table_options; ?></select>
<? }
    //Then show the rest whether $tablelock is set or not
?>
    Records to View: <INPUT type=text name='limit' size="3" value="<? echo $_SESSION['limit']; ?>" />
    Table Search: <INPUT type=text name='search' size="30" value="<? echo $_POST['search']; ?>" />
    <INPUT type=submit name=submitphpmysqlezedit value="Show" />
</FORM>
    <?

    if($_GET['action']=='add') {
        //Gather data to show Add Record section
        $Query = "SELECT distinct column_name, column_key, extra, column_default, column_comment FROM information_schema.columns WHERE table_schema = '$dbname' and table_name='{$_GET['table']}'";
        if ($Result1 = $DB1->query($Query)) {
            print("<FORM method=post action='{$_SERVER['PHP_SELF']}?action=savenew&table={$_GET['table']}&limit={$_GET['limit']}' ><table>");
            while($Record1 = $Result1->fetch_array()) {
                if($Record1['extra']=='auto_increment'||$Record1['column_default']=='CURRENT_TIMESTAMP') {
                    $fielddata='AUTO';
                } else {
                    $fielddata="<INPUT type=text name={$Record1['column_name']} value='{$Record1['column_default']}' />";
                }
                print("<tr><td><b>{$Record1['column_name']}</b></td><td>$fielddata</td><td>{$Record1['column_comment']}</td></tr>");
            }
            print("</table>\n<INPUT type=submit name=submitphpmysqlezedit value='Save New Record' />\n</FORM>");
        }
    }

    if($_GET['action']=='mod') {
        //Begin Modify Record action
        //First Gather column comments to use as hints on fields
        $Query = "SELECT distinct column_name, column_key, extra, column_default, column_comment FROM information_schema.columns WHERE table_schema = '$dbname' and table_name='{$_GET['table']}'";
        if ($Result1 = $DB1->query($Query)) {
            $i=0;
            while($Record1 = $Result1->fetch_array()) {
                $field_comments[$i]=$Record1['column_comment'];
                $i++;
            }
        }
        //Gather data to show Modify Record section
        $Query = "SELECT * FROM {$_GET['table']} WHERE {$_GET['col']} = '{$_GET['rec']}' limit 1";
        if ($Result1 = $DB1->query($Query)) {
            print("<FORM method=post action='{$_SERVER['PHP_SELF']}?action=savechanges&table={$_GET['table']}&col={$_GET['col']}&rec={$_GET['rec']}&limit={$_GET['limit']}' ><table>");
            $Record1 = $Result1->fetch_array();
            $i=0;
            while($i<$Result1->field_count) {
                $finfo = $Result1->fetch_field_direct($i);
                $clean_data=htmlentities($Record1[$i],ENT_QUOTES);
                if($finfo->flags=='49667') {
                    $fielddata=$clean_data;
                } else {
                    if(strlen($clean_data)>100){
                        $fielddata="\n<textarea name=$finfo->name rows=3 cols=100>$clean_data</textarea>\n";
                    } else {
                        $fielddata="<INPUT type=text name=$finfo->name size=$finfo->max_length value='$clean_data' />";
                    }
                }
                print("<tr><td><b>$finfo->name</b></td><td>$fielddata</td><td>$field_comments[$i]</td></tr>");
                $i++;
            }
           if($debug=='database'){
               print("\n<INPUT type=hidden name=debugphpmysqlezedit value='database' />\n");
           }
            print("<tr><td><b>Editing Record:</b></td><td>{$_GET['rec']}</td></tr></table>\n<INPUT type=submit name=submitphpmysqlezedit value='Save Changes' />\n</FORM>");
        }
    }

    if($_GET['action']=='savechanges') {
        //Announce Saved (although if there is an error later, this will not be true, we want to give an indication to the user that their prior button press had an effect ...) ?>
        <h3 style=" color: green">Record Changed</h3><p style=" color: green">If you have changed your mind, you may press REVERT below to revert to the prior version of this record.<br/>The PRIOR data is displayed <i>above</i> the Revert button.<br/>The NEW data is displayed <i>below</i> the Revert button (with the rest of the records).</p>
<?        //Begin Save Changes Section
        //BUT FIRST duplicate Modify Record action for all except name of button (we'll turn this into a recyclable function later)
        //This allows for "REVERT" in case there has been an Error.
        //First Gather column comments to use as hints on fields
        $Query = "SELECT distinct column_name, column_key, extra, column_default, column_comment FROM information_schema.columns WHERE table_schema = '$dbname' and table_name='{$_GET['table']}'";
        if ($Result1 = $DB1->query($Query)) {
            $i=0;
            while($Record1 = $Result1->fetch_array()) {
                $field_comments[$i]=$Record1['column_comment'];
                $i++;
            }
        }
        //Gather data to show Modify Record section
        $Query = "SELECT * FROM {$_GET['table']} WHERE {$_GET['col']} = '{$_GET['rec']}' limit 1";
        if ($Result1 = $DB1->query($Query)) {
            print("<FORM method=post action='{$_SERVER['PHP_SELF']}?action=savechanges&table={$_GET['table']}&col={$_GET['col']}&rec={$_GET['rec']}&limit={$_GET['limit']}' >\n<table>\n");
            $Record1 = $Result1->fetch_array();
            $i=0;
            while($i<$Result1->field_count) {
                $finfo = $Result1->fetch_field_direct($i);
                $clean_data=htmlentities($Record1[$i],ENT_QUOTES);
                if($finfo->flags=='49667') {
                    $fielddata=$clean_data;
                } else {
                    if(strlen($clean_data)>100){
                        $fielddata="\n<textarea name=$finfo->name rows=3 cols=100>$clean_data</textarea>\n";
                    } else {
                        $fielddata="\n<INPUT type=text name=$finfo->name size=$finfo->max_length value='$clean_data' />";
                    }
                }
                print("\n<tr><td><b>$finfo->name</b></td><td>$fielddata</td><td>$field_comments[$i]</td></tr>");
                $i++;
            }
            print("\n<tr><td><b>Editing Record:</b></td><td>{$_GET['rec']}</td></tr></table>\n<INPUT type=submit name=submitphpmysqlezedit value='Revert' />\n</FORM>");
        }
        $updateString='';
        $i=0;
        foreach ($_POST as $next=>$value) {
            if ( ($i<>0) && ($next<>"submitphpmysqlezedit") && ($next <> "debugphpmysqlezedit") ) {
                $updateString.=", ";
            }
            if ( ($next <> "submitphpmysqlezedit") && ($next <> "debugphpmysqlezedit") ) $updateString.=" $next='".mysql_real_escape_string($value)."'";
            $i++;
        }
        $Query = "update {$_GET['table']} set $updateString WHERE {$_GET['col']} = '{$_GET['rec']}' limit 1";
        if($debug=='database'){
            echo "<br/>\nLine".__LINE__." Query: $Query<br/>\n";
        }
        $Result1 = $DB1->query($Query);
        if($debug=='database'){
            echo "<br/>\nLine".__LINE__."DBerror=$DB1->error\nDBerrno=$DB1->errno\n";
        }
        if(strlen($editscript)>'4'){
            include($editscript);
        }
    }
    if($_GET['action']=='savenew') {
        $insertfields='';
        $insertvalues="";
        $i=0;
        foreach ($_POST as $next=>$value) {
            if ($i<>0 && $next <>"submitphpmysqlezedit") {
                $insertfields.=",";
                $insertvalues.=",";
            }
            if ($next <>"submitphpmysqlezedit") {
                $insertfields.="$next";
                $insertvalues.="'".mysql_real_escape_string($value)."'";
            }
            $i++;
        }
        $Query = "insert into {$_GET['table']} ($insertfields) VALUES ($insertvalues)";
        $Result1 = $DB1->query($Query);
        echo "Record Added.<br>\n";
        if(strlen($addscript)>'4'){
            include($addscript);
        }
    }
// Get result from query

    if($result=mysql_query($sql)) {
        //Get number of fields in query
        $num_fields=mysql_num_fields($result);

        # get column metadata
        $i = 0;

        //Set table width 15% for each column
        $width=15 * $num_fields;
        if ($can_add=='1') {
            $addstring="<a href='{$_SERVER['PHP_SELF']}?action=add&table=$table&limit=$limit'>Add</a>";
        }
        print("<br/> <table class='tableSorter table zebra-stripped'>");
        print("<thead></thead><tr><th>Delete</th><th>Modify</th>");

        while ($i < $num_fields) {

            //Get fields (columns) names
            $meta = mysql_fetch_field($result);

            $fields_array[]=$meta->name;

            //Display column headers in upper case
            print("<th>".strtoupper($fields_array[$i])."</th>");
            $i=$i+1;
        }

        print('</tr></thead>');


        //Get values for each row and column
        while($row=mysql_fetch_row($result)) {
            if ($can_delete) {
                if ($can_del == '1') {
                    $delstring="<div class='button-small'><a href='{$_SERVER['PHP_SELF']}?action=del&table=$table&col=$first_column&rec=$row[0]&limit=$limit'>delete</a></div>";
                }
                if ($can_mod == '1') {
                    $modstring="<div class='button-small'><a href='{$_SERVER['PHP_SELF']}?action=mod&table=$table&col=$first_column&rec=$row[0]&limit=$limit'>edit</a></div>";
                }
                print("   <tr><td>$delstring</td><td>$modstring</td>");
            } else {
                print("   <tr><td></td><td></td>");
            }
            for($i=0; $i<$num_fields; $i++) {
                //Display values for each row and column
                if(strlen($row[$i])>100) { $display_string=substr($row[$i],0,100).' ...'; } else { $display_string=$row[$i]; }
                print('      <td>'.htmlentities($display_string,ENT_QUOTES).'</td>'."\n");

            }

            print('   </tr>'."\n");
        }
        print('</table>');
    }
    if($debug=='phpinfo'){ phpinfo(); }
    ?>

    <?
} else {
    ?>
<html>
    <head><title>Bouncing for Login ...</title>
        <meta http-equiv="refresh" content="0; URL=<?php echo $url; ?>">
    </head>
    <body>You are bouncing to
        <a href="<?php echo $url; ?>"><?php echo $url; ?></a> for login, then try again.
    </body>
</html><?
}
function curPageURL() {
    $pageURL = 'http';
    if ($_SERVER["HTTPS"] == "on") {
        $pageURL .= "s";
    }
    $pageURL .= "://";
    if ($_SERVER["SERVER_PORT"] != "80") {
        $pageURL .= $_SERVER["SERVER_NAME"].":".$_SERVER["SERVER_PORT"].$_SERVER["REQUEST_URI"];
    } else {
        $pageURL .= $_SERVER["SERVER_NAME"].$_SERVER["REQUEST_URI"];
    }
    return $pageURL;
}
function searchString($search) {
    global $dbname;
    global $DB1;
    $table=$_SESSION['table'];
    $Query = "SELECT column_name FROM information_schema.columns WHERE table_schema='$dbname' AND table_name = '$table'";
    $Result1 = $DB1->query($Query);
    $string='';
    while($Record1 = $Result1->fetch_assoc()) {
        if( !empty( $string )) $string .= " OR "; else $string .= " WHERE ";
        $string .= $Record1['column_name']." LIKE '%$search%'";
    }
    return $string;
}

include_once("../includes/footer.php")

?>
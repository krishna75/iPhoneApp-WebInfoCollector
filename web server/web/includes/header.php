<html><head>    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">    <title>Cloud Nine App</title>    <link rel="shortcut icon" href="Http://www.cnapp.co.uk/Images/idea 3.png"/>    <meta name="description" content="Cloud Nine App.">    <meta name="keywords" content="app, cloud, nine, oxford, night, club, disco, music, dance, floor">    <meta http-equiv="imagetoolbar" content="no">    <meta http-equiv="content-language" content="en-US">    <meta name="copyright" content="Copyright 2013 Cloud Nine App.">    <link rel="stylesheet" type="text/css" href="css/styles.css" media="screen">    <link rel="stylesheet" type="text/css" href="admin/mobileWeb/css/ks-mobile.css" media="screen">    <style type="text/css"></style>    <script type="text/javascript" src="../js/jquery-1.10.2.js"></script>    <script type="text/javascript" src="../js/jquery.tablesorter.js"></script>    <script>        $(function()        {            $('.date-pick')                .datePicker(                {                    createButton:false,                    displayClose:true,                    closeOnSelect:false,                    selectMultiple:true                }            )                .bind(                'click',                function()                {                    $(this).dpDisplay();                    this.blur();                    return false;                }            )                .bind(                'dateSelected',                function(e, selectedDate, $td, state)                {                    console.log('You ' + (state ? '' : 'un') // wrap                        + 'selected ' + selectedDate);                }            )                .bind(                'dpClosed',                function(e, selectedDates)                {                    console.log('You closed the date picker and the ' // wrap                        + 'currently selected dates are:');                    console.log(selectedDates);                }            );        });    </script></head><body id="home"><div id="container">    <div id="logo_wrapper">        <div id="logo">            <img src="images/logo_text.png" alt="Cloud Nine App">        </div>    </div>    <div class="clear"></div>    <div id="content_side">        <div id="navigation">            <ul id="navlist">                <li><a href="index.php" id="home-nav">Home</a></li>                <li><a href="Info.php" id="infonav">Info</a></li>                <li><a href="events.php" id="overnav">Events</a></li>                <li><a href="venues.php" id="landnav">Venues</a></li>                <li><a href="genres.php" id="portnav">Preferences</a></li>                <li><a href="contactUs.php" id="connav">Contact Us</a></li>                <li><a href="signIn.php" id="connav">Sign In</a></li>            </ul>        </div>        <div id="quote">            <a href="http://www.facebook.com/Cnapps"><img src="images/icon-fb.png"/> </a>            <a href="https://twitter.com/Cloudnineapp"><img src="images/icon-tw.png"/> </a>        </div>    </div> 		
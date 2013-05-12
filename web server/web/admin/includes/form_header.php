<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title><?php echo $title; ?></title>
    <link rel="stylesheet" type="text/css" href="css/view.css" media="all">
    <script type="text/javascript" src="js/view.js"></script>
    <script type="text/javascript" src="js/validatious-custom.js"></script>
</head>
<body id="main_body" >

<img id="top" src="images/top.png" alt="">
<div id="form_container">
    <h1>&nbsp</h1>
    <form id="form_626766" class="appnitro validate"  method="post" action="<?php echo $action; ?>">
        <div class="form_description">
            <h2><?php echo $title; ?></h2>
            <label id="message" class="description">
                <?php if (!empty($_GET['message'])) {echo $_GET['message'];}?>
            </label>
        </div>
        <ul >
<?php
    include('header.php');
 ?>
<img id="top" src="../images/top.png" alt="">
<div id="form_container">
    <h1>&nbsp;</h1>
    <form enctype="multipart/form-data" id="form_626766" class="appnitro validate"  method="post"  action="<?php echo $action; ?>">
        <div class="form_description">
            <h2><?php echo $title; ?></h2>
            <label id="message" class="description">
                <?php if (!empty($_GET['message'])) {echo $_GET['message'];}?>
            </label>
        </div>
        <ul >
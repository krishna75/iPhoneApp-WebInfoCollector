<?php include_once("../admin/includes/header.php"); ?>

        <?php
        $success = false;
        $message = "";
        if (!empty($_GET['success'])&& !empty($_GET['message'])) {
            if ( $_GET['success']==1) { $success = true;}
            $message = $_GET['message'];
        }

        if ($success){
            echo "<h2>Success</h2>";
        } else {
            echo "<h2>Error </h2>";
        }

        echo "<p>".$message."</p>";

        ?>

 <p style="font-weight: bold;"> Use browsers back button to go back to the form</p> 
    <div class='admin-link'><a href='portal.php'> go to portal </a></div>;
 <div class='admin-link'><a href="../index.php">go to home page</div>
<?php include_once("../admin/includes/footer.php"); ?>
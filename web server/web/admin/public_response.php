<?php include_once("../admin/includes/header.php"); ?>
    <label id="message" class="description">
        <?php if (!empty($_GET['message'])) {echo $_GET['message'];}?>
    </label>
<p>
    <a href="../index.php">back to home page</a>
</p>
<?php include_once("../admin/includes/footer.php"); ?>
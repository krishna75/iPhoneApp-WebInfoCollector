


<div class="cell" onclick="window.location='<?php echo $link_page; ?>'">
<?php
    echo "<div class='cell-image'>";
        echo "<img src='".$image_url."' alt='venue logo' height='70' width='70'/>";
    echo "</div>";
    echo "<div class='cell-title'>";
        echo $title;
    echo "</div>";
    echo "<div class='cell-subtitle'>";
        echo $subtitle;
    echo "</div>";
    echo "<div class='cell-description'>";
        echo  $description;
    echo "</div>";
    echo "<div class='cell-next'/> </div>";
echo "</div>";

?>
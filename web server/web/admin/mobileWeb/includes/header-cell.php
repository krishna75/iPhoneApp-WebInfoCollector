<div class="header-cell">
<?php
echo "<div class='header-cell-image'>";
    if($header_image_url != ""){
        echo "<img src='".$header_image_url."' height='75' width='75'/>";
    }
echo "</div>";
echo "<div class='header-cell-title'>";
    echo $header_title;
echo "</div>";
echo "<div class='header-cell-subtitle'>";
    echo $header_subtitle;
echo "</div>";
echo "<div class='header-cell-description'>";
    echo  $header_description;
echo "</div>";

?>
</div>
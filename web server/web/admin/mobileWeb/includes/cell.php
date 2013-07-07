<?php
/**
 * Created by JetBrains PhpStorm.
 * User: Krishna
 * Date: 07/07/13
 * Time: 22:05
 * To change this template use File | Settings | File Templates.
 */

echo "<div class='cell'>";
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
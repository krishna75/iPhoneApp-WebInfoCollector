<?php
$requiredRole = 3;
require_once("includes/session.php");
require_once("includes/db_connection.php");
$title = "Add Event";
$action = "model_addEvent.php";
require_once("includes/form_header.php") ;
?>
<script type="text/javascript" charset="utf-8">
$(function(){
    $('.date-pick').datePicker({
        createButton:false,
        displayClose:true,
        closeOnSelect:false,
        selectMultiple:true,
        dateFormat: 'dd-mm-yy'
    })
    .bind('click',function(){
        $(this).dpDisplay();
        this.blur();
        return false;
    })
    .bind('dateSelected', function(e, selectedDate, $td, state){
        console.log('You ' + (state ? '' : 'un')  + 'selected ' + selectedDate);
            var newDates = new Array();
            for (i=0;i<selectedDates.length;i++){
                selectedDate =selectedDates[i];
                day = selectedDate.getDate();
                month = selectedDate.getMonth()+1;
                year = selectedDate.getFullYear();
                newDate = year+"/"+month+"/"+day;
                newDates[i]=newDate;
            }
            $("#date-label").text(newDates.toString());
    })
    .bind( 'dpClosed',function(e, selectedDates){
        console.log('You closed the date picker and the currently selected dates are:'+selectedDates);
        var newDates = new Array();
        for (i=0;i<selectedDates.length;i++){
            selectedDate =selectedDates[i];
            day = selectedDate.getDate();
            month = selectedDate.getMonth()+1;
            year = selectedDate.getFullYear();
            newDate = year+"/"+month+"/"+day;
            newDates[i]=newDate;
        }
        $("#date-label").text(newDates.toString());
        $("#dates").val(newDates);
    });
});
</script>
    <div class='admin-link'><a href='portal.php'> << back to portal </a></div>
    <br/> <br/>


    <li id="li_9">
        <label class="description" for="element_9">Date * </label>
        <span>Selected dates:</span> <span id="date-label"></span>
        <p></p>
        <p><a href="noJs.html" class="date-pick dp-applied" ><img src="images/calendar.gif"/></a></p>
        <input type="hidden" id="dates" name="dates" class="required" title="must select dates"/>

        <p class="guidelines" id="guide_9">
            <small>Date of the event for example 15/04/2013</small>
        </p>
    </li>
    <li id="li_1">
        <label class="description" for="element_1">Event Title* </label>

        <div>
            <input id="title" name="title" class="required element text medium" type="text" maxlength="255" value=""/>
        </div>
        <p class="guidelines" id="guide_1">
            <small>Please provide the title of the event. e.g. Grand Party</small>
        </p>
    </li>
    <li id="li_8">
        <label class="description" for="element_8">Description* </label>

        <div>
            <textarea id="description" name="description" class="required element textarea medium"></textarea>
        </div>
        <p class="guidelines" id="guide_8">
            <small>Description of the event. Including the time, special guests, DJ, offers etc</small>
        </p>
    </li>
    <li id="li_7">
        <label class="description" for="element_7">Event Photo* </label>

        <div>
            <input type="hidden" name="photoField" value="photo"/>
            <input id="photo" name="photo" class="required element file" type="file""/>
        </div>
        <p class="guidelines" id="guide_7">
            <small>If you have a poster of the event please upload it here. The ideal size of the poster would be 200 x
                300 pixel
            </small>
        </p>
    </li>
    <li id="li_10">
        <label class="description" for="element_10">Genre* </label>

        <div style="width:500px">

                <?php
                $result = mysql_query("SELECT * FROM Genres;") or die(mysql_error());
                $count = 1;
                while ($row = mysql_fetch_assoc($result)): ?>
                    <input type="checkbox" name="genres[]"  value="<?php echo $row['id']; ?>" class="g_genres" title="must select a genre" /> <?php echo  $row['genre']; ?> &nbsp;
                    <?php
                        if ($count % 6 == 0){
                            echo "<br/>";
                        }
                    ?>
               <?php  $count ++;  endwhile;?>
            </select>
        </div>
        <p class="guidelines" id="guide_10">
            <small>Please select related genres.</small>
        </p>
    </li>

    <li id="li_11">
        <label class="description" for="element_11">Voucher* </label>
        <p> Provide either a voucher image or voucher text </p>
        <div>
            <input type="hidden" name="voucherPhotoField" value="voucherPhoto"/>
            <input id="voucherPhoto" name="voucherPhoto" class=" element file" type="file""/>

        </div>
        <p class="guidelines" id="guide_11">
            <small>If you have a voucher photo of the event please upload it here. The ideal size of the image would be 200 x
                300 pixel
            </small>
        </p>
    </li>
    <li id="li_11.2">
        <div>
            <textarea id="voucher" name="voucher" class="required element textarea medium"></textarea>
        </div>
        <p class="guidelines" id="guide_8">
            <small>Voucher for promotion: e.g. 10% discount with this voucher</small>
        </p>
    </li>
    <!-- if it is a client it is disabled -->
    <li id="venueSelector">
        <label class="description" for="element_10">Venue </label>

        <div>
            <select class="required element select medium" id="venue" name="venue">
                <?php
                $userId = $_SESSION['user_id'];
                if ($_SESSION['role'] == "3") {
                    $result = mysql_query("SELECT v.id as id,v.name as name
                    FROM Venues as v left join ( Users_Venues as uv)
                    ON (v.id=uv.venue_id)
                    WHERE uv.user_id='$userId';") or die(mysql_error());

                    $venueId = mysql_result($result, 0, "id");
                    $venueName = mysql_result($result, 0, "name");

                    echo ' <option value="' . $venueId . '" selected="selected">' . $venueName . '</option>';
                } else {
                    echo '<option value="" selected="selected"></option>';
                    $result = mysql_query("SELECT id,name FROM Venues;") or die(mysql_error());
                    while ($row = mysql_fetch_assoc($result)) {
                        echo "<option value='" . $row['id'] . "' >" . $row['name'] . "</option>";
                    }
                }
                ?>
            </select>
        </div>
        <p class="guidelines" id="guide_10">
            <small> Venue associated with this event</small>
        </p>
    </li>

    <li class="buttons">
        <input type="hidden" name="form_id" value="620316"/>
        <input id="saveForm" class="button_text" type="submit" name="submit" value="Submit"/>
    </li>
<?php //include("includes/form_footer.php");?>
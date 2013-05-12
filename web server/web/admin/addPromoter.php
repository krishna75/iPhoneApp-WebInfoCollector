<?php
  $requiredRole = 1;
  include("includes/session.php");
  $title = "Add Promoter";
  $action = "model_addPromoter.php";
  include("includes/form_header.php") ;
 ?>
					<li id="li_1" >
		<label class="description" for="element_1">Name * </label>
		<span>
			<input id="element_1_1" name= "element_1_1" class="element text" maxlength="255" size="8" value=""/>
			<label>First</label>
		</span>
		<span>
			<input id="element_1_2" name= "element_1_2" class="element text" maxlength="255" size="14" value=""/>
			<label>Last</label>
		</span>
		</li>		<li id="li_2" >
		<label class="description" for="element_2">Email * </label>
		<div>
			<input id="element_2" name="element_2" class="element text medium" type="text" maxlength="255" value=""/>
		</div>
		</li>		<li id="li_3" >
		<label class="description" for="element_3">Phone </label>
		<span>
			<input id="element_3_1" name="element_3_1" class="element text" size="3" maxlength="3" value="" type="text"> -
			<label for="element_3_1">(###)</label>
		</span>
		<span>
			<input id="element_3_2" name="element_3_2" class="element text" size="3" maxlength="3" value="" type="text"> -
			<label for="element_3_2">###</label>
		</span>
		<span>
	 		<input id="element_3_3" name="element_3_3" class="element text" size="4" maxlength="4" value="" type="text">
			<label for="element_3_3">####</label>
		</span>

		</li>		<li id="li_4" >
		<label class="description" for="element_4">Address </label>
		<div>
			<textarea id="element_4" name="element_4" class="element textarea small"></textarea>
		</div>
		</li>		<li class="section_break">
			<h3>Log in details</h3>
			<p></p>
		</li>		<li id="li_6" >
		<label class="description" for="element_6">New username * </label>
		<div>
			<input id="element_6" name="element_6" class="element text medium" type="text" maxlength="255" value=""/>
		</div>
		</li>		<li id="li_7" >
		<label class="description" for="element_7">New password * </label>
		<div>
			<input id="element_7" name="element_7" class="element text medium" type="text" maxlength="255" value=""/>
		</div>
		</li>		<li id="li_8" >
		<label class="description" for="element_8">Confirm password * </label>
		<div>
			<input id="element_8" name="element_8" class="element text medium" type="text" maxlength="255" value=""/>
		</div>
		</li>

					<li class="buttons">
			    <input type="hidden" name="form_id" value="626766" />

				<input id="saveForm" class="button_text" type="submit" name="submit" value="Submit" />
		</li>

<?php include("includes/form_footer.php");
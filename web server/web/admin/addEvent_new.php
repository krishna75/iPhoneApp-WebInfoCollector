<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
    <meta http-equiv="Content-type" content="text/html; charset=utf-8">
    <title>jQuery datePicker datePickerMultiple demo</title>


    <!-- jQuery -->
    <script type="text/javascript" src="../js/jquery-1.10.2.js"></script>

<!--    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.5.2/jquery.min.js"></script>-->
    <!-- required plugins -->
    <script type="text/javascript" src="../js/date.js"></script>

    <!-- jquery.datePicker.js -->
    <script type="text/javascript" src="../js/jquery.datePicker.js"></script>

    <!-- datePicker required styles -->
    <link rel="stylesheet" type="text/css" media="screen" href="../css/datePicker.css">


    <!-- page specific scripts -->
    <script type="text/javascript" charset="utf-8">
        $(function()
        {
            $('.date-pick')
                .datePicker(
                {
                    createButton:false,
                    displayClose:true,
                    closeOnSelect:false,
                    selectMultiple:true
                }
            )
                .bind(
                'click',
                function()
                {
                    $(this).dpDisplay();
                    this.blur();
                    return false;
                }
            )
                .bind(
                'dateSelected',
                function(e, selectedDate, $td, state)
                {
                    console.log('You ' + (state ? '' : 'un') // wrap
                        + 'selected ' + selectedDate);

                }
            )
                .bind(
                'dpClosed',
                function(e, selectedDates)
                {
                    console.log('You closed the date picker and the ' // wrap
                        + 'currently selected dates are:');
                    console.log(selectedDates);
                }
            );
        });
    </script>

</head>
<body>
<div id="container">
    <h1>jquery.datePicker example: datePicker with multiple select enabled</h1>
    <p><a href="index.html">&lt; date picker home</a></p>
    <p>
        The following example shows how you can provide options to the date picker to allow you
        to select multiple dates. In this case a "dateSelected" event is triggered every time a date is
        selected or unselected. When the calendar is closed a "dpClosed" event is triggered.
    </p>
    <p>
        There is an extension to the example which shows how you can <a href="datePickerMultipleLimit.html">
            limit the number of dates selectable</a>.
    <p>
        <strong>NOTE</strong>: You will need firebug to see the results of the demo - firebug lite is included in this page
        so whatever browser you are in just press F12 to open up the firebug console.
    </p>
    <p>
        <a href="noJs.html" class="date-pick">Click here</a> to see a date picker pop up next to
        that link. You can also <a href="noJs.html" class="date-pick">click here</a> to see different
        date picker pop up.
    </p>
    <h2>Page sourcecode</h2>
			<pre class="sourcecode">
$(function()
{
	$('.date-pick')
		.datePicker(
			{
				createButton:false,
				displayClose:true,
				closeOnSelect:false,
				selectMultiple:true
			}
		)
		.bind(
			'click',
			function()
			{
				$(this).dpDisplay();
				this.blur();
				return false;
			}
		)
		.bind(
			'dateSelected',
			function(e, selectedDate, $td, state)
			{
				console.log('You ' + (state ? '' : 'un') // wrap
					+ 'selected ' + selectedDate);

			}
		)
		.bind(
			'dpClosed',
			function(e, selectedDates)
			{
				console.log('You closed the date picker and the ' // wrap
					+ 'currently selected dates are:');
				console.log(selectedDates);
			}
		);
});</pre>
</div>
</body>
</html>
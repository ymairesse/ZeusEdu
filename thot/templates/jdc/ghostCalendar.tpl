<div id="ghostCalendar">
</div>

<script type="text/javascript">

    $(document).ready(function(){

        $('#ghostCalendar').fullCalendar({
			weekends: false,
			defaultView: 'agendaWeek',
			eventLimit: 2,
			height: 500,
			timeFormat: 'HH:mm',
			header: {
				left: 'prev, today, next',
				center: 'title',
                right: ''
			},
			minTime: "08:00:00",
			maxTime: "17:00:00",
			firstDay: 1,
			eventSources: [
				{
				url: 'inc/jdc/events4modele.json.php',
				type: 'POST',
                data: {
					categories: $('.selectCategories').serialize()
					},
				}
			],
            viewRender: function(view, element){
                var currentdate = view.intervalStart.format();
                $('#laDate').val(currentdate);
            }
		})


    })

</script>

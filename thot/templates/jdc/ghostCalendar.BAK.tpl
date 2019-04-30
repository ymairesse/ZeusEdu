GHOSTCALENDAR
<div id="ghostCalendar">
</div>

<script type="text/javascript">

    $(document).ready(function(){

        function getMondayDate(){
            var date = $('.fc-day-header.fc-mon').data('date');
            console.log(date);
            return date;
        }

        $('#dateMonday').val(getMondayDate());

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
            test: 'test',
			minTime: "08:00:00",
			maxTime: "17:00:00",
			firstDay: 1,
            // empêcher l'édition avec la souris
            eventStartEditable: false,
            eventDurationEditable: false,
			eventSources: [
				{
				url: 'inc/jdc/events4ghost.json.php',
				type: 'POST',
                data: {
                    formulaire: $('#formCategories').serialize(),
					},
				}
			],
            dayClick: function(event, jsEvent, view) {
                console.log(event);
            },
            viewRender: function(view, element){
                var currentdate = view.intervalStart.format();
                $('#dateMonday').val(currentdate);
            }
		})


    })

</script>

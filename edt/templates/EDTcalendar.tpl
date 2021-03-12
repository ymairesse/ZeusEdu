<div id="EDTcalendar"
    data-editable="{$editable|default:"false"}"
    data-acronyme="{$acronyme|default:''}"
    data-viewstate="agendaWeek">
</div>

<script type="text/javascript">

    $(document).ready(function(){

        $('#EDTcalendar').fullCalendar({
            editable: true,
		 	weekends: false,
		 	defaultView: 'agendaWeek',
            columnFormat: "dddd",
            axisFormat: 'HH:mm',
		  	height: 500,
		 	timeFormat: 'HH:mm',
			header: {
				left: false,
                center: false,
				right: 'agendaWeek,agendaDay'
			},
		 	businessHours: {
		 	 	start: '08:15',
		 	 	end: '17:00',
		 	},
		  	minTime: "08:00:00",
		  	maxTime: "17:00:00",
            eventRender: function(event, element, view){
                element.addClass(event.className);
                element.find('.fc-time').append('<span class="pull-right">Local: ' + event.local + '</span>');
                element.find('.fc-title')
                    .html("<div class='cours'>" + event.matiere + '<br>' + event.classes +"</div>");
            },
			eventSources: [
				{
				url: 'inc/EDTevents.json.php',
				type: 'POST',
				data: {
					acronyme: $('#EDTcalendar').data('acronyme'),
					},
				error: function() {
					alert('Attention, vous semblez avoir perdu la connexion à l\'Internet');
					}
				}
			],
		})

    })

</script>

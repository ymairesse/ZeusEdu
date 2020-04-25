<div class="container">

	<div class="row">

		<div class="col-md-7 col-xs-12">
			<div class="alert alert-info">Sélectionnez une période</div>

			<div id="calendar"></div>

		</div>

		<div class="col-md-5 col-xs-12">

			<div id="unTravail">
				{if isset($travail)} {include file='jdc/unTravail.tpl'} {else}
				<strong>Veuillez sélectionner un item dans le calendrier</strong>
				<div class="img-responsive"><img src="../images/logoPageVide.png" alt="Logo"></div>
				{/if}
			</div>

		</div>
		<!-- col-md-... -->

	</div>
	<!-- row -->

	<div class="row">

		{foreach from=$legendeCouleurs key=cat item=travail}
		<div class="col-md-1 col-sm-6">
			<div class="cat_{$cat} discret" title="{$travail.categorie}">{$travail.categorie|truncate:10}</div>
		</div>
		<!-- col-md-... -->
		{/foreach}

	</div>
	<!-- row -->

</div>
<!-- container -->

<script type="text/javascript">
	$(document).ready(function() {

		$("#calendar").fullCalendar({
			events: {
				url: 'inc/jdc/events.json.php'
			},
			eventLimit: 2,
			header: {
				left: 'prev, today, next',
				center: 'title',
				right: 'month,agendaWeek,agendaDay'
			},
			eventClick: function(calEvent, jsEvent, view) {
				var id = calEvent.id; // l'id de l'événement
				$.post('inc/jdc/getTravail.inc.php', {
						event_id: id
					},
					function(resultat) {
						$("#unTravail").fadeOut(400, function() {
							$("#unTravail").html(resultat);
						});
						$("#unTravail").fadeIn();
					}
				)
			},
			defaultTimedEventDuration: '00:50',
			businessHours: {
				start: '08:15',
				end: '16:25',
				dow: [1, 2, 3, 4, 5]
			},
			minTime: "08:00:00",
			maxTime: "18:00:00",
			firstDay: 1,
			dayClick: function(date, event, view) {
				$('#calendar').fullCalendar('gotoDate', date);
				$('#calendar').fullCalendar('changeView', 'agendaDay');
			}
		});

	})
</script>

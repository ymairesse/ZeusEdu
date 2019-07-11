<div class="container-fluid">

	<div class="row">

		<div id="feuillePresences">

		</div>

		<div id="calendarListeCours">

			<div class="col-md-6 col-xs-12" id="weekCalendar">
			</div>

			<div class="col-md-3 col-xs-6">

				<div class="btn-group btn-group-vertical" style="width:100%">
				{foreach from=$listeCoursGrp key=coursGrp item=data}
					<button type="button"
						class="btn btn-block {if $data.virtuel == 1}btn-info{else}btn-default{/if} btn-presenceCours"
						data-coursgrp="{$coursGrp}">
						{if isset($data.nomCours) && ($data.nomCours != '')}
							{$data.nomCours} [{$coursGrp}]
						{else}
							[{$coursGrp}] {$data.statut} {$data.libelle} {$data.nbheures}h
						{/if}
					</button>

				{/foreach}
				</div>

			</div>  <!-- col-md-.. -->

		</div>

		<div class="col-md-3 col-xs-6">
			{include file="$INSTALL_DIR/widgets/flashInfo/templates/index.tpl"}
		</div>  <!-- col-md-... -->

	</div>




	</div>  <!-- row -->

</div>

<script type="text/javascript">

	$(document).ready(function(){

		$('.btn-presenceCours').click(function(){
			var coursGrp = $(this).data('coursgrp');
			$.post('inc/presencesTituCours.inc.php', {
				coursGrp: coursGrp
			}, function(resultat){
				$('#feuillePresences').html(resultat).removeClass('hidden');
				$('#calendarListeCours').addClass('hidden');
			})
		})

		$('#weekCalendar').fullCalendar({
			weekends: false,
			defaultView: 'agendaWeek',
			header: {

			},
			eventAfterAllRender:
				function() {
					$('.fc-header-toolbar').hide();
				},
			businessHours: {
				start: '08:15',
				end: '18:00',
				dow: [1, 2, 3, 4, 5]
				},
			minTime: "08:00:00",
			maxTime: "18:00:00",
			columnHeaderText: function(mom) {
					return mom.format('dddd');
			  },
			eventSources: [
				{
				url: 'inc/events4ghost.json.php',
				type: 'POST',
				error: function() {
					alert('Attention, vous semblez avoir perdu la connexion à l\'Internet');
					}
				}
			],
			eventRender: function(event, element, view) {
				element.html(event.coursGrp + ' - ' + event.startTime + '<br> <span style="color:red">' + event.libelle + '</span>');
			},
			eventClick: function (event, jsEvent, view) {
				console.log(event);
			}
		});

	})



</script>

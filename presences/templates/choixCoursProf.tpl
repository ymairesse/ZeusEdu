<div class="container-fluid">

	<div class="row">

		<div class="col-md-10">

			<ul class="nav nav-tabs">
				<li class="active"><a data-toggle="tab" href="#selection">Sélection</a></li>
				<li><a data-toggle="tab" href="#presences" class="btn disabled">Présences {if $photosVis == 'visible'}<i class="fa fa-address-book-o"></i> {/if}</a></li>
			</ul>

			<div class="tab-content">

				<div id="selection" class="tab-pane fade in active row">
					<div class="col-md-9">

						<div id="weekCalendar">
							{* emplacment du semainier type *}
						</div>
					</div>

					<div class="col-md-3">

						<div id="listeProfs">
							<div class="form-group">
								<label for="tituCours">Sélectionner un professeur</label>
								<select class="form-control" name="tituCours" id="tituCours">
									<option value="">Veuillez sélectionner un professeur</option>
									{foreach from=$listeProfs key=unAcronyme item=data}
									<option value="{$unAcronyme}" {if $acronyme==$unAcronyme} selected{/if}>{$data.nom} {$data.prenom}</option>
									{/foreach}
								</select>
							</div>
						</div>

						<div class="btn-group btn-group-vertical btn-block" id="listeCours">
							{include file='listeCoursGrpProf.tpl'}
						</div>

						</div>
					</div>

					<div id="presences" class="tab-pane fade row">
						<div class="col-md-12">
							<div id="feuillePresences">
							</div>
						</div>
					</div>

				</div>

			</div>


			<div class="col-md-2">

				{include file="$INSTALL_DIR/widgets/flashInfo/templates/index.tpl"}
			</div>

		</div> <!-- row -->

	</div>



	<script type="text/javascript">

		$(document).ready(function() {

			$('#tituCours').change(function() {
				var acronyme = $('#tituCours option:selected').val();
				// var dateLundi = $('#dateLundi').data('datelundi');
				var events = {
					url: 'inc/events4ghost.json.php',
					type: 'POST',
					data: {
						acronyme: acronyme,
					}
				};
				$('#weekCalendar').fullCalendar('removeEventSources');
				$('#weekCalendar').fullCalendar('addEventSource', events);
				$.post('inc/listeCoursGrpProf.inc.php', {
					acronyme: acronyme
				}, function(resultat) {
					$('#listeCours').html(resultat);
					$("[data-toggle='popover']").popover('hide');
				})
			})

			$('#listeCours').on('click', '.btn-presenceCours', function() {
				var coursGrp = $(this).data('coursgrp');
				$.post('inc/presencesTituCours.inc.php', {
					coursGrp: coursGrp
				}, function(resultat) {
					$('#feuillePresences').html(resultat);
					$('.nav-tabs a:eq(1)').removeClass('disabled').tab('show');
				})
			})

			$('#weekCalendar').fullCalendar({
				weekends: false,
				height: 600,
				defaultView: 'agendaWeek',
				header: {},
 				columnHeaderFormat: 'ddd D/M',
				nowIndicator: true,
				eventAfterAllRender: function() {
					$('.fc-header-toolbar').hide();
				},
				businessHours: {
					start: '08:15',
					end: '18:00',
					dow: [1, 2, 3, 4, 5]
				},
				minTime: "08:00:00",
				maxTime: "18:00:00",
				eventSources: [{
					url: 'inc/events4ghost.json.php',
					type: 'POST',
					data: {
						acronyme: $('#tituCours option:selected').val()
					},
					error: function() {
						alert('Attention, vous semblez avoir perdu la connexion à l\'Internet');
					}
				}],
				eventRender: function(event, element, view) {
					element.html(event.coursGrp + ' - ' + event.startTime + '<br> <span style="color:#bb9966">' + event.libelle + '</span>');
				},
				eventClick: function(event, jsEvent, view) {
					var heure = event.start.format('HH:mm');
					var laDate = event.start.format('YYYY-MM-DD');
					var coursGrp = event.coursGrp;
					$.post('inc/getPresencesFromGhost.inc.php', {
						laDate: laDate,
						heure: heure,
						coursGrp: coursGrp
					}, function(resultat) {
						$('#feuillePresences').html(resultat);
						$('.nav-tabs a:eq(1)').removeClass('disabled').tab('show');
					})
				}
			});

		})
	</script>

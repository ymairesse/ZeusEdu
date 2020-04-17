<ul class="nav nav-tabs">
	<li class="active"><a data-toggle="tab" href="#selection">Sélection</a></li>
	<li><a data-toggle="tab" id="tabJdc" href="#jdc" class="btn disabled">Journal de Classe</a></li>
</ul>

<div class="tab-content">

	<div id="selection" class="tab-pane fade in active row">
		<div class="col-md-9">

			<div id="weekCalendar">
				{* emplacment du semainier type*}
			</div>

		</div>

		<div class="col-md-3">
			{* boutons donnant accès aud différents cours de l'utlisateur actif *}
			<div class="btn-group btn-group-vertical btn-block" id="listeCours">
				<button type="button"
					id="synoptique"
					class="btn btn-danger"
					data-coursgrp="synoptique">
					Vue synoptique
				</button>

				{include file='jdc/listeCoursGrpProf.tpl'}
			</div>

		</div>
	</div>

	<div id="jdc" class="tab-pane fade row">
		<div class="col-md-12">
			<div id="ongletJDC">
				{* onglet qui contiendra le JDC et l'éditeur de JDC *}
			</div>
		</div>
	</div>

</div>



<script type="text/javascript">

	// calendrier plus étroit, zone d'édition plus grande
	function modeEdition(){
		$('#calendrier').removeClass('col-md-9').addClass('col-md-6');
		$('#editeur').removeClass('col-md-3').addClass('col-md-6');
	}
	// calendrier plus large, zone d'édition plus étroite
	function modeConsultation(){
		$('#calendrier').addClass('col-md-9').removeClass('col-md-6');
		$('#editeur').addClass('col-md-3').removeClass('col-md-6');
	}

	$(document).ready(function() {

		$('#listeCours').on('click', '.btn-selectCours', function() {
			$('.nav-tabs a:eq(1)').removeClass('disabled').tab('show');
			var coursGrp = $(this).data('coursgrp');
			$.post('inc/jdc/jdcCours.inc.php', {
				coursGrp: coursGrp
			}, function(resultat) {
					// mise à jour du semainier après ouverture de l'onglet qui le contient
					// souci entre jquery et fullCalendar
					$('#tabJdc').on('shown.bs.tab', function (e) {
					$('#calendar').fullCalendar('render');
				});
				$('#ongletJDC').html(resultat);
			})
		})

		$('#synoptique').click(function(){
			$('.nav-tabs a:eq(1)').removeClass('disabled').tab('show');
			$.post('inc/jdc/jdcSynoptique.inc.php', {
			}, function(resultat){
				// mise à jour du semainier après ouverture de l'onglet qui le contient
				// souci entre jquery et fullCalendar
				$('#tabJdc').on('shown.bs.tab', function (e) {
				$('#calendar').fullCalendar('render');
			});
			$('#ongletJDC').html(resultat);
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
				url: 'inc/jdc/events4ghost.json.php',
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

				$('.nav-tabs a:eq(1)').removeClass('disabled').tab('show');
				// date cliquée dans le modèle
				var laDate = event.start.format('DD/MM/YYYY');
				// établir le JDC à partir du modèle enregistré; la page contient le semainier et l'éditeur de JDC
				$.post('inc/jdc/getJdcFromGhost.inc.php', {
					id: event.id,
					laDate: laDate
				}, function(resultat) {
					$('#ongletJDC').html(resultat);
					// mise à jour du semainier après ouverture de l'onglet qui le contient
					// souci entre jquery et fullCalendar
					$('#tabJdc').on('shown.bs.tab', function (e) {
						$('#calendar').fullCalendar('render');
					});
					modeEdition();
			})

			}
		});

	})
</script>

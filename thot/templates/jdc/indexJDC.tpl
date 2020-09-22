<div class="container-fluid">

	<ul class="nav nav-tabs">
		<li class="active"><a data-toggle="tab" href="#selection">Sélection</a></li>
		<li><a data-toggle="tab" id="tabJdc" href="#jdc" class="btn disabled">Journal de Classe</a></li>
	</ul>

	<div class="tab-content">

		<div id="selection" class="tab-pane fade in active">

			<div class="col-md-9">

				<div id="weekCalendar">
					{* emplacment du semainier type *}
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

				<button type="button"
				        class="btn btn-lightBlue btn-block"
				        id="printJDC"
				        style="margin-top:10px;"
				        title=""
				        data-original-title="Impression PDF du JDC">
				    Impression PDF <i class="fa fa-file-pdf-o fa-lg" style="color:red"></i>
				</button>

			</div>
		</div>

		<div id="jdc" class="tab-pane fade">

			<div class="col-md-6 col-sm-12" id="panneauAgenda">
				{* onglet qui contiendra la grille JDC *}
			</div>

			<div class="col-md-6 col-sm-12" id="panneauEditeur">
				{* onglet qui contiendra l'éditeur de JDC *}
				{include file="jdc/selectItem.html"}
			</div>

		</div>

	</div>

</div>

<div id="modal"></div>

<script type="text/javascript">

	function lockUnlock(){
		var lockState = $('#unlocked').val();
		if (lockState == "true") {
			$('#unlocked').val('false');
			$('#panneauEditeur .btn-edit').addClass('disabled');
			$('.fc-unLockButton-button').html('<i class="fa fa-lock fa-2x"></i>');
			}
			else {
				$('#unlocked').val('true');
				$('#panneauEditeur .btn-edit').removeClass('disabled');
				$('.fc-unLockButton-button').html('<i class="fa fa-unlock fa-2x"></i>');
			}
		}

	$(document).ready(function() {

		$('#panneauEditeur').on('click', '#delete', function(){
			var id = $(this).data('id');
			$.post('inc/jdc/getModalDel.inc.php', {
					id: id,
				},
				function(resultat) {
					$("#modal").html(resultat);
					$("#modalDel").modal('show');
				}
			)
		})
		$('#modal').on('click', '#btn-modalDel', function(){
            var id = $('#id').val();
            $.post('inc/jdc/delJdc.inc.php', {
                id: id
            }, function(resultat){
                if (resultat > 0) {
                    $('#panneauEditeur').load('templates/jdc/selectItem.html');
                    bootbox.alert({
                        message: "Événement supprimé",
                        size: 'small'
                    });
                }
                $('#calendar').fullCalendar('refetchEvents');
                $('#modalDel').modal('hide');
            })
        })

		$('#panneauEditeur').on('click', '#modifier', function(){
			var id = $(this).data('id');
			$.post('inc/jdc/getMod.inc.php', {
				id: id
			}, function(resultat){
				$('#panneauEditeur').html(resultat);
			})
		})

		$('#panneauEditeur').on('click', '#saveJDC', function(){
			if ($('#editJdc').valid()) {
				var enonce = $('#enonce').val();
				var formulaire = $('#editJdc').serialize();

				$.post('inc/jdc/saveJdc.inc.php', {
					formulaire: formulaire,
					enonce: enonce
				}, function(resultat) {
					var resultJSON = JSON.parse(resultat);
					var idJdc = resultJSON.idJdc;
					bootbox.alert({
						message: resultJSON.texte,
						size: 'small'
					});
					// récupérer le contenu de la zone "travail" à droite
					$.post('inc/jdc/getTravail.inc.php', {
						id: idJdc,
						editable: true
						}, function(resultat){
							$('#unTravail').html(resultat);
						})
				$('#calendar').fullCalendar('refetchEvents');
				});
			}
		})

		$('#panneauEditeur').on('click', '#btn-clone', function() {
			var idTravail = $(this).data('id');
			var pastIsOpen = $('#unlocked').val();
			$.post('inc/jdc/editCible.inc.php', {
				idTravail: idTravail,
				pastIsOpen: pastIsOpen
			}, function(resultat) {
				$('#modal').html(resultat);
				$('#modalEditCible').modal('show');
				})
			})

		// ----------------------------------------------------------------
		$('#printJDC').click(function(){
			var currentTime = new Date();
			var currentYear = currentTime.getFullYear();
			var currentMonth = currentTime.getMonth()+1;
			if (currentMonth > 8 && currentMonth <= 12)
				var dateDepuis = '01/09/' + currentYear
				else var dateDepuis = '01/09/' + String(currentYear - 1);
			$.post('inc/jdc/modalPrintPDF.inc.php', {
				dateDepuis: dateDepuis,
			}, function(resultat){
				$('#modal').html(resultat);
				$('#modalPrintJDC').modal('show');
			})
		})
		$('#modal').on('click', '#btnModalPrintJDC', function(){
			var formulaire = $('#printForm').serialize();
			if ($('#printForm').valid()) {
				$.post('inc/jdc/printJdc.inc.php', {
					formulaire: formulaire
				}, function(resultat){
					$('#modalPrintJDC').modal('hide');
					bootbox.alert(resultat);
				})
			}
		})
		// ----------------------------------------------------------------

		$('#listeCours').on('click', '.btn-selectCours', function() {
			$('.nav-tabs a:eq(1)').removeClass('disabled').tab('show');
			var coursGrp = $(this).data('coursgrp');
			$.post('inc/jdc/getAgendaCours.inc.php', {
				coursGrp: coursGrp
			}, function(resultat) {
				$('#panneauAgenda').html(resultat);
				$('#panneauEditeur').load('templates/jdc/selectItem.html');
				// IMPORTANT: mise à jour du semainier après ouverture de l'onglet qui le contient
				// souci entre jquery et fullCalendar
				$('#tabJdc').on('shown.bs.tab', function (e) {
					$('#calendar').fullCalendar('render');
				});
			})
		})

		$('#synoptique').click(function(){
			$('.nav-tabs a:eq(1)').removeClass('disabled').tab('show');
			$.post('inc/jdc/jdcSynoptique.inc.php', {
			}, function(resultat){
				$('#jdc').html(resultat);
				// IMPORTANT: mise à jour du semainier après ouverture de l'onglet qui le contient
				// souci entre jquery et fullCalendar
				$('#tabJdc').on('shown.bs.tab', function (e) {
					$('#calendar').fullCalendar('render');
				});
			})
		})

		// calendrier modèle de semaine
		$('#weekCalendar').fullCalendar({
			weekends: false,
			height: 600,
			defaultView: 'agendaWeek',
			header: {
				left: '',
				right: 'title',
				},
			nowIndicator: true,
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
					$('#panneauAgenda').html(resultat);
					$.post('inc/jdc/getEditorFromGhost.inc.php', {
						id: event.id,
						laDate: laDate
					}, function(resultat){
						$('#panneauEditeur').html(resultat);
					})
					// IMPORTANT: mise à jour du semainier après ouverture de l'onglet qui le contient
					// souci entre jquery et fullCalendar
					$('#tabJdc').on('shown.bs.tab', function (e) {
						$('#calendar').fullCalendar('render');
					});
			})

			}
		});

	})
</script>

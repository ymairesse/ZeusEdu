{* au cas où un enregistrement vient d'avoir lieu, une variable $travail *}
{* contenant toutes les caractéristiques de l'enregistrement est renvoyée et on en extrait les infos nécessaires à l'affichage *}
{if isset($travail)}
	{assign var=destinataire value=$travail.destinataire}
	{assign var=type value=$travail.type}
	{assign var=startDate value=$travail.startDate}
{/if}

<div class="container">

	<div class="row">

		<div class="col-md-7 col-xs-12">
			<h2>{$lblDestinataire|default:''}</h2>

			<div id="calendar"></div>

		</div>

		<div class="col-md-5 col-xs-12" style="max-height:50em; overflow: auto">

			<form action="index.php" method="POST" name="detailsJour" id="detailsJour" role="form" class="form-vertical ombre">
				<!-- champs destinés à être lus pour d'autres formulaires -->
				<input type="hidden" name="mode" id="mode" value="{$mode}">
				<input type="hidden" name="action" id="action" value="{$action}">
				<input type="hidden" name="acronyme" id="acronyme" value="{$identite.acronyme}">
				<input type="hidden" name="destinataire" id="destinataire" value="{$destinataire|default:''}">
				<input type="hidden" name="lblDestinataire" id="lblDestinataire" value="{$lblDestinataire|default:''}">
				<input type="hidden" name="type" id="type" value="{$type|default:''}">
				<input type="hidden" name="editable" id="editable" value="{$editable|default:false}">
				<input type="hidden" name="startDate" id="startDate" value="{$startDate|default:''}">
				<input type="hidden" name="type" id="type" value="{$type}">
				<input type="hidden" name="coursGrp" id="coursGrp" value="{$coursGrp|default:''}">
				<input type="hidden" name="classe" id="classe" value="{$classe|default:''}">
				<input type="hidden" name="matricule" id="matricule" value="{$matricule|default:''}">
				<input type="hidden" name="viewState" id="viewState" value="">

				<div id="unTravail">
					{if isset($travail)}
						{include file='jdc/unTravail.tpl'}
					{else}
						<strong>Veuillez sélectionner un item dans le calendrier</strong>
						<br>
						<strong>ou cliquer dans une zone libre pour rédiger une nouvelle note.</strong>
						<div class="img-responsive"><img src="../images/logoPageVide.png" alt="Logo"></div>
					{/if}
				</div>
			</form>

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

	<div id="zoneMod">
	</div>
	<div id="zoneDel">
	</div>

</div>
<!-- container -->

<script type="text/javascript">
	// bootstrap-ckeditor-fix.js
	// hack to fix ckeditor/bootstrap compatiability bug when ckeditor appears in a bootstrap modal dialog
	//
	// Include this file AFTER both jQuery and bootstrap are loaded.
	// http://ckeditor.com/comment/127719#comment-127719
	$.fn.modal.Constructor.prototype.enforceFocus = function() {
		modal_this = this
		$(document).on('focusin.modal', function(e) {
			if (modal_this.$element[0] !== e.target && !modal_this.$element.has(e.target).length &&
				!$(e.target.parentNode).hasClass('cke_dialog_ui_input_select') &&
				!$(e.target.parentNode).hasClass('cke_dialog_ui_input_text')) {
				modal_this.$element.focus()
			}
		})
	};

	function dateFromFr(uneDate) {
		var laDate = uneDate.split('/');
		return laDate[2] + '-' + laDate[1] + '-' + laDate[0];
	}

	$(document).ready(function() {

		$('#refetchEvents').click(function(){
			$('#calendar').fullCalendar('refetchEvents');
		})

		$('#calendar').fullCalendar({
			eventSources: [
				{
				url: 'inc/events.json.php',
				type: 'POST',
				data: {
					type: $('#type').val(),
					coursGrp: $('#coursGrp').val(),
					classe: $('#classe').val(),
					matricule: $('#matricule').val(),
					},
				error: function() {
					alert('Une erreur s\'est produite. Merci de la signaler à l\'administrateur.');
					}
				}
			],
			eventLimit: 2,
			header: {
				left: 'prev, today, next',
				center: 'title',
				right: 'month,agendaWeek,agendaDay'
			},
			defaultTimedEventDuration: '00:50',
			viewRender: function(view, element) {
				var state = view.name;
				$("#viewState").val(state);
			},
			businessHours: {
				start: '08:15',
				end: '19:00',
				dow: [1, 2, 3, 4, 5]
				},
			minTime: "08:00:00",
			maxTime: "22:00:00",
			firstDay: 1,
			// on clique sur un événement
			eventClick: function(calEvent, jsEvent, view) {
				var eventId = calEvent.id; // l'id de l'événement
				var startDate = moment(calEvent.start).format('YYYY-MM-DD HH:mm'); // la date de début de l'événement
				// mémoriser la date pour le retour
				$("#startDate").val(startDate);
				$.post('inc/getTravail.inc.php', {
						event_id: eventId
					},
					function(resultat) {
						$('#unTravail').fadeOut(400, function() {
							$('#unTravail').html(resultat);
						});
						$('#unTravail').fadeIn();
						$('#calendar').fullCalendar('gotoDate', startDate);
					}
				)
			},
			eventResize: function(event, delta, revertFunc) {
				var startDate = moment(event.start).format('YYYY-MM-DD HH:mm');
				var endDate = moment(event.end).format('YYYY-MM-DD HH:mm');
				// mémoriser la date, pour le retour
				$("#startDate").val(startDate);
				var id = event.id;
				$.post('inc/getDragDrop.inc.php', {
						id: id,
						startDate: startDate,
						endDate: endDate
					},
					function(resultat) {
						$("#unTravail").html(resultat);
						$('#calendar').fullCalendar('refetchEvents');
					}
				)
			},
			// on clique dans le calendrier (ajout d'événement)
			dayClick: function(date, event, view) {
				var editable = $('#editable').val();
				if (editable == 1) {
					var startDate = moment(date).format('YYYY-MM-DD HH:mm');
					if (view.type == 'agendaDay'){
						var heure = moment(date).format('HH:mm');
						var dateFr = moment(date).format('DD/MM/YYYY');
						// mémoriser la date pour le retour
						$("#startDate").val(startDate);
						// est-ce une notification par classe ou par cours?
						var type = ($("#selectClasse").val() == undefined) ? 'cours' : 'classe';
						if (type == 'cours')
							var destinataire = $('#coursGrp').val();
							else var destinataire = $('#selectClasse').val();
						var lblDestinataire = $("#lblDestinataire").val();
						$.post('inc/jdc/getAdd.inc.php', {
							startDate: startDate,
							heure: heure,
							type: type,
							destinataire: destinataire,
							lblDestinataire: lblDestinataire
							},
							function(resultat){
								$("#zoneMod").html(resultat);
									$("#modalAdd").modal('show');
									$('#calendar').fullCalendar('gotoDate', startDate);
							})
						}
					else {
						$('#calendar').fullCalendar('gotoDate', startDate);
						// forcer le mode "agendaDay" pour permettre la modification
						$('#calendar').fullCalendar('changeView', 'agendaDay');
					}
				}
				else bootbox.alert('Dans ce mode, seule la consultation est permise');
			},
			eventDrop: function(event, delta, revertFunc) {
				var startDate = moment(event.start).format('YYYY-MM-DD HH:mm');
				// mémoriser la date pour le retour
				$("#startDate").val(startDate);
				// si l'événement est draggé sur allDay, la date de fin est incorrecte
				if (moment.isMoment(event.end))
					var endDate = moment(event.end).format('YYYY-MM-DD HH:mm');
				else var endDate = '0000-00-00 00:00';
				var id = event.id;
				// var viewState = $("#viewState").val();
				$.post('inc/getDragDrop.inc.php', {
						id: id,
						startDate: startDate,
						endDate: endDate
					},
					function(resultat) {
						$("#unTravail").html(resultat);
						$('#calendar').fullCalendar('gotoDate', startDate);
						// forcer le mode "agendaDay" pour voir finement la modification
						$('#calendar').fullCalendar('changeView', 'agendaDay');
					}
				)
			}
		})

		// suppression d'une note au JDC
		$("#unTravail").on('click', '#delete', function() {
			var id = $(this).data('id');
			$.post('inc/jdc/getDel.inc.php', {
					id: id,
				},
				function(resultat) {
					$("#zoneDel").html(resultat);
					$("#modalDel").modal('show');
					$('#calendar').fullCalendar('gotoDate', startDate);
				}
			)
		})

		// modification d'une note au JDC
		$("#unTravail").on('click', '#modifier', function() {
			var id = $(this).data('id');
			var startDate = $("#startDate").val();
			var type = ($("#selectClasse").val() == undefined) ? 'cours' : 'classe';
			$.post('inc/jdc/getMod.inc.php', {
					id: id,
					startDate: startDate,
					type: type
				},
				function(resultat) {
					// construction de la boîte modale d'édition du JDC
					$("#zoneMod").html(resultat);
					// indispensable pour réactiver le CKEDITOR après un "dismiss" de la boîte modale
					CKEDITOR.replace('enonce');
					$("#modalMod").modal('show');
					// mise à jour du calendrier
					$('#calendar').fullCalendar('gotoDate', startDate);
					// $('#calendar').fullCalendar('refetchEvents');
				}
			)
		})

		$("#zoneMod").on('click', '#journee', function() {
			if ($(this).prop('checked') == true) {
				$("#duree").prop('disabled', true);
				$("#timepicker").prop('disabled', true);
				$("#listeDurees").addClass('disabled');
			} else {
				$("#duree").prop('disabled', false);
				$("#timepicker").prop('disabled', false);
				$("#listeDurees").removeClass('disabled');
			}
		})

		$("#zoneMod").on('change', '#destinataire', function() {
			var type = $(this).find(':selected').data('type');
			$("#type").val(type);
		})

		$("#zoneMod").on('change', '#categorie', function(){
	        if (($('#titre').val() == '') && ($('#categorie').val() != '')) {
	            var texte = $("#categorie option:selected" ).text();
	            $('#titre').val(texte);
	        }
	    })

		{if isset($startDate)}
			$('#calendar').fullCalendar('gotoDate', moment("{$startDate}"));
			// $('#calendar').fullCalendar('refetchEvents');
			// $('#calendar').fullCalendar('changeView', 'agendaMonth');
		{/if}

})
</script>

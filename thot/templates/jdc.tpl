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

			<div class="row">

				<div class="col-md-10 col-xs-10">
					<h2>
					{if $type == 'subjectif'}
						<span title="Vue subjective"><i class="fa fa-eye fa-lg"></i></span>
						{elseif $type == 'eleve'}
						<span title="Vue élève"><i class="fa fa-user fa-lg"></i></span>
						{elseif $type == 'classe'}
						<span title="Vue classe"><i class="fa fa-users fa-lg"></i></span>
						{elseif $type == 'cours'}
						<span title="Vue cours"><i class="fa fa-graduation-cap fa-lg"></i></span>
						{elseif $type == 'niveau'}
						<span title="Vue Niveau d'étude"><i class="fa fa-bars fa-lg"></i></span>
						{elseif $type == 'ecole'}
						<span title="Vue école"><i class="fa fa-university fa-lg"></i></span>
					{/if}
					{$lblDestinataire|default:''}
					</h2>
				</div>

				<div class="col-md-2 col-xs-2">
					{if $type == 'cours'}
						<button type="button" class="btn btn-lightBlue btn-block" style="margin-top:10px;" id="printJDC" title="Impression PDF du JDC"><i class="fa fa-print fa-lg"></i></button>
					{/if}
				</div>

			</div>

			<div id="calendar"></div>

		</div>

		<div class="col-md-5 col-xs-12" style="max-height:50em; overflow: auto">

			{if $editable == 0}
				<p class="notice">En vue subjective, vous voyez tous les événements dans le JDC d'un élève, quel que soit le propriétaire.<br>
				<strong>Aucune modification n'est possible</strong>.</p>
			{else}
				<p class="notice">Accédez à vos événements pour {$lblDestinataire}</p>
			{/if}

			<form action="index.php" method="POST" name="detailsJour" id="detailsJour" role="form" class="form-vertical ombre">

				<!-- champs destinés à être lus pour d'autres formulaires -->
				<input type="hidden" name="destinataire" id="destinataire" value="{$destinataire}">
				<input type="hidden" name="lblDestinataire" id="lblDestinataire" value="{$lblDestinataire|default:''}">
				<input type="hidden" name="type" id="type" value="{$type|default:''}">
				<input type="hidden" name="editable" id="editable" value="{$editable|default:false}">
				<input type="hidden" name="startDate" id="startDate" value="{$startDate|default:''}">
				<input type="hidden" name="viewState" id="viewState" value="">

				<div id="unTravail">
					{if isset($travail)}
						{include file='jdc/unTravail.tpl'}
					{else}
						<strong>Veuillez sélectionner un item dans le calendrier</strong>
						{if $editable == 1}
						<br><strong>ou cliquer dans une zone libre pour rédiger une nouvelle note.</strong>
						{/if}

						<div class="img-responsive"><img src="../images/logoPageVide.png" alt="Logo"></div>
					{/if}
				</div>
			</form>

		</div>
		<!-- col-md-... -->

	</div>
	<!-- row -->

	<div class="row">
		{* légende et couleurs *}
		<div class="btn-group" id="legend">
			{foreach from=$categories key=cat item=travail}
			<button type="btn btn-default" class="cat_{$cat} voir" data-categorie="{$cat}" title="{$travail.categorie}">{$travail.categorie|truncate:12}</button>
			{/foreach}
		</div>

	</div>
	<!-- row -->

	<div id="zoneMod">
	</div>
	<div id="zoneDel">
	</div>

</div>
<!-- container -->

{include file="jdc/modal/modalPrint.tpl"}

{include file="jdc/modal/modalDislikes.tpl"}


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

		$('#printJDC').click(function(){
			var coursGrp = $('#coursGrp').val();
			$.post('inc/jdc/listeCoursProfs.inc.php', {
				coursGrp: coursGrp
			}, function(resultat){
				$('#listeCours').html(resultat);
			})
			$('#modalPrintJDC').modal('show');
		})

		$('#printForm').validate({
			rules: {
				from: {
					required: true
				},
				to: {
					required: true
				}
			}
		})

		$('#btnModalPrintJDC').click(function(){
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

		$('.datepicker').datepicker({
            format: "dd/mm/yyyy",
            clearBtn: true,
            language: "fr",
            calendarWeeks: true,
            autoclose: true,
            todayHighlight: true
            });

		var editable = $('#editable').val();

		$('#unTravail').on('click', '#infoLikes', function(){
			var id = $(this).data('id');
			$.post('inc/jdc/getDislikes.inc.php', {
				id: id
			}, function(resultat){
				$('#modalDislikes .modal-body').html(resultat);
				$('#modalDislikes').modal('show');
			})
		})

		$('#unTravail').on('click', '#approprier', function(){
			var id = $(this).data('id');
			$.post('inc/jdc/setProprioJdc.inc.php', {
				id: id
			}, function (resultat){
				if (resultat == 1) {
					$.post('inc/jdc/getTravail.inc.php', {
						id: id,
						editable: editable
						},
						function(resultat) {
							$('#unTravail').html(resultat);
						}
					)
				}
			})
		})

		$('#calendar').fullCalendar({
			eventSources: [
				{
				url: 'inc/events.json.php',
				type: 'POST',
				data: {
					type: $('#type').val(),
					coursGrp: $('#coursGrp').val(),
					classe: $('#selectClasse').val(),
					matricule: $('#selectEleve').val(),
					niveau: $('#niveau').val(),
					},
				error: function() {
					alert('Une erreur s\'est produite. Merci de la signaler à l\'administrateur.');
					}
				}
			],
			eventLimit: 2,
			// empêcher l'édition en vue subjective
			eventStartEditable: editable,
			eventDurationEditable: editable,
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
			eventClick: function (calEvent, jsEvent, view) {
				var id = calEvent.id; // l'id de l'événement
				var startDate = moment(calEvent.start).format('YYYY-MM-DD HH:mm'); // la date de début de l'événement
				// mémoriser la date pour le retour
				$("#startDate").val(startDate);
				$.post('inc/jdc/getTravail.inc.php', {
					id: id,
					editable: editable
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
				var editable = $('#editable').val();
				// mémoriser la date, pour le retour
				$("#startDate").val(startDate);
				var id = event.id;
				$.post('inc/jdc/getDragDrop.inc.php', {
						id: id,
						startDate: startDate,
						endDate: endDate,
						editable: editable,
						allDay: false
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
						// type de la notification: élève, cours, classe, niveau, école?
						var type = $('#type').val();
						switch (type) {
							case 'cours':
								var destinataire = $('#coursGrp').val();
								break;
							case 'classe':
								var destinataire = $('#selectClasse').val();
								break;
							case 'eleve':
								var destinataire = $('#selectEleve').val();
								break;
							case 'niveau':
								var destinataire = $('#niveau').val();
								break;
							case 'ecole':
								var destinataire = 'all';
								break;
						}
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
									$("#modalEdit").modal('show');
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
				var editable = $('#editable').val();
				if (editable == 1){
					var startDate = moment(event.start).format('YYYY-MM-DD HH:mm');
					// mémoriser la date pour le retour
					$("#startDate").val(startDate);
					// si l'événement est draggé sur allDay, la date de fin est incorrecte
					if (event.allDay == true) {
						var endDate = startDate;
						}
						else var endDate = moment(event.end).format('YYYY-MM-DD HH:mm');
					var id = event.id;
					$.post('inc/jdc/getDragDrop.inc.php', {
							id: id,
							startDate: startDate,
							endDate: endDate,
							editable: editable,
							allDay: event.allDay
						},
						function(resultat) {
							$("#unTravail").html(resultat);
							$('#calendar').fullCalendar('gotoDate', startDate);
							// forcer le mode "agendaDay" pour voir finement la modification
							$('#calendar').fullCalendar('changeView', 'agendaDay');
						}
					)
				}
				else bootbox.alert('Dans ce mode, seule la consultation est permise');
			}
		})

		// suppression d'une note au JDC
		$("#unTravail").on('click', '#delete', function() {
			var id = $(this).data('id');
			$.post('inc/jdc/getModalDel.inc.php', {
					id: id,
				},
				function(resultat) {
					$("#zoneDel").html(resultat);
					$("#modalDel").modal('show');
				}
			)
		})

		// modification d'une note au JDC
		$("#unTravail").on('click', '#modifier', function() {
			var id = $(this).data('id');
			var destinataire = $(this).data('destinataire');
			var startDate = $("#startDate").val();
			var type = $('#type').val();
			var lblDestinataire = $("#lblDestinataire").val();
			$.post('inc/jdc/getMod.inc.php', {
					id: id,
					startDate: startDate,
					type: type,
					destinataire: destinataire,
				},
				function(resultat) {
					// construction de la boîte modale d'édition du JDC
					$("#zoneMod").html(resultat);
					$("#modalEdit").modal('show');
					// mise à jour du calendrier
					$('#calendar').fullCalendar('gotoDate', startDate);
					// $('#calendar').fullCalendar('refetchEvents');
				}
			)
		})

		$("#zoneMod").on('click', '#journee', function() {
			if ($(this).prop('checked') == true) {
				$("#duree").prop('disabled', true);
				$('#heure').prop('disabled', true).val('');
				$("#timepicker").prop('disabled', true);
				$("#listeDurees").addClass('disabled');
			} else {
				$("#duree").prop('disabled', false);
				$('#heure').prop('disabled', false);
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

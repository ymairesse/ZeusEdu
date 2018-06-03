<div class="container-fluid">

	<div class="row">

		<div class="col-md-10 col-xs-10">
			<h2>
			{if $type == 'subjectif'}
				<span title="Vue subjective"><i class="fa fa-eye fa-lg"></i></span>
				{elseif $type == 'eleve'}
				<span title="Vue élève"><i class="fa fa-user fa-lg"></i></span>
				{elseif $type == 'classe'}
				<span title="Vue classe"><i class="fa fa-user-plus fa-lg"></i></span>
				{elseif $type == 'cours'}
				<span title="Vue cours"><i class="fa fa-graduation-cap fa-lg"></i></span>
				{elseif $type == 'niveau'}
				<span title="Vue Niveau d'étude"><i class="fa fa-users fa-lg"></i></span>
				{elseif $type == 'ecole'}
				<span title="Vue école"><i class="fa fa-university fa-lg"></i></span>
			{/if}
			<span id="cible">{$lblDestinataire|default:''}</span>
			</h2>
		</div>

		<div class="col-md-2 col-xs-2">
			{if $type == 'cours'}
				<button type="button" class="btn btn-lightBlue btn-block" style="margin-top:10px;" id="printJDC" title="Impression PDF du JDC"><i class="fa fa-print fa-lg"></i></button>
			{/if}
		</div>

		<div class="col-md-9 col-sm-12">
			<p class="jdcInfo {$mode} demiOmbre">{$jdcInfo|default:''}</p>
			<input type="hidden" name="unlocked" id="unlocked" value="false">
			<div id="calendar"
				class="{$mode} demiOmbre"
				data-type="{$type|default:''}"
				data-lbldestinataire="{$lblDestinataire|default:''}"
				data-coursgrp="{$coursGrp|default:''}"
				data-editable="{$editable|default:false}"
				data-startdate="{$startDate|default:''}"
				data-viewstate="">
			</div>

		</div>

		<div class="col-md-3 col-sm-12" style="max-height:50em; overflow: auto">

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

		<div class="col-xs-12">
			{* légende et couleurs *}
			<div class="btn-group" id="legend">
				{foreach from=$categories key=cat item=travail}
				<button type="button" class="btn btn-default cat_{$cat} voir" data-categorie="{$cat}" title="{$travail.categorie}">{$travail.categorie|truncate:12}</button>
				{/foreach}
			</div>
		</div>

	</div>
	<!-- row -->

</div>

<div id="zoneEdit"></div>
<div id="zoneDel"></div>
<div id="zoneClone"></div>

<style media="screen">
    .popover {
        width: 100%;
    }
</style>

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
            todayHighlight: true,
			daysOfWeekDisabled: [0,6],
            });

		var editable = $('#calendar').data('editable');

		$('#unTravail').on('click', '#btn-clone', function() {
		    var idTravail = $(this).data('id');
			var pastIsOpen = $('#unlocked').val();
            $.post('inc/jdc/editCible.inc.php', {
                idTravail: idTravail,
				pastIsOpen: pastIsOpen
            }, function(resultat) {
                $('#zoneClone').html(resultat);
                $('#modalEditCible').modal('show');
            	})
			})

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

		function lockUnlock(){
            var lockState = $('#unlocked').val();
            if (lockState == "true") {
                $('#unlocked').val('false');
                $('.fc-unLockButton-button').html('<i class="fa fa-lock fa-2x"></i>')
                }
                else {
                    $('#unlocked').val('true');
                    $('.fc-unLockButton-button').html('<i class="fa fa-unlock fa-2x"></i>')
                }
        }

		$('#calendar').fullCalendar({
			weekends: false,
			defaultView: 'month',
			eventLimit: 3,
			height: 600,
			timeFormat: 'HH:mm',
			customButtons: {
                unLockButton: {
                  text: 'unlock',
                  click: function(){
                      lockUnlock();
                  }
                }
              },
			header: {
				left: 'prev, today, next, unLockButton',
				center: 'title',
				right: 'month,agendaWeek,agendaDay,listMonth,listWeek'
			},
			buttonText: {
				listMonth: 'Liste Mois',
				listWeek: 'Liste Semaine'
			},
			businessHours: {
				start: '08:15',
				end: '19:00',
				dow: [1, 2, 3, 4, 5]
				},
			minTime: "08:00:00",
			maxTime: "22:00:00",
			weekNumbers: true,
			navLinks: true,
			// empêcher l'édition en vue subjective
			eventStartEditable: editable,
			eventDurationEditable: editable,
			defaultTimedEventDuration: '00:50',
			firstDay: 1,
			eventSources: [
				{
				url: 'inc/jdc/events.json.php',
				type: 'POST',
				data: {
					type: $('#calendar').data('type'),
					coursGrp: $('#calendar').data('coursgrp'),
					classe: $('#selectClasse').val(),
					matricule: $('#selectEleve').val(),
					niveau: $('#niveau').val(),
					},
				error: function() {
					alert('Attention, vous semblez avoir perdu la connexion à l\'Internet');
					}
				}
			],
			eventRender: function(event, element, view) {
				element.popover({
					title: event.destinataire,
					content: event.enonce,
					template: popTemplate,
					html: true,
					trigger: 'hover',
					animation: true,
					delay: 500,
					placement: "top",
					container: "#calendar"
				});
				element.attr('data-type', event.type);
			},
			viewRender: function(view, element) {
				$('.popover').hide();
			},
			// on clique sur un événement
			eventClick: function (calEvent, jsEvent, view) {
				var debut = moment(calEvent.start);
                var today = moment().format('YYYY-MM-DD');
				var unlockedPast = $('#unlocked').val();
				var locked = (debut.isBefore(today) && (unlockedPast == "false")) ;
				popoverElement = $(jsEvent.currentTarget);
				var id = calEvent.id; // l'id de l'événement
				$.post('inc/jdc/getTravail.inc.php', {
					id: id,
					editable: editable,
					locked: locked
					},
					function(resultat) {
						$('#unTravail').fadeOut(400, function() {
							$('#unTravail').html(resultat).fadeIn();
						});
					}
				)
			},
			// on clique dans le calendrier (ajout d'événement)
			dayClick: function(calEvent, jsEvent, view) {
				var debut = moment(calEvent);
                var today = moment().format('YYYY-MM-DD');
				var unlockedPast = $('#unlocked').val();
                if (debut.isBefore(today) && (unlockedPast == "false")) {
                    bootbox.alert({
                        title: 'Erreur',
                        message: datePassee
                    })
                } else {
				var editable = $('#calendar').data('editable');
				if (editable == 1) {
					if (view.type == 'agendaDay'){
						var heure = moment(calEvent).format('HH:mm');
						var date = moment(calEvent).format('MM/DD/YYYY');
						var type = $('#calendar').data('type');
						switch (type) {
							case 'cours':
								var cible = $('#coursGrp').val();
								break;
							case 'classe':
								var cible = $('#selectClasse').val();
								break;
							case 'eleve':
								var cible = $('#selectEleve').val();
								break;
							case 'niveau':
								var cible = $('#niveau').val();
								break;
							case 'ecole':
								var cible = 'all';
								break;
						}
						var lblDestinataire = $("#calendar").data('lbldestinataire');
						$.post('inc/jdc/getAdd.inc.php', {
							date: date,
							heure: heure,
							type: type,
							cible: cible,
							lblDestinataire: lblDestinataire
							},
							function(resultat){
								$("#zoneEdit").html(resultat);
								$("#modalEdit").modal('show');
							})
						}
					else {
						$('#calendar').fullCalendar('gotoDate', debut);
						// forcer le mode "agendaDay" pour permettre la modification
						$('#calendar').fullCalendar('changeView', 'agendaDay');
					}
				}
				else bootbox.alert('Dans ce mode, seule la consultation est permise');
				}
			},
			eventResize: function(calEvent, delta, revertFunc) {
				$('.popover').hide();
				var startDate = moment(calEvent.start).format('YYYY-MM-DD HH:mm');
				var endDate = moment(calEvent.end).format('YYYY-MM-DD HH:mm');
				var id = calEvent.id;
				var editable = $('#calendar').data('editable');
				$.post('inc/jdc/getDragDrop.inc.php', {
						id: id,
						startDate: startDate,
						endDate: endDate,
						editable: editable,
						allDay: false
					},
					function(resultat) {
						$("#unTravail").html(resultat);
					}
				)
			},
			eventDrop: function(calEvent, delta, revertFunc, jsEvent, ui, view) {
				var debut = moment(calEvent.start);
				var today = moment().format('YYYY-MM-DD');
				var unlockedPast = $('#unlocked').val();
				$('.popover').hide();
				var editable = $('#calendar').data('editable');
				if (debut.isBefore(today) && (unlockedPast == "false")) {
					bootbox.alert({
						title: 'Erreur',
						message: datePassee
					});
					$('#calendar').fullCalendar('refetchEvents');
				}
				else {
				if (editable == 1){
					var startDate = moment(calEvent.start).format('YYYY-MM-DD HH:mm');
					// si l'événement est draggé sur allDay, la date de fin est incorrecte
					if (calEvent.allDay == true) {
						var endDate = startDate;
						}
						else var endDate = moment(calEvent.end).format('YYYY-MM-DD HH:mm');
					var id = calEvent.id;
					$.post('inc/jdc/getDragDrop.inc.php', {
							id: id,
							startDate: startDate,
							endDate: endDate,
							editable: editable,
							allDay: calEvent.allDay
						},
						function(resultat) {
							$("#unTravail").html(resultat);
							$(".popover").remove();
						}
					)
				}
				else bootbox.alert('Dans ce mode, seule la consultation est permise');
			}
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
			var lblDestinataire = $("#calendar").data('lbldestinataire');
			$.post('inc/jdc/getMod.inc.php', {
					id: id,
					startDate: startDate,
					type: type,
					destinataire: destinataire,
				},
				function(resultat) {
					// construction de la boîte modale d'édition du JDC
					$("#zoneEdit").html(resultat);
					$("#modalEdit").modal('show');
				}
			)
		})

		$("#zoneEdit").on('click', '#journee', function() {
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

        $('.fc-unLockButton-button').html('<i class="fa fa-lock fa-2x"></i>').addClass('btn btn-primary').prop('title', '(Dé)-verrouiller les dates passées');

		var datePassee = 'Veuillez déverrouiller les dates passées pour modifier un item à cette date';

		// http://jsfiddle.net/slyvain/6vmjt9rb/
        var popTemplate = [
            '<div class="popover" style="max-width:600px;" >',
            '<div class="arrow down"></div>',
            '<div class="popover-header">',
            '<button id="closepopover" type="button" class="close" aria-hidden="true">&times;</button>',
            '<h3 class="popover-title"></h3>',
            '</div>',
            '<div class="popover-content"></div>',
            '</div>'].join('');

        var popoverElement;

        function closePopovers() {
            $('.popover').not(this).popover('hide');
        }

        $('body').on('click', function (e) {
            // close the popover if: click outside of the popover || click on the close button of the popover
            if (popoverElement && ((!popoverElement.is(e.target) && popoverElement.has(e.target).length === 0 && $('.popover').has(e.target).length === 0) || (popoverElement.has(e.target) && e.target.id === 'closepopover'))) {
                ///$('.popover').popover('hide'); --> works
                closePopovers();
            }
        });

		{if $mode == 'subjectif'}
			$('.fc-unLockButton-button').prop('disabled', true);
		{/if}

		{if isset($startDate)}
			$('#calendar').fullCalendar('gotoDate', moment("{$startDate}"));
		{/if}

})
</script>

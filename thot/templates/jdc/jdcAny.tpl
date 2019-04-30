<div class="container-fluid">

	<div class="row">

		<div class="col-md-9 col-sm-12" id="calendrier">

			<p class="jdcInfo {$mode} demiOmbre">Voir tous les événements de <strong>{$lblDestinataire}</strong> et écrire dans ce JDC</p>
			<input type="hidden" name="unlocked" id="unlocked" value="false">

			<div id="calendar"
				class="{$mode} demiOmbre"
				data-type="{$type|default:'ecole'}"
				data-lbldestinataire="{$lblDestinataire|default:''}"
				data-cible="{$destinataire}"
				data-coursgrp="{$coursGrp|default:''}"
				data-niveau="{$niveau|default:''}"
				data-classe="{$classe|default:''}"
				data-matricule="{$matricule|default:''}"
				data-editable="{$editable|default:false}"
				data-viewstate="">
			</div>

		</div>

		<div class="col-md-3 col-sm-12" style="max-height:50em; overflow: auto" id="editeur">

			<div id="unTravail">
				{if isset($travail)}
					{include file='jdc/jdcEdit.tpl'}
				{else}
					<strong>Veuillez sélectionner un item dans le calendrier</strong>
					{if $editable == 1}
					<br><strong>ou cliquer dans une zone libre pour rédiger une nouvelle note.</strong>
					{/if}

					<div class="img-responsive"><img src="../images/logoPageVide.png" alt="Logo"></div>
				{/if}
			</div>

		</div>
		<!-- col-md-... -->

		<div class="col-xs-12">
			{* légende et couleurs *}
			<div class="btn-group" id="legend">
				{foreach from=$categories key=cat item=travail}
				<button type="button" class="btn btn-default cat_{$cat} voir" data-categorie="{$cat}" title="{$travail.categorie}">{$travail.categorie}</button>
				{/foreach}
			</div>
		</div>

	</div>
	<!-- row -->

</div>

<div id="zoneDel"></div>
<div id="zoneClone"></div>

<style media="screen">
    .popover {
        width: 100%;
    }
</style>

{include file="jdc/modal/modalPrint.tpl"}

<script type="text/javascript">

	function dateFromFr(uneDate) {
		var laDate = uneDate.split('/');
		return laDate[2] + '-' + laDate[1] + '-' + laDate[0];
	}

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

		$(document).ajaxStart(function() {
			$('body').addClass('wait');
		}).ajaxComplete(function() {
			$('body').removeClass('wait');
		});

		$('#editeur').on('click', '#saveJDC', function(){
	        if ($('#editJdc').valid()) {
	            var formulaire = $('#editJdc').serialize();
	            // récupérer le contenu du CKEDITOR
	            var enonce = CKEDITOR.instances.enonce.getData();
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
                    $.post('inc/jdc/getJdcEdit.inc.php', {
                        id: idJdc,
                        editable: true
                        }, function(resultat){
                            $('#unTravail').html(resultat);
                        })
                    $('#calendar').fullCalendar('refetchEvents');
	            });
				modeConsultation();
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

		function lockUnlock(){
            var lockState = $('#unlocked').val();
            if (lockState == "true") {
                $('#unlocked').val('false');
                $('.fc-unLockButton-button').html('<i class="fa fa-lock fa-2x"></i>');
				$('#unTravail .btn-edit').prop('disabled', true);
                }
                else {
                    $('#unlocked').val('true');
					$('#unTravail .btn-edit').prop('disabled', false);
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
				url: 'inc/jdc/myGlobalEvents.json.php',
				type: 'POST',
				data: {
					type: $('#calendar').data('type'),
					destinataire: $('#calendar').data('cible'),
					coursGrp: $('#calendar').data('coursgrp'),
					niveau: $('#calendar').data('niveau'),
					classe: $('#calendar').data('classe'),
					matricule: $('#calendar').data('matricule'),
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
							modeConsultation();
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
						var date = moment(calEvent).format('DD/MM/YYYY');
						var type = $('#calendar').data('type');
						var cible = $('#calendar').data('cible');

						var lblDestinataire = $("#calendar").data('lbldestinataire');
						$.post('inc/jdc/getAdd.inc.php', {
							date: date,
							heure: heure,
							type: type,
							cible: cible,
							lblDestinataire: lblDestinataire
							},
							function(resultat){
								modeEdition();
								$('#unTravail').html(resultat);
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
			$.post('inc/jdc/getMod.inc.php', {
					id: id
				},
				function(resultat) {
					modeEdition();
					$('#unTravail').html(resultat);
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

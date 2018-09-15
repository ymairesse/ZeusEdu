<p class="jdcInfo {$mode} demiOmbre">{$jdcInfo|default:''}</p>
<input type="hidden" name="unlocked" id="unlocked" value="false">
<div id="calendar"
    class="{$mode} demiOmbre"
    data-type="{$type|default:'ecole'}"
    data-lbldestinataire="{$lblDestinataire|default:''}"
    data-coursgrp="{$coursGrp|default:''}"
    data-niveau="{$niveau|default:''}"
    data-classe="{$classe|default:''}"
    data-matricule="{$matricule|default:''}"
    data-editable="{$editable|default:false}"
    data-viewstate="">
</div>

<script type="text/javascript">

    $('document').ready(function(){

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
						var date = moment(calEvent).format('MM/DD/YYYY');
						var type = $('#calendar').data('type');
						var cible = $('#coursGrp').val();
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
    })

</script>

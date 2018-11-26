<div class="container-fluid">

    <div class="row">

        <div class="col-md-9" id="calendrier">

            <h2>Agenda général</h2>

            <div id="calendar"
                data-editable="true"
                data-tous=""
                data-coursGrp=""
                data-classe=""
                data-niveau=""
                data-section=""
                data-matricule="">

            </div>
        </div>

        <div class="col-md-3" id="editeur">

            <div class="panel">
                <div class="panel-heading">
                    Détails de l'événement
                </div>
                <div class="panel-body" id="unTravail">
                    Test
                </div>

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

    $(document).ready(function(){

        var editable = 1;

        $('#calendar').fullCalendar({
			weekends: true,
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
			// empêcher l'édition
			eventStartEditable: editable,
			eventDurationEditable: editable,
			defaultTimedEventDuration: '00:50',
			firstDay: 1,
			eventSources: [
				{
				url: 'inc/diary/myGlobalDiary.json.php',
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
						var date = moment(calEvent).format('MM/DD/YYYY');
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

    })

</script>

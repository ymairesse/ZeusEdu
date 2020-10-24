<h2>
    <span id="cible">{$lblDestinataire}</span>
</h2>

<div id="calendrier">

    <p class="jdcInfo {$mode} demiOmbre">{$jdcInfo}</p>
    <input type="hidden" name="unlocked" id="unlocked" value="false">
    <input type="hidden" name="mode" id="mode" value="{$mode}">

    <div id="calendar"
        class="{$mode} demiOmbre"
        data-type="{$type|default:''}"
        data-destinataire="{$destinataire}"
        data-lbldestinataire="{$lblDestinataire|default:''}"
        data-editable="{$editable|default:false}"
        data-viewstate="agendaWeek">
    </div>

</div>

<div class="btn-group" id="legend">
    {foreach from=$categories key=cat item=travail}
        <button type="button" class="btn btn-default cat_{$cat} voir" data-categorie="{$cat}" title="{$travail.categorie}">{$travail.categorie}</button>
    {/foreach}
</div>

<div id="zoneDel"></div>
<div id="zoneClone"></div>

<style media="screen">
    .popover {
        width: 100%;
    }
</style>

<script type="text/javascript">

    var readonly = 'Dans ce mode, seule la consultation est possible';
    var error = 'Erreur';

    var fcView = Cookies.get('fc-view');

    var views = ['month', 'agendaWeek', 'agendaDay', 'listMonth', 'listWeek'];
    if (!(views.includes(fcView)))
        fcView = 'month';

    $(document).ready(function(){

        var editable = $('#calendar').data('editable');

        // cookie sur le type de vue retenu pour le JDC
        $('#calendar').on('click', '.fc-button', function(){
            if ($(this).hasClass('fc-month-button')) {
                Cookies.set('fc-view', 'month', { expires: 7, path: 'thot/' });
                }
                else if ($(this).hasClass('fc-agendaWeek-button')) {
                    Cookies.set('fc-view', 'agendaWeek', { expires: 7, path: 'thot/' });
                }
                else if ($(this).hasClass('fc-agendaDay-button')) {
                    Cookies.set('fc-view', 'agendaDay', { expires: 7, path: 'thot/' });
                }
                else if ($(this).hasClass('fc-listMonth-button')) {
                    Cookies.set('fc-view', 'listMonth', { expires: 7, path: 'thot/' });
                }
                else if ($(this).hasClass('fc-listWeek-button')) {
                    Cookies.set('fc-view', 'listWeek', { expires: 7, path: 'thot/' });
                }
        })

        $('#calendar').fullCalendar({
			weekends: false,
			defaultView: fcView,
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
			// empêcher/autoriser l'édition
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
					coursGrp: $('#calendar').data('destinataire'),
					},
				error: function() {
					alert('Attention, vous semblez avoir perdu la connexion à l\'Internet');
					}
				}
			],
			eventRender: function(event, element, view) {
				element.find('.fc-title').html('<div>'+event.destinataire+'</div>');
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
                var editable = 1;
				popoverElement = $(jsEvent.currentTarget);
				var id = calEvent.id; // l'id de l'événement

				$.post('inc/jdc/getTravail.inc.php', {
					id: id,
					editable: editable,
					locked: locked
					},
					function(resultat) {
						$('#panneauEditeur').fadeOut(400, function() {
                            $('#panneauEditeur').html(resultat).fadeIn();
						});
					}
				)
			},
			// on clique dans le calendrier (ajout d'événement)
			dayClick: function(calEvent, jsEvent, view) {
				var view = $('#calendar').fullCalendar('getView');
				var debut = moment(calEvent);
                var today = moment().format('YYYY-MM-DD');
				var unlockedPast = $('#unlocked').val();

                if (debut.isBefore(today) && (unlockedPast == "false")) {
                    bootbox.alert({
                        title: error,
                        message: datePassee,
                        size: 'small'
                    })
                } else {

                var editable = $('#calendar').data('editable');
                var type = $('#calendar').data('type');

				if ((editable == 1) && (type != 'synoptique')) {
					if (view.type == 'agendaDay'){
						var heure = moment(calEvent).format('HH:mm');
						var date = moment(calEvent).format('DD/MM/YYYY');
						var cible = $('#coursGrp').val();
                        var destinataire = $('#calendar').data('destinataire');

						var lblDestinataire = $("#calendar").data('lbldestinataire');
						$.post('inc/jdc/getAdd.inc.php', {
							date: date,
							heure: heure,
							type: type,
							cible: cible,
                            destinataire: destinataire,
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
				else bootbox.alert({
                    title: error,
                    message: readonly,
                    size: 'small'
                })
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
						title: error,
						message: datePassee,
                        size: 'small'
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
				else bootbox.alert({
                    title: error,
                    message: readonly,
                    size: 'small'
                });
			}
		}
		})

        // $("#zoneEdit").on('click', '#journee', function() {
		// 	if ($(this).prop('checked') == true) {
		// 		$("#duree").prop('disabled', true);
		// 		$('#heure').prop('disabled', true).val('');
		// 		$("#timepicker").prop('disabled', true);
		// 		$("#listeDurees").addClass('disabled');
		// 	} else {
		// 		$("#duree").prop('disabled', false);
		// 		$('#heure').prop('disabled', false);
		// 		$("#timepicker").prop('disabled', false);
		// 		$("#listeDurees").removeClass('disabled');
		// 	}
		// })
        //
        $('.fc-unLockButton-button').html('<i class="fa fa-lock fa-2x"></i>').addClass('btn btn-primary').prop('title', '(Dé)-verrouiller les dates passées');

		var datePassee = 'Veuillez déverrouiller les dates passées pour modifier un item à cette date';

		// http://jsfiddle.net/slyvain/6vmjt9rb/
        var popTemplate = [
            '<div class="popover" style="max-width:600px;" >',
            '<div class="popover-header">',
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

        {if isset($travail.startDate)}
			$('#calendar').fullCalendar('gotoDate', moment("{$travail.startDate}"));
		{/if}


    })

</script>

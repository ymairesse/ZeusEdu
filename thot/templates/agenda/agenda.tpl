<div class="container-fluid">

    <div class="row">

        <div class="col-md-3 col-xs-12" id="editeur">

                <div id="unTravail">

                    {include file="agenda/include/mesAgendas.tpl"}

                </div>

        </div>

        <div class="col-md-9 col-xs-12 ombre" id="calendrier">

            <h2>{$listeAgendas.$idAgenda.nomAgenda}</h2>
            <input type="hidden" name="unlocked" id="unlocked" value="false">

            <div id="calendar" data-editable="true" data-idagenda="{$idAgenda}">

            </div>

        </div>

    </div>

</div>

<div id="divModal">
</div>


<script type="text/javascript">

    // http://jsfiddle.net/slyvain/6vmjt9rb/
    var popTemplate = [
        '<div class="popover" style="max-width:600px; min-width:300px;" >',
        '<div class="arrow down"></div>',
        '<div class="popover-header">',
        '<h3 class="popover-title"></h3>',
        '</div>',
        '<div class="popover-content"></div>',
        '</div>'].join('');


    var datePassee = 'Veuillez déverrouiller les dates passées pour modifier un item à cette date';
    var noRedac = 'Vous n\'êtes pas rédacteur de cette note';

    var popoverElement;

    function closePopovers() {
        $('.popover').not(this).popover('hide');
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

    $(document).ready(function(){

        $('#unTravail').on('change', '#allDay', function(){
            if ($(this).is(':checked')) {
                $('#startTime').val('00:00').attr('disabled', true);
                $('#endTime').val('00:00').attr('disabled', true);
            }
            else {
                var keep = $('#startTime').data('keep').substr(0,5);
                $('#startTime').val(keep).attr('disabled', false);
                var keep = $('#endTime').data('keep').substr(0,5);
                $('#endTime').val(keep).attr('disabled', false);
            }
        })

        $('#unTravail').on('change', '.datepicker', function(){
            var date = $(this).val();
            $(this).data('keep', date);
        })

        $('#unTravail').on('change', '.timepicker', function(){
            var time = $(this).val();
            $(this).data('keep', time);
        })

        $('#unTravail').on('change', '#selectCategorie', function(){
            var classe = $('#selectCategorie option:selected').data('classe');
            var titre = $('#selectCategorie option:selected').text();
            $('#unTravail .panel-title').removeClass().addClass(classe).addClass('panel-title');
        })

        $('#unTravail').on('click', '#btn-delete', function(){
            var idPost = $(this).data('idpost');
            var idAgenda = $('#calendar').data('idagenda');
            bootbox.confirm({
                title: 'Confirmation',
                message: 'Veuillez confirmer la suppression définitive de cette note',
                callback: function(result){
                    if (result == true) {
                        $.post('inc/agenda/deletePost.inc.php', {
                            idPost: idPost,
                            idAgenda: idAgenda
                        }, function(resultat){
                            // récupérer le contenu de la zone "travail" à gauche
                            $('#unTravail').html(resultat);
                            $('#calendar').fullCalendar('refetchEvents');
                         });
                    }
                    modeConsultation();
                 }
            })
        })

        $('#unTravail').on('click', '#btn-retour', function(){
            var idAgenda = $(this).data('idagenda');
            $.post('inc/agenda/listeMesAgendas.inc.php', {
                idAgenda: idAgenda
            }, function(resultat){
                $('#unTravail').html(resultat);
                modeConsultation();
            });
        })

        $('#unTravail').on('click', '#saveEdit', function(){
            if ($('#formEditAgenda').valid()) {
               var formulaire = $('#formEditAgenda').serialize();
               $.post('inc/agenda/saveAgenda.inc.php', {
                   formulaire: formulaire
               }, function(resultat) {
                   var resultJSON = JSON.parse(resultat);
                   var idAgenda = resultJSON.idAgenda;
                    bootbox.alert({
                        message: resultJSON.texte,
                        size: 'small'
                    });
                    // récupérer le contenu de la zone "travail" à gauche
                    var idAgenda = $('#calendar').data('idagenda')
                    $.post('inc/agenda/listeMesAgendas.inc.php', {
                        idAgenda: idAgenda
                    }, function(resultat){
                        $('#unTravail').html(resultat);
                    })
                    // $.post('inc/agenda/getTravail.inc.php', {
                    //     id: idAgenda,
                    //     editable: true
                    //     }, function(resultat){
                    //         $('#unTravail').html(resultat);
                    //     })
                    $('#calendar').fullCalendar('refetchEvents');
               });
               modeConsultation();
           }
        })

        $('#unTravail').on('change', '#selectAgendas', function(){
            var idAgenda = $('#selectAgendas').val();
            if (idAgenda != '') {
                var events = {
                    url: 'inc/agenda/myGlobalDiary.json.php',
    				type: 'POST',
    				data: {
    					idAgenda: idAgenda
    					}
                };
                $('#calendar').data('idagenda', idAgenda);
                $('#calendar').fullCalendar('removeEventSources');
                $('#calendar').fullCalendar('addEventSource', events);
                $('#boutonsAgenda').find('button').prop('disabled', false);
            }
            else {
                $('#boutonsAgenda').find('button').prop('disabled', true);
            }
        })

        $('#unTravail').on('change', '#sharedAgenda', function(){
            var idAgenda = $(this).val();
            if (idAgenda != '') {
                var events = {
                    url: 'inc/agenda/sharedDiary.json.php',
    				type: 'POST',
    				data: {
    					idAgenda: idAgenda
    					}
                };
                $('#calendar').data('idagenda', idAgenda);
                $('#calendar').fullCalendar('removeEventSources');
                $('#calendar').fullCalendar('addEventSource', events);
            }
        })

        $('#editeur').on('click', '#btn-shareAgenda', function(){
            var idAgenda = $('#selectAgendas').val();
            $.post('inc/agenda/shareAgenda.inc.php', {
                idAgenda: idAgenda,
                nomAgenda: $('#selectAgendas option:selected').text()
            }, function(resultat){
                $('#divModal').html(resultat);
                $('#modalShareAgenda').modal('show');
            })
        })

        $('#editeur').on('click', '#btn-modifAgenda', function(){
            var idAgenda = $('#selectAgendas').val();
            $.post('inc/agenda/modalNewAgenda.inc.php', {
                idAgenda: idAgenda,
                nomAgenda: $('#selectAgendas option:selected').text()
            }, function(resultat){
                $('#divModal').html(resultat);
                $('#modalNewAgenda').modal('show');
            })
        })

        $('#editeur').on('click', '#btn-newAgenda', function(){
            $.post('inc/agenda/modalNewAgenda.inc.php', {
                idAgenda: void(0),
                nomAgenda: void(0)
            }, function(resultat){
                $('#divModal').html(resultat);
                $('#modalNewAgenda').modal('show');
            })
        })

        $('#editeur').on('click', '#btn-delAgenda', function(){
            var idAgenda = $('#selectAgendas').val();
            var nom = $('#selectAgendas option:selected').text();
            bootbox.confirm({
                title: 'Confirmation',
                message: 'Veuillez confirmer la suppression définitive de l\'agenda <strong>' + nom + '</strong><br>et de tout son contenu.',
                callback: function(result){
                    if (result == true) {
                        $.post('inc/agenda/delAgenda.inc.php', {
                            idAgenda: idAgenda
                        }, function(resultat){
                            // bootbox.alert('Agenda supprimé');
                            $.post('inc/agenda/listeMesAgendas.inc.php', {
                                idAgenda: idAgenda
                            }, function(resultat){
                                $('#unTravail').html(resultat);
                            });
                            $('#calendar').data('idagenda') = Null;
                            $('#calendar').fullCalendar('refetchEvents');
                        });
                    }
                }
            });
        })

        $('#divModal').on('click', '#btn-saveNewName', function(){
            if ($('#modalNewForm').valid()) {
                var nomAgenda = $('#nomAgenda').val();
                var idAgenda = $('#idAgenda').val();
                var creation = (idAgenda == '');

                if (nomAgenda != ''){
                    $.post('inc/agenda/saveNomAgenda.inc.php', {
                        nomAgenda: nomAgenda,
                        idAgenda: idAgenda
                    }, function(resultat){
                        if (resultat > 0){
                            var idAgenda = resultat;
                            var message = 'Agenda <strong> ' + nomAgenda + '</strong> ';
                            message += (creation == true) ? 'créé' : 'modifié';

                            $('#modalNewAgenda').modal('hide');
                            bootbox.alert({
                                title: 'Enregistrement',
                                size: 'small',
                                message: message
                            });

                            $.post('inc/agenda/listeMesAgendas.inc.php', {
                                idAgenda: idAgenda
                            }, function(resultat){
                                $('#unTravail').html(resultat);
                            })
                        }
                    })
                }
            }
        })

        $('body').on('click', function (e) {
            // close the popover if: click outside of the popover || click on the close button of the popover
            if (popoverElement && ((!popoverElement.is(e.target) && popoverElement.has(e.target).length === 0 && $('.popover').has(e.target).length === 0) || (popoverElement.has(e.target) && e.target.id === 'closepopover'))) {
                ///$('.popover').popover('hide'); --> works
                closePopovers();
            }
        });

        var editable = 1;

        $('#calendar').fullCalendar({
            editable: editable,
			weekends: true,
			defaultView: 'month',
			eventLimit: true,
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
			weekNumbers: true,
			navLinks: true,
			defaultTimedEventDuration: '00:60',
			firstDay: 1,
			eventSources: [
				{
				url: 'inc/agenda/myGlobalDiary.json.php',
				type: 'POST',
				data: {
					idAgenda: $('#calendar').data('idagenda')
					},
				error: function() {
					alert('Attention, vous semblez avoir perdu la connexion à l\'Internet');
					}
				}
			],
			eventRender: function(event, element, view) {
				element.popover({
					title: event.title,
					content: event.enonce,
					template: popTemplate,
					html: true,
					trigger: 'hover',
					animation: true,
					delay: 500,
					placement: "top",
					container: "body"
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
				var locked = (debut.isBefore(today) && (unlockedPast == "false"));
				popoverElement = $(jsEvent.currentTarget);
				var idPost = calEvent.idPost; // l'id de l'événement
                modeEdition();
				$.post('inc/agenda/getEvent.inc.php', {
					idPost: idPost,
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
                        var idAgenda = $('#calendar').data('idagenda');
						var startTime = moment(calEvent).format('HH:mm');
                        var endTime = moment(calEvent).add(1, 'hours').format('HH:mm');
						var startDate = moment(calEvent).format('DD/MM/YYYY');
                        var id = $('#calendar').data('id');
						$.post('inc/agenda/getAdd.inc.php', {
							startDate: startDate,
							startTime: startTime,
                            endTime: endTime,
                            idAgenda: idAgenda
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
            eventResize: function(calEvent, delta, revertFunc){
                var idPost = calEvent.idPost;
                $('.popover').hide();
                $.post('inc/agenda/proprioOuRedacteur.inc.php', {
                    idPost: idPost
                }, function(resultat){
                    if (resultat == true) {
                        // l'utilisateur est propriétaire ou rédacteur du Post
                        var startDate = moment(calEvent.start).format('YYYY-MM-DD HH:mm');
        				// si l'événement est draggé sur allDay, la date de fin est incorrecte
        				if (calEvent.allDay == true) {
        					var endDate = startDate;
        					}
        					else var endDate = moment(calEvent.end).format('YYYY-MM-DD HH:mm');
        				$.post('inc/agenda/getDragDrop.inc.php', {
        						idPost: idPost,
        						startDate: startDate,
        						endDate: endDate,
        						allDay: calEvent.allDay
        					},
        					function(resultat) {
        						$("#unTravail").html(resultat);
        						$(".popover").remove();
        					}
        				);
                        modeEdition();
                    }
                    else {
                        bootbox.alert({
                            title: 'Avertissement',
                            message: noRedac,
                        })
                        $('#calendar').fullCalendar('refetchEvents');
                    }
                })
            },
			eventDrop: function(calEvent, delta, revertFunc, jsEvent, ui, view) {
                var idPost = calEvent.idPost;
                $('.popover').hide();
                $.post('inc/agenda/proprioOuRedacteur.inc.php', {
                    idPost: idPost
                    }, function(resultat){
                        if (resultat == true) {
                            var debut = moment(calEvent.start);
                            var today = moment().format('YYYY-MM-DD');
                            // var unlockedPast = $('#unlocked').val();
                            if (debut.isBefore(today) && (unlockedPast == "false")) {
                                bootbox.alert({
                                    title: 'Erreur',
                                    message: datePassee
                                });
                                $('#calendar').fullCalendar('refetchEvents');
                            }
                            else {
                                var startDate = moment(calEvent.start).format('YYYY-MM-DD HH:mm');
                                // si l'événement est draggé sur allDay, la date de fin est incorrecte
                                if (calEvent.allDay == true) {
                                    var endDate = startDate;
                                    }
                                    else var endDate = moment(calEvent.end).format('YYYY-MM-DD HH:mm');

                                $.post('inc/agenda/getDragDrop.inc.php', {
                                        idPost: idPost,
                                        startDate: startDate,
                                        endDate: endDate,
                                        allDay: calEvent.allDay
                                    },
                                    function(resultat) {
                                        $("#unTravail").html(resultat);
                                        $(".popover").remove();
                                        }
                                    );
                                modeEdition();
                                }
                            }
                            else {
                                bootbox.alert({
                                    title: 'Avertissement',
                                    message: noRedac,
                                })
                                $('#calendar').fullCalendar('refetchEvents');
                            }
                        }
                    )
                }

        })

    $('.fc-unLockButton-button').html('<i class="fa fa-lock fa-2x"></i>').addClass('btn btn-primary').prop('title', '(Dé)-verrouiller les dates passées');

    })

</script>

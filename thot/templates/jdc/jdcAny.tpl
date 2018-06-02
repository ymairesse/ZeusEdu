<div class="container-fluid">
    <div class="row">
        <div class="col-xs-12">

            {include file="jdc/selectTousNiveauClasseEleve.tpl"}

            <h2>
                <span class="icone hidden eleve" title="Vue élève"><i class="fa fa-user fa-lg"></i></span>
                <span class="icone hidden classe" title="Vue classe"><i class="fa fa-user-plus fa-lg"></i></span>
                <span class="icone hidden niveau" title="Vue Niveau d'étude"><i class="fa fa-users fa-lg"></i></span>
                <span class="icone ecole" title="Vue école"><i class="fa fa-university fa-lg"></i></span>

                <span id="cible">{$lblDestinataire|default:''}</span>
            </h2>

        </div>

        <div class="col-md-9 col-sm-12">

            <p class="jdcInfo {$mode} demiOmbre">{$jdcInfo}</p>

            <input type="hidden" name="unlocked" id="unlocked" value="false">
            <div id="calendar"
                class="fc-global demiOmbre {$mode}"
                data-editable="{$editable|default:false}"
                data-type="{$type|default:'ecole'}"
                data-cible="all">
            </div>
        </div>

        <div class="col-md-3 col-sm-12" style="max-height:50em; overflow:auto;">

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

        </div>

    </div>

    <div class="row">
        <div class="col-xs-12" id="memoTypes">

        {foreach from=$listeTypes key=type item=data name=type}
            <button
                type="button"
                title="{$data}"
                class="btn btn-xs memo {if isset($typesJDC.$type) && ($typesJDC.$type == 1)}btn-primary{else}btn-danger{/if}">
                {$smarty.foreach.type.iteration}
            </button>
        {/foreach}
        </div>
        <div class="col-xs-12">
        {* légende et couleurs *}
        <div class="btn-group" id="legend">
            {foreach from=$categories key=cat item=travail}
            <button type="button" class="btn btn-default btn-sm cat_{$cat} voir" data-categorie="{$cat}" title="{$travail.categorie}">{$travail.categorie|truncate:12}</button>
            {/foreach}
        </div>
        </div>
    </div>

</div>
<div id="zoneEdit"></div>
<div id="zoneDel"></div>
<div id="zoneClone"></div>

{include file="jdc/modal/modalFiltre.tpl"}

<style media="screen">
    .popover {
        width: 100%;
    }
</style>

<script type="text/javascript">

    $(document).ready(function() {

        $(document).ajaxStart(function() {
            $('body').addClass('wait');
        }).ajaxComplete(function() {
            $('body').removeClass('wait');
        });

        $('#confirmFiltre').click(function(){
            var formulaire = $('#formTypes').serialize();
            $.post('inc/jdc/cookieFie.inc.php', {
                formulaire: formulaire
            }, function(resultat){
                $('#calendar').fullCalendar('refetchEvents');
                $.post('inc/jdc/memoTypes.inc.php', {
                    formulaire: formulaire
                }, function(resultat){
                    $('#memoTypes').html(resultat);
                    $('#modalFiltre').modal('hide')
                })
            })
        })

        $('#selectNiveau').change(function() {
            var niveau = $(this).val();
            if (niveau == '') {
                $('#selectClasse').addClass('hidden');
                $('.icone').addClass('hidden');
                $('.icone.ecole').removeClass('hidden');
                $('#calendar').data('type', 'ecole');
                $('#calendar').data('cible', 'all');
                $('#cible').text('Tous les élèves');

            } else {
                $.post('inc/jdc/listeClassesNiveau.inc.php', {
                    niveau: niveau
                }, function(resultat) {
                    $('#selectClasse').html(resultat).removeClass('hidden');
                    $('#selectEleve').addClass('hidden');
                    $('.icone').addClass('hidden');
                    $('.icone.niveau').removeClass('hidden');
                    $('#calendar').data('type', 'niveau');
                    $('#calendar').data('cible', niveau);
                    var suffixe = (niveau == 1) ? "ères" : "èmes";
                    $('#cible').text('Tous les élèves de ' + niveau + suffixe);
                })
            }
        })

        $("#selectClasse").change(function() {
            var classe = $(this).val();
            if (classe == '') {
                $('#selectEleve').addClass('hidden');
                $('.icone').addClass('hidden');
                $('.icone.niveau').removeClass('hidden');
                $('#calendar').data('type', 'niveau');
                var cible = $('#selectNiveau').val();
                $('#calendar').data('cible', cible);
            } else {
                $.post('inc/jdc/listeEleves.inc.php', {
                    classe: classe
                }, function(resultat) {
                    $('#selectEleve').html(resultat).removeClass('hidden');
                    $('.icone').addClass('hidden');
                    $('.icone.classe').removeClass('hidden');
                    $('#calendar').data('type', 'classe');
                    $('#calendar').data('cible', classe);
                    $('#cible').text('Tous les élèves de ' + classe);
                    $('#calendar').fullCalendar('refetchEvents');
                })
            }
        });

        $('#selectEleve').change(function() {
            var matricule = $(this).val();
            if (matricule == '') {
                $('#calendar').data('type', 'classe');
                var classe = $('#selectClasse').val();
                $('.icone').addClass('hidden');
                $('.icone.classe').removeClass('hidden');
                $('#calendar').data('cible', classe);
            } else {
                $('#calendar').data('type', 'eleve');
                var nomEleve = $('#selectEleve :selected').text();
                $('.icone').addClass('hidden');
                $('.icone.eleve').removeClass('hidden');
                $('#cible').text(nomEleve);
                $('#calendar').data('type', 'eleve');
                $('#calendar').data('cible', matricule);
            }
        })

        $('body').on('click', '.memo', function(){
            $('#modalFiltre').modal('show');
        })

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
                },
                filterButton: {
                    text: 'filtrer',
                    click: function(){
                        $('#modalFiltre').modal('show');
                    }
                }
              },
            header: {
                left: 'prev, today, next, unLockButton, filterButton',
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
            eventSources: [
                {
                url: 'inc/jdc/myGlobalEvents.json.php',
                type: 'POST',
                data: {
                },
                error: function() {
                    alert('Attention, vous semblez avoir perdu la connexion à l\'Internet.');
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
                    animation: 'true',
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
                    editable: true,
                    locked: locked
                    },
                    function(resultat) {
                        $('#unTravail').fadeOut(400, function() {
                            $('#unTravail').html(resultat).fadeIn();
                        });
                    }
                )
            },
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
                    if (view.type == 'agendaDay'){
                        var heure = moment(calEvent).format('HH:mm');
                        var date = moment(calEvent).format('MM/DD/YYYY');
                        var type = $('#calendar').data('type');
                        var cible = $('#calendar').data('cible');
                        $.post('inc/jdc/editGlobalEvent.inc.php', {
                            date: date,
                            heure: heure,
                            type: type,
                            cible: cible
                        }, function(resultat) {
                            $('#zoneEdit').html(resultat);
                            $('#modalEdit').modal('show');
                        })
                    }
                    else {
                        $('#calendar').fullCalendar('gotoDate', debut);
                        // forcer le mode "agendaDay" pour permettre la modification
                        $('#calendar').fullCalendar('changeView', 'agendaDay');
                    }
                }
            },
            eventResize: function(calEvent, delta, revertFunc, jsEvent, ui, view) {
                var nbJours = moment.duration(calEvent.end - calEvent.start).days();
                if (nbJours == 0) {
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
                }
                else {
                    bootbox.alert({
                        title: 'Erreur',
                        message: dureeMax
                    });
                    $('#calendar').fullCalendar('refetchEvents');
                }
            },
            eventDrop: function(event, delta, revertFunc, jsEvent, ui, view) {
                var debut = moment(event.start);
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
				if (editable == 1) {
					var startDate = moment(event.start).format('YYYY-MM-DD HH:mm');
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
        $('.fc-filterButton-button').html('<i class="fa fa-filter fa-2x"></i>').addClass('btn btn-primary').prop('title', 'Filtrer les événements');

		var datePassee = 'Veuillez déverrouiller les dates passées pour modifier un item à cette date';
        var dureeMax = 'La durée d\'un événement ne peut dépasser la journée';

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
                closePopovers();
            }
        });

    })
</script>

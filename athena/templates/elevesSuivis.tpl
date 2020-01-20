<div class="container-fluid"> 

    <div class="row">

        <div class="col-md-7 col-sm-12">

            <h2>Les élèves que je suis
                <button type="button" class="btn btn-primary btn-xs pull-right" id="print"><i class="fa fa-print"></i> Imprimer</button>
            </h2>

            <ul id="tabsAnSCol" class="nav nav-tabs hidden-print" data-tabs="tabs">
                {foreach from=$anneesScolaires item=anneeScolaire}
                <li {if $anneeScolaire == $ANNEESCOLAIRE}class="active"{/if}><a href="#tabs-{$anneeScolaire}" data-toggle="tab">
                    {$anneeScolaire}</a></li>
                {/foreach}
            </ul>
            <div id="queJeSuis">

                {include file="queJeSuis.tpl"}

            </div>

        </div>
        <!-- col-md-... -->

        <div class="col-md-5 col-sm-12">

            <h2>Élèves suivis</h2>

                <ul id="tabs" class="nav nav-tabs hidden-print" data-tabs="tabs">
                    {foreach from=$listeNiveaux item=niveau}
                    <li {if $niveau == 1}class="active"{/if}><a href="#tabs-{$niveau}" data-toggle="tab">
                        {$niveau}e</a></li>
                    {/foreach}
                </ul>



                <div id="clients" class="tab-content" style="max-height: 35em; overflow: auto;">

                    {foreach from=$clients key=niveau item=lesClients}

                        <div class="tab-pane {if $niveau == 1}active{/if}" id="tabs-{$niveau}">

                            {foreach from=$lesClients key=matricule item=dataClient}
                                <table class="table table-condensed">
                                    <tbody>
                                        <tr>
                                            <td style="width:2em;">
                                                <form action="index.php" method="POST" role="form" class="form-inline microform">
                                                    <input type="hidden" name="matricule" value="{$matricule}">
                                                    <input type="hidden" name="action" value="ficheEleve">
                                                    <button type="submit" class="btn btn-primary btn-xs"><i class="fa fa-eye"></i></button>
                                                </form>
                                            </td>
                                            <td style="font-weight: bold">{$dataClient.eleve.nom}</td>
                                            <td style="font-weight: bold; width:10em">{$dataClient.eleve.classe}</td>
                                        </tr>
                                        {foreach from=$dataClient.coaches key=acronyme item=dataCoach}
                                            <tr style="color:#777">
                                                <td>{$acronyme}</td>
                                                <td>{$dataCoach.nomCoach}</td>
                                                <td>{$dataCoach.nb} visite(s)</td>
                                            </tr>
                                        {/foreach}

                                    </tbody>

                                </table>
                            {/foreach}
                        </div>

                    {/foreach}

                </div>

        </div>

        <!-- <div class="col-md-6 col-sm-12">
        <div class="panel panel-info">
          <div class="panel-heading">
            <h3 class="panel-title">Mon calendrier</h3>
          </div>
          <div class="panel-body">

            <div id="calendar"></div>

          </div>
          <div class="panel-footer">

          </div>
        </div>

    </div> -->

    </div>

</div>

<div class="modal fade" id="modalPrint" tabindex="-1" role="dialog" aria-labelledby="titleModalPrint2" aria-hidden="true">

    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="titleModalPrint2">Imprimer</h4>
            </div>
            <div class="modal-body">
                <form id="printSuivi">

                    <div class="form-group">
                        <label for="anneeScolaire">Année scolaire</label>
                        <select class="form-control dates" name="anneeScolaire" id="anneeScolaire">
                            {foreach from=$elevesSuivis key=anneeScolaire item=wtf}
                            <option value="{$anneeScolaire}"{if $anneeScolaire == $ANNEESCOLAIRE} selected{/if}>{$anneeScolaire}</option>
                            {/foreach}
                        </select>
                        <p class="help-block">Année scolaire concernée</p>
                    </div>

                    <div class="form-group">
                        <label for="dateDebut">Date de début</label>
                        <input type="text" class="form-control dates" name="debut" id="dateDebut" placeholder="Date de début" class="datepicker">
                        <p class="help-block">Laisser vide si pas de date limite</p>
                    </div>

                    <div class="form-group">
                        <label for="dateFin">Date de Fin</label>
                        <input type="text" class="form-control dates" name="fin" id="dateFin" placeholder="Date de Fin" class="datepicker">
                        <p class="help-block">Laisser vide si pas de date limite</p>
                    </div>
                    <div class="form-group">
                        <label>Tri</label>
                        <label class="radio-inline"><input type="radio" name="tri" value="chrono" checked>Chronologique</label>
                        <label class="radio-inline"><input type="radio" name="tri" value="alpha">Alphabétique</label>
                        <label class="radio-inline"><input type="radio" name="tri" value="classeAlpha">Par classe + alpha</label>
                    </div>

                </form>
            </div>

            <div class="modal-footer">
                <div class="btn-group pull-right">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Fermer</button>
                    <button type="button" class="btn btn-primary" id="btnPrint">Imprimer</button>
                </div>
            </div>
        </div>
    </div>
</div>


<script type="text/javascript">

    $(document).ready(function() {

        $('#queJeSuis').on('click', '#btnClasse', function(){
            $.post('inc/queJeSuis.inc.php', {
                tri: 'classeAlpha'
            }, function(resultat){
                $('#queJeSuis').html(resultat);
            })
        })

        $('#queJeSuis').on('click', '#btnDate', function(){
            $.post('inc/queJeSuis.inc.php', {
                tri: 'chrono'
            }, function(resultat){
                $('#queJeSuis').html(resultat);
            })
        })

        $('#queJeSuis').on('click', '#btnName', function(){
            $.post('inc/queJeSuis.inc.php', {
                tri: 'alpha'
            }, function(resultat){
                $('#queJeSuis').html(resultat);
            })
        })


        $("#print").click(function() {
            $("#modalPrint").modal('show');
        })

        $("#btnPrint").click(function() {
            var formulaire = $('#printSuivi').serialize();
            $.post('inc/printListe.inc.php', {
                formulaire: formulaire
                }, function (resultat){
                    bootbox.alert(resultat);
                })
            $('#modalPrint').modal('hide');
        })

        $('body').on('click', '#celien', function(){
            bootbox.hideAll();
            })

        $("#dateDebut").datepicker({
                format: "dd/mm/yyyy",
                clearBtn: true,
                language: "fr",
                calendarWeeks: true,
                autoclose: true,
                todayHighlight: true
            })
            .off('focus')
            .click(function() {
                $(this).datepicker('show');
            });

        $("#dateFin").datepicker({
            format: "dd/mm/yyyy",
            clearBtn: true,
            language: "fr",
            calendarWeeks: true,
            autoclose: true,
            todayHighlight: true
        });

        $(".more").click(function() {
            var matricule = $(this).data('matricule');
            var open = $(this).data('open');
            if (open == 0) {
                $(this).find('i').removeClass('fa-arrow-circle-down').addClass('fa-arrow-circle-up');
                $(".more_" + matricule).fadeIn(1000);
                $(this).data('open', 1);
            } else {
                $(this).find('i').removeClass('fa-arrow-circle-up').addClass('fa-arrow-circle-down');
                $(".more_" + matricule).fadeOut(1000);
                $(this).data('open', 0);
            }
        })

        $("#calendar").fullCalendar({
            events: {
                url: 'inc/calendar/events.json.php'
            },
            eventLimit: 2,
            header: {
                left: 'prev, today, next',
                center: 'title',
                right: 'month,agendaWeek,agendaDay'
            },
            eventClick: function(calEvent, jsEvent, view) {
                var id = calEvent.id; // l'id de l'événement
                var startDate = moment(calEvent.start).format('YYYY-MM-DD HH:mm'); // la date de début de l'événement
                // mémoriser la date pour le retour
                $("#startDate").val(startDate);
                var viewState = $("#viewState").val();
                $.post('inc/getTravail.inc.php', {
                        event_id: id
                    },
                    function(resultat) {
                        $('#unTravail').fadeOut(400, function() {
                            $('#unTravail').html(resultat);
                        });
                        $('#unTravail').fadeIn();
                        $('#calendar').fullCalendar('gotoDate', startDate);
                        $('#calendar').fullCalendar('changeView', viewState);
                    }
                )
            },
            eventConstraint: {
                start: '08:00:00',
                end: '19:00:00'
            },
            defaultTimedEventDuration: '00:50',
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
                    }
                )
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
                var viewState = $("#viewState").val();
                $.post('inc/getDragDrop.inc.php', {
                        id: id,
                        startDate: startDate,
                        endDate: endDate
                    },
                    function(resultat) {
                        $("#unTravail").html(resultat);
                        $('#calendar').fullCalendar('gotoDate', startDate);
                        $('#calendar').fullCalendar('changeView', viewState);
                    }
                )
            },
            viewRender: function(event) {
                var state = event.name;
                $("#viewState").val(state);
            },
            businessHours: {
                start: '08:15',
                end: '19:00',
                dow: [1, 2, 3, 4, 5]
            },
            minTime: "08:00:00",
            maxTime: "22:00:00",
            firstDay: 1
                //,
                // dayClick: function(date,event,view) {
                // 	var startDate = moment(date).format('YYYY-MM-DD HH:mm');
                // 	if (view.type == 'agendaDay') {
                // 		var heure = moment(date).format('HH:mm');
                // 		var dateFr = moment(date).format('DD/MM/YYYY');
                // 		var viewState = $("#viewState").val();
                // 		// mémoriser la date pour le retour
                // 		$("#startDate").val(startDate);
                // 		// est-ce une notification par classe ou par cours?
                // 		var type = ($("#selectClasse").val() == undefined)?'cours':'classe';
                // 		if (type == 'cours')
                // 			var destinataire = $("#coursGrp").val();
                // 			else if (type == 'classe')
                // 					var destinataire = $("#selectClasse").val();
                // 		var lblDestinataire = $("#lblDestinataire").val();
                // 		$.post('inc/calendar/getAdd.inc.php', {
                // 			startDate: startDate,
                // 			viewState: viewState,
                // 			heure: heure,
                // 			type: type,
                // 			destinataire: destinataire,
                // 			lblDestinataire: lblDestinataire
                // 			},
                // 			function(resultat) {
                // 				$("#zoneMod").html(resultat);
                // 				$("#modalAdd").modal('show');
                // 				$('#calendar').fullCalendar('gotoDate', startDate);
                // 				$('#calendar').fullCalendar('changeView', viewState);
                // 				}
                // 			)
                // 		}
                // 		else {
                // 			$('#calendar').fullCalendar('gotoDate', startDate);
                // 			$('#calendar').fullCalendar('changeView', 'agendaDay');
                // 		}
                // 	}

        });

    })
</script>

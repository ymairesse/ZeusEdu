<div class="container">

    <div class="row">
        <div class="col-xs-12">
            {include file="selecteurs/selectNiveauPOST.tpl"}
        </div>
    </div>

    <div class="row">
        <div class="col-md-7 col-xs-12">
            <h2>Note au Journal de Classe pour <strong id="cible">tous les élèves</strong></h2>

            <div id="calendar">
            </div>

        </div>

        <div class="col-md-5 col-xs-12" style="max-height:50em; overflow: auto">

            <form action="index.php" method="POST" name="detailsJour" id="detailsJour" role="form" class="form-vertical ombre">
                <!-- champs destinés à être lus pour d'autres formulaires -->
                <input type="hidden" name="destinataire" id="destinataire" value="{$destinataire}">
                <input type="hidden" name="lblDestinataire" id="lblDestinataire" value="{$lblDestinataire|default:''}">
                <input type="hidden" name="startDate" id="startDate" value="{$startDate|default:''}">
                <input type="hidden" name="viewState" id="viewState" value="">

                <div id="unTravail">

                </div>
            </form>
        </div>

    </div>

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


<script type="text/javascript">

$(document).ready (function() {

	$('#selectClasse, #selectEleve').hide();

    $('#calendar').fullCalendar({
        eventSources: [
            {
            url: 'inc/events.json.php',
            type: 'POST',
            data: {
                type: $('#type').val(),
                niveau: $('#selectNiveau').val(),
                classe: $('#selectClasse').val(),
                matricule: $('#selectEleve').val(),
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
        eventClick: function (calEvent, jsEvent, view) {
            var id = calEvent.id; // l'id de l'événement
            var startDate = moment(calEvent.start).format('YYYY-MM-DD HH:mm'); // la date de début de l'événement
            // mémoriser la date pour le retour
            $("#startDate").val(startDate);
            $.post('inc/jdc/getJdcEdit.inc.php', {
                id: id,
                editable: true
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
                var lblDestinataire = $("#cible").text();
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
        var lblDestinataire = $("#cible").text();
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

	$('#selectNiveau').change(function(){
		var niveau = $(this).val();
        $('#selectEleve').hide();
		if (niveau == '') {
			$('#selectClasse').hide();
			$('#type').val('ecole');
            $('#cible').text('tous les élèves')
			}
			else {
				$.post('inc/jdc/listeClassesNiveau.inc.php', {
					niveau: niveau
				}, function(resultat){
					$('#selectClasse').html(resultat).show();
					$('#type').val('niveau');
                    var suffixe = (niveau == 1) ? "ères" : "èmes";
                    $('#cible').text('tous les élèves de ' + niveau + suffixe);
                    $('#calendar').fullCalendar('refetchEvents');
				})
			}
		})

	$("#selectClasse").change(function(){
		var classe = $(this).val();
		if (classe == '') {
			$('#selectEleve').hide();
			$('#type').val('niveau');
			}
			else {
				$.post('inc/jdc/listeEleves.inc.php',{
					classe: classe
				}, function (resultat){
					$('#selectEleve').html(resultat).show();
					$('#type').val('classe');
                    $('#cible').text('tous les élèves de ' + classe);
                    $('#calendar').fullCalendar('refetchEvents');
					}
				)
			}
		});

	$('#selectEleve').change(function(){
		var matricule = $(this).val();
		if (matricule == '') {
			$('#type').val('classe');
			}
			else {
				$('#type').val('eleve');
                var nomEleve = $('#selectEleve :selected').text()
                $('#cible').text(nomEleve);
                $('#calendar').fullCalendar('refetchEvents');
			}
		})

})

</script>

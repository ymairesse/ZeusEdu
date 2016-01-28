{* au cas où un enregistrement vient d'avoir lieu, une variable $travail *}
{* contenant toutes les caractéristiques de l'enregistrement est renvoyée et on en extrait les infos nécessaires à l'affichage *}
{if isset($travail)}
	{assign var=destinataire value=$travail.destinataire}
	{assign var=type value=$travail.type}
	{assign var=startDate value=$travail.startDate}
{/if}

<div class="container">

<!-- <h2>Journal de classe de {$destinataire}</h2> -->

<div class="row">

	<div class="col-md-7 col-xs-12">
		<h2>{$lblDestinataire}</h2>

		<div id="calendar"></div>
	</div>

	<div class="col-md-5 col-xs-12">

		<form action="index.php" method="POST" name="detailsJour" id="detailsJour" role="form" class="form-vertical ombre">
			<!-- champs destinés à être lus pour d'autres formulaires -->
			<input type="hidden" name="mode" id="mode" value="{$mode}">
			<input type="hidden" name="action" id="action" value="{$action}">
			<input type="hidden" name="acronyme" id="acronyme" value="{$identite.acronyme}">
			<input type="hidden" name="destinataire" id="destinataire" value="{$destinataire}">
			<input type="hidden" name="lblDestinataire" id="lblDestinataire" value="{$lblDestinataire|default:''}">
			<input type="hidden" name="type" id="tp" value="{$type|default:''}">

			<input type="hidden" name="startDate" id="startDate" value="{$startDate|default:''}">
			<input type="hidden" name="viewState" id="viewState" value="{$viewState|default:'month'}">

			<div id="unTravail">
				{if isset($travail)}
					{include file='jdc/unTravail.tpl'}
				{else}
					<strong>Veuillez sélectionner un item dans le calendrier</strong><br>
					<strong>ou cliquer dans une zone libre pour rédiger une nouvelle note.</strong>
					<div class="img-responsive"><img src="../images/logoPageVide.png" alt="Logo"></div>
				{/if}
			</div>
		</form>

	</div>  <!-- col-md-... -->

</div>  <!-- row -->

<div class="row">

	{foreach from=$legendeCouleurs key=cat item=travail}
		<div class="col-md-1 col-sm-6">
			<div class="cat_{$cat} discret" title="{$travail.categorie}">{$travail.categorie|truncate:10}</div>
		</div>  <!-- col-md-... -->
	{/foreach}

</div>	  <!-- row -->

<div id="zoneDel">
	<!-- boîte modale d'effacement de note du JDC -->
</div>

<div id="zoneMod">
	<!-- boîte modale d'ajout de note au JDC -->
</div>

</div>  <!-- container -->

<script type="text/javascript">

function dateFromFr (uneDate) {
	var laDate = uneDate.split('/');
	return laDate[2]+'-'+laDate[1]+'-'+laDate[0];
	}

$(document).ready(function(){

	$("#calendar").fullCalendar({
		events: {
			url:'inc/events.json.php'
		},
		eventLimit: 2,
		header: {
		left: 'prev, today, next',
		center: 'title',
		right: 'month,agendaWeek,agendaDay'
		},
		eventClick: function(calEvent, jsEvent, view) {
			var id = calEvent.id; // l'id de l'événement
			var startDate = moment(calEvent.start).format('YYYY-MM-DD HH:mm');  // la date de début de l'événement
			// mémoriser la date pour le retour
			$("#startDate").val(startDate);
			var viewState = $("#viewState").val();
			$.post('inc/getTravail.inc.php', {
				event_id: id
				},
				function (resultat){
					$('#unTravail').fadeOut(400,function(){
						$('#unTravail').html(resultat);
					});
					$('#unTravail').fadeIn();
					$('#calendar').fullCalendar('gotoDate', startDate);
					$('#calendar').fullCalendar('changeView', viewState);
					}
				)
			},
		eventConstraint:{
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
			$.post('inc/getDragDrop.inc.php',{
				id: id,
				startDate: startDate,
				endDate: endDate
				},
				function (resultat){
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
			$.post('inc/getDragDrop.inc.php',{
				id: id,
				startDate: startDate,
				endDate: endDate
				},
				function (resultat){
					$("#unTravail").html(resultat);
					$('#calendar').fullCalendar('gotoDate', startDate);
					$('#calendar').fullCalendar('changeView', viewState);
					}
				)
			},
		viewRender: function(event){
			var state = event.name;
			$("#viewState").val(state);
			},
		businessHours: {
			start: '08:15',
			end: '19:00',
			dow: [ 1, 2, 3, 4, 5 ]
			},
		minTime: "08:00:00",
		maxTime: "22:00:00",
		firstDay: 1,
		dayClick: function(date,event,view) {
			var startDate = moment(date).format('YYYY-MM-DD HH:mm');
			if (view.type == 'agendaDay') {
				var heure = moment(date).format('HH:mm');
				var dateFr = moment(date).format('DD/MM/YYYY');
				var viewState = $("#viewState").val();
				// mémoriser la date pour le retour
				$("#startDate").val(startDate);
				// est-ce une notification par classe ou par cours?
				var type = ($("#selectClasse").val() == undefined)?'cours':'classe';
				if (type == 'cours')
					var destinataire = $("#coursGrp").val();
					else if (type == 'classe')
							var destinataire = $("#selectClasse").val();
				var lblDestinataire = $("#lblDestinataire").val();
				$.post('inc/getAdd.inc.php', {
					startDate: startDate,
					viewState: viewState,
					heure: heure,
					type: type,
					destinataire: destinataire,
					lblDestinataire: lblDestinataire
					},
					function(resultat) {
						$("#zoneMod").html(resultat);
						$("#modalAdd").modal('show');
						$('#calendar').fullCalendar('gotoDate', startDate);
						$('#calendar').fullCalendar('changeView', viewState);
						}
					)
				}
				else {
					$('#calendar').fullCalendar('gotoDate', startDate);
					$('#calendar').fullCalendar('changeView', 'agendaDay');
				}
			}

		});

	// suppression d'une note au JDC
	$("#unTravail").on('click','#delete',function(){
		var id = $(this).data('id');
		var startDate = $("#startDate").val();
		var viewState = $("#viewState").val();
		var destinataire = $("#destinataire").val();
		var type = $("#type").val();
		$.post('inc/getDel.inc.php', {
			id: id,
			startDate: startDate,
			viewState: viewState,
			destinataire: destinataire,
			type: type
			},
			function (resultat) {
				$("#zoneDel").html(resultat);
				$("#modalDel").modal('show');
				$('#calendar').fullCalendar('gotoDate', startDate);
				$('#calendar').fullCalendar('changeView', viewState);
				}
			)
		})

	// modification d'une note au JDC
	$("#unTravail").on('click','#modifier',function(){
		var id = $(this).data('id');
		var viewState = $("#viewState").val();
		var startDate = $("#startDate").val();
		var type = ($("#selectClasse").val() == undefined)?'cours':'classe';
		$.post('inc/getMod.inc.php',{
			id:id,
			viewState: viewState,
			startDate: startDate,
			type: type
			},
			function (resultat) {
				$("#zoneMod").html(resultat);
				$("#modalMod").modal('show');
				$('#calendar').fullCalendar('gotoDate', startDate);
				$('#calendar').fullCalendar('changeView', viewState);
				}
			)
		})


$("#zoneMod").on('click','#journee',function(){
	if($(this).prop('checked') == true) {
		$("#duree").prop('disabled',true);
		$("#timepicker").prop('disabled',true);
		$("#listeDurees").addClass('disabled');
		}
		else {
			$("#duree").prop('disabled',false);
			$("#timepicker").prop('disabled',false);
			$("#listeDurees").removeClass('disabled');
		}
	})

$("#zoneMod").on('change','#destinataire',function(){
    var type = $(this).find(':selected').data('type');
    $("#type").val(type);
})

{if isset($startDate) && isset($viewState)}
	$('#calendar').fullCalendar('gotoDate', moment("{$startDate}"));
	$('#calendar').fullCalendar('changeView', '{$viewState}');
{/if}
})

</script>

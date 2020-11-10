	<form id="presencesEleves">

		<input type="hidden" id="date" name="date" value="{$date}">
		<input type="hidden" name="parent" value="prof/educ">
		<input type="hidden" name="media" value="en classe">
		<input type="hidden" name="periode" id="periode" value="{$periode}">
		<input type="hidden" id="coursGrp" name="coursGrp" value="{$coursGrp|default:''}">
		<input type="hidden" id="classe" name="classe" value="{$classe|default:''}">
		<input type="hidden" name="oups" id="oups" value="false">
		<input type="hidden" name="presAuto" id="presAuto" value="true">

		<img src="../images/ajax-loader.gif" alt="wait" class="hidden" id="ajaxLoader">

		<div class="pull-right" style="font-size:110%;">
			[<span>{$nbEleves}</span> <span class="glyphicon glyphicon-user"></span> ]
			[<i class="fa fa-clock-o"></i> {$periode} <span style="font-size:10pt"><span class="glyphicon glyphicon-arrow-right"></span> {$listePeriodes.$periode.debut}-{$listePeriodes.$periode.fin}</span> ]
			[<span class="glyphicon glyphicon-user" style="color:green"></span> <span style="color:green" id="nbPres"></span>]
			[<span class="glyphicon glyphicon-user" style="color:red"></span> <span style="color:red" id="nbAbs"></span> ]
		</div>

	<div id="listeDouble">

		{include file="listeDouble.tpl"}

	</div>
	<div class="clearfix"></div>
</form>



{* liste des périodes de cours avec les heures *}
<div class="visible-md visible-lg">

	<div class="table-responsive">

	<table class="table tableauPresences" style="padding-top:2em">
		<tr>
		<th>Périodes</th>
		{foreach from=$listePeriodes key=noPeriode item=periode}
			<th style="text-align:center; font-weight: bold">{$noPeriode}</th>
		{/foreach}
		</tr>
		<tr>
		<th>Heures</th>
		{foreach from=$listePeriodes key=noPeriode item=periode}
			<td style="text-align:center">{$periode.debut}<br>{$periode.fin}</td>
		{/foreach}
		</tr>
	</table>

</div>

	{include file='legendeAbsences.tpl'}

</div>  <!-- container -->

{include file="modal/confirmUnlock.tpl"}

<script type="text/javascript">

	var modifie = false;
	var confirmationBeforeUnload = "Vous allez perdre toutes les modifications. Annulez pour rester sur la page.";
	var confirmationVerrou = "Souhaitez-vous vraiment déverrouiller cette période?\nÀ n'utiliser que pour noter une présence inattendue."

	function modification () {
		if (!(modifie)) {
			modifie = true;
			window.onbeforeunload = function(){
				var confirmation = confirm(confirmationBeforeUnload);
				$("#wait").hide();
				return confirmation;
				};
			}
		}

	function notificationNombres(){
		var nbAbs = $(".now.absent").length+$(".now.signale").length+$(".now.sortie").length+$(".now.justifie").length+$(".now.renvoi").length+$(".now.ecarte").length+$(".now.suivi").length;
		var nbPres = $("input.cb").length - nbAbs;
		$("#nbAbs").text(nbAbs);
		$("#nbPres").text(nbPres);
		}

$(document).ready(function(){

	$(document).ajaxStart(function() {
		$('#ajaxLoader').removeClass('hidden');
		}).ajaxComplete(function() {
			$('#ajaxLoader').addClass('hidden');
		});

	notificationNombres();
	modifie = false;

	$('#datePresences').change(function(){
		var date = $('#datePresences').val();
		$('#date').val(date);
		var classe = $('#classe').val();
		var coursGrp = $('#coursGrp').val();
		var periode = $('#periode').val();
		$.post('inc/refreshAfterSave.inc.php', {
			coursGrp: coursGrp,
			classe: classe,
			date: date,
			periode: periode
		}, function(tableau){
			$('#listeDouble').html(tableau);
		})
	})

	$("#datePresences").datepicker({
		language: "fr",
		autoclose: true,
		todayHighlight: true,
		todayBtn: 'linked',
		daysOfWeekDisabled: [0,6]
	});

	$('#save').click(function(){
		var formulaire = $('#presencesEleves').serialize();
		var coursGrp = $('#coursGrp').val();
		var classe = $('#classe').val();
		var date = $('#date').val();
		var periode = $('#periode').val();
		$.post('inc/savePresences.inc.php', {
			formulaire: formulaire
		}, function(resultat){
			modifie = false;
			$("#oups").val(false);
			window.onbeforeunload = function(){};
			$.post('inc/refreshAfterSave.inc.php', {
				coursGrp: coursGrp,
				classe: classe,
				date: date,
				periode: periode
			}, function(tableau){
				$('#listeDouble').html(tableau);
				bootbox.alert({
					title: 'Enregistrement des présences',
					message: resultat + ' enregistrements de présences'
				})
			})
		})
	})


	$('#listeDouble').on('click', '.tableauPresences td', function(e){
		modification();
		var ligne = $(this).closest('tr');
		var cb = ligne.find('input:hidden');
		// input 'disabled' si l'absence est connue
		if (cb.attr('disabled') != 'disabled') {
			if ($('#btnRetard').hasClass('active')) {
				var statut = cb.val();
				switch (statut) {
					case 'retard':
						cb.val('indetermine');
						break;
					default:
						cb.val('retard');
						break;
					}
				}
				else {
					var statut = cb.val();
					switch (statut) {
						case 'absent':
							cb.val('present');
							break;
						case 'indetermine':
							cb.val('absent');
							break;
						case 'present':
							cb.val('indetermine');
							break;
						case 'retard':
							cb.val('absent');
							break;
						}
					}
				var newStatut = cb.val();
			}

			ligne.find('button').removeClass().addClass('btn btn-large btn-block nomEleve clip').addClass(newStatut);
			var periode = $("#periode").val()
			ligne.find('td[data-periode="' + periode +'"]').removeClass().addClass(newStatut+' now');

			// notification du nombre d'absents et de présents
			notificationNombres();
			}
		)

	$('#listeDouble').on('click', '.lock', function(){
		var periodeActuelle = $("#periode").val();
		var periode = $(this).data('periode');
		if (periodeActuelle == periode) {
			$("#verrou").text($(this).attr('id'));
			$("#confirmeVerrou").modal('show');
			}
		})

	$("#unlock").click(function() {
		var elt = $("#verrou").text();
		periode = elt.split('-');
		periode = periode[2];
		$("#"+elt).find("span.glyphicon").replaceWith("<strong>"+periode+"</strong>");
		$("#"+elt).find("input").attr('disabled',false).val('present').closest('td').removeClass().addClass('now present');
		$("#"+elt).closest('tr').find('td button').eq(0).removeClass().addClass('btn btn-large btn-block now present');
		$("#"+elt).removeClass('lock').unbind('click');
		$("#confirmeVerrou").modal('hide');
		})

	$('#listeDouble').on('click', '.trash', function(){
		var periodeActuelle = $("#periode").val();
		var periodeTrash = $(this).data('periode');
		// on ne travaille que si la période à réinitialiser est la période actuelle
		if (periodeActuelle == periodeTrash) {
			modification();
			var colonneActuelle = $("td[data-periode='"+periodeActuelle+"']");
			$("#oups").val(true);
			// reset de la colonne actuelle à 'indéterminé'
			$.each(colonneActuelle,function(){
				if (!($(this).hasClass('lock'))) {
					var input = $(this).find('input:hidden');
					input.val('indetermine');
					$(this).closest('td').removeClass().addClass('now indetermine');
					$(this).closest('td').removeAttr('style');
					var matricule = $(this).data('matricule');
					// changer le statut du bouton "nomEleve"
					$("#nomEleve-"+matricule).removeClass().addClass("btn btn-large btn-block nomEleve indetermine");
					}
				})
			// notification du nombre d'absents et de présents
			notificationNombres();
			}
		})

	$('#listeDouble').on('click', '.horloge', function(){
		// annulation de toutes les modifications non enregistrées
		$("#annuler").trigger('click');
		$("#oups").val(false);

		var periodeActuelle = $("#periode").val();
		var nouvellePeriode = $(this).data('periode');

		// on ne travaille que si les deux périodes sont différentes
		if (periodeActuelle != nouvellePeriode) {
			// mise à jour des icônes de têtes de colonnes
			$(".horloge[data-periode='" + periodeActuelle + "']").html("<i class='fa fa-circle-thin'></i>");
			$(".horloge[data-periode='" + nouvellePeriode + "']").html("<i class='fa fa-clock-o'></i>");

			// mise à jour du champ "input" de la période en cours
			$("#periode").val(nouvellePeriode);

			var colonneActuelle = $("td[data-periode='" + periodeActuelle + "']");
			// vider la colonne actuelle
			$.each(colonneActuelle,function(){
				$(this).removeClass('now').addClass('notNow');
				// s'il s'agit d'une absence déjà signalée, on remet le verrou; sinon, on indique seulement le numéro de la période
				if ($(this).hasClass('lock'))
					var html = "<span class='glyphicon glyphicon-lock' title='absence déjà signalée'></span>";
				else var html = "<strong>" + periodeActuelle + "</strong>";
				$(this).html(html);
				})

			var nouvelleColonne = $("td[data-periode='" + nouvellePeriode + "']");
			// peupler la nouvelle colonne
			$.each(nouvelleColonne,function(){
				$(this).addClass('now').removeClass('notNow');
				var statut = $(this).data('statut');
				var matricule = $(this).data('matricule');
				// changer le statut du bouton "nomEleve"
				$("#nomEleve-"+matricule).removeClass().addClass("btn btn-large btn-block nomEleve").addClass(statut);
				var html = '';
				if ($(this).hasClass('lock'))
					html = "<span class='glyphicon glyphicon-lock' title='absence déjà signalée'></span>";
				html += "<input type='hidden' value='"+statut+"' name='matr-" + matricule + "' class='cb' id='matr-" + matricule + "'";
				if ($(this).hasClass('lock'))
					html += " disabled";
				html += ">";
				if (!$(this).hasClass('lock'))
					html += "<strong>"+nouvellePeriode+"</strong>";
				$(this).html(html);
				})
			// déplacer le trash actif vers la nouvelle période
			$(".trash[data-periode='"+periodeActuelle+"']").addClass('disabled');
			$(".trash[data-periode='"+nouvellePeriode+"']").removeClass('disabled');

			notificationNombres();
			}
		})

	$("#annuler").click(function(){
		var champs = $(".tableauPresences").find('td input');
		// remettre les valeurs des champs à la valeur initiale conservée dans data-statut
		// ajouter le statut "now"
		$.each(champs,function(){
			statut = $(this).closest('td').data('statut');
			$(this).val(statut);
			$(this).closest('td').not('.lock').removeClass();
			$(this).closest('td').addClass(statut +' now');
			})
		var boutonNomEleve = $(".nomEleve");
		// remettre le statut des boutons à la valeur initiale conservée dans data-statut
		$.each(boutonNomEleve, function(){
			var statut = $(this).data('statut');
			$(this).removeClass().addClass("btn btn-large btn-block nomEleve").addClass(statut);
			})
		// notification du nombre d'absents et de présents
		notificationNombres();
		})

	// bouton pour annuler la mise des présences automatique si pas d'absence signalée
	$("#btnPresAuto").click(function(){
		$(this).toggleClass('btn-warning btn-danger');
		if ($(this).hasClass('btn-danger')){
			$("#presAuto").val(false);
			$(this).text('Présence Auto [Désactivé]');
			}
			else {
				$(this).text('Présence Auto [Activé]');
				$("#presAuto").val(true);
				}
		})

	// bouton pour activer la prise en compte des retards
	$('#btnRetard').click(function(){
		$(this).toggleClass('btn-pink btn-lightPink');
		if ($(this).hasClass('btn-pink')){
			$('#btnRetard').toggleClass('active');
			$(this).html('<i class="fa fa-clock-o"></i> Retard au cours [Activé]');
			}
			else {
				$('#btnRetard').toggleClass('active');
				$(this).html('<i class="fa fa-moon-o"></i> Retard au cours [Désactivé]');
			}
	})

})

</script>

	<strong>{$jourSemaine|ucwords} {$date}</strong>
	<div style="float:right; font-size:110%;">
		[<span>{$nbEleves}</span> <span class="glyphicon glyphicon-user"></span> ]
		[<i class="fa fa-clock-o"></i> {$periode} <span style="font-size:10pt"><span class="glyphicon glyphicon-arrow-right"></span> {$listePeriodes.$periode.debut}-{$listePeriodes.$periode.fin}</span> ]
		[<span class="glyphicon glyphicon-user" style="color:green"></span> <span style="color:green" id="nbPres"></span>]
		[<span class="glyphicon glyphicon-user" style="color:red"></span> <span style="color:red" id="nbAbs"></span> ]
	</div>

	{* répartition des élèves dans deux colonnes sur les écrans larges; sinon, les deux tableaux seront superposés *}
	{assign var=nbCol1 value=round($listeEleves|count / 2)}
	{assign var=listeDouble value=array($listeEleves|array_slice:0:$nbCol1:true, $listeEleves|array_slice:$nbCol1:Null:true)}

	<div class="row" style="clear:both">

		{foreach from=$listeDouble key=i item=liste}

		<div class="col-md-6 col-sm-12">

		<table class="table-condensed table-hover tableauPresences" id="tableauPresences{$i}">

			<thead {if $i == 1}class="hidden-sm hidden-xs"{/if}>
				<tr>
					<th style="width:30px" class="hidden-sm hidden-xs">&nbsp;</th>
					<th style="width:230px">&nbsp;</th>
					{foreach from=$lesPeriodes item=noPeriode}
					<th class="horloge {if $noPeriode==$periode}ouvert{else}ferme{/if}"
						data-periode="{$noPeriode}">
						<i class="fa {if $noPeriode == $periode}fa-clock-o{else}fa-circle-thin{/if}"></i>
					</th>
					{/foreach}
				</tr>
			</thead>

			{foreach from=$liste key=matricule item=unEleve}
				{assign var=listePr value=$listePresences.$matricule}
				<tr>
					<th style="width:30px" class="hidden-sm hidden-xs">{$unEleve.classe|default:'&nbsp;'}</th>
					<td style="width:230px">
						{assign var=statut value=$listePr.$periode.statut|default:'indetermine'}
						<button class="btn btn-large btn-block nomEleve {$statut} clip"
								id="nomEleve-{$matricule}"
								data-statut="{$statut}"
								type="button">
							<span class="visible-xs">{$unEleve.nom|truncate:10:'..'} {$unEleve.prenom|truncate:10:'.'}</span>
							<span class="visible-sm visible-md visible-lg">{$unEleve.nom|truncate:20:'...'|default:'&nbsp;'} {$unEleve.prenom|default:'&nbsp;'}</span>
						</button>
					</td>

					{* on passe les différentes périodes existantes en revue *}
					{foreach from=$lesPeriodes item=noPeriode}
						{assign var=statut value=$listePr.$noPeriode.statut|default:''}
						<td class="{$statut}
							{if $noPeriode==$periode} now{else} notNow{/if}
							{if (in_array($statut, array('sortie','signale','justifie','ecarte','renvoi','suivi')))} lock{/if}"
							id="lock-{$matricule}_periode-{$noPeriode}"
							data-statut="{$statut}"
							data-periode="{$noPeriode}"
							data-matricule="{$matricule}">

							{if (in_array($statut, array('sortie','signale','justifie','ecarte','renvoi','suivi')))}
								<span class="glyphicon glyphicon-lock" title="absence déjà signalée"></span>
								{else}
								<strong>{$noPeriode}</strong>
							{/if}

							{if ($noPeriode == $periode)}
								<input type="hidden"
									value="{$statut}"
									name="matr-{$matricule}_periode-{$noPeriode}"
									class="cb"
									id="matr-{$matricule}_periode-{$noPeriode}"
									{if (in_array($statut, array('sortie','signale','justifie','ecarte','renvoi','suivi')))}
										disabled
									{/if}>
							{/if}
						</td>
					{/foreach}  {* $lesPeriodes *}
				</tr>
			{/foreach}  {* $liste *}

			<!-- ouuuupsss... pour réinitialiser la prise de présences de cette période -->
			<tfoot {if $i == 0}class="hidden-sm hidden-xs"{/if}>
				<tr>
					<th style="width:30px" class="hidden-sm hidden-xs">&nbsp;</th>
					<th style="width:230px">&nbsp;</th>
				{foreach from=$lesPeriodes item=noPeriode}
					<th class="trash {if $noPeriode != $periode} disabled{/if}"
						data-periode="{$noPeriode}">
						<i class="fa fa-trash"></i>
					</th>
				{/foreach}
				</tr>
			</tfoot>
		</table>

		</div>  <!-- col-md... -->
		{/foreach}  {* $listeDouble *}

		</div> <!-- col-md...  -->

	</div>  <!-- row -->

	</form>
</div>  <!-- container -->

<div class="container visible-md visible-lg">

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

</div>  <!-- container -->


<!-- boîte modale pour confirmation de déverrouillage -->

<div class="modal fade" id="confirmeVerrou" tabindex="-1" role="dialog" aria-labelled-by="labelModal" aria-hidden="true">

	<div class="modal-dialog">

		<div class="modal-content">

			<div class="modal-header">
				<h4 class="modal-title" id="labelModal">ATTENTION!!!</h4>
			</div>  <!-- modal-header -->

			<div class="modal-body">
				<p>Souhaitez-vous vraiment déverrouiller cette période? <span id="verrou" style="display:none"></span></p>
				<p>Notez que l'absence de cet-te élève est déjà connue. Il n'est pas souhaitable de la re-signaler.</p>
				<p>Cette possibilité ne devrait être utilisée que pour noter une présence inattendue: malgré l'absence signalée, l'élève se trouve quand même devant vous.</p>
			</div>  <!-- modal-body -->

			<div class="modal-footer">
				 <button type="button" class="btn btn-default" data-dismiss="modal">Annuler</button>
                <button type="button" id="unlock" class="btn btn-primary">Déverrouiler malgré tout</button>
			</div>  <!-- modal-footer -->

		</div>  <!-- modal-content -->

	</div>  <!-- modal-dialog -->

</div>  <!-- modal -->

<script type="text/javascript">

	var modifie = false;
	var confirmationBeforeUnload = "Vous allez perdre toutes les modifications. Annulez pour rester sur la page.";
	var confirmationVerrou = "Souhaitez-vous vraiment déverrouiller cette période?\nÀ n'utiliser que pour noter une présence inattendue."

$(document).ready(function(){

	var nbAbs = $(".now.absent").length+$(".now.signale").length+$(".now.sortie").length+$(".now.justifie").length+$(".now.renvoi").length;
	var nbPres = $("input.cb").length - nbAbs;
	var modifie = false;

	$("#nbAbs").text(nbAbs);
	$("#nbPres").text(nbPres);

	function modification () {
		$("#save").html("<i class='fa fa-floppy-o'></i>");
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

	$("#presencesEleves").submit(function(){
		$.blockUI();
		$("#wait").show();
		})

	$("#presencesEleves").submit(function(){
		window.onbeforeunload = function(){};
		})

	// il suffit de cliquer sur le <td> contenant les input's
	$(".tableauPresences td").click(function(e){
		modification();
		var ligne = $(this).closest('tr');
		var cb = ligne.find('input:hidden');
		// input 'disabled' si l'absence est connue
		if (cb.attr('disabled') != 'disabled') {
			var statut = cb.val();
			if (statut == 'absent')
				cb.val('present');
				else cb.val('absent');

			var newStatut = cb.val();
			ligne.find('button').removeClass().addClass('btn btn-large btn-block nomEleve clip').addClass(newStatut);
			var periode = $("#periode").val()
			ligne.find('td').eq(periode).removeClass().addClass(newStatut+' now');

			// notification du nombre d'absents et de présents
			notificationNombres();
			}
		})

	$(".lock").click(function(event){
		var periodeActuelle = $("#periode").val();
		var periode = $(this).data('periode');
		if (periodeActuelle == periode) {
			$("#verrou").text($(this).attr('id'));
			$("#confirmeVerrou").modal('show');
			}
		event.stopPropagation();
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

	$(".trash").click(function(){
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
					var matricule = $(this).data('matricule');
					// changer le statut du bouton "nomEleve"
					$("#nomEleve-"+matricule).removeClass().addClass("btn btn-large btn-block nomEleve indetermine");
					}
				})
			// notification du nombre d'absents et de présents
			notificationNombres();
			}
		})

	$(".horloge").click(function(){
		// annulation de toutes les modifications non enregistrées
		$("#annuler").trigger('click');

		var periodeActuelle = $("#periode").val();
		var nouvellePeriode = $(this).data('periode');
		// on ne travaille que si les deux périodes sont différentes
		if (periodeActuelle != nouvellePeriode) {
			// mise à jour des icônes de têtes de colonnes
			$(".horloge[data-periode='"+periodeActuelle+"']").html("<i class='fa fa-circle-thin'></i>");
			$(".horloge[data-periode='"+nouvellePeriode+"']").html("<i class='fa fa-clock-o'></i>");

			// mise à jour du champ "input" de la période en cours
			$("#periode").val(nouvellePeriode);

			var colonneActuelle = $("td[data-periode='"+periodeActuelle+"']");
			// vider la colonne actuelle
			$.each(colonneActuelle,function(){
				$(this).removeClass('now').addClass('notNow');
				// s'il s'agit d'une absence déjà signalée, on remet le verrou; sinon, on indique seulement le numéro de la période
				if ($(this).hasClass('lock'))
					var html = "<span class='glyphicon glyphicon-lock' title='absence déjà signalée'></span>";
				else var html = "<strong>"+periodeActuelle+"</strong>";
				$(this).html(html);
				})

			var nouvelleColonne = $("td[data-periode='"+nouvellePeriode+"']");
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
				html += "<input type='hidden' value='"+statut+"' name='matr-"+matricule+"_periode-"+nouvellePeriode+"' class='cb' id='matr-"+matricule+"_periode-"+nouvellePeriode+"'";
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
			}
		})

	$("#annuler").click(function(){
		$("#save").html('');
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


})



</script>

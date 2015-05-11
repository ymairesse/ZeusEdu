	<strong>{$jourSemaine|ucwords} {$date}</strong>
	<div style="float:right; font-size:110%;">
		[<span>{$nbEleves}</span> <span class="glyphicon glyphicon-user"></span> ]
		[<span class="glyphicon glyphicon-time"></span> {$periode} <span style="font-size:10pt">-> {$listePeriodes.$periode.debut}-{$listePeriodes.$periode.fin}</span> ]
		[<span class="glyphicon glyphicon-user" style="color:green"></span> <span style="color:green" id="nbPres"></span>]
		[<span class="glyphicon glyphicon-user" style="color:red"></span> <span style="color:red" id="nbAbs"></span> ]
	<span id="save"></span>
	</div>

	{* nombre d'élèves dans chaque colonne *}
	{assign var=nbCol1 value=round($listeEleves|count / 2)}
	{assign var=listeDouble value=array($listeEleves|array_slice:0:$nbCol1:true, $listeEleves|array_slice:$nbCol1:Null:true)}

	<div class="row" style="clear:both">
		
		{foreach from=$listeDouble key=i item=liste}
		
		<div class="col-md-6 col-sm-12">	

		<table class="table-condensed table-hover tableauPresences" id="tableauPresences{$i}">

			{foreach from=$liste key=matricule item=unEleve}
				{assign var=listePr value=$listePresences.$matricule}
				<tr>
					<th style="width:30px" class="hidden-sm hidden-xs">{$unEleve.classe|default:'&nbsp;'}</th>
					<td style="width:230px">
						{assign var=statut value=$listePr.$periode.statut|default:'indetermine'}
						<button class="btn btn-large btn-block {$statut}" type="button">
							<span class="visible-xs">{$unEleve.nom|truncate:12:'..'} {$unEleve.prenom|truncate:3:'.'}</span>
							<span class="visible-sm visible-md visible-lg">{$unEleve.nom|truncate:20:'...'|default:'&nbsp;'} {$unEleve.prenom|default:'&nbsp;'}</span>
						</button>
					</td>
			
					{* on passe les différentes périodes existantes en revue *}
					{foreach from=$lesPeriodes item=noPeriode}
						{assign var=statut value=$listePr.$noPeriode.statut|default:''}
						<td class="{$statut}
							{if $noPeriode==$periode} now{else} notNow{/if}
							{if (in_array($statut, array('sortie','signale','justifie','renvoi'))) && $noPeriode==$periode} lock{/if}"
							id="lock-{$matricule}_periode-{$noPeriode}">
							
							{if ($noPeriode == $periode)}
								{if (in_array($statut, array('sortie','signale','justifie','renvoi')))}
									<span class="glyphicon glyphicon-lock" title="absence déjà signalée"></span>
									<input type="hidden"
										   value="{$statut}"
										   name="matr-{$matricule}_periode-{$noPeriode}"
										   class="cb"
										   id="matr-{$matricule}_periode-{$noPeriode}"
										   disabled>
								{else}
									<input type="hidden"
										   value="{$statut}"
										   name="matr-{$matricule}_periode-{$noPeriode}"
										   class="cb">
										<strong>{$noPeriode}</strong>
								{/if}
								{else}
								<strong>{$noPeriode}</strong>
							{/if}
							
						</td>
					{/foreach}  {* $lesPeriodes *}
				</tr>
			{/foreach}  {* $liste *}
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
			$("#save").html("<img src='../images/disk.png' alt='S'>");
			if (!(modifie)) {
				modifie = true;
				window.onbeforeunload = function(){
					var confirmation = confirm(confirmationBeforeUnload);
					$("#wait").hide();
					return confirmation;
					};
				}
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
			var ligne = $(this).closest('tr');
			var cb = ligne.find('input:hidden');
			// input 'disabled' si l'absence est connue
			if (cb.attr('disabled') != 'disabled') {
				var statut = cb.val();
				if (statut == 'absent') 
					cb.val('present');
					else cb.val('absent');
			
				var newStatut = cb.val();
				ligne.find('button').removeClass().addClass('btn btn-large btn-block').addClass(newStatut);
				var periode = $("#periode").val()
				ligne.find('td').eq(periode).removeClass().addClass(newStatut+' now');
				
				var nbAbs = $(".now.absent").length+$(".now.signale").length+$(".now.sortie").length+$(".now.justifie").length+$(".now.renvoi").length;
				var nbPres = $("input.cb").length - nbAbs;
				$("#nbAbs").text(nbAbs);
				$("#nbPres").text(nbPres);
				}
			})
		
		$(".lock").click(function(event){
			$("#verrou").text($(this).attr('id'));
			$("#confirmeVerrou").modal('show');
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

	})

</script>


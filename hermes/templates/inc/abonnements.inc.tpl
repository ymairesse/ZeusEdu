<div class="container-fluid">

	<div class="row">

		<div class="col-md-4 col-sm-12">

			<form name="formStatut" id="formStatut">
				<h3>Statut de vos listes personnelles</h3>
				<table class="table table-condensed">
					<tr>
						<th>Nom de la liste</td>
						<th>Privée</td>
						<th>Publiée</td>
						<th style="width:2em;">&nbsp;</th>
					</tr>
					<tbody id="statutsPerso">
						{include file="inc/statutsListePerso.tpl"}
					</tbody>
				</table>

				<div class="clearfix"></div>

				{if $abonnesDe != Null}
					<h3>Vos abonnés</h3>
					<table class="table table-condensed table-striped">
					{foreach from=$abonnesDe key=id item=data}
						<tr>
							<th data-container="body" title="{$data.abonnes|count} abonne(s)">{$data.nomListe}</th>
						</tr>
						<tr>
							<td>
							{foreach from=$data.abonnes item=unAbonne}
								{$unAbonne}&nbsp;
							{/foreach}
							</td>
						</tr>
					{/foreach}
					</table>
					{/if}
			</form>
		</div>


		<div class="col-md-8 col-sm-12">
				<form name="formAbonnement" id="formAbonnement">
				<h3>Abonnement / désabonnement aux listes</h3>
					<h4>Vous êtes abonné·e à</h4>
					<table class="table table-condensed table-striped">
						<tr>
							<th style="width:30%">Nom de la liste</th>
							<th style="width:30%">Propriétaire</th>
							<th style="width:20%">Désabonnement</th>
							<th style="width:20%">Appropriation</th>
						</tr>
						<tbody id="listeAbonnements">

							{include file="inc/listeAbonnements.tpl"}

						</tbody>
					</table>

					<h4>Vous pourriez vous abonner à</h4>
					<table class="table tabl-condensed table-striped">
						<tr>
							<th style="width:30%">Nom de la liste</th>
							<th style="width:30%">Propriétaire</th>
							<th style="width:20%">Abonnement</th>
							<th style="width:20%">Appropriation</th>
						</tr>
						<tbody id="listesDisponibles">

							{include file="inc/listeDisponibles.tpl"}

						</tbody>
					</table>
				{foreach from=$listeAbonne key=id item=data}
				<input type="hidden" name="liste_{$id}" value="{$data.nomListe}">
				<input type="hidden" name="proprio_{$id}" value="{$data.proprio}">
				{/foreach}
				{foreach from=$listePublie key=id item=data}
				<input type="hidden" name="liste_{$id}" value="{$data.nomListe}">
				<input type="hidden" name="proprio_{$id}" value="{$data.proprio}">
				{/foreach}

				</form>
				<p style="clear:both"></p>

			</div>  <!-- col-md-... -->

	</div>  <!-- row -->

</div>  <!-- container  -->

<script type="text/javascript">

	$(document).ready(function(){

		$('.btn-editListe').click(function(){
			var idListe = $(this).closest('tr').data('idliste');
			var nomListe = $(this).closest('tr').find('input.nomListe').val();
			var statut = $(this).closest('tr').find('input:radio:checked').val();
			$.post('inc/editListe.inc.php', {
				idListe: idListe,
				nomListe: nomListe,
				statut: statut
			}, function(resultat){
				var title = 'Modification de la liste';
				switch (resultat) {
					case '-1':
						var message = 'Cette liste ne vous appartient pas';
						break;
					case '0':
						var message = 'Aucune modification enregistrée';
						break;
					case '1':
						var message = 'Modification enregistrée';
						break;
				}
				// rafraichissement de la liste des listes (cadre de gauche)
				$.post('inc/listeListes.inc.php', {
				}, function(resultat){
					$('#listeListes').html(resultat);
					// rafraichissement du choix des listes dans la gestion des membres
					$.post('inc/getChoixListe.inc.php', {
					}, function(resultat){
						$('#choixListe').html(resultat);
						$('#nomListe').val('');
					})
				});
				bootbox.alert({
					title: title,
					message: message
				});
			})
		})

	})

</script>

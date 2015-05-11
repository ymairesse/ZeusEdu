<div class="container">

	<div class="row">
		
		<div class="col-md-4 col-sm-12">
			
			<form name="formStatut" method="POST" action="index.php" id="formStatut" class="form-vertical" role="form">
				<h4>Statut de vos listes personnelles</h4>
				<table class="table table-condensed">
					<tr>
						<th>Nom de la liste</td>
						<th>Privée</td>
						<th>Publiée</td>
					</tr>
					{foreach from=$listesPerso key=idListe item=liste}
					<tr>
						<td data-container="body" title="{$liste.membres|count|default:0} membres|{foreach from=$liste.membres key=acronyme item=wtf}{$acronyme} {/foreach}">
							<input type="text" name="nomListe_{$idListe}" maxlength="32" value="{$liste.nomListe}" class="form-control">
						</td>
						<td style="text-align:center">
							<input type="radio" name="statut_{$idListe}" {if $liste.statut == 'prive'}checked="checked"{/if} value="prive">
						</td>
						<td style="text-align:center">
							<input type="radio" name="statut_{$idListe}" {if $liste.statut == 'publie'}checked="checked"{/if} value="publie">
						</td>
					</tr>
					{/foreach}
				</table>
				<input type="hidden" name="action" value="{$action}">
				<input type="hidden" name="mode" value="statutListe">
				<input type="hidden" name="onglet" class="onglet" value="{$onglet|default:0}">
				<div class="btn-group pull-right">
					<button type="reset" name="reset" class="btn btn-default">Annuler</button>
					<button type="submit" name="submit" class="btn btn-primary">Enregistrer</button>					
				</div>
				{if $abonnesDe != Null}
					<h5>Vos abonnés</h5>
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
				<form name="formAbonnement" id="formAbonnement" method="POST" action="index.php">
				<h4>Abonnement / désabonnement aux listes</h4>
					<h5>Vos abonnements</h5>
					<table class="table table-condensed table-striped">
						<tr>
							<th>Nom de la liste</th>
							<th>Propriétaire</th>
							<th>Désabonnement</th>
							<th>Appropriation</th>
						</tr>
						{foreach from=$listeAbonne key=id item=data}
						<tr>
								<td data-container="body" title="{$liste.membres|count|default:0} membres|{foreach from=$liste.membres key=acronyme item=wtf}{$acronyme} {/foreach}">{$data.nomListe}</td>
								<td>{$data.proprio}</td>
								<td>Se désabonner <input type="checkbox" name="desabonner[]" value="{$id}"></td>
								<td>S'approprier <input type="checkbox" name="approprier[]" value="{$id}"</td>
						</tr>
					{/foreach}
					</table>
					<h5>Listes disponibles</h5>
					<table class="table tabl-condensed table-striped">
						<tr>
							<th>Nom de la liste</th>
							<th>Propriétaire</th>
							<th>Abonnement</th>
							<th>Appropriation</th>
						</tr>
						{foreach from=$listePublie key=id item=data}
						<tr>
								<td data-container="body" title="{$liste.membres|count|default:0} membres|{foreach from=$liste.membres key=acronyme item=wtf}{$acronyme} {/foreach}">{$data.nomListe}</td>
								<td>{$data.proprio}</td>
								<td>S'abonner <input type="checkbox" name="abonner[]" value="{$id}"></td>
								<td>S'approprier <input type="checkbox" name="approprier[]" value="{$id}"</td>
						</tr>
					{/foreach}
					</table>
				{foreach from=$listeAbonne key=id item=data}
				<input type="hidden" name="liste_{$id}" value="{$data.nomListe}">
				<input type="hidden" name="proprio_{$id}" value="{$data.proprio}">
				{/foreach}
				{foreach from=$listePublie key=id item=data}
				<input type="hidden" name="liste_{$id}" value="{$data.nomListe}">
				<input type="hidden" name="proprio_{$id}" value="{$data.proprio}">
				{/foreach}
				<input type="hidden" name="onglet" class="onglet" value="{$onglet|default:0}">
				<input type="hidden" name="action" value="{$action}">
				<input type="hidden" name="mode" value="abonnement">
				<div class="btn-group pull-right">
					<button type="reset" class="btn btn-default">Annuler</button>
					<button type="submit" class="btn btn-primary">Enregistrer</button>
				</div>					
				</form>
				<p style="clear:both"></p>

			</div>  <!-- col-md-... -->

	</div>  <!-- row -->

</div>  <!-- container  -->
<div class="gauche">
	<form name="formStatut" method="POST" action="index.php" id="formStatut">
	<h4>Statut de vos listes personnelles</h4>
	<table class="tableauHermes">
		<tr>
			<th>Nom de la liste</td>
			<th style="text-align:center">Privée</td>
			<th style="text-align:center">Publiée</td>
		</tr>
		{foreach from=$listesPerso key=idListe item=liste}
		<tr>
			<td title="{$liste.membres|count|default:0} membres|{foreach from=$liste.membres key=acronyme item=wtf}{$acronyme} {/foreach}">
				<input type="text" name="nomListe_{$idListe}" size="12" maxlength="32" value="{$liste.nomListe}">
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
	<input type="submit" name="submit" value="Enregistrer" class="fauxBouton">
	<input type="reset" name="reset" value="Annuler">

	{if $abonnesDe != Null}
		<h5>Vos abonnés</h5>
		<table class="tableauHermes">
		{foreach from=$abonnesDe key=id item=data}
			<tr>
				<th title="{$data.abonnes|count} abonne(s)">{$data.nomListe}</th>
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


<div class="droit">
	<form name="formAbonnement" id="formAbonnement" method="POST" action="index.php">
	<h4>Abonnement / désabonnement aux listes</h4>
		<h5>Vos abonnements</h5>
		<table class="tableauHermes">
			<tr>
				<th>Nom de la liste</th>
				<th>Propriétaire</th>
				<th>Désabonnement</th>
				<th>Appropriation</th>
			</tr>
			{foreach from=$listeAbonne key=id item=data}
			<tr>
					<td title="{$liste.membres|count|default:0} membres|{foreach from=$liste.membres key=acronyme item=wtf}{$acronyme} {/foreach}">{$data.nomListe}</td>
					<td>{$data.proprio}</td>
					<td>Se désabonner <input type="checkbox" name="desabonner[]" value="{$id}"></td>
					<td>S'approprier <input type="checkbox" name="approprier[]" value="{$id}"</td>
			</tr>
		{/foreach}
		</table>
		<h5>Listes disponibles</h5>
		<table class="tableauHermes">
			<tr>
				<th>Nom de la liste</th>
				<th>Propriétaire</th>
				<th>Abonnement</th>
				<th>Appropriation</th>
			</tr>
			{foreach from=$listePublie key=id item=data}
			<tr>
					<td title="{$liste.membres|count|default:0} membres|{foreach from=$liste.membres key=acronyme item=wtf}{$acronyme} {/foreach}">{$data.nomListe}</td>
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
	<input type="submit" name="submit" value="Enregistrer" class="fauxBouton">
	<input type="reset" name="reset" value="Annuler">
	</form>
	<p style="clear:both"></p>
</div>

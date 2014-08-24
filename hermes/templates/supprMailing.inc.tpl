{if $listesPerso|count > 0}
	<p>Veuillez sélectionner les liste à supprimer dans la zone de gauche et/ou les destinataires à supprimer à droite.</p>

	<form name="deleteList" id="deleteList" action="index.php" method="POST">
	<div style="float:left">
	<h4 style="margin: 0 0 0.5em 0">Listes complètes</h4>
	{foreach from=$listesPerso key=id item=liste}
		{assign var=membres value=$liste.membres}
		<h4 class="teteListe" title={if $membres != Null}"cliquer pour ouvrir"{else}"liste vide"{/if}>
			<input type="checkbox" class="checkListe" name="liste-{$id}" id="liste-{$id}" value="{$id}">
			{$liste.nomListe} -> {$liste.membres|count} membres</h4>
	{/foreach}
	<p>Destinataires sélectionnés <strong id="selectionDest">0</strong></p>
	<input type="hidden" name="onglet" class="onglet" value="{$onglet|default:0}">
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="delete">
	<input type="submit" name="submit" value="Supprimer" class="fauxBouton">
	<input type="reset" name="Annuler" id="resetDel" value="Annuler">

	</div>

	<div class="blocMails" style="display:none">
	<h4 style="margin: 0 0 0.5em 0">Détails</h4>
	{foreach from=$listesPerso key=id item=liste}
		<div style="display:none" id="blocMails_{$id}">
		<h5 style="padding-top:0">{$liste.nomListe}</h5>
			{assign var=membres value=$liste.membres}
			{if $membres != Null}
				<ul class="listeMails">
				{foreach from=$membres key=acronyme item=prof}
					<li><input class="selecteur mails mailsSuppr" type="checkbox" name="mailing-{$id}_acronyme-{$prof.acronyme}" value="{$prof.acronyme}">
					<span class="label">{$prof.nom|truncate:15:'...'} {$prof.prenom} {$prof.classe|default:''}</span>
					</li>
				{/foreach}
				</ul>
			{/if}
		</div>
	{/foreach}
	</div>
	<p style="clear:both"></p>
	</form>

	{if isset($deleted)}
	<div id="confirmDelete" title="Suppressions">
		{$deleted.nbMailing|default:0} destinataire(s) supprimé(s)<br>
		{$deleted.nbListes|default:0} liste(s) vide(s) supprimée(s)<br>
		<span class="micro">Les listes non vides ne sont pas supprimées</span>
	</div>
	{/if}
{else}
<p>Aucune liste définie</p>
{/if}

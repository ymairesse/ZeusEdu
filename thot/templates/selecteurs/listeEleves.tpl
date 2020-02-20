<option value="">Sélectionner un élève</option>
{if isset($listeEleves)}
	{foreach from=$listeEleves key=leMatricule item=unEleve}
		<option value="{$leMatricule}"{if isset($matricule) && ($leMatricule==$matricule)} selected{/if}>{$unEleve.nom} {$unEleve.prenom}</option>
	{/foreach}
{/if}

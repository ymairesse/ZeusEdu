{if isset($listeEleves)}
<select name="matricule" id="selectEleve" {if isset($size)}size="{$size}"{/if}{if isset($multiple)} multiple{/if}>
	{if (isset($placeHolder) && ($placeHolder != ''))}<option value="">Choisir un élève</option>{/if}
	{if isset($listeEleves)}
		{foreach from=$listeEleves key=leMatricule item=unEleve}
		<option value="{$leMatricule}"{if isset($matricule) && ($leMatricule==$matricule)} selected{/if}>{$unEleve.nom} {$unEleve.prenom}</option>
		{/foreach}
	{/if}
</select>
{/if}

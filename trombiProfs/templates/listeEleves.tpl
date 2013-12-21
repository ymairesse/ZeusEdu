<select id="selectEleve">
	<option value="">Élève</option>
	{foreach from=$listeEleves item=unEleve }
	<option value="{$unEleve.codeInfo}">{$unEleve.nomPrenom}</option> 
	{/foreach}
</select>

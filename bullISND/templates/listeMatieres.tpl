{if isset($listeMatieres)}
<select name="cours" id="matiere" class="form-control">
	<option value=''>Choisir une matière en {$niveau}e</option>
	{foreach from=$listeMatieres key=uneMatiere item=data}
	<option value="{$uneMatiere}"{if isset($cours) && ($uneMatiere == $cours)} selected{/if}>{$data.cours} {$data.statut} {$data.libelle|truncate:30} {$data.nbheures}h</option>
	{/foreach}
</select>
{/if}

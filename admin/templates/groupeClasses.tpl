<fieldset style="clear:both; width:45%; float:left;"><legend>Grouper des classes</legend>

{if $listeGroupes|@count > 0}
<form name="formGroupe" id="formGroupe" action="index.php" method="POST">
<h3>Groupes existants</h3>
<table class="tableauAdmin">
	<tr>
		<th>Nom du groupe</th>
		<th>Formé des classes</th>
		<th>Séparer</th>
	</tr>
{foreach from=$listeGroupes key=nomGroupe item=lesClasses}
	<tr>
		<td><strong>{$nomGroupe}</strong></td>
		<td><strong>{", "|implode:$lesClasses}</strong></td>
		<td><input type="checkbox" name="checkbox_{$nomGroupe}" value="{$nomGroupe}"></td>
{/foreach}
	</tr>
</table>
<div style="float:right">
<input type="submit" name="submit" value="Dégrouper" id="submit">
<input type="reset" name="reset" value="Annuler" id="reset">
<input type="hidden" name="action" value="gestEleves">
<input type="hidden" name="mode" value="unGroup">
</div>
</form>
{/if} 
</fieldset>

<fieldset style="width:45%; float:left;"><legend>DEgrouper des classes</legend>
<form name="form" action="index.php" method="POST">
<h3>Formation de nouveaux groupes de classes</h3>
<label for="classes">Choisir une ou plusieurs classes</label>
<select name="classes[]" size="10" multiple="multiple" id="classes">
	{foreach from=$listeClasses item=classe}
		{if isset($selectedClasses)}
		<option value="{$classe}"{if $classe|@in_array:$selectedClasses} selected{/if}>{$classe}</option>
		{else}
		<option value="{$classe}">{$classe}</option>
		{/if}
	{/foreach}
</select>
<label for="groupe">Groupe à former</label>
<input type="text" name="groupe" id="groupe" value="{$groupe|default:Null}" size="5" maxlength="5">

<input type="hidden" name="action" value="gestEleves">
<input type="hidden" name="mode" value="groupEleve">
<input type="submit" value="Grouper" name="OK">
</form>
</fieldset>

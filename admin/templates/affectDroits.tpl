<div id="selecteur" class="noprint" style="clear:both">
<fieldset style="clear:both"><legend>Affectation des droits en masse</legend>
	<form name="selecteur" id="formSelecteur" method="POST" action="index.php">
		<select multiple name="usersList[]" id="selectMultiUser" size="30">
		{foreach from=$usersList key=abreviation item=prof}
			<option value="{$abreviation}">{$prof.nom} {$prof.prenom} [{$abreviation}]</option>
		{/foreach}
	</select>
		
		
	<select multiple name="applications[]" id="applications" size="10">
		{foreach from=$listeApplications key=nomApplication item=data}
		<option value="{$nomApplication}">{$data.nomLong}</option>
		{/foreach}
	</select>
	<select name="droits" id="droits" size="{$listeDroits|@count}">
		{foreach from=$listeDroits item=unDroit}
			<option value="{$unDroit}">{$unDroit}</option>
		{/foreach}
	</select>
	<input type="hidden" name="mode" value="saveDroits">
	<input type="hidden" name="action" value="gestUsers">
	<input type="submit" value="OK" name="OK" id="envoi">
	</form>
</fieldset>
</div>

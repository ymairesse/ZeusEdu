<fieldset>
    <legend>Regrouper des élèves</legend>
    <form action="{$smarty.server.PHP_SELF}" name="form" id="formGrouper">
		<div id="groupement"></div>
        <label for="classes">Sélection des classes: </label>
		<select name="classes" id="classes" MULTIPLE size="15">
		{foreach from=$listeClasses item=uneClasse}
			<option value="{$uneClasse}">{$uneClasse}</option>
		{/foreach}
		</select>
		<label for="groupe">Groupe à former</label>
        <input type="text" maxlength="6" size="6" name="groupe" id="groupe" />
        <input type="submit" name="grouper" value="Regroupe ces classes" id="btnRegrouper">  
    </form>
</fieldset>


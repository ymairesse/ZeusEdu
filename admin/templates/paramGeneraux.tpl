<h3>Paramètres généraux</h3>
<form name="formParametres" id="formParametres" method="POST" action="index.php">
	{foreach from=$parametres key=parametre item=data}
	<label for="{$parametre}">{$data.label}</label>
	<input type="text" size="{$data.size}" name="{$parametre}" id="{$parametre}" value="{$data.valeur}" title="{$parametre}">
		<span class="micro">{$data.signification}</span><br>
	{/foreach}
	<hr>
	<input type="submit" name="submit" value="Enregistrer">
	<input type="reset" name="reset" value="Annuler">
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	<input type="hidden" name="etape" value="save">
</form>

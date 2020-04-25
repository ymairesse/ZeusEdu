<div class="questionImportante">
<fieldset style="clear:both">
	<legend>Effacement de tous les carnets de cotes</legend>
	<form name="form" id="confirmDel" action="index.php" method="POST">
	<p>Veuillez confirmer la suppresion définitive de tous les carnets de cotes.</p>
	<p>Attention, la décision est irrévocable et touche les carnets de cotes de tous les utilisateurs.</p>
	
	<input type="hidden" name="mode" value="{$mode}">
	<input type="hidden" name="etape" value="{$etape}">
	<input type="hidden" name="action" value="{$action}">
	<input type="submit" value="Supprimer" name="OK" id="envoi">
	</form>
</fieldset>
</div>
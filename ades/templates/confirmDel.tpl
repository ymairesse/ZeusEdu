<div class="questionImportante">
	{assign var=debut value='Veuille confirmer la suppression définitive de '}
<fieldset style="clear:both">
	<legend>Effacement définitif</legend>
	<form name="form" id="confirmDel" action="index.php" method="POST">
	
	
	
	
	<input type="hidden" name="mode" value="{$mode}">
	<input type="hidden" name="etape" value="{$etape}">
	<input type="hidden" name="action" value="{$action}">
	<input type="submit" value="Supprimer" name="OK" id="envoi">
	</form>
</fieldset>
</div>
<div class="questionImportante">
<fieldset style="clear:both">
	<legend>Effacement de toutes les pondérations</legend>
	<form name="form" id="confirmDel" action="index.php" method="POST">
	<p>Veuillez confirmer la suppresion définitive de toutes les pondérations.</p>
	<p>Attention, la décision est irrévocable. Il ne faut plus utiliser cette fonction après le début de l'année scolaire!!!</p>
	
	<input type="hidden" name="mode" value="{$mode}">
	<input type="hidden" name="etape" value="{$etape}">
	<input type="hidden" name="action" value="{$action}">
	<input type="submit" value="Supprimer" name="OK" id="envoi">
	</form>
</fieldset>
</div>
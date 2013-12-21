<div class="questionImportante">
<fieldset style="clear:both"><legend>Suppression d'un utilisateur</legend>
	<form name="form" id="confirmDel" action="index.php" method="POST">
	<p>Veuillez confirmer la suppresion définitive</p>
	<strong>Utilisateur: {$acronyme}</strong>
	<input type="hidden" name="acronyme" value="{$acronyme}">
	<input type="hidden" name="mode" value="{$mode}">
		<input type="hidden" name="etape" value="{$etape}">
	<input type="hidden" name="action" value="gestUsers">
	<input type="submit" value="Supprimer {$nomPrenom}" name="OK" id="envoi">
	</form>
</fieldset>
</div>

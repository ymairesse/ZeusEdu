<h2>Notices des coordinateurs</h2>
<p>Notice pour le bulletin <strong>{$bulletin}</strong></p>
<p>Année d'étude <strong>{$niveau}</strong></p>
<form method="POST" action="index.php" name="notas">
	<textarea name="notice" cols="80" rows="6" class="ckeditor">{$notice}</textarea><br>
	<input name="Envoyer" value="Enregistrer" type="submit">
	<input type="hidden" name="action" value="nota">
	<input type="hidden" name="etape" value="enregistrer">
	<input type="hidden" name="bulletin" value="{$bulletin}">
	<input type="hidden" name="niveau" value="{$niveau}">
	<input name="Annuler" value="Annuler" type="reset">
</form>
{include file="noticeCoordinateurs.html"}
<h2>Changement de la photo de votre profil</h2>
<form method="post" action="index.php" enctype="multipart/form-data">
	<div style="float:right; width:180px; border: 1px solid red; text-align:center">
	<p>Photo actuelle</p>
	<p><img src="../photosProfs/{$photo}.jpg" width="150px" class="photo"></p>
	</div>
	<div class="notice">
	<p>Vous pouvez envoyer un fichier de taille maximale <strong>{$MAXIMAGESIZE} octets</strong>. Seules les images de type <strong>.jpg</strong> sont autorisées</p>
	<p>Recherchez l'image à envoyer sur votre ordinateur puis cliquez sur le bouton "Envoyer le fichier"</p>
	<p>Il sera peut-être nécessaire de rafraîchir la page après confirmation de la réception de la nouvelle photo</p>
	</div>
	<h3>Sélectionnez une photo</h3>
	<p><input type="file" name="nomFichier" id="nomFichier">
	<input type="hidden" name="MAX_FILE_SIZE" value="60000"></p>
	<input type="hidden" name="action" value="photo">
	<input type="hidden" name="mode" value="confirmer">
	<input type="submit" name="submit" value="Envoyer le fichier">
</form>

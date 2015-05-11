<div class="container">
	
<h2>Changement de la photo de votre profil</h2>
<form method="post" action="index.php" enctype="multipart/form-data">
	<div class="row">
		<div class="col-md-5 col-sm-6">
			<h3>Sélectionnez une photo</h3>
			<input type="file" name="nomFichier" id="nomFichier">
			<input type="hidden" name="MAX_FILE_SIZE" value="60000">
			<input type="hidden" name="action" value="photo">
			<input type="hidden" name="mode" value="confirmer">
			<button type="submit" class="btn btn-primary pull-right">Envoyer le fichier</button>
		</div>
		
		<div class="col-md-3 col-sm-6"
			<p>Photo actuelle</p>
			<p><img src="../photosProfs/{$photo}.jpg" class="photo img-responsive"></p>
		</div>

		<div class="col-md-4 col-sm-12">
			<div class="notice">
				<p>Vous pouvez envoyer un fichier de taille maximale <strong>{$MAXIMAGESIZE} octets</strong>. Seules les images de type <strong>.jpg</strong> sont autorisées</p>
				<p>Recherchez l'image à envoyer sur votre ordinateur puis cliquez sur le bouton "Envoyer le fichier"</p>
				<p>Il sera peut-être nécessaire de rafraîchir la page après confirmation de la réception de la nouvelle photo</p>
			</div>
		</div>  <!-- col-md ... -->		
	
	</div> <!-- row -->
</form>

</div>  <!-- container -->	
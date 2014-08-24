<script type="text/javascript" src="../ckeditor/ckeditor.js"></script>
<p>Éditez le texte de la signature ici.</p>
<ul>
	<li>La mention <strong>##expediteur##</strong> sera automatiquement remplacée par le nom de l'utilisateur</li>
	<li>la mention <strong>##mailExpediteur##</strong> sera remplacée par son adresse de courrier électronique</li>
</ul>
<form name="editeur" method="POST" action="index.php">
	<input type="submit" name="submit" value="Enregistrer" class="fauxBouton">
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="enregistrer">
	<textarea id="signature" name="signature" cols="80" rows="15" class="ckeditor" placeholder="Frappez votre texte ici" autofocus="true">{$signature}</textarea>
</form>

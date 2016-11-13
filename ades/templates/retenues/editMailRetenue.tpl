<script type="text/javascript" src="../ckeditor/ckeditor.js"></script>

<div class="container">

	<div class="row">

		<div class="col-md-9 col-sm-12">

			<div class="panel">

				<div class="panel-header">
					<h3>Éditez le texte type du mail ici.</h3>
				</div>

				<form role="form" name="editeur" method="POST" action="index.php">
					<button type="submit" class="btn btn-primary pull-right" name="submit">Enregistrer</button>
					<input type="hidden" name="action" value="{$action}">
					<input type="hidden" name="mode" value="{$mode}">
					<input type="hidden" name="etape" value="enregistrer">
					<textarea id="mailRetenue" name="mailRetenue" cols="80" rows="15" class="ckeditor" placeholder="Frappez votre texte ici" autofocus="true">{$signature}</textarea>
				</form>

			</div>  <!-- panel -->

		</div>  <!-- col-sm-... -->

		<div class="col-md-3 col-sm-12">

				<div class="notice">
					<p>Ce texte figure dans le mail envoyé avec chaque billet de retenue. Il est éventuellement encore personnalisable par l'utilisateur avant chaque envoi.<br>
						Seul l'administrateur peut modifier le texte "type".
					</p>
				</div>

		</div>  <!-- col-md-... -->

	</div>  <!-- row -->

</div>  <!-- container -->

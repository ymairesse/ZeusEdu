<script type="text/javascript" src="../ckeditor/ckeditor.js"></script>

<div class="container">
	
	<div class="row">
		
		<div class="col-md-9 col-sm-12">
			
			<div class="panel">
				
				<div class="panel-header">
					<h3>Éditez le texte de la signature ici.</h3>
				</div>
		
				<form role="form" name="editeur" method="POST" action="index.php">
					<button type="submit" class="btn btn-primary pull-right" name="submit">Enregistrer</button>
					<input type="hidden" name="action" value="{$action}">
					<input type="hidden" name="mode" value="enregistrer">
					<textarea id="signature" name="signature" cols="80" rows="15" class="ckeditor" placeholder="Frappez votre texte ici" autofocus="true">{$signature}</textarea>
				</form>
			
			</div>  <!-- panel -->
			
		</div>  <!-- col-sm-... -->
		
		<div class="col-md-3 col-sm-12">
			
				<div class="notice">
					<ul class="list-unstyled">
						<li>La mention <strong>##expediteur##</strong> sera automatiquement remplacée par le nom de l'utilisateur</li>
						<li>La mention <strong>##mailExpediteur##</strong> sera remplacée par son adresse de courrier électronique</li>
					</ul>
				</div>

		</div>  <!-- col-md-... -->

	</div>  <!-- row -->

</div>  <!-- container -->
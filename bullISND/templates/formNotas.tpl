<div class="container">
	
	<div class="row">
		
		<div class="col-md-9 col-sm-12">
			
			<h2>Notices des coordinateurs</h2>
			<p>Notice pour le bulletin <strong>{$bulletin}</strong></p>
			<p>Année d'étude <strong>{$niveau}</strong></p>
			<form method="POST" action="index.php" name="notas" class="form-vertical" role="form">
				<button type="submit" class="btn btn-primary pull-right">Enregistrer</button>				
				<textarea name="notice" rows="6" class="ckeditor form-control">{$notice}</textarea><br>
				<input type="hidden" name="action" value="nota">
				<input type="hidden" name="etape" value="enregistrer">
				<input type="hidden" name="bulletin" value="{$bulletin}">
				<input type="hidden" name="niveau" value="{$niveau}">
			</form>
			
		</div>  <!-- col-md... -->
		
		<div class="col-md-3 col-sm-12">
			
		{include file="noticeCoordinateurs.html"}
		
		</div>  <!-- col-md... -->  

	</div>  <!-- row -->
	
</div>  <!-- container -->
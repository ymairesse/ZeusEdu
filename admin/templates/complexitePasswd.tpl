<div class="container">
	
<h3>Mots de passe élèves</h3>

<div class="row">
	
	<div class="col-md-4 col-sm-6">
		
		<form name="complexite" id="complexite" action="index.php" method="POST" class="form-vertical" role="form">
			<p>Choix de la longueur des mots de passe: entre 3 et 12 caractères</p>
			<div class="input-group">
				<label for="longueur">Longueur</label>
				<input type="text" name="longueur" id="longueur" maxlenght="2" class="form-control">
			</div>
			<button type="submit" class="btn btn-primary">Enregistrer</button>
			<input type="hidden" name="action" value="{$action}">
			<input type="hidden" name="mode" value="{$mode}">
			<input type="hidden" name="etape" value="save">
		</form>

	</div>  <!-- col-md-... -->
	
	<div class="col-md-4 col-sm-6">
		
		<div class="notice">Attribution de mot de passe aux élèves qui en sont encore dépourvus.</div>
		
	</div>

</div>  <!-- row -->

</div>  <!-- container -->


<script type="text/javascript">

	$(document).ready(function(){

		$( "#complexite" ).validate({
			rules: {
				longueur: {
					required: true,
					min: 3,
					max: 12
				}
			},
		errorElement: "span"
		});
	})

</script>

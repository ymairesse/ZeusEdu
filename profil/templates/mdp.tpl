<div class="container">

<fieldset style="clear:both">
	
	<legend>Informations Professionnelles</legend>
	<form role="form" method="post" action="index.php" name="formMdp" id="formMdp" autocomplete="off" class="form-vertical">
		<p><strong>{$identite.nom} {$identite.prenom}</strong></p>

		<div class="row">
		
			<div class="col-md-4 col-sm-12">
		
				<div class="form-group">
					<label for="mdp" class="sr-only">Mot de passe:</label>
					<input maxlength="12" name="mdp" class="form-control" id="mdp" type="password" placeholder="Mot de passe" required>
					<div class="help-group">Votre mot de passe (6 à 12 caractères)</div>
				</div>
				
				<div class="form-group">
					<label for="mdp2" class="sr-only">Confirmation:</label>
					<input maxlength="12" name="mdp2" id="mdp2" class="form-control" type="password" placeholder="Confirmation" required>
					<div class="help-group">Confirmation de votre mot de passe</div>
				</div>
				
				<div class="btn-group pull-right">
					<button class="btn btn-default" type="reset">Annuler</button>
					<button class="btn btn-primary" type="submit">Modifier</button>
				</div>
				<input type="hidden" name="action" value="{$action}">
				<input type="hidden" name="mode" value="modifier">

			</div>  <!-- col-md-... -->
			
			<div class="col-md-8 col-sm-12">
				
				<div class="notice">
					<p>De la force de votre mot de passe dépend fortement l'intégrité de l'application et la sécurité d'informations confidentielles.</p>
					<p>Il est hautement recommandé que votre mot de passe:</p>
					<ul>
						<li>ne soit pas trop court (6 caractères est vraiment un minimum)</li>
						<li>ne soit pas un mot d'un dictionnaire</li>
						<li>ne soit pas un nom de personne</li>
						<li>contienne des lettres (mélange de majuscules et de minuscules) et des chiffres</li>
						<li>contienne des signes "spéciaux" (ponctuation, symboles divers)</li>
					</ul>
				</div>
			</div>
		
		</div>  <!-- row -->
		
    </form>
	
</fieldset>

</div>  <!-- container -->

<script type="text/javascript">
	

$(document).ready (function() {
    
    $("#formMdp").validate({
        rules: {
            mdp2: {
				required: true,
				equalTo:"#mdp",
				minlength: 6,
				maxlength: 12
				},
			mdp : {
				required: true,
      			minlength: 6,
      			maxlength: 12
				}
        },
		highlight: function(element) {
			$(element).closest('.control-group').removeClass('has-success').addClass('has-error');
			},
		success: function(element) {
			element.closest('.control-group').removeClass('has-error').addClass('has-success');
			},
		errorElement: 'span',
		errorClass: 'help-block',
		errorPlacement: function(error, element) {
			if(element.parent('.control-group').length) {
				error.insertAfter(element.parent());
				} else {
				error.insertAfter(element);
				}
			}
        
    })

})

</script>
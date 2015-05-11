<div class="container">

<form role="form" method="post" action="index.php" name="form1" autocomplete="off" id="formPerso" class="form-vertical">
	
	<fieldset style="clear:both"><legend>Informations Personnelles</legend>
		
		<div class="row">
			
		<div class="col-md-12 col-sm-12">
			<input name="action" type="hidden" value="{$action}">
			<input name="mode" type="hidden" value="{$mode}">
			<button name="submit" class="btn btn-primary pull-right" type="submit">Enregistrer</button>
			<button name="reset" class="btn btn-default pull-right" type="reset">Annuler</button>
		</div>
			
			<div class="col-md-4 col-sm-6 col-xs-12">

				<h4>Identité</h4>
				<dl>
					<dt>Nom d'utilisateur</dt>
						<dd>{$identite.acronyme}
						<input type="hidden" name="acronyme" value="{$identite.acronyme}"></dd>
					<dt>Nom</dt>
						<dd>{$identite.nom}
						<input type="hidden" name="nom" value="{$identite.nom}"></dd>
					<dt>Prénom</dt>
						<dd>{$identite.prenom}
						<input type="hidden" name="prenom" value="{$identite.prenom}"></dd>
					<dt>Sexe:</dt>
						<dd>{if $identite.sexe =="M"}M{else}F{/if}</dd>
				</dl>
				
				<input type="hidden" name="sexe" value="{$identite.sexe}"></p>
				
			</div>
			
			<div class="col-md-4 col-sm-6 col-xs-12">
				
				<h4>Contacts</h4>
				<div class="form-group">
					<label class="sr-only" for="mail">Mail*</label>
					<input type="email" class="form-control" maxlength="40" name="mail" id="mail" value="{$identite.mail}"  required placeholder="adresse mail">
				</div>
				<div class="form-group">
					<label class="sr-only" for="telephone">Téléphone*</label>
					<input maxlength="40" name="telephone" id="telephone" value="{$identite.telephone}" placeholder="Téléphone" class="form-control">
				</div>
				<div class="form-group">
					<label class="sr-only" for="GSM">GSM*</label>
					<input maxlength="40" name="GSM" id="GSM" value="{$identite.GSM}" placeholder="Téléphone portable" class="form-control">
				</div>
				
			</div>
		
			<div class="col-md-4 col-sm-6 col-xs-12">
			<h4>Domicile</h4>
				<div class="form-group">
					<label class="sr-only" for="adresse">Adresse</label>
					<input type="text" maxlength="40" name="adresse" id="adresse" value="{$identite.adresse}" placeholder="Adresse" class="form-control">
				</div>
				<div class="form-group">
					<label class="sr-only" for="codePostal">Code Postal*</label>
					<input type="text" maxlength="6" name="codePostal" id="codePostal" value="{$identite.codePostal}" placeholder="Code postal" class="form-control">
				</div>
				<div class="form-group">
					<label class="sr-only" for="commune">Commune*</label>
					<input type="text" maxlength="40" name="commune" id="commune" value="{$identite.commune}" placeholder="Commune" class="form-control">
				</div>
				<div class="form-group">
					<label class="sr-only" for="pays">Pays*</label>
					<input type="text" maxlength="10" name="pays" id="pays" value="{$identite.pays}" placeholder="Pays" class="form-control">
				</div>
			</div>
		

		</div>  <!-- row -->
		
	</fieldset>
		
</form>

</div> <!-- container -->


<script type="text/javascript">

$(document).ready(function(){
	
		$("#formPerso").validate({
		rules: {
			email: {
				required: true,
				email: true
				},
			adresse: {
				required: true
				},
			codePostal: {
				required: true
				},
			commune: {
				required: true
				},
			pays: {
				required: true
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
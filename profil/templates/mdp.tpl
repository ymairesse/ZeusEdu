<div class="container">

<div class="row">

	<div class="col-md-4 col-sm-12">

		<form id="formPasswd" name="formPasswd" method="POST">

			<div class="panel panel-default">
				<div class="panel-heading">
					<h3 class="panel-title">Changement de mot de passe</h3>
				</div>
				<div class="panel-body">
					<div class="form-group">
						<label for="mdp" class="sr-only">Mot de passe:</label>
						<input maxlength="40" name="mdp1" class="form-control" id="mdp1" type="password" placeholder="Mot de passe" required>
						<div class="help-group">Votre mot de passe (au moins 8 caractères)</div>
					</div>

					<div class="form-group">
						<label for="mdp2" class="sr-only">Confirmation:</label>
						<input maxlength="40" name="mdp2" id="mdp2" class="form-control" type="password" placeholder="Confirmation" required>
						<div class="help-group">Confirmation de votre mot de passe</div>
					</div>


				</div>
				<div class="panel-footer">
					<div class="btn-group pull-right">
						<button class="btn btn-default" type="reset">Annuler</button>
						<button class="btn btn-primary" type="submit" id="btnSavePwd">Modifier</button>
					</div>
				</div>
			</div>

		</form>

	</div>
	<!-- col-md-... -->

	<div class="col-md-8 col-sm-12">

		<div class="alert alert-warning" id="warning">
			<p><i class="fa fa-exclamation-triangle fa-2x"></i> Votre mot de passe contiendra <strong>au moins 8 caractères</strong> dont, <strong>au moins deux lettres</strong> et <strong>au moins deux chiffres</strong>.</p>
			<p>Il sera formé de moins de 40 caractères</p>
		</div>

		<div class="notice ">
			<p>De la force de votre mot de passe dépend fortement l'intégrité de l'application et la sécurité d'informations confidentielles.</p>
			<p>Il est hautement recommandé que votre mot de passe:</p>
			<ul>
				<li>ne soit pas trop court (8 caractères est vraiment un minimum)</li>
				<li>ne soit pas un mot d'un dictionnaire</li>
				<li>ne soit pas un nom de personne</li>
				<li>contienne des lettres (mélange de majuscules et de minuscules) et des chiffres</li>
				<li>contienne des signes "spéciaux " (ponctuation, symboles divers)</li>
			</ul>
		</div>
	</div>

</div>
<!-- row -->

</div>

<script type="text/javascript ">
	{literal}

	function countLettres(chaine) {
		return (chaine.match(/[a-zA-Z]/g) == null) ? 0 : chaine.match(/[a-zA-Z]/g).length;
	}

	function countChiffres(chaine) {
		return (chaine.match(/[0-9]/g) == null) ? 0 : chaine.match(/[0-9]/g).length;
	}

	jQuery.validator.addMethod('goodPwd', function(value, element) {
		// validation longueur
		var condLength = (value.length >= 8);
		// validation 2 chiffres min
		var condChiffres = (countChiffres(value) >= 2)
			// validation 2 lettres min
		var condLettres = (countLettres(value) >= 2)

		var testOK = (condLength && condChiffres && condLettres);
		return this.optional(element) || testOK;
	}, "Complexité insuffisante");

	{/literal}

		$(document).ready(function() {

			$("#formPasswd").validate({
				rules: {
					mdp1: {
						required: true,
						goodPwd: true,
						minlength: 8
					},
					mdp2: {
						equalTo: "#mdp1"
					}
				}
			});

			$("#formPasswd").submit(function(event) {
				var passwd1 = $("#mdp1").val();
				var passwd2 = $("#mdp2").val();
				if (passwd1 == passwd2) {
					$.post('inc/savePasswd.inc.php', {
							passwd1: passwd1,
							passwd2: passwd2
						},
						function(resultat) {
							if (resultat == 1) {
								$("#mdp1, #mdp2").val('');
								alert('Votre mot de passe a été changé')
							}
							else alert(resultat);
						})
				}
				event.preventDefault();
			})

		})
</script>

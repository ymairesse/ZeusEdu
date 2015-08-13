<!DOCTYPE html>
<head>
<meta charset="utf-8">
<title>{$titre}</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="menu.css" type="text/css" media="screen">
<link type="text/css" media="all" rel="stylesheet" href="bootstrap/css/bootstrap.css">

<script type="text/javascript" src="js/jquery-2.1.3.min.js"></script>
<script type="text/javascript" src="bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript" src="js/jquery.validate.js"></script>

<link rel="stylesheet" href="screen.css" type="text/css" media="screen">
<link rel="stylesheet" href="print.css" type="text/css" media="print">

</head>
<body>

<div class="container">

	<div class="vertical-align">

	<div class="row">

		{if (isset($message) && $message == 'logout')}
		<div class="alert alert-dismissible alert-success auto-fadeOut">
			<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
			<p>Votre session est terminée. Veuillez vous reconnecter pour poursuivre le travail.</p>
		</div>
		{/if}

		{if (isset($message) && $message == 'erreurMDP')}
		<div class="alert alert-dismissable alert-danger">
			<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
			<p>Nom d'utilisateur ou mot de passe incorrect</p>
			<p>Votre tentative d'accès, votre adresse IP et le nom de votre fournisseur d'accès ont été enregistrés.</p>
			<p>Les administrateurs ont été prévenus.</p>
		</div>
		{/if}

		<div class="col-md-offset-1 col-md-5 col-sm-12">

			<h4>{$titre}</h4>

			<form class="form-vertical" role="form" id="login" action="login.php" method="POST">
				<fieldset>
					<legend>Veuillez vous identifier</legend>

					<div class="form-group">
						<label for="name" class="control-label sr-only">Nom d'utilisateur</label>
						<input type="text" id="acronyme" name="acronyme" class="form-control input-lg" placeholder="Nom d'utlisateur" autocomplete="off">
						<span class="help-group">En 3 lettres</span>
					   </div>

					<div class="form-group">
						<label for="name" class="control-label sr-only">Mot de passe</label>
							<input type="password" id="mdp" name="mdp" class="form-control input-lg" placeholder="Mot de passe" autocomplete="off">
							<span class="help-group">Au moins 6 caractères</span>
					   </div>

					<br class="clearfix">
						<div class="btn-group pull-right">
							<button class="btn btn-default btn-lg" type="reset">Annuler</button>
							<button class="btn btn-primary btn-lg" type="submit">Connexion</button>
						</div>
					<br class="clearfix">
					<a href="mdp/index.php">Ciel! J'ai perdu mon mot de passe</a>
					</button>

				</fieldset>
			</form>

		</div>  <!-- col-md- -->

		<div class="col-md-5 col-sm-12">
			<h4>Avertissement!</h4>
			<p><span class="glyphicon glyphicon-warning-sign" style="font-size:2em"></span> Cette application gère des données privées et strictement confidentielles. Toute tentative d'accès sans autorisation est <a href="#" id="popModal" title="Cliquer pour plus d'informations">punissable au sens de la Loi</a>.
			<p><span class="glyphicon glyphicon-eye-open" style="font-size:2em"></span> Votre adresse IP: {$identification.ip}. Votre passage est enregistré.</p>
		</div>  <!-- col-md -->

	</div>  <!-- row -->


	<div class="modal fade" id="dialogueRenvoiMdp" tabindex="-1" role="dialog" aria-labelledby="dialogueRenvoiMdp" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h4 class="modal-title">Changer mon mot de passe</h4>
				</div>
				<div class="modal-body">
					<p>Souhaitez-vous choisir un nouveau mot de passe? Un lien vous sera envoyé sur votre adresse mail professionnelle.</p>

					<form name="renvoiMDP" id="renvoiMDP" action="index.php" methode="POST" role="form" class="form-vertical">
						<div class="form-group">
							<label for="user">Nom d'utilisateur</label>
							<input type="text" name="acronyme" id="acro" maxlength="3" placeholder="nom d'utilisateur" class="form-control">
							<div class="help-block">Veuillez indiquer votre nom d'utilisateur</div>
						</div>

						<div class="form-group">
							<label>Votre adresse IP</label>
							<p class="form-control-static">Adresse IP: {$identification.ip} ({$identification.hostname})</p>
							<div class="help-block">Cette adresse vous identifie sur l'Internet. Elle est enregistrée.</div>
						</div>
					</form>

				</div>  <!-- modal-body -->
				<div class="modal-footer">
					<button type="reset" class="btn btn-default" data-dismiss="modal">Annuler</button>
					<button type="submit" class="btn btn-primary" id="okRenvoi">Envoyer</button>
				</div>  <!-- modal-footer -->
			</div>  <!-- modal-content -->
		</div>  <!-- modal-dialog -->
	</div>  <!-- dialogueRenvoiMdp -->



	<div class="modal fade" id="confirmMail" tabindex="-1" role="dialog" aria-labelledby="confirmMail" aria-hidden="true">

		<div class="mode-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h4>Changement de mot de passe</h4>
				</div>

				<div class="modal-body">
					<p>Un lien vers une adresse qui vous permettra de changer de mot de passe vient d'être envoyé à {$identite.mail}.</p>
					<p>Si vous ne recevez pas ce mail dans les minutes qui viennent, vérifier votre dossier des "Indésirables".</p>
					<p>Attention, le lien qui figure dans ce mail ne fonctionnera que pendant 48h à partir du moment de la demande de changement de mot de passe.<br>
						Passé ce délai, vous devrez faire une nouvelle demande.</p>
				</div>

				<div class="modal-footer">
					<button type="reset" class="btn btn-default" data-dismiss="modal">Fermer cette fenêtre</button>
				</div>
			</div>

		</div>

	</div>


	<div class="modal fade" id="rappelLoi" tabindex="-1" role="dialog" aria-labelledby="rappelLoi" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
				<h4>Rappel de la Loi</h4>
				</div>
				<div class="modal-body">
					{include file="texteLoi.html"}
				</div>  <!-- modal-body -->
				<div class="modal-footer">
					<button type="button" class="btn btn-primary" data-dismiss="modal">J'ai bien compris</button>
				</div>  <!-- modal-footer -->
			</div>  <!-- modal-content -->
		</div>  <!-- modal-dialog -->
	</div>  <!-- rappelLoi -->


		</div>  <!-- vertical-align -->

	</div>  <!-- container -->

{include file="footer.tpl"}

<script type="text/javascript">

window.setTimeout(function() {
    $(".auto-fadeOut").fadeTo(500, 0).slideUp(500, function(){
        $(this).remove();
	    });
	}, 3000);

$(document).ready (function() {

	$("input:enabled").eq(0).focus();

	$("input").not(".autocomplete").attr("autocomplete","off");

	$("#login").validate({
		rules: {
			acronyme: {
				required:true,
				minlength:3,
				maxlength:3
				},
			mdp: {
				required:true,
				minlength:6
				}
			},
		errorElement: 'span',
		errorClass: 'error'
		})

	$(".pop").popover({ trigger:'hover' });

	$("#popModal").click(function(){
		$("#rappelLoi").modal('show');
		})

	$("#okRenvoi").click(function(){
		var acronyme = $("#acro").val().toUpperCase();
		if (acronyme != '') {
			$.post('inc/renvoimdp.inc.php', {
				acronyme: acronyme
				},
				function(resultat) {
					$("#dialogueRenvoiMdp").modal('hide');
					$("#infoMDP").find('.mdp').text(resultat);
					$("#infoMDP").show();
					}
				)
			}
		})

	$("*[title], .tooltip").tooltip();

	})

</script>

</body>
</html>

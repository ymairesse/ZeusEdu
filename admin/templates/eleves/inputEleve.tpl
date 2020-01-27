<div class="container">

	<div class="row">

		<div class="col-md-10 col-sm-12">

			<form method="post" action="index.php" name="formEleve" id="formEleve" class="form-vertical">

				<div class="panel panel-default">
					<div class="panel-heading">
						<h3 class="panel-title">Modifier les données d'un élève</h3>
					</div>

					<div class="panel-body">

						<div class="panel-group" id="accordion">

							{include file='eleves/panneaux/eleve.tpl'}
							{include file='eleves/panneaux/responsable.tpl'}
							{include file='eleves/panneaux/pere.tpl'}
							{include file='eleves/panneaux/mere.tpl'}
							{include file='eleves/panneaux/informatique.tpl'}

						</div>

					</div>
					<div class="panel-footer">
						<div class="btn-group btn-group-sm pull-right">
							<button type="reset" class="btn btn-default" name="annuler">Annuler</button>
							<button class="btn btn-primary" id="enregistrer" type="submit">Enregistrer</button>
						</div>
						<div class="clearfix"></div>
						<input type="hidden" name="action" value="{$action}">
						<input type="hidden" name="mode" value="{$mode}"> {if isset($etape)}
						<input type="hidden" name="etape" value="{$etape}">{/if}
						<input type="hidden" name="recordingType" value="{$recordingType}">
						<input type="hidden" name="laClasse" value="{$laClasse}">
						<input type="hidden" name="userName" value="{$info.user}" id="userName">
						<input type="hidden" name="mailDomain" value="{$eleve.mailDomain}" id="mailDomain">
					</div>
				</div>

			</form>

		</div>

		<!-- col-md-... -->

		<div class="col-md-2 col-sm-12">
			{if isset($eleve.photo)}
			<img src="../photos/{$eleve.photo}.jpg" alt="{$eleve.matricule}" class="photo img-responsive">
			{else}
			<img src="../photos/nophoto.jpg" alt="Pas de photo" class="photo img-responsive">
			{/if}

		</div>
		<!-- col-md-... -->

	</div>
	<!-- row -->

</div>
<!-- container -->

<script type="text/javascript ">
	$.validator.addMethod(
		"dateFr",
		function(value, element) {
			return value.match(/^\d\d?\/\d\d?\/\d\d\d\d$/);
		},
		"date au format jj/mm/AAAA svp"
	);

	// -------------------------------------------------------------------------------------
	// pour des raisons de compatibilité avec Google Chrome et autres navigateurs à base
	// de webkit, il ne faut pas utiliser la règle "date " du validateur jquery.validate.js
	// Elle sera remplacée par la règle "uneDate " dont le fonctionnement n'est pas basé sur
	// le présupposé que le contenu du champ est une date. Google Chrome et Webkit traitent
	// exclusivement les dates au format américain mm-dd-yyyy
	// sans cette nouvelle règle, les dates du type 15-09-2012 sont refusées sous Webkit
	// https://github.com/jzaefferer/jquery-validation/issues/20
	// -------------------------------------------------------------------------------------
	jQuery.validator.addMethod('uneDate', function(value, element) {
		var reg = new RegExp("/ ", "g ");
		var tableau = value.split(reg);
		// ne pas oublier le paramètre de "base" dans la syntaxe de parseInt
		// au risque que les numéros des jours et des mois commençant par "0 " soient
		// considérés comme de l'octal
		// https://developer.mozilla.org/en-US/docs/JavaScript/Reference/Global_Objects/parseInt
		jour = parseInt(tableau[0], 10);
		mois = parseInt(tableau[1], 10);
		annee = parseInt(tableau[2], 10);
		nbJoursFev = new Date(annee, 1, 1).getMonth() == new Date(annee, 1, 29).getMonth() ? 29 : 28;
		var lgMois = new Array(31, nbJoursFev, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
		condMois = ((mois >= 1) && (mois <= 12));
		if (!(condMois)) return false;
		condJour = ((jour >= 1) && (jour <= lgMois[mois - 1]));
		condAnnee = ((annee > 1900) && (annee < 2100));
		var testDateOK = (condMois && condJour && condAnnee);
		return this.optional(element) || testDateOK;
	}, "Date incorrecte ");


	$(document).ready(function() {

		$("#formEleve ").validate({
			rules: {
				nom: {
					required: true
				},
				prenom: {
					required: true
				},
				annee: {
					required: true
				},
				section: {
					required: true
				},
				sexe: {
					required: true
				},
				classe: {
					required: true
				},
				matricule: {
					required: true
				},
				courriel: {
					email: true
				},
				DateNaiss: {
					required: true,
					uneDate: true
				},
			},
			errorElement: "span"
		})

		$('#resetPasswd').click(function(){
			var matricule = $('#matricule').val();
			$.post('inc/eleves/changePasswd.inc.php', {
				matricule: matricule,
			}, function(newPasswd){
				$('#passwd').val(newPasswd);
				bootbox.alert({
					title: 'Changement du mot de passe',
					message: 'Le mot de passe a été changé'
				})
			})

		})

		$("#matricule").keyup(function() {
			var matricule = $(this).val();
			$.get("inc/verifMatricule.php", {
					'matricule': matricule
				},
				function(resultat) {
					if (resultat == true) {
						$("#OK").html('<span style="color:red" title="Déjà utilisé">:o(</span>');
						$("#enregistrer").attr("disabled", "disabled").css("color", "#ccc");
					} else {
						$("#OK").html(':o)');
						$("#enregistrer").removeAttr('disabled').css('color', '');
					}
				})
		})

		$("input, textarea, select").each(function(i, value) {
			$(this).attr("tabindex", i + 1);
		})

		$(".passwd").hide();

		$(".passwd").prev().hover(function() {
			$(".passwd").toggle();
		})

		$('#eye').click(function() {
			var type = $(this).parent().parent().find('input').attr('type');
			if (type == 'password')
				$(this).parent().parent().find('input').attr('type', 'text');
			else $(this).parent().parent().find('input').attr('type', 'password');
		})

		// forcer les majuscules à la sortie des champs de cette class
		$(".text-uppercase").on("blur", function() {
			$(this).val($(this).val().toUpperCase());
		})

	})
</script>

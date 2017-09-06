<?php /* Smarty version Smarty-3.1.13, created on 2017-05-15 10:44:15
         compiled from "./templates/eleves/inputEleve.tpl" */ ?>
<?php /*%%SmartyHeaderCode:55380104259196a5fbf5ab3-30419634%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    '15c88c106a0d1ddc3cd91972d12784903da0c663' => 
    array (
      0 => './templates/eleves/inputEleve.tpl',
      1 => 1494743017,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '55380104259196a5fbf5ab3-30419634',
  'function' => 
  array (
  ),
  'variables' => 
  array (
    'action' => 0,
    'mode' => 0,
    'etape' => 0,
    'recordingType' => 0,
    'laClasse' => 0,
    'eleve' => 0,
  ),
  'has_nocache_code' => false,
  'version' => 'Smarty-3.1.13',
  'unifunc' => 'content_59196a5fc03a97_79971244',
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_59196a5fc03a97_79971244')) {function content_59196a5fc03a97_79971244($_smarty_tpl) {?><div class="container">

	<div class="row">

		<div class="col-md-10 col-sm-12">

			<form method="post" action="index.php" name="formEleve" id="formEleve" class="form-vertical">

				<div class="panel panel-default">
					<div class="panel-heading">
						<h3 class="panel-title">Modifier les données d'un élève</h3>
					</div>

					<div class="panel-body">

						<div class="panel-group" id="accordion">

							<?php echo $_smarty_tpl->getSubTemplate ('eleves/panneaux/eleve.tpl', $_smarty_tpl->cache_id, $_smarty_tpl->compile_id, null, null, array(), 0);?>

							<?php echo $_smarty_tpl->getSubTemplate ('eleves/panneaux/responsable.tpl', $_smarty_tpl->cache_id, $_smarty_tpl->compile_id, null, null, array(), 0);?>

							<?php echo $_smarty_tpl->getSubTemplate ('eleves/panneaux/pere.tpl', $_smarty_tpl->cache_id, $_smarty_tpl->compile_id, null, null, array(), 0);?>

							<?php echo $_smarty_tpl->getSubTemplate ('eleves/panneaux/mere.tpl', $_smarty_tpl->cache_id, $_smarty_tpl->compile_id, null, null, array(), 0);?>
 <?php echo $_smarty_tpl->getSubTemplate ('eleves/panneaux/informatique.tpl', $_smarty_tpl->cache_id, $_smarty_tpl->compile_id, null, null, array(), 0);?>


						</div>

					</div>
					<div class="panel-footer">
						<div class="btn-group btn-group-sm pull-right">
							<button type="reset" class="btn btn-default" name="annuler">Annuler</button>
							<button class="btn btn-primary" id="enregistrer" type="submit">Enregistrer</button>
						</div>
						<div class="clearfix"></div>
						<input type="hidden" name="action" value="<?php echo $_smarty_tpl->tpl_vars['action']->value;?>
">
						<input type="hidden" name="mode" value="<?php echo $_smarty_tpl->tpl_vars['mode']->value;?>
"> <?php if (isset($_smarty_tpl->tpl_vars['etape']->value)){?>
						<input type="hidden" name="etape" value="<?php echo $_smarty_tpl->tpl_vars['etape']->value;?>
"><?php }?>
						<input type="hidden" name="recordingType" value="<?php echo $_smarty_tpl->tpl_vars['recordingType']->value;?>
">
						<input type="hidden" name="laClasse" value="<?php echo $_smarty_tpl->tpl_vars['laClasse']->value;?>
">
					</div>
				</div>

			</form>

		</div>

		<!-- col-md-... -->

		<div class="col-md-2 col-sm-12">
			<?php if (isset($_smarty_tpl->tpl_vars['eleve']->value['photo'])){?>
			<img src="../photos/<?php echo $_smarty_tpl->tpl_vars['eleve']->value['photo'];?>
.jpg" alt="<?php echo $_smarty_tpl->tpl_vars['eleve']->value['matricule'];?>
" class="photo img-responsive">
			<?php }else{ ?>
			<img src="../photos/nophoto.jpg" alt="Pas de photo" class="photo img-responsive">
			<?php }?>

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
<?php }} ?>
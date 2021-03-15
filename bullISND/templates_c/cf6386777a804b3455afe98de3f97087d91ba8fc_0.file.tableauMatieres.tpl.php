<?php
/* Smarty version 3.1.34-dev-7, created on 2021-03-14 19:33:51
  from '/home/yves/www/sio2/peda/bullISND/templates/tableauMatieres.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_604e570f1a26b9_30202757',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    'cf6386777a804b3455afe98de3f97087d91ba8fc' => 
    array (
      0 => '/home/yves/www/sio2/peda/bullISND/templates/tableauMatieres.tpl',
      1 => 1601141711,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
    'file:admin/tableauGestCours.tpl' => 1,
  ),
),false)) {
function content_604e570f1a26b9_30202757 (Smarty_Internal_Template $_smarty_tpl) {
?><div class="container-fluid">

<h3>Création d'un nouveau cours</h3>

<form name="creationCours" id="creationCours" action="index.php" method="POST" role="form" class="form-vertical">

	<div class="row">

		<div class="col-md-2 col-sm-6">
			<div class="form-group">
				<label>Matière</label>
				<p class="form-control-static"><?php echo $_smarty_tpl->tpl_vars['cours']->value;?>
</p>
			</div>
		</div>

		<div class="col-md-2 col-sm-6">
			<?php $_smarty_tpl->_assignInScope('dataCours', $_smarty_tpl->tpl_vars['listeMatieres']->value[$_smarty_tpl->tpl_vars['cours']->value]);?>
			<div class="form-group">
				<label>Libellé</label>
				<p class="form-control-static"><?php echo $_smarty_tpl->tpl_vars['dataCours']->value['libelle'];?>
</p>
			</div>
		</div>

		<div class="col-md-2 col-sm-6">
			<div class="form-group">
				<label>Cadre</label>
				<p class="form-control-static"><?php echo $_smarty_tpl->tpl_vars['dataCours']->value['cadre'];?>
</p>
			</div>
		</div>

		<div class="col-md-2 col-sm-6">
			<div class="form-group">
				<label>Statut</label>
				<p class="form-control-static"><?php echo $_smarty_tpl->tpl_vars['dataCours']->value['statut'];?>
</p>
			</div>
		</div>

		<div class="col-md-2 col-sm-6">
			<div class="form-group">
				<label>Nombre d'heures</label>
				<p class="form-control-static"><?php echo $_smarty_tpl->tpl_vars['dataCours']->value['nbheures'];?>
h</p>
			</div>
		</div>  <!-- col-md-... -->


	</div>  <!-- row -->

	<div class="row">

		<div class="panel panel-default">

			<div class="panel-heading">
				Nouvelle occurrence
			</div>

			<div class="panel-body">

				<div class="col-md-3 col-sm-6">

					<div class="form-group">
						<label>Nouveau cours:</label>
						<p class="form-control-static" id="nouveauCours"><?php echo $_smarty_tpl->tpl_vars['cours']->value;?>
</p>
					</div>

				</div>  <!-- col-md-... -->

				<div class="col-md-4 col-sm-6">

					<div class="form-group">
						<label for="groupe">Groupe [(0)n(x)]</label>
						<input type="text" name="groupe" id="groupe" maxlength="3" class="form-control">
						<div class="help-block">1 ou 2 chiffres puis 0 ou 1 lettre (a, b ou c)</div>
					</div>

					<div class="checkbox">
						<label>
							<input type="checkbox" name="virtuel" id="cbVirtuel" value="1">
							Cours Virtuel
						</label>

						<div class="help-block">
							Les cours "virtuels" n'apparaissent pas au  bulletin
						</div>
					</div>

					<div id="selectLinked">
						<select class="form-control hidden" name="linkedCoursGrp" id="linkedCoursGrp" multiple required>
						</select>
					</div>

				</div>  <!-- col-md-... -->

				<div class="col-md-5 col-sm-6">

					<div class="form-group">
						<label for="profs">Professeur(s)</label>
						<select name="profs[]" id="profs" multiple="multiple" class="form-control" required>
							<option value="">Sélectionner un ou plusieurs noms</option>
							<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeProfs']->value, 'data', false, 'acronyme');
$_smarty_tpl->tpl_vars['data']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['acronyme']->value => $_smarty_tpl->tpl_vars['data']->value) {
$_smarty_tpl->tpl_vars['data']->do_else = false;
?>
							<option value="<?php echo $_smarty_tpl->tpl_vars['acronyme']->value;?>
"><?php echo $_smarty_tpl->tpl_vars['data']->value['nom'];?>
 <?php echo $_smarty_tpl->tpl_vars['data']->value['prenom'];?>
</option>
							<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
						</select>
						<div class="help-block">Touche CTRL enfoncée pour une sélection multiple</div>
					</div>

				</div>  <!-- col-md-... -->

			</div>  <!-- panel-body -->

		</div>	<!-- panel -->

			<button type="submit" class="btn btn-primary pull-right">Enregistrer</button>
			<button type="reset" class="btn btn-default pull-right">Annuler</button>
			<input type="hidden" name="cours" id="matiere" value="<?php echo $_smarty_tpl->tpl_vars['cours']->value;?>
">
			<input type="hidden" name="action" value="<?php echo $_smarty_tpl->tpl_vars['action']->value;?>
">
			<input type="hidden" name="mode" value="<?php echo $_smarty_tpl->tpl_vars['mode']->value;?>
">
			<input type="hidden" name="niveau" value="<?php echo $_smarty_tpl->tpl_vars['niveau']->value;?>
">
			<input type="hidden" name="etape" value="enregistrer">


	</div>  <!-- row -->
</form>

<?php if (!(empty($_smarty_tpl->tpl_vars['listeCoursGrp']->value))) {?>

<h3>Action sur les cours</h3>

	<div id="panneauGestCours">
			<?php $_smarty_tpl->_subTemplateRender("file:admin/tableauGestCours.tpl", $_smarty_tpl->cache_id, $_smarty_tpl->compile_id, 0, $_smarty_tpl->cache_lifetime, array(), 0, false);
?>
	</div>

<?php }?>

<?php if (empty($_smarty_tpl->tpl_vars['listeCoursGrp']->value)) {?>

	<h3>Suppression d'un cours</h3>
	<p>Le cours <strong><?php echo $_smarty_tpl->tpl_vars['cours']->value;?>
 <?php echo $_smarty_tpl->tpl_vars['listeMatieres']->value[$_smarty_tpl->tpl_vars['cours']->value]['statut'];?>
 <?php echo $_smarty_tpl->tpl_vars['listeMatieres']->value[$_smarty_tpl->tpl_vars['cours']->value]['libelle'];?>
 <?php echo $_smarty_tpl->tpl_vars['listeMatieres']->value[$_smarty_tpl->tpl_vars['cours']->value]['nbheures'];?>
h</strong> est orphelin (ni professeur, ni élèves).</p>
	<button type="button" class="btn btn-danger" id="delOrphanCours" data-cours="<?php echo $_smarty_tpl->tpl_vars['cours']->value;?>
">Supprimer ce cours</button>

<?php }?>

</div>

<div id="modal"></div>

<?php echo '<script'; ?>
 type="text/javascript">

	var texteVirtuel = 'Ce cours sera rendu "réel" et apparaîtra au bulletin<br>';
	texteVirtuel += 'Les élèves restent inscrits.'

	$(document).ready(function(){

		$('#delOrphanCours').click(function(){
			var cours = $(this).data('cours');
			$.post('inc/admin/delOrphanCours.inc.php', {
				cours: cours
			}, function(resultat){
				bootbox.alert({
					title : 'Effacement',
					message: 'Le cours '+cours+' a été supprimé',
					callback: function(){
						var prevCours = $('#matiere option:selected').prev().val();
						var nextCours = $('#matiere option:selected').next().val();
						if (nextCours != undefined) {
							// si possible, sélection du cours suivant
							$('#matiere option:selected').next().attr('selected', true);
							}
							else {
								// sinon, si possible sélection du cours précédent
								if (prevCours != undefined) {
									$('#matiere option:selected').prev().attr('selected', true);
								}
								else {
									// sinon, aucune sélection
									$('#matiere').val('');
								}
							}
						$('#envoi').trigger('click');
					}
				})
			})
		})

		$('#panneauGestCours').on('click', '.btn-addEleves', function(){
			var coursGrp = $(this).data('coursgrp');
			$.post('inc/admin/getModalAddEleves.inc.php', {
				coursGrp: coursGrp
			}, function(resultat){
				$('#modal').html(resultat);
				$('#modalSelectEleves').modal('show');
			})
		})
		$('#modal').on('click', '#ajoutEleves', function(){
			var coursGrp = $(this).data('coursgrp');
			var listeEleves = $('#modal #listeEleves option:selected');
			var formulaire = $('#formEleves').serialize();
			$.post('inc/admin/addEleves2cours.inc.php', {
				formulaire: formulaire,
				coursGrp: coursGrp
			}, function(){
				$.post('inc/admin/getListeEleves4coursGrp.inc.php', {
					coursGrp: coursGrp
				}, function(resultat){
					$('#modal #listeElevesCours').html(resultat);
					$.post('inc/admin/tableauGestCours.inc.php', {
						coursGrp: coursGrp
					}, function(resultat){
						$('#panneauGestCours').html(resultat);
					})
				})
			})
		})
		$('#modal').on('click', '#supprEleves', function(){
			var coursGrp = $(this).data('coursgrp');
			var formulaire = $('#formElevesCours').serialize();
			$.post('inc/admin/delElevesFromCoursGrp.inc.php', {
				formulaire: formulaire,
				coursGrp: coursGrp
			}, function(resultat){
				$('#modal #listeElevesCours').html(resultat);
				$.post('inc/admin/tableauGestCours.inc.php', {
					coursGrp: coursGrp
				}, function(resultat){
					$('#panneauGestCours').html(resultat);
				})
			})
		})


		$('#panneauGestCours').on('click', '.btn-addProf', function(){
			var coursGrp = $(this).data('coursgrp');
			$.post('inc/admin/getModalAddProfs.inc.php', {
				coursGrp: coursGrp
			}, function(resultat){
				$('#modal').html(resultat);
				$('#modalSelectProf').modal('show');
			})
		})
		$('#modal').on('click', '#ajoutProfs', function(){
            var coursGrp = $(this).data('coursgrp');
			var formulaire = $('#formProfs').serialize();
			$.post('inc/admin/addProfs2cours.inc.php', {
				formulaire: formulaire,
				coursGrp: coursGrp
			}, function(resultat){
				$.post('inc/admin/getListeProfs4coursGrp.inc.php',{
					coursGrp: coursGrp
				}, function(resultat){
					$('#modal #listeProfsCours').html(resultat);
					$.post('inc/admin/tableauGestCours.inc.php', {
						coursGrp: coursGrp
					}, function(resultat){
						$('#panneauGestCours').html(resultat);
					})
				})
			})
        })
		$('#modal').on('click', '#supprProfs', function(){
			var coursGrp = $(this).data('coursgrp');
			var formulaire = $('#listeProfCours').serialize();
			$.post('inc/admin/delProfsFromCoursGrp.inc.php', {
				formulaire: formulaire,
				coursGrp: coursGrp
			}, function(resultat){
				// restaurer la liste dans la boîte modale
				$('#modal #listeProfsCours').html(resultat);
				$.post('inc/admin/tableauGestCours.inc.php', {
					coursGrp: coursGrp
				}, function(resultat){
					$('#panneauGestCours').html(resultat);
				})
			})
		})

		$('#cbVirtuel').change(function(){
			var matiere = $('#matiere').val();
			if ($('#cbVirtuel').is(':checked')) {
				$.post('inc/admin/getLinkedList.inc.php', {
					matiere: matiere
				}, function (resultat){
					$('#selectLinked').html(resultat);
				})
			}
			else $('#selectLinked').html('');
		})

		$('.btn-virtuel').click(function(){
			var coursGrp = $(this).data('coursgrp');
			var bouton = $(this);
			// nombre de notes au JDC pour les composants du cours virtuel
			$.post('inc/admin/getNbJdc4coursGrp.inc.php', {
				coursGrp: coursGrp
			}, function(nb){
				if (nb == 0) {
					bootbox.confirm({
						title: 'Veuillez confirmer',
						message: texteVirtuel,
						buttons: {
							cancel: {
								label: 'Surtout pas!!',
								className: 'btn-danger'
								},
							confirm: {
								label: 'Oui, je le veux',
								className: 'btn-success'
								}
							},
						callback: function(result){
							if (result == true){
								$.post('inc/admin/saveVirtuel.inc.php', {
									coursGrp: coursGrp,
									virtuel: 0
								}, function(nb){
									bouton.closest('td').next('td').html('');
									bouton.remove();
									bootbox.alert(nb + ' modification(s) enregistrée(s)');
								})
							}
						}
					})
				}
				else {
					bootbox.alert({
						title: 'Opération impossible',
						message: 'Il existe des notes au journal de classe pour au moins un des sous-cours'
					})
				}
			})

		})

		$("#groupe").keyup(function(){
			var groupe = $(this).val();
			var matiere = $("#matiere").val();
			$("#nouveauCours").text(matiere+'-'+groupe);
			})

		$("#creationCours").validate({
				rules: {
					groupe:{
						required: true,
						regex: /^[0]*[1-9]+[a-c]*$/
						},
					profs: {
						required: true
						}
					},
				errorElement: "span"
			});

		$("#supprCours").submit(function(){
			if (!(confirm("La suppression de ce cours est définitive. Veuillez confirmer.")))
				return false;
				else {
					$("#wait").show();
					$.blockUI();
					}

			})

		})

	$.validator.addMethod(
       "regex",
        function(value, element, regexp) {
        var check = false;
        return this.optional(element) || regexp.test(value);
        },
        "format incorrect"
        );

<?php echo '</script'; ?>
>
<?php }
}

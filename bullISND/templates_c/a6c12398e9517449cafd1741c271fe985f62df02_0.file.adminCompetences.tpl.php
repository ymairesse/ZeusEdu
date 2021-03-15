<?php
/* Smarty version 3.1.34-dev-7, created on 2021-03-14 20:13:08
  from '/home/yves/www/sio2/peda/bullISND/templates/adminCompetences.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_604e6044343ca7_05079892',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    'a6c12398e9517449cafd1741c271fe985f62df02' => 
    array (
      0 => '/home/yves/www/sio2/peda/bullISND/templates/adminCompetences.tpl',
      1 => 1607859886,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
    'file:admin/bodyCompetences.tpl' => 1,
  ),
),false)) {
function content_604e6044343ca7_05079892 (Smarty_Internal_Template $_smarty_tpl) {
?><div class="container-fluid">
	<h2>Administration des compétences <?php echo $_smarty_tpl->tpl_vars['cours']->value;?>
</h2>

			<div class="row">

			<div class="col-md-6 col-xs-12">
				<h3>Compétences actuelles</h3>

				<form name="formAdminCompetences" id="formAdminCompetences">

					<table class="table table-condensed" id="tableCompetences">
						<thead>
							<tr>
								<th style="width:1em;">&nbsp;</th>
								<th>Libellé</th>
								<th style="width:5em;">Ordre</th>
							</tr>
						</thead>

						<tbody>

							<?php $_smarty_tpl->_subTemplateRender("file:admin/bodyCompetences.tpl", $_smarty_tpl->cache_id, $_smarty_tpl->compile_id, 0, $_smarty_tpl->cache_lifetime, array(), 0, false);
?>

						</tbody>
						<tfoot>
							<tr>
								<td colspan="3">
									<div class="btn-group btn-group-justified">
										<a href="#" type="button" class="btn btn-success" id="btn-addCompetence">Ajouter une compétence</a>
										<a href="#" type="button" class="btn btn-primary" id="btn-saveCompetences">Enregistrer</a>
									</div>
									<input type="hidden" name="cours" value="<?php echo $_smarty_tpl->tpl_vars['cours']->value;?>
">
								</td>
							</tr>
						</tfoot>
					</table>

				</form>
			</div>

			<div class="col-md-6 col-xs-12">
				<div class="panel panel-info">
					<div class="panel-heading">
						Compétences
					</div>
					<div class="panel-body">
						<p>Pour ajouter une nouvelle compétences, cliquer le bouton "Ajouter une compétence". Un libellé générique est proposé; il suffit de le modifier.</p>
						<p>Les compétences déjà utilisées dans le bulletin ou dans le carnet de cotes ne peuvent être effacées. Le bouton de suppression est désactivé.</p>
						<p>Pour changer l'ordre de présentation des compétences dans le bulletin, ajuster le nombre dans la colonne de droite. Les valeurs ne doivent pas être consécutives.</p>
					</div>

				</div>

			</div>
			<!-- col-md... -->

		</div>
		<!-- row -->

</div>
<!-- container -->

<?php echo '<script'; ?>
 type="text/javascript">
	$(document).ready(function() {
		var nbNewComp = 1;

		$('#formAdminCompetences').validate();

		$('#tableCompetences').on('click', '.btn-delCompetence', function(){
			var cours = $('#cours').val();
			var idComp = $(this).closest('tr').data('idcomp');
			var libelle = $('.lblComp[data-idcomp="'+idComp+'"]').val();
			bootbox.confirm({
				title: 'Suppression d\'une compétence',
				message: 'Veuille confirmer la suppression définitive de la compétence <br>' + libelle,
				callback: function(resultat){
					if (resultat == true) {
						$.post('inc/competences/delCompetence.inc.php', {
							idComp: idComp,
							cours: cours
						}, function(resultat){
							$('#tableCompetences tr[data-idcomp="' + idComp +'"]').remove();
						})
					}
				}
			});
		})

		$('#btn-addCompetence').click(function(){
			var cours = $('#cours').val();
			var libelle = 'Nouvelle compétence ' + nbNewComp;
			$.post('inc/competences/addCompetence.inc.php', {
				cours: cours,
				libelle: libelle
			}, function(resultat){
				if (resultat == -1)
					bootbox.alert({
						title: 'Erreur',
						message: 'Renommez et enregistrez d\'abord la compétence <strong>' + libelle + '</strong>'
					})
					else {
						$('#tableCompetences tbody').append(resultat);
						nbNewComp ++;
					}
			})
		})

		$('#btn-saveCompetences').click(function(){
			if ($('#formAdminCompetences').valid()) {
				var formulaire = $('#formAdminCompetences').serialize();
				$.post('inc/competences/saveCompetences.inc.php', {
					formulaire: formulaire
				}, function(resultat){
					$('#tableCompetences tbody').html(resultat);
					var nb = $('#tableCompetences tbody tr').length;
					bootbox.alert({
						title: 'Enregistrement',
						message: nb + ' compétences enregistrées'
					})
				})
			}
		})

	})
<?php echo '</script'; ?>
>
<?php }
}

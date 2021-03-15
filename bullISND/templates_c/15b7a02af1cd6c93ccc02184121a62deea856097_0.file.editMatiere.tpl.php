<?php
/* Smarty version 3.1.34-dev-7, created on 2021-03-14 18:59:24
  from '/home/yves/www/sio2/peda/bullISND/templates/editMatiere.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_604e4efc09a900_07516508',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '15b7a02af1cd6c93ccc02184121a62deea856097' => 
    array (
      0 => '/home/yves/www/sio2/peda/bullISND/templates/editMatiere.tpl',
      1 => 1615744438,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
    'file:admin/formEditMatiere.tpl' => 1,
  ),
),false)) {
function content_604e4efc09a900_07516508 (Smarty_Internal_Template $_smarty_tpl) {
?><div class="container-fluid">

	<div class="row">
		<div class="col-xs-3">
			<div id="selecteurVertical">

				<div class="form-group">
					<label for="selectNiveau">Niveau d'étude</label>
					<select class="form-control" name="selectNiveau" id="selectNiveau">
						<option value="">Niveau d'étude</option>
						<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeNiveaux']->value, 'unNiveau');
$_smarty_tpl->tpl_vars['unNiveau']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['unNiveau']->value) {
$_smarty_tpl->tpl_vars['unNiveau']->do_else = false;
?>
						<option value="<?php echo $_smarty_tpl->tpl_vars['unNiveau']->value;?>
"<?php if ($_smarty_tpl->tpl_vars['unNiveau']->value == $_smarty_tpl->tpl_vars['niveau']->value) {?> selected<?php }?>><?php echo $_smarty_tpl->tpl_vars['unNiveau']->value;?>
e année</option>
						<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
					</select>
				</div>

				<div id="selectMatiere" class="hidden">

					
				</div>

			</div>
		</div>

		<div class="col-xs-9" id="editMatiere">

			<?php $_smarty_tpl->_subTemplateRender("file:admin/formEditMatiere.tpl", $_smarty_tpl->cache_id, $_smarty_tpl->compile_id, 0, $_smarty_tpl->cache_lifetime, array(), 0, false);
?>

		</div>

	</div>

</div>

<div id="modal">
	<div id="modalInfo" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalInfoLabel" aria-hidden="true">
	  <div class="modal-dialog">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	          <span aria-hidden="true">&times;</span>
	        </button>
	        <h4 class="modal-title" id="modalInfoLabel">Information</h4>
	      </div>
	      <div class="modal-body">

	      </div>

	    </div>
	  </div>
	</div>
</div>

<?php echo '<script'; ?>
 type="text/javascript">

	var invitation = '<p class="avertissement">Veuillez sélectionner un niveau <br>et une matière ci-contre</p>';

	$(document).ready(function(){

		$('#editMatiere').html(invitation);

		$('#selectNiveau').change(function(){
			var niveau = $(this).val();
			$.post('inc/admin/listeCours.inc.php', {
				niveau: niveau
			}, function(resultat){
				$('#selectMatiere').html(resultat).removeClass('hidden');
				$('#editMatiere').html(invitation);
			})
		})

		$('body').on('change', '#matiere', function(){
			var matiere = $(this).val();
			var niveau = $('#niveau').val();
			$.post('inc/admin/getDetailsMatiere.inc.php', {
				matiere: matiere,
				niveau: niveau
			}, function(resultat){
				$('#editMatiere').html(resultat);
			})
		})

		$('body').on('click', '.table .info', function(){
			var texte = $(this).closest('td, th').html();
			$('#modalInfo .modal-body').html(texte);
			$('.modal-body div').removeClass('hidden');
			$('.modal-body button').addClass('hidden');
			$('#modalInfo').modal('show');
		})

		$('body').on('click', '#btn-saveMatiere', function(){
			if ($('#matiereEdit').valid()) {
				var niveau = $('#selectNiveau').val();
				var formulaire = $('#matiereEdit').serialize();
				$.post('inc/admin/saveMatiere.inc.php', {
					formulaire: formulaire
				}, function(resultat){
					var resultatJS = JSON.parse(resultat);
					$.post('inc/admin/listeCours.inc.php', {
						niveau: niveau
					}, function(resultat){
						$('#selectMatiere').html(resultat);
						bootbox.alert({
							title: 'Enregistrement',
							message: '<strong>' + resultatJS.nb + '</strong>' + ' enregistrement pour la matière <strong>' + resultatJS.cours + '</strong>'
						})
					})
				})
			}
		})

		$('body').on('click', '#deleteMatiere', function(){
			var matiere = $('#matiere').val();
			var libelle = $('#libelle').val();
			var titre = 'Suppression d\'une matière';
			var niveau = $('#selectNiveau').val();
			bootbox.confirm({
				title: titre,
				message: 'Veuillez confirmer la suppression du cours [<strong>'+ matiere + '</strong>]<br><strong>' + libelle + '</strong>',
				callback: function(result){
					if (result == true) {
						$.post('inc/admin/delMatiere.inc.php', {
						 	matiere: matiere
							}, function(resultat){
						 	var message;
						 	if (resultat == 1) {
						 	 	message = '<strong>' + matiere + '</strong> : matière supprimée';
								$('#selectMatiere option[value="' + matiere + '"]').remove();
								$('#editMatiere').html(invitation);
						 		}
						 	 	else message = 'Cette matière ne peut pas être supprimée';
						 	bootbox.alert({
						 		title: titre,
						 		message: message
						 	})
						 })
			 		}
				}
			})
		})

		$('body').on('click', "#nouvelleMatiere", function(){
			var newCode = $('#code').val();
			$("#matiereEdit .mod").attr("readonly", false);
			$('#code').attr('placeholder', newCode).val('');
			$("#matiereEdit").css("background-color","#ffff99");
			$("#fullEdition").val(1);
			})

		$("#matiereEdit").validate({
			rules: {
				code: { required: true },
				nbheures: { required: true, number: true },
				libelle: { required: true }
				},
			errorElement: "span"
			});

		$('body').on('keyup', '.mod', function(){
			$(this).val(String($(this).val()).toUpperCase());
			var matiere = $("#leNiveau").val()+$("#forme").val()+':'+$("#code").val()+$("#nbheures").val();
			$("#laMatiere").text(matiere);
		})

	})

<?php echo '</script'; ?>
>


<?php }
}

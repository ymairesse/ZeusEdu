<?php
/* Smarty version 3.1.34-dev-7, created on 2021-03-15 11:23:32
  from '/home/yves/www/sio2/peda/bullISND/templates/choixInit.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_604f35a4279239_28469496',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '6269c977ac93631e8b4ffe3af5ea5ba11fb846fc' => 
    array (
      0 => '/home/yves/www/sio2/peda/bullISND/templates/choixInit.tpl',
      1 => 1562054814,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_604f35a4279239_28469496 (Smarty_Internal_Template $_smarty_tpl) {
?><div class="container">

	<h3>Choix d'initialisation</h3>

	<p>Attention, les commandes <strong class="danger"><span>en rouge</span></strong> ne devraient plus être utilisées après le début de l'année scolaire. Danger de casser le système!!</p>

	<form name="choixInit" id="choixInit" action="index.php" method="POST" role="form" class="form-vertical">
		<ul class="list-unstyled">
			<li>
				<input type="radio" name="mode" value="archivageEleves"<?php if (((isset($_smarty_tpl->tpl_vars['mode']->value))) && ($_smarty_tpl->tpl_vars['mode']->value == 'archivageEleves')) {?> checked<?php }?>>
				<span>Archivage des élèves par classe pour l'année scolaire écoulée</span>
			</li>
			<li class="danger">
				<input type="radio" name="mode" value="resetSituations"<?php if (((isset($_smarty_tpl->tpl_vars['mode']->value))) && ($_smarty_tpl->tpl_vars['mode']->value == 'resetSituations')) {?> checked<?php }?>>
				<span>Initialisation des situations de <?php echo $_smarty_tpl->tpl_vars['ANNEESCOLAIRE']->value;?>
 et des épreuves externes</span>
			</li>
			<li class="danger">
				<input type="radio" name="mode" value="resetDetailsCotes"<?php if (((isset($_smarty_tpl->tpl_vars['mode']->value))) && ($_smarty_tpl->tpl_vars['mode']->value == 'resetDetailsCotes')) {?> checked="checked"<?php }?>>
				<span>Effacement du détail des cotes de <?php echo $_smarty_tpl->tpl_vars['ANNEESCOLAIRE']->value;?>
 par compétences dans les bulletins</span>
			</li>
			<li class="danger">
				<input type="radio" name="mode" value="delProfsElevesCours"<?php if (((isset($_smarty_tpl->tpl_vars['mode']->value))) && ($_smarty_tpl->tpl_vars['mode']->value == 'delProfsElevesCours')) {?> checked="checked"<?php }?>>
				<span>Effacement des liens profs/eleves avec les cours</span>
			</li>
			<li class="danger">
				<input type="radio" name="mode" value="resetHistorique"<?php if (((isset($_smarty_tpl->tpl_vars['mode']->value))) && ($_smarty_tpl->tpl_vars['mode']->value == 'resetHistorique')) {?> checked="checked"<?php }?>>
				<span>Effacement de l'historique des changements de cours</span>
			</li>
			<li class="danger">
				<input type="radio" name="mode" value="resetCommentProfs"<?php if (((isset($_smarty_tpl->tpl_vars['mode']->value)) && ($_smarty_tpl->tpl_vars['mode']->value == 'resetCommentProfs'))) {?> checked="checked"<?php }?>>
					<span>Effacement des commentaires des profs aux bulletins</span>
			</li>
			<li class="danger">
				<input type="radio" name="mode" value="resetCommentTitus"<?php if (((isset($_smarty_tpl->tpl_vars['mode']->value)) && ($_smarty_tpl->tpl_vars['mode']->value == 'resetCommentTitus'))) {?> checked="checked"<?php }?>>
				<span>Effacement des commentaires des titulaires aux bulletins</span>
			</li>
			<li class="danger">
				<input type="radio" name="mode" value="initCarnet"<?php if (((isset($_smarty_tpl->tpl_vars['mode']->value))) && ($_smarty_tpl->tpl_vars['mode']->value == 'initCarnet')) {?> checked="checked"<?php }?>>
					<span>Initialisation du carnet de cotes</span>
			</li>
			<li class="danger">
				<input type="radio" name="mode" value="delPonderations"<?php if (((isset($_smarty_tpl->tpl_vars['mode']->value))) && ($_smarty_tpl->tpl_vars['mode']->value == 'delPonderations')) {?> checked="checked"<?php }?>>
				<span>Suppression de toutes les pondérations des cours</span>
			</li>
			<li class="danger">
				<input type="radio" name="mode" value="ponderations"<?php if (((isset($_smarty_tpl->tpl_vars['mode']->value))) && ($_smarty_tpl->tpl_vars['mode']->value == 'ponderations')) {?> checked="checked"<?php }?>>
				<span>Initialisation des pondérations des cours (penser à supprimer les pondérations avant)</span>
			</li>
			<li class="danger">
				<input type="radio" name="mode" value="resetCoordin"<?php if (((isset($_smarty_tpl->tpl_vars['mode']->value))) && ($_smarty_tpl->tpl_vars['mode']->value == 'resetCoordin')) {?> checked="checked"<?php }?>>
				<span>Effacement des notices coordinateurs</span>
			</li>
			<li class="danger">
				<input type="radio" name="mode" value="resetAttitudes"<?php if (((isset($_smarty_tpl->tpl_vars['mode']->value))) && ($_smarty_tpl->tpl_vars['mode']->value == 'resetAttitudes')) {?> checked="checked"<?php }?>>
				<span>Initialisation des "Attitudes"</span>
			</li>
			<li class="danger">
				<input type="radio" name="mode" value="resetNotifications"<?php if (((isset($_smarty_tpl->tpl_vars['mode']->value))) && ($_smarty_tpl->tpl_vars['mode']->value == 'resetNotifications')) {?> checked="checked"<?php }?>>
				<span>Effacement des notifications de décisions Thot</span>
			</li>
			<li class="danger">
				<input type="radio" name="mode" value="resetEduc"<?php if ((isset($_smarty_tpl->tpl_vars['mode']->value)) && ($_smarty_tpl->tpl_vars['mode']->value == 'resetEduc')) {?> checked<?php }?>>
				<span>Effacement des remarques des éducateurs</span>
			</li>
			<li>
				<input type="radio" name="mode" value="initBulletinThot" <?php if (((isset($_smarty_tpl->tpl_vars['mode']->value))) && ($_smarty_tpl->tpl_vars['mode']->value == 'initBulletinThot')) {?> checked="checked"<?php }?>>
				<span>Réinitialisation des accès aux bulletins dans Thot</span>
			</li>
			<li>
				<input type="radio" name="mode" value="verrous"<?php if (((isset($_smarty_tpl->tpl_vars['mode']->value))) && ($_smarty_tpl->tpl_vars['mode']->value == 'verrous')) {?> checked="checked"<?php }?>>
				<span>Initialisation des verrous des cours</span>
			</li>
			<li>
				<input type="radio" name="mode" value="images"<?php if (((isset($_smarty_tpl->tpl_vars['mode']->value))) && ($_smarty_tpl->tpl_vars['mode']->value == 'images')) {?> checked="checked"<?php }?>>
				<span>Initialisation des images des cours</span>
			</li>
			<li>
				<input type="radio" name="mode" value=""<?php if ((!(isset($_smarty_tpl->tpl_vars['mode']->value))) || ($_smarty_tpl->tpl_vars['mode']->value == '')) {?> checked="checked"<?php }?>>
				Ne rien faire
			</li>
		</ul>
	<input type="hidden" name="action" value="<?php echo $_smarty_tpl->tpl_vars['action']->value;?>
">
	<?php if ((isset($_smarty_tpl->tpl_vars['etape']->value))) {?><input type="hidden" name="etape" value="<?php echo $_smarty_tpl->tpl_vars['etape']->value;?>
"><?php }?>
	<button type="submit" class="btn btn-primary pull-right" name="Submit">Initialiser</button>
	</form>

</div>


<?php echo '<script'; ?>
 type="text/javascript">

$(document).ready(function(){

	$("#choixInit").submit(function(){
		var confirmation = true;
		if ($("#choixInit input:radio:checked").parent().hasClass("danger")) {
			confirmation = confirm("Vous savez ce que vous faites, n'est-ce pas?\nVous avez été assez averti!");
			}
		if (confirmation == true) {
			$.blockUI();
			$("#wait").show();
			}
		else return false;
		})

	})

<?php echo '</script'; ?>
>
<?php }
}

<?php /* Smarty version Smarty-3.1.13, created on 2017-05-15 10:45:06
         compiled from "./templates/selecteurs/selectClasseEleve.tpl" */ ?>
<?php /*%%SmartyHeaderCode:55020079259196a5829fc42-47477873%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    '71ea026778d6636e2a536a30dc132ba933fed94a' => 
    array (
      0 => './templates/selecteurs/selectClasseEleve.tpl',
      1 => 1494837901,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '55020079259196a5829fc42-47477873',
  'function' => 
  array (
  ),
  'version' => 'Smarty-3.1.13',
  'unifunc' => 'content_59196a582b3c64_27895885',
  'variables' => 
  array (
    'listeClasses' => 0,
    'classe' => 0,
    'laClasse' => 0,
    'listeEleves' => 0,
    'matric' => 0,
    'matricule' => 0,
    'eleve' => 0,
  ),
  'has_nocache_code' => false,
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_59196a582b3c64_27895885')) {function content_59196a582b3c64_27895885($_smarty_tpl) {?><div id="selecteur" class="noprint" style="clear:both">
	<form name="formSelecteur" id="formSelecteur" method="POST" action="index.php" class="form-inline">

	<select name="laClasse" id="selectClasse" class="form-control">
		<option value="">Classe</option>
		<?php  $_smarty_tpl->tpl_vars['classe'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['classe']->_loop = false;
 $_from = $_smarty_tpl->tpl_vars['listeClasses']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['classe']->key => $_smarty_tpl->tpl_vars['classe']->value){
$_smarty_tpl->tpl_vars['classe']->_loop = true;
?>
			<option value="<?php echo $_smarty_tpl->tpl_vars['classe']->value;?>
"<?php if ($_smarty_tpl->tpl_vars['classe']->value==$_smarty_tpl->tpl_vars['laClasse']->value){?> selected<?php }?>><?php echo $_smarty_tpl->tpl_vars['classe']->value;?>
</option>
		<?php } ?>
	</select>

	<span id="choixEleve">
		
		<select name="matricule" id="selectEleve" class="form-control">
			<option value="">Choisir un élève</option>
			<?php if (isset($_smarty_tpl->tpl_vars['listeEleves']->value)){?>
				
				<?php  $_smarty_tpl->tpl_vars['eleve'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['eleve']->_loop = false;
 $_smarty_tpl->tpl_vars['matric'] = new Smarty_Variable;
 $_from = $_smarty_tpl->tpl_vars['listeEleves']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['eleve']->key => $_smarty_tpl->tpl_vars['eleve']->value){
$_smarty_tpl->tpl_vars['eleve']->_loop = true;
 $_smarty_tpl->tpl_vars['matric']->value = $_smarty_tpl->tpl_vars['eleve']->key;
?>
				<option value="<?php echo $_smarty_tpl->tpl_vars['matric']->value;?>
"<?php if (isset($_smarty_tpl->tpl_vars['matricule']->value)&&($_smarty_tpl->tpl_vars['matric']->value==$_smarty_tpl->tpl_vars['matricule']->value)){?> selected="selected"<?php }?>>
					<?php echo $_smarty_tpl->tpl_vars['eleve']->value['nom'];?>
 <?php echo $_smarty_tpl->tpl_vars['eleve']->value['prenom'];?>
</option>
				<?php } ?>
			<?php }?>
		</select>
	</span>
	<button type="submit" class="btn btn-primary btn-sm" id="envoi">OK</button>
	<input type="hidden" name="action" value="gestEleves">
	<input type="hidden" name="mode" value="modifEleve">
	<input type="hidden" name="etape" value="showEleve">
	</form>
</div>

<script type="text/javascript">

$(document).ready (function() {

	$("#formSelecteur").submit(function(){
		if ($("#selectEleve").val() != '')
			$("#wait").show();
			else return false;
	})

	$("#selectClasse").change(function(){
		// on a choisi une classe dans la liste déroulante
			var classe = $(this).val();
		if (classe != '') $("#envoi").show();
		// la fonction listeEleves.inc.php renvoie la liste déroulante
		// des élèves de la classe sélectionnée
		$.post('inc/listeEleves.inc.php', {
			'classe': classe,
			'partis': true
			},
				function (resultat){
					$("#choixEleve").html(resultat)
				}
			)
	});

	$("#selectEleve").change(function(){
		if ($(this).val() > 0) {
			// si la liste de sélection des élèves renvoie une valeur significative
			// le formulaire est soumis
			$("#formSelecteur").submit();
			$("#envoi").show();
		}
			else $("#envoi").hide();
		})
})

</script>
<?php }} ?>
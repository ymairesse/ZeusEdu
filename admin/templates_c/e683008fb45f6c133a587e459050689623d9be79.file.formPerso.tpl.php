<?php /* Smarty version Smarty-3.1.13, created on 2017-05-25 11:04:17
         compiled from "./templates/users/formPerso.tpl" */ ?>
<?php /*%%SmartyHeaderCode:128088200659269e1161ad99-32663171%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    'e683008fb45f6c133a587e459050689623d9be79' => 
    array (
      0 => './templates/users/formPerso.tpl',
      1 => 1481975184,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '128088200659269e1161ad99-32663171',
  'function' => 
  array (
  ),
  'variables' => 
  array (
    'dejaConnu' => 0,
    'userIdentite' => 0,
    'statut' => 0,
    'applicationDroits' => 0,
    'unStatut' => 0,
    'applications' => 0,
    'uneApplication' => 0,
    'nomApplication' => 0,
    'userApplications' => 0,
  ),
  'has_nocache_code' => false,
  'version' => 'Smarty-3.1.13',
  'unifunc' => 'content_59269e11646575_87698762',
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_59269e11646575_87698762')) {function content_59269e11646575_87698762($_smarty_tpl) {?><div class="container">
<fieldset>
	<legend>Informations Personnelles</legend>

	<form method="post" action="index.php" name="form" autocomplete="off" id="formPerso" class="form-vertical" role="form">

		<div class="row">

			<div class="col-md-6 col-sm-12">

				<div id="photo"></div>

				<div class="form-group">
					<label for="acronyme">Nom d'utilisateur:</label>
					<?php if ($_smarty_tpl->tpl_vars['dejaConnu']->value){?>
						<input name="acronyme" type="hidden" value="<?php echo (($tmp = @$_smarty_tpl->tpl_vars['userIdentite']->value['acronyme'])===null||$tmp==='' ? '' : $tmp);?>
">
						<strong class="form-control-static"><?php echo (($tmp = @$_smarty_tpl->tpl_vars['userIdentite']->value['acronyme'])===null||$tmp==='' ? '' : $tmp);?>
</strong>
						<?php }else{ ?>
						<input type="text" maxlength="3" name="acronyme" id="acronyme" value="<?php echo (($tmp = @$_smarty_tpl->tpl_vars['userIdentite']->value['acronyme'])===null||$tmp==='' ? '' : $tmp);?>
" class="required form-control">
						<div class="help-block" id="acronymeOK"></div>
					<?php }?>
				</div>

				<div class="form-group">
					<label>Sexe:</label>
					<div class="radio-inline">
						<label for="M" class="radio-inline">
							<input name="sexe" type="radio" id="M" value="M" <?php if (isset($_smarty_tpl->tpl_vars['userIdentite']->value['sexe'])&&($_smarty_tpl->tpl_vars['userIdentite']->value['sexe']=="M")){?> checked="checked"<?php }?> class="required">M
						</label>
					</div>

					<div class="radio-inline">
						<label for="F" class="radio-inline">
						<input name="sexe" type="radio" id="F" value="F" <?php if (isset($_smarty_tpl->tpl_vars['userIdentite']->value['sexe'])&&($_smarty_tpl->tpl_vars['userIdentite']->value['sexe']=="F")){?> checked="checked"<?php }?> class="required">F
						</label>
					</div>
				</div>

				<div class="form-group">
					<label for="nom">Nom: </label>
					<input type="text" maxlength="40" name="nom" id="nom" value="<?php echo (($tmp = @$_smarty_tpl->tpl_vars['userIdentite']->value['nom'])===null||$tmp==='' ? '' : $tmp);?>
" class="required form-control">
				</div>

				<div class="form-group">
					<label for="prenom">Prénom: </label>
					<input type="text" maxlength="40" name="prenom" id="prenom" value="<?php echo (($tmp = @$_smarty_tpl->tpl_vars['userIdentite']->value['prenom'])===null||$tmp==='' ? '' : $tmp);?>
" class="required form-control">
				</div>

				<div class="form-group">
					<label for="mdp">Mot de passe: </label>
					
					<input type="passwd" maxlenght="20" name="mdp" id="mdp" value=""
						<?php if ($_smarty_tpl->tpl_vars['dejaConnu']->value==false){?> class="required form-control" <?php }else{ ?> class="form-control"<?php }?>>
					<div class="help-block">Laisser vide pour ne pas modifier le mot de passe</div>
				</div>

			</div>  <!-- col-md-... -->

			<div class="col-md-6 col-sm-12">
				<div class="form-group">
					<label for="mail">Mail: </label>
					<input type="text" maxlength="40" name="mail" id="mail" value="<?php echo (($tmp = @$_smarty_tpl->tpl_vars['userIdentite']->value['mail'])===null||$tmp==='' ? '' : $tmp);?>
" class="required mail form-control">
				</div>

				<div class="form-group">
					<label for="telephone">Téléphone:</label>
					<input type="text" maxlength="40" name="telephone" id="telephone" value="<?php echo (($tmp = @$_smarty_tpl->tpl_vars['userIdentite']->value['telephone'])===null||$tmp==='' ? '' : $tmp);?>
" class="form-control">
					<div class="help-block">Téléphone fixe</div>
				</div>

				<div class="form-group">
					<label for="GSM">GSM: </label>
					<input type="text" maxlength="40" name="GSM" id="GSM" value="<?php echo (($tmp = @$_smarty_tpl->tpl_vars['userIdentite']->value['GSM'])===null||$tmp==='' ? '' : $tmp);?>
" class="form-control">
					<div class="help-block">Téléphone portable</div>
				</div>

				<div class="form-group">
					<label for="statut">Statut global</label>
					<?php $_smarty_tpl->tpl_vars['statut'] = new Smarty_variable((($tmp = @$_smarty_tpl->tpl_vars['userIdentite']->value['statut'])===null||$tmp==='' ? null : $tmp), null, 0);?>
					<select name="statut" id="statut" class="form-control">
						<option value="user"
							<?php if (($_smarty_tpl->tpl_vars['statut']->value=='user')||($_smarty_tpl->tpl_vars['statut']->value==null)){?> selected="selected"<?php }?>>Utilisateur
						</option>
						<option value="admin"<?php if (($_smarty_tpl->tpl_vars['statut']->value=='admin')){?> selected="selected"<?php }?>>Administrateur</option>
					</select>
					<div class="help-block">L'administrateur global reçoit les notifications "admin"</div>
				</div>
				<input type="hidden" name="oldUser" value="<?php echo $_smarty_tpl->tpl_vars['dejaConnu']->value;?>
">
				<input type="hidden" name="action" value="gestUsers">
				</p>

			</div>

		</div>  <!-- row -->

		<div class="row">

		<table width="100%"class="table table-striped table-condensed">
		<tr>
			<th>&nbsp;</th>
			<th>Application</th>
			<?php  $_smarty_tpl->tpl_vars['unStatut'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['unStatut']->_loop = false;
 $_from = $_smarty_tpl->tpl_vars['applicationDroits']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['unStatut']->key => $_smarty_tpl->tpl_vars['unStatut']->value){
$_smarty_tpl->tpl_vars['unStatut']->_loop = true;
?>
				<th id="<?php echo $_smarty_tpl->tpl_vars['unStatut']->value;?>
" class="statut" title="statut '<?php echo $_smarty_tpl->tpl_vars['unStatut']->value;?>
'  pour toutes les applications" data-container="body" style="text-align:center"><a href="javascript:void(0)"><?php echo $_smarty_tpl->tpl_vars['unStatut']->value;?>
</a></th>
			<?php } ?>
		</tr>

		<?php  $_smarty_tpl->tpl_vars['uneApplication'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['uneApplication']->_loop = false;
 $_smarty_tpl->tpl_vars['nomApplication'] = new Smarty_Variable;
 $_from = $_smarty_tpl->tpl_vars['applications']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['uneApplication']->key => $_smarty_tpl->tpl_vars['uneApplication']->value){
$_smarty_tpl->tpl_vars['uneApplication']->_loop = true;
 $_smarty_tpl->tpl_vars['nomApplication']->value = $_smarty_tpl->tpl_vars['uneApplication']->key;
?>
			<tr <?php if ($_smarty_tpl->tpl_vars['uneApplication']->value['active']==0){?>class="inactif" title="Application inactive"<?php }?>>
			<td><?php if ($_smarty_tpl->tpl_vars['uneApplication']->value['active']==0){?><i class="fa fa-minus-circle fa-lg"></i><?php }else{ ?>&nbsp;<?php }?></td>
			<td><?php echo $_smarty_tpl->tpl_vars['uneApplication']->value['nomLong'];?>
</td>
			<?php  $_smarty_tpl->tpl_vars['unStatut'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['unStatut']->_loop = false;
 $_from = $_smarty_tpl->tpl_vars['applicationDroits']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['unStatut']->key => $_smarty_tpl->tpl_vars['unStatut']->value){
$_smarty_tpl->tpl_vars['unStatut']->_loop = true;
?>
				<td style="text-align:center">
					<input type="radio" name="<?php echo $_smarty_tpl->tpl_vars['nomApplication']->value;?>
" value="<?php echo $_smarty_tpl->tpl_vars['unStatut']->value;?>
" class="check_<?php echo $_smarty_tpl->tpl_vars['unStatut']->value;?>
"
						<?php if (isset($_smarty_tpl->tpl_vars['userApplications']->value[$_smarty_tpl->tpl_vars['nomApplication']->value])){?>
						   <?php if ($_smarty_tpl->tpl_vars['unStatut']->value==$_smarty_tpl->tpl_vars['userApplications']->value[$_smarty_tpl->tpl_vars['nomApplication']->value]['userStatus']){?> checked<?php }?>>
						<?php }else{ ?>
							<?php if ($_smarty_tpl->tpl_vars['unStatut']->value=='none'){?> checked<?php }?>>
						<?php }?>
				</td>
			<?php } ?>
			</tr>
		<?php } ?>

		</table>

		</div>  <!-- row -->

		<div style="clear:both">
			<input type="hidden" name="mode" value="saveUser">
				<div class="btn-group pull-right">
					<button class="btn btn-default" type="reset">Annuler</button>
					<button class="btn btn-primary" type="Submit">Enregistrer</button>
				</div>
		</div>
	</form>
</fieldset>

</div>  <!-- container -->

<script type="text/javascript">

$(document).ready(function(){

    // validation du formulaire de modification des données personnelles
    $("#formPerso").validate({
        errorElement: "span"
    })


	// formulaire d'inscription d'un nouvel utilisateur
    $("#acronyme").keyup(function(){
		$(this).val($(this).val().toUpperCase());
		$.get("inc/verifUserExists.inc.php", {
			acronyme: $(this).val()},
			function (resultat) {
				if (resultat != '') {
					$("#submit").attr("disabled","disabled");
					$("#acronymeOK").html("Existe déjà ");
				}
				else {
					$("#submit").removeAttr("disabled");
					$("#acronymeOK").html(":o)");
					}
				}
			)
		})

	$(".statut").click(function(){
		var id=$(this).attr("id");
		$(".check_"+id).trigger("click");
		})
})

</script>
<?php }} ?>
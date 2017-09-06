<?php /* Smarty version Smarty-3.1.13, created on 2017-05-15 10:44:15
         compiled from "./templates/eleves/panneaux/responsable.tpl" */ ?>
<?php /*%%SmartyHeaderCode:208979960859196a5fc16b34-69113921%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    '3d8251af97ceeef63480606d89d7ae8f68677d97' => 
    array (
      0 => './templates/eleves/panneaux/responsable.tpl',
      1 => 1478537040,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '208979960859196a5fc16b34-69113921',
  'function' => 
  array (
  ),
  'variables' => 
  array (
    'eleve' => 0,
  ),
  'has_nocache_code' => false,
  'version' => 'Smarty-3.1.13',
  'unifunc' => 'content_59196a5fc1ce64_39223139',
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_59196a5fc1ce64_39223139')) {function content_59196a5fc1ce64_39223139($_smarty_tpl) {?><div class="panel panel-default">

    <div class="panel-heading">
        <h4 class="panel-title">
        <a data-toggle="collapse" data-target="#collapse2" href="#collapse2">Personne responsable</a>
        </h4>
    </div>

    <div id="collapse2" class="panel-collapse collapse">
        <div class="row panel-body">

            <div class="col-md-4 col-sm-12">

                <div class="form-group">
                    <label for="nomResp">Responsable</label>
                    <input type="text" name="nomResp" id="nomResp" maxlength="50" value="<?php echo $_smarty_tpl->tpl_vars['eleve']->value['nomResp'];?>
" class="text-uppercase form-control">
                </div>

                <div class="form-group">
                    <label for="courriel">Courriel</label>
                    <input type="text" name="courriel" id="courriel" maxlength="40" value="<?php echo $_smarty_tpl->tpl_vars['eleve']->value['courriel'];?>
" class="form-control">
                </div>

                <div class="form-group">
                    <label for="telephone1">Téléphone</label>
                    <input type="text" name="telephone1" id="telephone1" maxlength="20" value="<?php echo $_smarty_tpl->tpl_vars['eleve']->value['telephone1'];?>
" class="form-control">
                </div>

            </div>

            <div class="col-md-4 col-sm-12">

                <div class="form-group">
                    <label for="telephone2">GSM</label>
                    <input type="text" name="telephone2" id="telephone2" maxlength="20" value="<?php echo $_smarty_tpl->tpl_vars['eleve']->value['telephone2'];?>
" class="form-control">
                </div>

                <div class="form-group">
                    <label for="telephone3">Téléphone bis</label>
                    <input type="text" name="telephone3" id="telephone3" maxlength="20" value="<?php echo $_smarty_tpl->tpl_vars['eleve']->value['telephone3'];?>
" class="form-control">
                </div>

                <div class="form-group">
                    <label for="adresseResp">Adresse</label>
                    <input type="text" name="adresseResp" id="adresseResp" maxlenght="40" value="<?php echo $_smarty_tpl->tpl_vars['eleve']->value['adresseResp'];?>
" class="form-control">
                </div>

            </div>

            <div class="col-md-4 col-sm-12">

                <div class="form-group">
                    <label for="cpostResp">Code Postal</label>
                    <input type="text" name="cpostResp" id="cpostResp" maxlength="6" value="<?php echo $_smarty_tpl->tpl_vars['eleve']->value['cpostResp'];?>
" class="form-control">
                </div>

                <div class="form-group">
                    <label for="localiteResp">Commune</label>
                    <input type="text" name="localiteResp" id="localiteResp" maxlength="30" value="<?php echo $_smarty_tpl->tpl_vars['eleve']->value['localiteResp'];?>
" class="form-control">
                </div>

            </div>
            <!-- col-md-... -->

        </div>
        <!-- row -->

    </div>
    <!-- collapse -->

</div>
<!-- panel -->
<?php }} ?>
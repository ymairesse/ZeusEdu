<?php /* Smarty version Smarty-3.1.13, created on 2017-05-15 10:44:15
         compiled from "./templates/eleves/panneaux/pere.tpl" */ ?>
<?php /*%%SmartyHeaderCode:70618679459196a5fc1e013-99438853%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    '32f85a320da187ddb0a3b251163e9d483062c560' => 
    array (
      0 => './templates/eleves/panneaux/pere.tpl',
      1 => 1478537040,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '70618679459196a5fc1e013-99438853',
  'function' => 
  array (
  ),
  'variables' => 
  array (
    'eleve' => 0,
  ),
  'has_nocache_code' => false,
  'version' => 'Smarty-3.1.13',
  'unifunc' => 'content_59196a5fc213d2_58930001',
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_59196a5fc213d2_58930001')) {function content_59196a5fc213d2_58930001($_smarty_tpl) {?><div class="panel">

    <div class="panel-heading">
        <h4 class="panel-title">
            <a data-toggle="collapse" data-target="#collapse3" href="#collapse3">Père de l'élève</a>
        </h4>
    </div>

    <div id="collapse3" class="panel-collapse collapse">

        <div class="row panel-body">

            <div class="col-md-6 col-sm-12">

                <div class="form-group">
                    <label for="nomPere">Nom</label>
                    <input type="text" name="nomPere" id="nomPere" maxlength="50" value="<?php echo $_smarty_tpl->tpl_vars['eleve']->value['nomPere'];?>
" class="text-uppercase form-control">
                </div>

                <div class="form-group">
                    <label for="telPere">Téléphone</label>
                    <input type="text" name="telPere" id="telPere" maxlength="20" value="<?php echo $_smarty_tpl->tpl_vars['eleve']->value['telPere'];?>
" class="form-control">
                </div>

            </div>
            <!-- col-md-... -->

            <div class="col-md-6 col-sm-12">

                <div class="form-group">
                    <label for="gsmPere">GSM</label>
                    <input type="text" name="gsmPere" id="gsmPere" maxlength="20" value="<?php echo $_smarty_tpl->tpl_vars['eleve']->value['gsmPere'];?>
" class="form-control">
                </div>

                <div class="form-group">
                    <label for="mailPere">Courriel</label>
                    <input type="text" name="mailPere" id="mailPere" maxlength="40" value="<?php echo $_smarty_tpl->tpl_vars['eleve']->value['mailPere'];?>
" class="form-control">
                </div>

            </div>
            <!-- col-md-... -->

        </div>
        <!-- row -->

    </div>
    <!-- collapse  -->

</div>
<!-- panel -->
<?php }} ?>
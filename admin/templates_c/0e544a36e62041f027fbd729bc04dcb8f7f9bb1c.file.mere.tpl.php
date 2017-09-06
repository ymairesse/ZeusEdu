<?php /* Smarty version Smarty-3.1.13, created on 2017-05-15 10:44:15
         compiled from "./templates/eleves/panneaux/mere.tpl" */ ?>
<?php /*%%SmartyHeaderCode:164651848159196a5fc222d4-93642936%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    '0e544a36e62041f027fbd729bc04dcb8f7f9bb1c' => 
    array (
      0 => './templates/eleves/panneaux/mere.tpl',
      1 => 1478537040,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '164651848159196a5fc222d4-93642936',
  'function' => 
  array (
  ),
  'variables' => 
  array (
    'eleve' => 0,
  ),
  'has_nocache_code' => false,
  'version' => 'Smarty-3.1.13',
  'unifunc' => 'content_59196a5fc25500_12833321',
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_59196a5fc25500_12833321')) {function content_59196a5fc25500_12833321($_smarty_tpl) {?><div class="panel">

    <div class="panel-heading">
        <h4 class="panel-title">
            <a data-toggle="collapse" data-target="#collapse4" href="#collapse4">Mère de l'élève</a>
        </h4>
    </div>

    <div id="collapse4" class="panel-collapse collapse">

        <div class="row panel-body">

            <div class="col-md-6 col-sm-12">

                <div class="form-group">
                    <label for="nomMere">Nom</label>
                    <input type="text" name="nomMere" id="nomMere" maxlength="50" value="<?php echo $_smarty_tpl->tpl_vars['eleve']->value['nomMere'];?>
" class="text-uppercase form-control">
                </div>

                <div class="form-group">
                    <label for="telMere">Téléphone</label>
                    <input type="text" name="telMere" id="telMere" maxlength="20" value="<?php echo $_smarty_tpl->tpl_vars['eleve']->value['telMere'];?>
" class="form-control">
                </div>

            </div>
            <!-- col-md-... -->

            <div class="col-md-6 col-sm-12">

                <div class="form-group">
                    <label for="gsmMere">GSM</label>
                    <input type="text" name="gsmMere" id="gsmMere" maxlength="20" value="<?php echo $_smarty_tpl->tpl_vars['eleve']->value['gsmMere'];?>
" class="form-control">
                </div>

                <div class="form-group">
                    <label for="mailMere">Courriel</label>
                    <input type="text" name="mailMere" id="mailMere" maxlength="40" value="<?php echo $_smarty_tpl->tpl_vars['eleve']->value['mailMere'];?>
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
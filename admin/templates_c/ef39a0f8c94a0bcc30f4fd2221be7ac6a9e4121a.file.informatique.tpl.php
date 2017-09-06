<?php /* Smarty version Smarty-3.1.13, created on 2017-05-15 10:44:15
         compiled from "./templates/eleves/panneaux/informatique.tpl" */ ?>
<?php /*%%SmartyHeaderCode:140998843059196a5fc26608-63130995%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    'ef39a0f8c94a0bcc30f4fd2221be7ac6a9e4121a' => 
    array (
      0 => './templates/eleves/panneaux/informatique.tpl',
      1 => 1494742329,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '140998843059196a5fc26608-63130995',
  'function' => 
  array (
  ),
  'variables' => 
  array (
    'info' => 0,
    'eleve' => 0,
  ),
  'has_nocache_code' => false,
  'version' => 'Smarty-3.1.13',
  'unifunc' => 'content_59196a5fc29ef6_80846437',
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_59196a5fc29ef6_80846437')) {function content_59196a5fc29ef6_80846437($_smarty_tpl) {?><div class="panel">

    <div class="panel-heading">
        <h4 class="panel-title">
            <a data-toggle="collapse" data-target="#collapse5" href="#collapse5">Informatique</a>
        </h4>
    </div>

    <div id="collapse5" class="panel-collapse collapse">

        <div class="row panel-body">

            <div class="col-md-4 col-sm-6">

                <div class="form-group">
                    <label for="userName">Nom d'utilisateur</label>
                    <p id="userName" class="code form-control-static"><?php echo (($tmp = @$_smarty_tpl->tpl_vars['info']->value['user'])===null||$tmp==='' ? '' : $tmp);?>
</p>
                </div>
            </div>

            <div class="col-md-4 col-sm-6">

                <div class="form-group">
                    <label for="mailDomain">Domaine mail</label>
                    <p class="code form-control-static"><?php echo (($tmp = @$_smarty_tpl->tpl_vars['eleve']->value['mailDomain'])===null||$tmp==='' ? '' : $tmp);?>
</p>
                </div>

            </div>

            <div class="col-md-4 col-sm-6">

                <div class="form-group">
                    <label for="mdp">Mot de passe</label>
                    <div class="input-group">
                        <input type="password" class="form-control" value="<?php echo (($tmp = @$_smarty_tpl->tpl_vars['info']->value['passwd'])===null||$tmp==='' ? '' : $tmp);?>
" disabled>
                        <span class="input-group-btn">
                           <button class = "btn btn-primary" id="eye" type = "button">
                              <i class="fa fa-eye"></i>
                           </button>
                        </span>
                    </div>
                    <p class="help-block">Cliquer pour voir</p>
                </div>

            </div>

        </div>
        <!-- row -->

    </div>
    <!-- collapse -->

</div>
<!-- panel -->
<?php }} ?>
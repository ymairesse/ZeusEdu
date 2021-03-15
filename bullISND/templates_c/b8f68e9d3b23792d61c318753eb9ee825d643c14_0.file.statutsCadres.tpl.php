<?php
/* Smarty version 3.1.34-dev-7, created on 2021-03-14 19:39:42
  from '/home/yves/www/sio2/peda/bullISND/templates/admin/statutsCadres.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_604e586e2bf144_43199842',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    'b8f68e9d3b23792d61c318753eb9ee825d643c14' => 
    array (
      0 => '/home/yves/www/sio2/peda/bullISND/templates/admin/statutsCadres.tpl',
      1 => 1545476737,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
    'file:admin/manuel_cadre.html' => 1,
  ),
),false)) {
function content_604e586e2bf144_43199842 (Smarty_Internal_Template $_smarty_tpl) {
?><div class="container">

    <div class="row">

        <div class="col-md-9 col-sm-12">

            <form action="index.php" method="POST" role="form" class="form-vertical" id="statutsCadres" name="statutsCadres">

                <table class="table table-condensed" style="text-align:center">
                    <thead>
                        <tr>
                            <th style="text-align:center !important">
                                Cadre du cours<br>
                                (officiel)
                            </th>
                            <th style="text-align:center !important">
                                Ordre
                            </th>
                            <th style="text-align:center !important">
                                Statut du cours<br>
                                (dans l'application)
                            </th>
                            <th style="text-align:center !important">
                                Pas d'échec
                            </th>
                            <th style="text-align:center !important">
                                Pas de totalisation
                            </th>
                        </tr>
                    </thead>

                    <tbody>
                        <?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['statutsCadres']->value, 'data', false, 'cadre');
$_smarty_tpl->tpl_vars['data']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['cadre']->value => $_smarty_tpl->tpl_vars['data']->value) {
$_smarty_tpl->tpl_vars['data']->do_else = false;
?>
                        <tr>
                            <td>
                                <input type="hidden" name="cadre[]" value="<?php echo $_smarty_tpl->tpl_vars['cadre']->value;?>
">
                                <?php echo $_smarty_tpl->tpl_vars['cadre']->value;?>

                            </td>
                            <td>
                                <input type="text" name="rang_<?php echo $_smarty_tpl->tpl_vars['cadre']->value;?>
" value="<?php echo $_smarty_tpl->tpl_vars['data']->value['rang'];?>
" class="form-control" required number="true" max="100">
                            </td>
                            <td>
                                <input type="text" name="statut_<?php echo $_smarty_tpl->tpl_vars['cadre']->value;?>
" value="<?php echo $_smarty_tpl->tpl_vars['data']->value['statut'];?>
" class="form-control" required maxlength="6">
                            </td>
                            <td>
                                <input type="checkbox" name="echec_<?php echo $_smarty_tpl->tpl_vars['cadre']->value;?>
" value="1" <?php if ($_smarty_tpl->tpl_vars['data']->value['echec'] == 1) {?>checked<?php }?>>
                            </td>
                            <td>
                                <input type="checkbox" name="total_<?php echo $_smarty_tpl->tpl_vars['cadre']->value;?>
" value="1" <?php if ($_smarty_tpl->tpl_vars['data']->value['total'] == 1) {?>checked<?php }?>>
                            </td>
                        </tr>
                        <?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
                    </tbody>

                </table>

                <input type="hidden" name="action" value="<?php echo $_smarty_tpl->tpl_vars['action']->value;?>
">
                <input type="hidden" name="mode" value="<?php echo $_smarty_tpl->tpl_vars['mode']->value;?>
">
                <input type="hidden" name="etape" value="enregistrer">

                <div class="btn-group pull-right">
                    <button type="reset" class="btn btn-default">Annuler</button>
                    <button type="submit" class="btn btn-primary">Enregistrer</button>
                </div>
                <div class="clearfix"></div>

            </form>

        </div>

        <div class="col-md-3 col-sm-12">

            <?php $_smarty_tpl->_subTemplateRender("file:admin/manuel_cadre.html", $_smarty_tpl->cache_id, $_smarty_tpl->compile_id, 0, $_smarty_tpl->cache_lifetime, array(), 0, false);
?>

        </div>



    </div>  <!-- row -->

</div>


<?php echo '<script'; ?>
 type="text/javascript">

$(document).ready(function(){

    $("#statutsCadres").validate()

})

<?php echo '</script'; ?>
>
<?php }
}

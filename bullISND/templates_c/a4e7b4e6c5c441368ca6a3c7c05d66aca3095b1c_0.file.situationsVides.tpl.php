<?php
/* Smarty version 3.1.34-dev-7, created on 2021-02-09 18:08:39
  from '/home/yves/www/sio2/peda/bullISND/templates/news/situationsVides.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_6022c197b35919_73687804',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    'a4e7b4e6c5c441368ca6a3c7c05d66aca3095b1c' => 
    array (
      0 => '/home/yves/www/sio2/peda/bullISND/templates/news/situationsVides.tpl',
      1 => 1465748459,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_6022c197b35919_73687804 (Smarty_Internal_Template $_smarty_tpl) {
$_smarty_tpl->_assignInScope('nbVide', (($tmp = @count($_smarty_tpl->tpl_vars['listeSituationsVides']->value))===null||$tmp==='' ? 0 : $tmp));?>

<h3>Bulletins à compléter</h3>

<?php if ($_smarty_tpl->tpl_vars['nbVide']->value > 0) {?>
    <div class="alert alert-danger">
        <p><i class="fa fa-exclamation-triangle"></i> Il vous reste des bulletins à compléter pour les cours suivants:</p>
    </div>

        <ul>
        <?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeSituationsVides']->value, 'listeEleves', false, 'coursGrp');
$_smarty_tpl->tpl_vars['listeEleves']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['coursGrp']->value => $_smarty_tpl->tpl_vars['listeEleves']->value) {
$_smarty_tpl->tpl_vars['listeEleves']->do_else = false;
?>
            <li class="cours collapsible"><?php echo $_smarty_tpl->tpl_vars['coursGrp']->value;?>
: <?php echo count($_smarty_tpl->tpl_vars['listeEleves']->value);?>
 eleve(s)
                <ul style="display:none">
                <?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeEleves']->value, 'data', false, 'matricule');
$_smarty_tpl->tpl_vars['data']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['matricule']->value => $_smarty_tpl->tpl_vars['data']->value) {
$_smarty_tpl->tpl_vars['data']->do_else = false;
?>
                    <li><?php echo $_smarty_tpl->tpl_vars['data']->value['nom'];?>
</li>
                <?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
                </ul>
            </li>
        <?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
        </ul>
    <?php } else { ?>
    <div class="alert alert-info">
        <p>Bonne nouvelle. À ce stade, vous avez mis des cotes dans tous les bulletins.</p>
    </div>
<?php }
}
}

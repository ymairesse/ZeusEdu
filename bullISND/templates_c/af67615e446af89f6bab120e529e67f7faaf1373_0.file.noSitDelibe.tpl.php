<?php
/* Smarty version 3.1.34-dev-7, created on 2021-02-09 18:08:39
  from '/home/yves/www/sio2/peda/bullISND/templates/news/noSitDelibe.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_6022c197b3a831_33139592',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    'af67615e446af89f6bab120e529e67f7faaf1373' => 
    array (
      0 => '/home/yves/www/sio2/peda/bullISND/templates/news/noSitDelibe.tpl',
      1 => 1465798647,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_6022c197b3a831_33139592 (Smarty_Internal_Template $_smarty_tpl) {
$_smarty_tpl->_assignInScope('nbVide', (($tmp = @count($_smarty_tpl->tpl_vars['listeDelibeVide']->value))===null||$tmp==='' ? 0 : $tmp));?>

<h3>Cotes de délibération</h3>

<?php if ($_smarty_tpl->tpl_vars['nbVide']->value > 0) {?>
    <div class="alert alert-danger">
        <p><i class="fa fa-exclamation-triangle"></i> Il vous reste à sélectionner des cotes de délibération pour les cours suivants:</p>
    </div>

        <ul>
        <?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeDelibeVide']->value, 'listeEleves', false, 'coursGrp');
$_smarty_tpl->tpl_vars['listeEleves']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['coursGrp']->value => $_smarty_tpl->tpl_vars['listeEleves']->value) {
$_smarty_tpl->tpl_vars['listeEleves']->do_else = false;
?>
            <li class="cours collapsible"><?php echo $_smarty_tpl->tpl_vars['coursGrp']->value;?>
: <?php echo count($_smarty_tpl->tpl_vars['listeEleves']->value);?>
 cote(s) de délibération manquante(s)
                <ul style="display:none">
                <?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeEleves']->value, 'data', false, 'matricule');
$_smarty_tpl->tpl_vars['data']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['matricule']->value => $_smarty_tpl->tpl_vars['data']->value) {
$_smarty_tpl->tpl_vars['data']->do_else = false;
?>
                    <li><?php echo $_smarty_tpl->tpl_vars['data']->value['nom'];?>
 <?php echo $_smarty_tpl->tpl_vars['data']->value['prenom'];?>
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
        <p><img src="images/peggynounou.gif" alt="yes">Bonne nouvelle. À ce stade, vous avez fourni toutes les cotes de délibération.</p>
    </div>
<?php }
}
}

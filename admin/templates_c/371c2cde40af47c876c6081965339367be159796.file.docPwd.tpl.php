<?php /* Smarty version Smarty-3.1.13, created on 2017-06-18 16:49:24
         compiled from "../../templates/eleves/docPwd.tpl" */ ?>
<?php /*%%SmartyHeaderCode:1410436177594692f410f065-90994062%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    '371c2cde40af47c876c6081965339367be159796' => 
    array (
      0 => '../../templates/eleves/docPwd.tpl',
      1 => 1478537040,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '1410436177594692f410f065-90994062',
  'function' => 
  array (
  ),
  'variables' => 
  array (
    'nomFichier' => 0,
    'photo' => 0,
  ),
  'has_nocache_code' => false,
  'version' => 'Smarty-3.1.13',
  'unifunc' => 'content_594692f41117e2_95902241',
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_594692f41117e2_95902241')) {function content_594692f41117e2_95902241($_smarty_tpl) {?><p>
    Le document est disponible là:
        <a href="inc/download.php?type=pfN&amp;f=/pwd/<?php echo $_smarty_tpl->tpl_vars['nomFichier']->value;?>
">
        <img src="../photos/<?php echo $_smarty_tpl->tpl_vars['photo']->value;?>
.jpg" alt="photo" style="width:200px" title="Cliquer pour télécharger le document">
    </a>
</p>
<?php }} ?>
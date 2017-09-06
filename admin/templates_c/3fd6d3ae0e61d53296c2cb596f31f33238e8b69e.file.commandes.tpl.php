<?php /* Smarty version Smarty-3.1.13, created on 2017-05-18 16:07:01
         compiled from "./templates/commandes.tpl" */ ?>
<?php /*%%SmartyHeaderCode:1018949993591daa854a5309-44820777%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    '3fd6d3ae0e61d53296c2cb596f31f33238e8b69e' => 
    array (
      0 => './templates/commandes.tpl',
      1 => 1478537040,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '1018949993591daa854a5309-44820777',
  'function' => 
  array (
  ),
  'has_nocache_code' => false,
  'version' => 'Smarty-3.1.13',
  'unifunc' => 'content_591daa854a6240_81307243',
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_591daa854a6240_81307243')) {function content_591daa854a6240_81307243($_smarty_tpl) {?><h4>Commandes rapides</h4>
<a type="button" class="btn btn-danger btn-sm" href="index.php?action=autres&mode=alias"><i class="fa fa-user-secret fa-2x"></i> Prendre un alias</a>
<a type="button" class="btn btn-primary btn-sm" href="index.php?action=news"><i class="fa fa-bell fa-2x"></i></span> Pad Admin</a>
<a type="button" class="btn btn-success btn-sm" href="index.php?action=gestUsers&mode=addUser"><i class="fa fa-user-plus fa-2x"></i> Ajouter un utilisateur</a>
<?php }} ?>
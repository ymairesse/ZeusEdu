<?php /* Smarty version Smarty-3.1.13, created on 2020-07-25 10:17:18
         compiled from "../../templates/ponderation/formPonderation.tpl" */ ?>
<?php /*%%SmartyHeaderCode:19779508095f1bea8ec87456-78738836%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    'aeecbcc839903306692bf30b9eb23c729ce82000' => 
    array (
      0 => '../../templates/ponderation/formPonderation.tpl',
      1 => 1478158767,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '19779508095f1bea8ec87456-78738836',
  'function' => 
  array (
  ),
  'variables' => 
  array (
    'listePonderations' => 0,
    'periode' => 0,
    'NOMSPERIODES' => 0,
    'ponderation' => 0,
    'bulletin' => 0,
  ),
  'has_nocache_code' => false,
  'version' => 'Smarty-3.1.13',
  'unifunc' => 'content_5f1bea8ecc9610_01453712',
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_5f1bea8ecc9610_01453712')) {function content_5f1bea8ecc9610_01453712($_smarty_tpl) {?><?php  $_smarty_tpl->tpl_vars['ponderation'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['ponderation']->_loop = false;
 $_smarty_tpl->tpl_vars['periode'] = new Smarty_Variable;
 $_from = $_smarty_tpl->tpl_vars['listePonderations']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['ponderation']->key => $_smarty_tpl->tpl_vars['ponderation']->value){
$_smarty_tpl->tpl_vars['ponderation']->_loop = true;
 $_smarty_tpl->tpl_vars['periode']->value = $_smarty_tpl->tpl_vars['ponderation']->key;
?>

    <tr>
        <td><?php echo $_smarty_tpl->tpl_vars['periode']->value;?>
</td>
        <td><?php echo $_smarty_tpl->tpl_vars['NOMSPERIODES']->value[$_smarty_tpl->tpl_vars['periode']->value-1];?>
</td>
        <td>
            <input type="text"
                class="poids form-control"
                value="<?php echo $_smarty_tpl->tpl_vars['ponderation']->value['form'];?>
"
                <?php if (($_smarty_tpl->tpl_vars['bulletin']->value>$_smarty_tpl->tpl_vars['periode']->value)){?> readonly <?php }?>
                name="formatif_<?php echo $_smarty_tpl->tpl_vars['periode']->value;?>
" maxlength="3">
        </td>
        <td>
            <input type="text"
                class="poids form-control"
                value="<?php echo $_smarty_tpl->tpl_vars['ponderation']->value['cert'];?>
"
                <?php if (($_smarty_tpl->tpl_vars['bulletin']->value>$_smarty_tpl->tpl_vars['periode']->value)){?> readonly <?php }?>
                name="certif_<?php echo $_smarty_tpl->tpl_vars['periode']->value;?>
"
                maxlength="3">
        </td>
    </tr>

<?php } ?>

<script type="text/javascript">

$(document).ready(function(){
    var readonly = "Cette période est passée et n'est plus modifiable";
    $("#modPonderation").find('input:text[readonly]').attr('title',readonly);
})

</script>
<?php }} ?>
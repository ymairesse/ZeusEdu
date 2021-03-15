<?php
/* Smarty version 3.1.34-dev-7, created on 2021-03-14 19:33:51
  from '/home/yves/www/sio2/peda/bullISND/templates/admin/tableauGestCours.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_604e570f1ad953_57478611',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '6043fd496ad310b00a23fb6661854a7a47e4b4d9' => 
    array (
      0 => '/home/yves/www/sio2/peda/bullISND/templates/admin/tableauGestCours.tpl',
      1 => 1601142008,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_604e570f1ad953_57478611 (Smarty_Internal_Template $_smarty_tpl) {
?><table class="tableauBull">
	<tr>
		<th>Cours</th>
		<th>Libellé</th>
		<th style="width:3em;">Statut</th>
		<th style="width:3em;">Cadre</th>
		<th style="width:3em;">Virtuel</th>
		<th>Cours liés</th>
		<th>Professeur(s)</th>
		<th style="width:1em"></th>
		<th style="width:3em">&nbsp;</th>
        <th>Élèves</th>
		<th style="width:1em">&nbsp;</th>
        <th style="width:3em;">&nbsp;</th>
	</tr>
<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeCoursGrp']->value, 'data', false, 'coursGrp');
$_smarty_tpl->tpl_vars['data']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['coursGrp']->value => $_smarty_tpl->tpl_vars['data']->value) {
$_smarty_tpl->tpl_vars['data']->do_else = false;
?>
	<tr>
		<td><?php echo $_smarty_tpl->tpl_vars['coursGrp']->value;?>
</td>
		<td><?php echo $_smarty_tpl->tpl_vars['data']->value['libelle'];?>
</td>
		<td><?php echo $_smarty_tpl->tpl_vars['data']->value['statut'];?>
</td>
		<td><?php echo $_smarty_tpl->tpl_vars['data']->value['cadre'];?>
</td>
		<td><?php if ($_smarty_tpl->tpl_vars['listeVirtualCoursGrp']->value[$_smarty_tpl->tpl_vars['coursGrp']->value] == 1) {?>
			<button type="button" class="btn btn-danger btn-sm btn-virtuel" data-coursgrp="<?php echo $_smarty_tpl->tpl_vars['coursGrp']->value;?>
">Virtuel</button>
			<?php } else { ?>
			&nbsp;
			<?php }?>
		</td>
		<td>
			<?php if ((isset($_smarty_tpl->tpl_vars['listeLinkedCoursGrp']->value[$_smarty_tpl->tpl_vars['coursGrp']->value]))) {?>
				<select class="form-control" name="wtf<?php echo $_smarty_tpl->tpl_vars['coursGrp']->value;?>
">
					<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeLinkedCoursGrp']->value[$_smarty_tpl->tpl_vars['coursGrp']->value], 'linked', false, 'wtf');
$_smarty_tpl->tpl_vars['linked']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['wtf']->value => $_smarty_tpl->tpl_vars['linked']->value) {
$_smarty_tpl->tpl_vars['linked']->do_else = false;
?>
					<option value="<?php echo $_smarty_tpl->tpl_vars['linked']->value;?>
"><?php echo $_smarty_tpl->tpl_vars['linked']->value;?>
</option>
					<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
				</select>
			<?php } else { ?>
				&nbsp;
			 <?php }?>
		</td>
		<td data-coursgrp="<?php echo $_smarty_tpl->tpl_vars['coursGrp']->value;?>
" class="listeProfs">
			<?php if ((isset($_smarty_tpl->tpl_vars['listeProfsCoursGrp']->value[$_smarty_tpl->tpl_vars['coursGrp']->value]))) {?>
				<select class="form-control" name="">
					<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeProfsCoursGrp']->value[$_smarty_tpl->tpl_vars['coursGrp']->value], 'data', false, 'acronyme');
$_smarty_tpl->tpl_vars['data']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['acronyme']->value => $_smarty_tpl->tpl_vars['data']->value) {
$_smarty_tpl->tpl_vars['data']->do_else = false;
?>
					<option value="<?php echo $_smarty_tpl->tpl_vars['acronyme']->value;?>
"> <?php echo $_smarty_tpl->tpl_vars['data']->value['nom'];?>
 <?php echo $_smarty_tpl->tpl_vars['data']->value['prenom'];?>
</option>
					<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
				</select>
				<?php } else { ?>
				&nbsp;
			<?php }?>
		</td>
		<td data-coursgrp="<?php echo $_smarty_tpl->tpl_vars['coursGrp']->value;?>
" class="badge">
			<span class="badge badge-primary"><?php echo (($tmp = @count($_smarty_tpl->tpl_vars['listeProfsCoursGrp']->value[$_smarty_tpl->tpl_vars['coursGrp']->value]))===null||$tmp==='' ? 0 : $tmp);?>
</span>
		</td>
		<td>
			<button
				type="button"
				class="btn btn-primary btn-xs btn-addProf pull-right"
				style="width:5em"
				data-coursgrp="<?php echo $_smarty_tpl->tpl_vars['coursGrp']->value;?>
">
				+/-
			</button>
		</td>
		<td>
            <?php if ((isset($_smarty_tpl->tpl_vars['listeElevesCoursGrp']->value[$_smarty_tpl->tpl_vars['coursGrp']->value]))) {?>
            <select class="form-control" name="">
                <?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeElevesCoursGrp']->value[$_smarty_tpl->tpl_vars['coursGrp']->value], 'data', false, 'matricule');
$_smarty_tpl->tpl_vars['data']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['matricule']->value => $_smarty_tpl->tpl_vars['data']->value) {
$_smarty_tpl->tpl_vars['data']->do_else = false;
?>
                <option value="<?php echo $_smarty_tpl->tpl_vars['matricule']->value;?>
"><?php echo $_smarty_tpl->tpl_vars['data']->value['groupe'];?>
 <?php echo $_smarty_tpl->tpl_vars['data']->value['nom'];?>
 <?php echo $_smarty_tpl->tpl_vars['data']->value['prenom'];?>
</option>
                <?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
            </select>
            <?php } else { ?>
            &nbsp;
            <?php }?>
		</td>
        <td>
            <span class="badge badge-primary"><?php echo (($tmp = @count($_smarty_tpl->tpl_vars['listeElevesCoursGrp']->value[$_smarty_tpl->tpl_vars['coursGrp']->value]))===null||$tmp==='' ? 0 : $tmp);?>
</span>
        </td>
        <td>
			<button
				type="button"
				class="btn btn-primary btn-xs btn-addEleves pull-right"
				style="width:5em"
				data-coursgrp="<?php echo $_smarty_tpl->tpl_vars['coursGrp']->value;?>
">
				+/-
			</button>
		</td>

	</tr>
<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
</table>
<?php }
}

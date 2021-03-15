<?php
/* Smarty version 3.1.34-dev-7, created on 2021-03-14 19:33:53
  from '/home/yves/www/sio2/peda/bullISND/templates/admin/modal/modalSelectProf.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_604e57116b1a20_13550326',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '70d1c6a5fe6e15473f0a8278d03129a2fc2bec6d' => 
    array (
      0 => '/home/yves/www/sio2/peda/bullISND/templates/admin/modal/modalSelectProf.tpl',
      1 => 1601114219,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
    'file:admin/modal/listeProfsCoursGrp.tpl' => 1,
  ),
),false)) {
function content_604e57116b1a20_13550326 (Smarty_Internal_Template $_smarty_tpl) {
?><div id="modalSelectProf" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalSelectProfLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalSelectProfLabel">
            <?php echo $_smarty_tpl->tpl_vars['coursGrp']->value;?>
 <?php echo $_smarty_tpl->tpl_vars['detailsCoursGrp']->value['statut'];?>
 <?php echo $_smarty_tpl->tpl_vars['detailsCoursGrp']->value['libelle'];?>
 <?php echo $_smarty_tpl->tpl_vars['detailsCoursGrp']->value['nbheures'];?>
h
        </h4>
      </div>
      <div class="modal-body row">

          <div class="col-xs-5" id="listeProfsCours">

              <?php $_smarty_tpl->_subTemplateRender("file:admin/modal/listeProfsCoursGrp.tpl", $_smarty_tpl->cache_id, $_smarty_tpl->compile_id, 0, $_smarty_tpl->cache_lifetime, array(), 0, false);
?>

          </div>

          <div class="col-xs-2">
              <div class="btn-group-vertical  btn-block">
                  <button type="button" class="btn btn-primary" style="margin: 3em 0" id="ajoutProfs" data-coursgrp="<?php echo $_smarty_tpl->tpl_vars['coursGrp']->value;?>
"><<<</button>
                  <button type="button" class="btn btn-primary" style="margin: 3em 0" id="supprProfs" data-coursgrp="<?php echo $_smarty_tpl->tpl_vars['coursGrp']->value;?>
">>>></button>
              </div>
          </div>

          <div class="col-xs-5">
              <form id="formProfs">
              <div class="form-group">
                  <label for="listeProfsCoursGrp">Titulaire(s) possibles</label>
                  <select class="form-control" name="listeProfs[]" id="listeProfs" size="10" multiple>
                      <?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeProfs']->value, 'dataProf', false, 'acronyme');
$_smarty_tpl->tpl_vars['dataProf']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['acronyme']->value => $_smarty_tpl->tpl_vars['dataProf']->value) {
$_smarty_tpl->tpl_vars['dataProf']->do_else = false;
?>
                      <option value="<?php echo $_smarty_tpl->tpl_vars['acronyme']->value;?>
"><?php echo $_smarty_tpl->tpl_vars['dataProf']->value['nom'];?>
 <?php echo $_smarty_tpl->tpl_vars['dataProf']->value['prenom'];?>
 [<?php echo $_smarty_tpl->tpl_vars['acronyme']->value;?>
]</option>
                      <?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
                  </select>
                  <div class="help-block">Ctrl / Maj pour sélection multiple</div>
              </div>
              </form>
          </div>

      </div>
      <div class="modal-footer">
        <button type="button" name="button" data-dismiss="modal" >Terminer</button>
      </div>
    </div>
  </div>
</div>
<?php }
}

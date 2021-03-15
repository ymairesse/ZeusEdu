<?php
/* Smarty version 3.1.34-dev-7, created on 2021-03-14 19:36:23
  from '/home/yves/www/sio2/peda/bullISND/templates/admin/modal/modalSelectEleves.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_604e57a701b974_51016837',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '2a1fcefa4b9bd70a4ecc5ace6e776ca8817d8b01' => 
    array (
      0 => '/home/yves/www/sio2/peda/bullISND/templates/admin/modal/modalSelectEleves.tpl',
      1 => 1601016048,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
    'file:admin/modal/listeElevesCoursGrp.tpl' => 1,
    'file:admin/modal/listeClasses.inc.tpl' => 1,
    'file:admin/modal/listeElevesClasse.inc.tpl' => 1,
  ),
),false)) {
function content_604e57a701b974_51016837 (Smarty_Internal_Template $_smarty_tpl) {
?><div id="modalSelectEleves" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalSelectElevesLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalSelectElevesLabel"><?php echo $_smarty_tpl->tpl_vars['coursGrp']->value;?>
 <?php echo $_smarty_tpl->tpl_vars['detailsCoursGrp']->value['statut'];?>
 <?php echo $_smarty_tpl->tpl_vars['detailsCoursGrp']->value['libelle'];?>
 <?php echo $_smarty_tpl->tpl_vars['detailsCoursGrp']->value['nbheures'];?>
h</h4>
      </div>
      <div class="modal-body">
          <div class="col-xs-5" id="listeElevesCours">

              <?php $_smarty_tpl->_subTemplateRender("file:admin/modal/listeElevesCoursGrp.tpl", $_smarty_tpl->cache_id, $_smarty_tpl->compile_id, 0, $_smarty_tpl->cache_lifetime, array(), 0, false);
?>

          </div>

          <div class="col-xs-2">
              <div class="btn-group-vertical  btn-block">
                  <button type="button" class="btn btn-primary" style="margin: 3em 0" id="ajoutEleves" data-coursgrp="<?php echo $_smarty_tpl->tpl_vars['coursGrp']->value;?>
"><<<</button>
                  <button type="button" class="btn btn-primary" style="margin: 3em 0" id="supprEleves" data-coursgrp="<?php echo $_smarty_tpl->tpl_vars['coursGrp']->value;?>
">>>></button>
              </div>
          </div>

          <div class="col-xs-5">
              <div class="form-group">
                  <label for="listeNiveaux">Niveau d'étude</label>
                  <select class="form-control" name="listeNiveaux" id="listeNiveaux">
                      <?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeNiveaux']->value, 'niveau');
$_smarty_tpl->tpl_vars['niveau']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['niveau']->value) {
$_smarty_tpl->tpl_vars['niveau']->do_else = false;
?>
                      <option value="<?php echo $_smarty_tpl->tpl_vars['niveau']->value;?>
"<?php if ($_smarty_tpl->tpl_vars['niveau']->value == $_smarty_tpl->tpl_vars['guessNiveau']->value) {?> selected<?php }?>><?php echo $_smarty_tpl->tpl_vars['niveau']->value;?>
e année</option>
                      <?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
                  </select>
              </div>

              <div class="form-group" id="listeClasses">
                  <?php $_smarty_tpl->_subTemplateRender("file:admin/modal/listeClasses.inc.tpl", $_smarty_tpl->cache_id, $_smarty_tpl->compile_id, 0, $_smarty_tpl->cache_lifetime, array(), 0, false);
?>
              </div>

              <div class="form-group" id="listeElevesClasse">

                  <?php $_smarty_tpl->_subTemplateRender("file:admin/modal/listeElevesClasse.inc.tpl", $_smarty_tpl->cache_id, $_smarty_tpl->compile_id, 0, $_smarty_tpl->cache_lifetime, array(), 0, false);
?>

              </div>

          </div>

      </div>
      <div class="modal-footer">
        <button type="button" name="button" data-dismiss="modal" >Terminer</button>
      </div>
    </div>
  </div>
</div>

<?php echo '<script'; ?>
 type="text/javascript">

    $(document).ready(function(){

        $('#listeNiveaux').change(function(){
            var niveau = $(this).val();
            $.post('inc/admin/getListeClassesNiveau.inc.php', {
                niveau: niveau
            }, function(resultat){
                $('#listeClasses').html(resultat);
            })
        })

        $('#listeClasses').change(function(){
            var classe = $('#listeClasses option:selected').val();
            $.post('inc/admin/getListeElevesClasse.inc.php', {
                classe: classe
            }, function(resultat){
                $('#listeElevesClasse').html(resultat);
            })
        })
    })

<?php echo '</script'; ?>
>
<?php }
}

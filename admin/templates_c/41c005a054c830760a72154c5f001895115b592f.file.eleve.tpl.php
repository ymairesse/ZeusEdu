<?php /* Smarty version Smarty-3.1.13, created on 2017-09-06 17:37:01
         compiled from "./templates/eleves/panneaux/eleve.tpl" */ ?>
<?php /*%%SmartyHeaderCode:153763835759196a5fc04f53-46370070%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    '41c005a054c830760a72154c5f001895115b592f' => 
    array (
      0 => './templates/eleves/panneaux/eleve.tpl',
      1 => 1504711694,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '153763835759196a5fc04f53-46370070',
  'function' => 
  array (
  ),
  'version' => 'Smarty-3.1.13',
  'unifunc' => 'content_59196a5fc15888_57373829',
  'variables' => 
  array (
    'eleve' => 0,
    'recordingType' => 0,
  ),
  'has_nocache_code' => false,
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_59196a5fc15888_57373829')) {function content_59196a5fc15888_57373829($_smarty_tpl) {?><div class="panel panel-default" id="panel1">

    <div class="panel-heading">
        <h4 class="panel-title">
        <a data-toggle="collapse" data-target="#collapse1" href="#collapse1">Élève</a>
        </h4>
    </div>

    <div id="collapse1" class="panel-collapse collapse">

        <div class="row panel-body">

            <div class="col-md-4 col-sm-12">

                <div class="form-group">
                    <label for="nom">Nom:</label>
                    <input type="text" maxlength="30" size="20" name="nom" id="nom" value="<?php echo $_smarty_tpl->tpl_vars['eleve']->value['nom'];?>
" class="text-uppercase form-control">
                    <br>
                </div>

                <div class="form-group">
                    <label for="prenom">Prénom:</label>
                    <input type="text" maxlength="30" size="20" name="prenom" id="prenom" value="<?php echo $_smarty_tpl->tpl_vars['eleve']->value['prenom'];?>
" class="form-control">
                </div>

                <div class="form-group">
                    <label for="annee">Année:</label>
                    <input type="text" maxlength="2" size="2" name="annee" id="annee" value="<?php echo $_smarty_tpl->tpl_vars['eleve']->value['annee'];?>
" class="text-uppercase form-control">
                    <div class="help-block">(SEULEMENT L'ANNÉE - attention à distinguer les 1C, des 1S et des 1D)</div>
                </div>

                <div class="form-group">
                    <label for="sexe">Sexe</label>
                    <input type="text" maxlength="1" size="1" name="sexe" id="sexe" value="<?php echo $_smarty_tpl->tpl_vars['eleve']->value['sexe'];?>
" class="text-uppercase form-control">
                    <div class="help-block">(M ou F)</div>
                </div>

            </div>

            <div class="col-md-4 col-sm-12">

                <div class="form-group">
                    <label for="classe">Classe:</label>
                    <input type="text" maxlength="6" size="6" name="classe" id="classe" value="<?php echo $_smarty_tpl->tpl_vars['eleve']->value['classe'];?>
" class="text-uppercase form-control">
                </div>

                <div class="form-group">
                    <label for="groupe">Groupe:</label>
                    <input type="text" maxlength="6" size="6" name="groupe" id="groupe" value="<?php echo $_smarty_tpl->tpl_vars['eleve']->value['groupe'];?>
" class="text-uppercase form-control">
                </div>

                <div class="form-group">
                    <label for="section">Section</label>
                    <select name="section" id="section" class="form-control">
                        <option value=''>Section</option>
                        <option value='TQ' <?php if ($_smarty_tpl->tpl_vars['eleve']->value['section']=='TQ'){?> selected<?php }?>>TQ</option>
                        <option value='GT' <?php if ($_smarty_tpl->tpl_vars['eleve']->value['section']=='GT'){?> selected<?php }?>>GT</option>
                        <option value='TT' <?php if ($_smarty_tpl->tpl_vars['eleve']->value['section']=='TT'){?> selected<?php }?>>TT</option>
                        <option value='S' <?php if ($_smarty_tpl->tpl_vars['eleve']->value['section']=='S'){?> selected<?php }?>>S</option>
                        <option value='PARTI' <?php if ($_smarty_tpl->tpl_vars['eleve']->value['section']=='PARTI'){?> selected<?php }?>>PARTI</option>
                    </select>
                </div>


                <div class="form-group">
                    <label for="matricule">Matricule:</label>
                    <input type="text" maxlength="6" size="6" name="matricule" id="matricule" value="<?php echo $_smarty_tpl->tpl_vars['eleve']->value['matricule'];?>
" class="form-control" <?php if ($_smarty_tpl->tpl_vars['recordingType']->value=='modif'){?>readonly="readonly" <?php }?>>
                    <div class="help-block">
                        <?php if ($_smarty_tpl->tpl_vars['recordingType']->value=='modif'){?> non modifiable.<?php }?> Veiller à indiquer exclusivement le matricule officiel
                    </div>
                </div>

            </div>
            <!-- col-md-... -->

            <div class="col-md-4 col-sm-12">

                <div class="form-group">
                    <label for="DateNaiss">Date de naissance:</label>
                    <input type="text" name="DateNaiss" id="DateNaiss" maxlength="11" type="text" value="<?php echo $_smarty_tpl->tpl_vars['eleve']->value['DateNaiss'];?>
" class="form-control">
                    <div class="help-block">Utiliser le format jj/mm/AAAA</div>
                </div>

                <div class="form-group">
                    <label for="commNaissance">Commune de naissance</label>
                    <input type="text" name="commNaissance" id="commNaissance" maxlength="30" value="<?php echo $_smarty_tpl->tpl_vars['eleve']->value['commNaissance'];?>
" class="form-control">
                </div>

                <div class="form-group">
                    <label for="adresseEleve">Adresse</label>
                    <input type="text" name="adresseEleve" id="adresseEleve" maxlenght="40" value="<?php echo $_smarty_tpl->tpl_vars['eleve']->value['adresseEleve'];?>
" class="form-control">
                </div>

                <div class="form-group">
                    <label for="cpostEleve">Code Postal</label>
                    <input type="text" name="cpostEleve" id="cpostEleve" maxlength="6" value="<?php echo $_smarty_tpl->tpl_vars['eleve']->value['cpostEleve'];?>
" class="form-control">
                </div>

                <div class="form-group">
                    <label for="localiteEleve">Commune</label>
                    <input type="text" name="localiteEleve" id="localiteEleve" maxlength="30" value="<?php echo $_smarty_tpl->tpl_vars['eleve']->value['localiteEleve'];?>
" class="form-control">
                </div>

            </div>
            <!-- col-md-... -->

        </div>
        <!-- row -->

    </div>
    <!-- collapse -->

</div>
<!-- panel -->
<?php }} ?>
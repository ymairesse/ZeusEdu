<?php
/* Smarty version 3.1.34-dev-7, created on 2021-03-14 18:30:19
  from '/home/yves/www/sio2/peda/bullISND/templates/admin/formEditMatiere.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_604e482b05b747_82032364',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    'bf675b44ed9495bc6790e78b906a1285651f25c8' => 
    array (
      0 => '/home/yves/www/sio2/peda/bullISND/templates/admin/formEditMatiere.tpl',
      1 => 1615743011,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_604e482b05b747_82032364 (Smarty_Internal_Template $_smarty_tpl) {
if ((isset($_smarty_tpl->tpl_vars['detailsCours']->value))) {?>

<h2>Modfication d'une matière existante</h2>

    <?php if (((isset($_smarty_tpl->tpl_vars['fullEditable']->value)) && ($_smarty_tpl->tpl_vars['fullEditable']->value == false))) {?>
        <div class="alert alert-warning alert-dismissable">
            <h4>Avertissement</h4>
            <p>Cette matière est affectée à des élèves ou à des professeurs: seul le libellé est modifiable. Il n'est pas possible de la supprimer.</p>
        </div>
    <?php }?>

<form id="matiereEdit">

    <table class="table table-condensed">
        <thead>
            <tr>
                <th style="width:40%">

                    <div class="btn-group btn-group-justified">
                        <a href="#" type="button" class="btn btn-success" id="nouvelleMatiere">
                            Créer une nouvelle matière sur ce modèle
                        </a>
                        <a href="#" type="button" class="btn btn-danger" id="deleteMatiere" <?php if (!($_smarty_tpl->tpl_vars['fullEditable']->value)) {?> disabled <?php }?>>Supprimer cette matière</a>
                    </div>
                </th>
                <th style="width:60%">
                    <button type="button" class="btn btn-primary btn-xs info" style="float:left; margin-right:1em;" name="button"><i class="fa fa-info"></i> </button>
                    <p>Distinction entre "cours" et "matière".</p>
                    <div class="hidden">
                    <p>Il est important de distinguer les matières (qui sont enseignées à tous les élèves d'un niveau d'étude) et les cours qui sont les matières enseignées à tel ou tel groupe d'élèves. Tous les élèves d'un niveau d'étude suivent les mêmes matières mais dans des "cours" différents avec des enseignants différents.</p>
                </div>
                </th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>
                    <div class="form-group">
                        <label for="niveau">Niveau</label>
                        <select name="niveau" id="leNiveau" class="mod form-control">
                            <?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeNiveaux']->value, 'unNiveau');
$_smarty_tpl->tpl_vars['unNiveau']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['unNiveau']->value) {
$_smarty_tpl->tpl_vars['unNiveau']->do_else = false;
?>
                            <option value="<?php echo $_smarty_tpl->tpl_vars['unNiveau']->value;?>
"<?php if ((isset($_smarty_tpl->tpl_vars['detailsCours']->value['annee'])) && ($_smarty_tpl->tpl_vars['unNiveau']->value == $_smarty_tpl->tpl_vars['detailsCours']->value['annee'])) {?> selected="selected"
                                <?php } else { ?>
                                <?php if (!($_smarty_tpl->tpl_vars['fullEditable']->value)) {?> disabled="disabled"<?php }?>
                                <?php }?>><?php echo $_smarty_tpl->tpl_vars['unNiveau']->value;?>
e année</option>
                            <?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
                        </select>
                    </div>
                </td>
                <td style="vertical-align: middle;">
                    <button type="button" class="btn btn-primary btn-xs info" style="float:left; margin-right:1em;" name="button"><i class="fa fa-info"></i> </button>
                    <p>Année d'étude dans lequel la matière est enseignée.</p>
                    <div class="hidden">
                        <p>Il reste possible d'affecter des élèves à un cours d'une année d'étude qui n'est pas celle dans laquelle ils sont inscrits.</p>
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    <div class="form-group">
                        <label for="forme" title="Liste basée sur les 'formes' figurant déjà dans les autres matières (<?php echo implode($_smarty_tpl->tpl_vars['listeFormes']->value,',');?>
)">Forme</label>
                        <select name="forme" id="forme" class="mod form-control">
                            <?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeFormes']->value, 'uneForme');
$_smarty_tpl->tpl_vars['uneForme']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['uneForme']->value) {
$_smarty_tpl->tpl_vars['uneForme']->do_else = false;
?>
                            <option value="<?php echo $_smarty_tpl->tpl_vars['uneForme']->value;?>
"<?php if (((isset($_smarty_tpl->tpl_vars['detailsCours']->value['forme'])) && ($_smarty_tpl->tpl_vars['uneForme']->value == $_smarty_tpl->tpl_vars['detailsCours']->value['forme']))) {?> selected="selected"
                                <?php } else { ?>
                                <?php if (!($_smarty_tpl->tpl_vars['fullEditable']->value)) {?> disabled="disabled"<?php }?>
                                <?php }?>><?php echo $_smarty_tpl->tpl_vars['uneForme']->value;?>
</option>
                            <?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
                        </select>
                    </div>
                </td>
                <td style="vertical-align: middle;">
                    <button type="button" class="btn btn-primary btn-xs info" style="float:left; margin-right:1em;" name="button"><i class="fa fa-info"></i> </button>
                    <p>Forme d'enseignement ("GT", "TT", "TQ",...)</p>
                    <div class="hidden">
                    <p>Dans le logiciel ProEco qui sert de base pour l'importation des  (et donc, des matières), chacun d'eux est défini dans une forme d'enseignement. Cette "forme" figure dans le nom conventionnel technique de chaque matière.</p>
                    <p>Exemple: la matière "4 GT:FR4" fait partie de la forme "GT"; la matière "5 TQ:EDPS" fait partie de la forme TQ.</p>
                    <p>Les "formes" sélectionnables ici sont celles qui sont utilisées dans la nomenclature "ProEco" et qui figurent dans les cours importés en masse à l'initialisation.</p>
                    <p>Lors de la création d'une nouvelle matière, sélectionner l'une des "formes" proposées dans la liste. Pour disposer d'autres "formes", il faut importer en CSV au moins un cours disposant de cette "forme". Il n'est pas prévu de pouvoir définir des "formes" séparément.</p>
                    </div>
                </td>
            </tr>

            <tr>
                <td>
                    <div class="form-group">
                        <label for="section" title="Liste des sections déclarées dans la base de données (<?php echo implode($_smarty_tpl->tpl_vars['listeSections']->value,',');?>
)">Section</label>
                        <select name="section" id="section" class="mod form-control">
                            <?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeSections']->value, 'uneSection');
$_smarty_tpl->tpl_vars['uneSection']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['uneSection']->value) {
$_smarty_tpl->tpl_vars['uneSection']->do_else = false;
?>
                            <option value="<?php echo $_smarty_tpl->tpl_vars['uneSection']->value;?>
"<?php if (((isset($_smarty_tpl->tpl_vars['detailsCours']->value['section'])) && ($_smarty_tpl->tpl_vars['uneSection']->value == $_smarty_tpl->tpl_vars['detailsCours']->value['section']))) {?> selected="selected"
                            <?php } else {
if (!($_smarty_tpl->tpl_vars['fullEditable']->value)) {?> disabled="disabled"<?php }?>
                            <?php }?>><?php echo $_smarty_tpl->tpl_vars['uneSection']->value;?>
</option>
                            <?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
                        </select>
                    </div>
                </td>
                <td style="vertical-align: middle;">
                    <button type="button" class="btn btn-primary btn-xs info" style="float:left; margin-right:1em;" name="button"><i class="fa fa-info"></i> </button>
                    <p>La "section" est une information purement indicative. </p>
                    <div class="hidden"><p>Elle ne fait pas partie de la dénomination technique d'une matière. Des élèves d'uene section de qualification peuvent être inscrits à des cours de la section générale de transition.</p>
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    <div class="form-group">
                        <label for="code">Abréviation de la matière</label>
                        <input type="text" name="code" id="code" class="mod maj form-control" value="<?php echo $_smarty_tpl->tpl_vars['detailsCours']->value['code'];?>
"<?php if (!($_smarty_tpl->tpl_vars['fullEditable']->value)) {?> readonly="readonly"<?php }?> maxlength="14">
                    </div>
                </td>
                <td style="vertical-align: middle;">
                    <button type="button" class="btn btn-primary btn-xs info" style="float:left; margin-right:1em;" name="button"><i class="fa fa-info"></i> </button>
                    <p>Nom court pour la matière.</p>
                    <div class="hidden">
                        <p> 14 caractère maximum. Uniquement des caractères alphabétiques.</p>
                    </div>
                </td>
            <tr>
                <td>
                    <div class="form-group">
                        <label for="nbheures">Nb Heures</label>
                        <input type="text" name="nbheures" id="nbheures" maxlength="2" class="mod form-control" value="<?php echo $_smarty_tpl->tpl_vars['detailsCours']->value['nbheures'];?>
"<?php if (!($_smarty_tpl->tpl_vars['fullEditable']->value)) {?> readonly="readonly"<?php }?>>
                    </div>
                </td>
                <td style="vertical-align: middle;">
                    <button type="button" class="btn btn-primary btn-xs info" style="float:left; margin-right:1em;" name="button"><i class="fa fa-info"></i> </button>
                    <p>Le nombre d'heures de cours pour cette matière.</p>
                    <div class="hidden">
                        <p>Il est possible d'avoir plusieurs cours qui portent la même dénomination mais des nombres d'heures d'enseignement différnts. On les considère alors comme deux matières différentes. FR4 et FR6 sont deux "matières" différentes.</p>
                    </div
                </td>
            </tr>
            <tr>
                <td>
                    <div class="form-group">
                        <label for="cadre" title="Pour la signification des 'cadres', voir la documentation de ProEco">Cadre/statut</label>
                        <select name="cadre" id="cadre" class="mod form-control">
                            <?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeCadresStatuts']->value, 'unStatut', false, 'unCadre');
$_smarty_tpl->tpl_vars['unStatut']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['unCadre']->value => $_smarty_tpl->tpl_vars['unStatut']->value) {
$_smarty_tpl->tpl_vars['unStatut']->do_else = false;
?>
                            <option value="<?php echo $_smarty_tpl->tpl_vars['unCadre']->value;?>
"<?php if (((isset($_smarty_tpl->tpl_vars['detailsCours']->value['cadre'])) && ($_smarty_tpl->tpl_vars['detailsCours']->value['cadre'] == $_smarty_tpl->tpl_vars['unCadre']->value))) {?> selected="selected"
                            <?php } else {
if (!($_smarty_tpl->tpl_vars['fullEditable']->value)) {?> disabled="disabled"<?php }?>
                            <?php }?>> Cadre <?php echo $_smarty_tpl->tpl_vars['unCadre']->value;?>
 => <?php echo $_smarty_tpl->tpl_vars['unStatut']->value;?>
</option>
                            <?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
                        </select>
                    </div>
                </td>
                <td style="vertical-align: middle;">
                    <button type="button" class="btn btn-primary btn-xs info" style="float:left; margin-right:1em;" name="button"><i class="fa fa-info"></i> </button>

                    <p>En Belgique francophone (au moins), chaque matière fait partie d'un "cadre".</p>
                    <div class="hidden">
                        <p>Celui-ci est, en qulque sorte, une indication de l'importance de la matière dans la section concernée.</p>
                        <p>La notion de "cadre" intervient dans ProEco (le logiciel dont sont exportées les informations traitées ici). On peut établir une correspondance entre la notion de "cadre" et celle de "statut" de la matière. Seul le statut est utilisé dans cette application. La correspondance entre les "cadres" et les "statuts" figure dans la table didac_statutCours.</p>
                        <p>Outre le "cadre" (information numérique), cette table contient entre-autres l'information
                            <ul>
                                <li>du statut de la matière (AC, OG, OB,...)</li>
                                <li>le rang dans lequel la matière apparaît dans les listes</li>
                                <li>le fait que la matière puisse être considérée en échec si la cote est < 50%</li>
                                <li>le fait que la matière doit être (ou non) comptabilisée dans la somme des cotes obtenues par l'élève</li>
                            </ul>
                        </p>
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    <div class="form-group">
                        <label for="libelle">Libellé</label>
                        <input type="text" maxlength="50" name="libelle" id="libelle" class="mod maj form-control" value="<?php echo $_smarty_tpl->tpl_vars['detailsCours']->value['libelle'];?>
">
                    </div>
                </td>
                <td style="vertical-align: middle;">
                    <button type="button" class="btn btn-primary btn-xs info" style="float:left; margin-right:1em;" name="button"><i class="fa fa-info"></i> </button>
                    <p>Le libellé de la matière.<p>
                        <div class="hidden">
                            Le texte descriptif qui apparaîtra dans tous les modules de l'application. Maximum 60 caractères</p>
                        </div>

                </td>
            </tr>
            <tr>
                <td>
                    <div class="input-group">
                        <label>La matière s'appellera</label>
                        <p class="form-control-static" id="laMatiere"><?php echo $_smarty_tpl->tpl_vars['detailsCours']->value['cours'];?>
</p>
                    </div>
                </td>
                <td style="vertical-align: middle;">
                    <button type="button" class="btn btn-primary btn-xs info" style="float:left; margin-right:1em;" name="button"><i class="fa fa-info"></i> </button>

                    <p>Synthèse de l'année d'étude, de la forme, du nom technique de la matière et du nombre d'heures de cours pour cette matière.</p>
                </td>
            </tr>

        </tbody>
        <tfoot>
            <td>
                <div class="btn-group btn-group-justified">
             <div class="btn-group">
               <button type="button" class="btn btn-primary" id="btn-saveMatiere">Enregistrer</button>
             </div>
             <div class="btn-group">
               <button type="reset" class="btn btn-default">Annuler</button>
             </div>

           </div>
            </td>
            <td>&nbsp;</td>

        </tfoot>
    </table>

    <input type="hidden" name="cours" value="<?php echo $_smarty_tpl->tpl_vars['cours']->value;?>
">
    <input type="hidden" name="fullEdition" value="<?php if ($_smarty_tpl->tpl_vars['fullEditable']->value) {?>1<?php } else { ?>0<?php }?>" id="fullEdition">

</form>

    <?php } else { ?>

    <p class="avertissement">Veuillez sélectionner un niveau <br>et une matière ci-contre</p>

<?php }?>

<?php echo '<script'; ?>
 type="text/javascript">

    $(document).ready(function(){

    	$("#matiereEdit").validate({
    		rules: {
    			niveau: { required: true, number: true },
    			section:{ required: true },
    			code: { required: true },
    			cadreStatut: { required: true },
    			nbheures: { required: true, number: true },
    			libelle: { required: true }
    			},
    		errorElement: "span"
    		});

        $(".mod").change(function(){
    		var matiere = $("#leNiveau").val()+$("#forme").val()+':'+$("#code").val()+$("#nbheures").val();
    		$("#laMatiere").text(matiere);
    		})

    	$(".mod").blur(function(){
    		$(this).val(String($(this).val()).toUpperCase());
    		var matiere = $("#leNiveau").val()+$("#forme").val()+':'+$("#code").val()+$("#nbheures").val();
    		$("#laMatiere").text(matiere);
    		})
    })

<?php echo '</script'; ?>
>
<?php }
}

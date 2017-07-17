<?php

require_once '../../../config.inc.php';

// définition de la class Application
require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

// définition de la class USER utilisée en variable de SESSION
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';

session_start();
if (!(isset($_SESSION[APPLICATION]))) {
    echo "<script type='text/javascript'>document.location.replace('".BASEDIR."');</script>";
    exit;
}

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

require_once INSTALL_DIR.'/inc/classes/classEleve.inc.php';

$module = $Application->getModule(3);
require_once INSTALL_DIR."/$module/inc/classes/classAdes.inc.php";
$Ades = new Ades();

$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : null;
$form = array();
parse_str($formulaire, $form);

$debut = $form['debut'];
$fin = $form['fin'];
$matricule = isset($form['matricule']) ? $form['matricule'] : null;
$niveau = isset($form['niveau']) ? $form['niveau'] : null;
$classe = isset($form['classe']) ? $form['classe'] : null;

// détermination des types de faits à imprimer
$aImprimer = array();
foreach ($form AS $field => $value) {
    if (substr($field, 0, 4) == 'type') {
        $typeFait = explode('_', $field);
        $aImprimer[$typeFait[1]] = 1;
    }
}

// génération pour un élève isolé, une classe ou le niveau d'étude
if ($matricule == Null) {
    if ($classe == Null) {
        $listeEleves = $listeEleves = $Ecole->listeElevesNiveaux($niveau);
        }
        else {
            $listeEleves = $Ecole->listeEleves($classe, 'groupe');
        }
    }
    else $listeEleves = array($matricule => Eleve::staticGetDetailsEleve($matricule));

require_once INSTALL_DIR."/smarty/Smarty.class.php";
$smarty = new Smarty();
$smarty->template_dir = "../../templates";
$smarty->compile_dir = "../../templates_c";

$listeChamps = $Ades->champsInContexte('tableau');
$listeFaits = $Ades->fichesDisciplinaires($listeEleves, $debut, $fin, ANNEESCOLAIRE, $aImprimer);

$descriptionsChamps = $Ades->listeChamps();

$smarty->assign('debut', $debut);
$smarty->assign('fin', $fin);
$smarty->assign('listeChamps', $listeChamps);
$smarty->assign('listeFaits', $listeFaits);
$smarty->assign('classe', $classe);
$smarty->assign('listeEleves', $listeEleves);
$smarty->assign('listeTypesFaits', $Ades->getTypesFaits());
$smarty->assign('descriptionsChamps', $descriptionsChamps);

echo $smarty->fetch('eleve/synthese.tpl');

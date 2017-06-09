<?php

require_once '../../../config.inc.php';

// définition de la class Application
require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

// caractéristiques d'un fait édité
$type = isset($_POST['type']) ? $_POST['type'] : null;
$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : null;
$classe = isset($_POST['classe']) ? $_POST['classe'] : null;
// null si c'est un nouveau fait
$idfait = isset($_POST['idfait'])?$_POST['idfait']: null;
$mode = isset($_POST['mode'])?$_POST['mode']:null;

$module = $Application->getModule(3);

// définition de la class USER utilisée en variable de SESSION
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();
if (!(isset($_SESSION[APPLICATION]))) {
    die("<div class='alert alert-danger'>".EXPIRED."</div>");
}

$User = $_SESSION[APPLICATION];

require_once INSTALL_DIR."/$module/inc/classes/classAdes.inc.php";
$Ades = new Ades();

require_once INSTALL_DIR."/$module/inc/classes/classEleveAdes.inc.php";
$ficheDisc = new EleveAdes($matricule);

require_once INSTALL_DIR."/smarty/Smarty.class.php";
$smarty = new Smarty();
$smarty->template_dir = "../../templates";
$smarty->compile_dir = "../../templates_c";

if ($idfait != Null) {
    // on ne vient pas du case 'new', il faut assigner le $fait et le $type
    $fait = $ficheDisc->lireUnFait($idfait);
    $type = $fait['type'];
    $matricule = $fait['matricule'];
    $smarty->assign('fait', $fait);
    $smarty->assign('type', $type);
}
else {
    $prototype = $Ades->prototypeFait($type);
    $faitVide = $ficheDisc->faitVide($prototype, $type, $User->identite());
    $smarty->assign('fait', $faitVide);
    $smarty->assign('type', $type);
}

// mode = delete ou edit
$smarty->assign('mode',$mode);

require_once INSTALL_DIR.'/inc/classes/classEleve.inc.php';
$Eleve = new eleve($matricule);
$Eleve = $Eleve->getDetailsEleve();
$smarty->assign('Eleve',$Eleve);

$smarty->assign('anneeScolaire', ANNEESCOLAIRE);

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

// liste nécessaire pour obtenir une liste des profs à l'origine du signalement du fait
$smarty->assign('listeProfs', $Ecole->listeProfs(false));
// acronyme de l'utilisateur pour indiquer qui a pris note du fait
$smarty->assign('acronyme', $User->acronyme());
$smarty->assign('qui', $User->acronyme());

$prototype = $Ades->prototypeFait($type);
$smarty->assign('prototype', $prototype);

$listeRetenues = $Ades->listeRetenues($prototype['structure']['typeRetenue'], true);
$smarty->assign('listeRetenues', $listeRetenues);

// les textes enregistrés pour les textarea
$smarty->assign('listeMemos', $Ades->listeMemos($User->acronyme()));

$smarty->assign('classe', $classe);
$smarty->assign('matricule', $matricule);
$smarty->display('faitDisc/editFaitDisciplinaire.tpl');

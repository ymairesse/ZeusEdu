<?php

require_once '../../../config.inc.php';

// définition de la class Application
require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

$idfait = isset($_POST['idfait'])?$_POST['idfait']: null;

$module = $Application->getModule(3);

require_once INSTALL_DIR."/$module/inc/classes/classAdes.inc.php";
$Ades = new Ades();
require_once INSTALL_DIR."/$module/inc/classes/classEleveAdes.inc.php";
$ficheDisc = new EleveAdes(Null);

require_once INSTALL_DIR."/smarty/Smarty.class.php";
$smarty = new Smarty();
$smarty->template_dir = "../../templates";
$smarty->compile_dir = "../../templates_c";

if ($idfait != Null) {
    $fait = $ficheDisc->lireUnFait($idfait);
    $type = $fait['type'];
    $matricule = $fait['matricule'];
    $smarty->assign('fait', $fait);
    $smarty->assign('type', $type);
}

require_once INSTALL_DIR.'/inc/classes/classEleve.inc.php';
$Eleve = new eleve($matricule);
$Eleve = $Eleve->getDetailsEleve();
$smarty->assign('Eleve',$Eleve);

$prototype = $Ades->prototypeFait($type);
$smarty->assign('prototype', $prototype);

$listeRetenues = $Ades->listeRetenues($prototype['structure']['typeRetenue'], true);
$smarty->assign('listeRetenues', $listeRetenues);

// $smarty->assign('classe', $classe);
// $smarty->assign('matricule', $matricule);
$formulaire = $smarty->fetch('faitDisc/delFaitDisciplinaire.tpl');
echo $formulaire;

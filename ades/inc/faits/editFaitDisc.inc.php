<?php

require_once '../../../config.inc.php';

// définition de la class Application
require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

// répertoire du module actuel
$module = $Application->getModule(3);

// durée de validité pour les Cookies
$unAn = time() + 365 * 24 * 3600;

// définition de la class USER utilisée en variable de SESSION
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';

session_start();
if (!(isset($_SESSION[APPLICATION]))) {
    echo "<script type='text/javascript'>document.location.replace('".BASEDIR."');</script>";
    exit;
}

$User = $_SESSION[APPLICATION];
$acronyme = $User->acronyme();

// null si c'est un nouveau fait
$idfait = isset($_POST['idfait']) ? $_POST['idfait']: null;
// $type est défini pour un nouveau fait (data-typefait sur le bouton)
$type = isset($_POST['type']) ? $_POST['type']: null;
$matricule = isset($_POST['matricule']) ? $_POST['matricule']: null;

require_once INSTALL_DIR."/$module/inc/classes/classAdes.inc.php";
$Ades = new Ades();

require_once INSTALL_DIR."/$module/inc/classes/classEleveAdes.inc.php";
$EleveAdes = new EleveAdes();

require_once INSTALL_DIR."/smarty/Smarty.class.php";
$smarty = new Smarty();
$smarty->template_dir = "../../templates";
$smarty->compile_dir = "../../templates_c";

// il faut connaître les caractéristiques de ce type de fait (couleurs,...)
$prototype = $Ades->prototypeFait($type);
$smarty->assign('prototype', $prototype);

if ($idfait != Null) {
    // on recherche les caractéristiques du fait dans la BD
    $fait = $EleveAdes->lireUnFait($idfait);
    $smarty->assign('fait', $fait);
}
else {
    // on crée un nouveau fait basé sur le type demandé.
    $faitVide = $EleveAdes->faitVide($prototype, $type, $acronyme);
    $smarty->assign('fait', $faitVide);
}

require_once INSTALL_DIR.'/inc/classes/classEleve.inc.php';
$Eleve = Eleve::staticGetDetailsEleve($matricule);
$smarty->assign('Eleve',$Eleve);

$smarty->assign('idfait', $idfait);
$smarty->assign('anneeScolaire', ANNEESCOLAIRE);
$smarty->assign('qui', $acronyme);

// liste des dates de retenues possibles
$listeRetenues = $Ades->listeRetenues($prototype['structure']['typeRetenue'], true);

$smarty->assign('listeRetenues', $listeRetenues);

// les textes enregistrés pour les textarea
$smarty->assign('listeMemos', $Ades->listeMemos($acronyme));

$smarty->display('faitDisc/editFaitDisciplinaire.tpl');

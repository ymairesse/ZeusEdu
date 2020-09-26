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

$type = isset($_POST['type']) ? $_POST['type'] : Null;
$item = isset($_POST['item']) ? $_POST['item'] : Null;
$periode = isset($_POST['periode']) ? $_POST['periode'] : Null;
$classe = isset($_POST['classe']) ? $_POST['classe'] : Null;

$matricule = Null;
$coursGrp = Null;

switch ($type) {
    case 'eleve':
        require_once INSTALL_DIR.'/inc/classes/classEleve.inc.php';
        $eleve = Eleve::staticGetDetailsEleve($item);
        $texte = sprintf('tous les cours de %s %s', $eleve['prenom'], $eleve['nom']);
        $matricule = $eleve['matricule'];
        break;
    case 'coursGrp':
        require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
        $Ecole = new Ecole();
        $cours = $Ecole->detailsCours($item);
        $coursGrp = $item;
        $texte = sprintf('le cours [%s]: %s %s %s h', $coursGrp, $cours['statut'], $cours['libelle'], $cours['nbheures']);
        break;
    case 'classe':
        $classe = $item;
        $texte = sprintf('la classe %s', $classe);
        break;
    case 'eleveCours':
        $item = explode('##', $item);
        $matricule = $item[0];
        $coursGrp = $item[1];

        require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
        $Ecole = new Ecole();
        $cours = $Ecole->detailsCours($coursGrp);

        require_once INSTALL_DIR.'/inc/classes/classEleve.inc.php';
        $eleve = Eleve::staticGetDetailsEleve($matricule);

        $texte = sprintf('le Cours %s de %s %s', $coursGrp, $eleve['prenom'], $eleve['nom']);
        break;

    default:
        die();
        break;
    }



$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR."/smarty/Smarty.class.php";
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

$smarty->assign('cible', $texte);
$smarty->assign('type', $type);
$smarty->assign('coursGrp', $coursGrp);
$smarty->assign('classe', $classe);
$smarty->assign('matricule', $matricule);
$smarty->assign('periode', $periode);

$smarty->display ('titu/formLocks.tpl');

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

$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : null;
$form = array();
parse_str($formulaire, $form);

$type = $form['type'];

$action = $form['action'];
$coursGrp = $form['coursGrp'];
$classe = $form['classe'];
$matricule = $form['matricule'];
$periode = $form['periode'];

$ds = DIRECTORY_SEPARATOR;
$module = $Application::getModule(3);
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classBulletin.inc.php';
$Bulletin = new Bulletin();

require_once INSTALL_DIR.$ds.'inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

switch ($type) {
    case 'eleve':
        $listeEleves = $matricule;
        $listeCours = array_keys($Bulletin->listeCoursGrpEleves($matricule, $periode)[$matricule]);
        break;
    case 'coursGrp':
        require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
        $Ecole = new Ecole();
        $listeEleves = array_keys($Ecole->listeEleves($classe, 'groupe'));
        $listeCours = $coursGrp;
        break;
    case 'classe':
        $listeEleves = $Ecole->listeEleves($classe, 'groupe');
        $listeCours = $Bulletin->listeCoursGrpEleves($listeEleves, $periode);
        break;
    case 'eleveCours':
        $listeEleves = $matricule;
        $listeCours = $coursGrp;
        break;
    default:
        die();
        break;
    }

$nb = $Bulletin->saveLocksBulletin($listeEleves, $listeCours, $type, $action, $periode);
echo $nb;

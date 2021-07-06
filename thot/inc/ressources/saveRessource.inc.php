<?php

require_once '../../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

// définition de la class USER utilisée en variable de SESSION
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();

if (!(isset($_SESSION[APPLICATION]))) {
    echo "<script type='text/javascript'>document.location.replace('".BASEDIR."');</script>";
    exit;
}

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();
$module = $Application->getModule(3);

$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : null;
$form = array();
parse_str($formulaire, $form);

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/class.reservations.php';
$Reservation = new Reservation();

$reference = isset($form['reference']) ? $form['reference'] : Null;
$idType = isset($form['idType']) ? $form['idType'] : Null;
$idRessource = isset($form['idRessource']) ? $form['idRessource'] : Null;

// s'agit-il d'une mise à jour, d'un clonage, d'une nouvelle ressource?
$addEditClone = isset($form['addEditClone']) ? $form['addEditClone'] : Null;

$html = Null;
// cette référence existe déjà pour ce type de ressources
// et c'est un clonage ou une nouvelle ressource
// dans ce cas, on n'enregistre rien et la procédure appelante expliquera le problème
if ($Reservation->referenceExiste($idType, $reference) && in_array($addEditClone, array('add', 'clone'))) {
    $idRessource = Null;
    }
    else {
        $idRessource = $Reservation->saveRessource($form);
        // recharger la liste des ressources
        $listeRessources = $Reservation->getRessourceByType($idType);

        require_once INSTALL_DIR.'/smarty/Smarty.class.php';
        $smarty = new Smarty();
        $smarty->template_dir = '../../templates';
        $smarty->compile_dir = '../../templates_c';

        $smarty->assign('idRessource', $idRessource);
        $smarty->assign('listeRessources', $listeRessources);
        $html = $smarty->fetch('ressources/selectRessource.tpl');
    }

echo json_encode(array('addEditClone' => $addEditClone, 'idRessource' => $idRessource, 'html' => $html));

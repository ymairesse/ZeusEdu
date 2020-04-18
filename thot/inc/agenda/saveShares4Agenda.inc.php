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

// récupérer le formulaire d'encodage du JDC
$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : null;
$form = array();
parse_str($formulaire, $form);

$idAgenda = isset($form['idAgenda']) ? $form['idAgenda'] : Null;
$type = isset($form['type']) ? $form['type'] : Null;
$TOUS = isset($form['TOUS']) ? $form['TOUS'] : Null;

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds."inc/classes/class.Agenda.php";
$Agenda = new Agenda();

switch ($type) {
    case 'profs':
        if ($TOUS == 'tous') {
            $nb = $Agenda->saveShares4Agenda($idAgenda, $type, true, Null);
        }
        else {
            $liste = $form['profs'];
            $nb = $Agenda->saveShares4Agenda($idAgenda, $type, false, $liste);
        }
        break;
    case 'classe':
        if ($TOUS == 'tous') {
            $liste = $form['classe'];
            $nb = $Agenda->saveShares4Agenda($idAgenda, $type, true, $liste);
        }
        else {
            $liste = $form['eleves'];
            $nb = $Agenda->saveShares4Agenda($idAgenda, $type, false, $liste);
        }
        break;
    case 'cours':
        if ($TOUS == 'tous') {
            $liste = $form['cours'];
            $nb = $Agenda->saveShares4Agenda($idAgenda, $type, true, $liste);
        }
        else {
            $liste = $form['eleves'];
            $nb = $Agenda->saveShares4Agenda($idAgenda, $type, false, $liste);
        }
        break;
    case 'coursGrp':
        if ($TOUS == 'tous') {
            $liste = $form['coursGrp'];
            $nb = $Agenda->saveShares4Agenda($idAgenda, $type, true, $liste);
        }
        else {
            $liste = $form['eleves'];
            $nb = $Agenda->saveShares4Agenda($idAgenda, $type, false, $liste);
        }
        break;
    case 'niveau':
        $liste = $form['selectNiveau'];
        $nb = $Agenda->saveShares4Agenda($idAgenda, $type, false, $liste);
        break;
    case 'ecole':
        $liste = 'tous';
        $nb = $Agenda->saveShares4Agenda($idAgenda, $type, false, $liste);
        break;
}

$listePartages = $Agenda->getShares4agenda($idAgenda, $acronyme);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

$smarty->assign('listePartages', $listePartages);
$smarty->display('agenda/include/listePartages.tpl');

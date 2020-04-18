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

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds."inc/classes/class.Agenda.php";
$Agenda = new Agenda();

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

$type = isset($_POST['type']) ? $_POST['type'] : Null;
$smarty->assign('type', $type);

switch ($type) {
    case 'coursGrp':
        require_once INSTALL_DIR.$ds.'inc/classes/classEcole.inc.php';
        $listeNiveaux = Ecole::listeNiveaux();
        $smarty->assign('listeNiveaux', $listeNiveaux);
        break;
    case 'cours':
        require_once INSTALL_DIR.$ds.'inc/classes/classEcole.inc.php';
        $listeNiveaux = Ecole::listeNiveaux();
        $smarty->assign('listeNiveaux', $listeNiveaux);
        break;
    case 'classe':
        require_once INSTALL_DIR.$ds.'inc/classes/classEcole.inc.php';
        $listeNiveaux = Ecole::listeNiveaux();
        $smarty->assign('listeNiveaux', $listeNiveaux);
        break;
    case 'niveau':
        require_once INSTALL_DIR.$ds.'inc/classes/classEcole.inc.php';
        $listeNiveaux = Ecole::listeNiveaux();
        $smarty->assign('listeNiveaux', $listeNiveaux);
        break;
    case 'profs':
        require_once INSTALL_DIR.$ds.'inc/classes/classEcole.inc.php';
        $listeProfs = Ecole::listeProfs(false);
        $smarty->assign('listeProfs', $listeProfs);
        break;
    case 'groupe':

        //  to be done

        break;
}

$smarty->display('agenda/modal/supplementModal.tpl');

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

$niveau = isset($_POST['niveau']) ? $_POST['niveau'] : Null;

$listePeriodes = range(1, PERIODEENCOURS);

// à prévoir dans un Cookie
$periode = 1;
// à prévoir dans un Cookie

$module = $Application->getModule(3);

$ds = DIRECTORY_SEPARATOR;

require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classBulletin.inc.php';
$Bulletin = new Bulletin();

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

$listeClasses = $Ecole->listeClassesNiveau($niveau, 'groupe', LISTESECTIONSBULL);

$directory = $Bulletin->flatDirectoryArchive('../../archives/'.ANNEESCOLAIRE, $niveau);

require_once INSTALL_DIR."/smarty/Smarty.class.php";
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds."templates";
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds."templates_c";

$smarty->assign('ANNEESCOLAIRE', ANNEESCOLAIRE);
$smarty->assign('niveau', $niveau);
$smarty->assign('listeClasses', $listeClasses);
$smarty->assign('listePeriodes', $listePeriodes);
$smarty->assign('directory', $directory);
$smarty->assign('periode', $periode);

$smarty->display('pdf/archiveNiveau.tpl');

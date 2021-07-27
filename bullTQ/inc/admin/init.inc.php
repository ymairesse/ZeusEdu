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

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

$module = $Application->getModule(3);

$ds = DIRECTORY_SEPARATOR;

require_once INSTALL_DIR.$ds.$module.'/inc/classes/classBullTQ.inc.php';
$BullTQ = new bullTQ();

$init = 0;
$init = $BullTQ->init('CommentProfs');
$init += $BullTQ->init('CotesCompetences');
$init += $BullTQ->init('CotesGlobales');
$init += $BullTQ->init('Mentions');

echo $init;

<?php


require_once '../../../config.inc.php';

session_start();

$date = isset($_POST['date']) ? $_POST['date'] : null;

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

require_once INSTALL_DIR.'/inc/classes/classThot.inc.php';
$thot = new Thot();

$infoRP = $thot->getInfoRp($date);
echo $infoRP['typeRP'];

<?php

require_once '../config.inc.php';

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
// ----------------------------------------------------------------------------
//


// placez votre code ici


//
// ----------------------------------------------------------------------------

$smarty->display('index.tpl');

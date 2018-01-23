<?php

require_once '../config.inc.php';


// ----------------------------------------------------------------------------
//

//
// ----------------------------------------------------------------------------

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();


$smarty->display('index.tpl');

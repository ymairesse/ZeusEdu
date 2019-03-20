<?php

switch ($mode) {
    case 'parents':
        require_once INSTALL_DIR.'/inc/classes/classThot.inc.php';
        $thot = new Thot();

        $stats = $thot->statsParents();
        $smarty->assign('statsParents', $stats);

        $smarty->assign('corpsPage', 'statsParents');
        break;
    case 'jdc':
        $listeCategories = $Jdc->getListeCategoriesJDC();
        $listeProfs = $Ecole->listeProfs();
        $debut = Application::postOrCookie('debut', $unAn);
        if ($debut == Null)
        	$debut = date('d/m/Y');

        $fin = Application::postOrCookie('fin', $unAn);
        if ($fin == Null)
        	$fin = date('d/m/Y');
        $smarty->assign('debut', $debut);
        $smarty->assign('fin', $fin);
        
        $smarty->assign('listeCategories', $listeCategories);
        $smarty->assign('listeProfs', $listeProfs);
        $smarty->assign('corpsPage', 'jdc/statsJdc');
        break;
    default:
        // wtf
        break;
}

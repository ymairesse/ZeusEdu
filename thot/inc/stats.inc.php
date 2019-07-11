<?php

switch ($mode) {
    case 'frequentation':
        require_once INSTALL_DIR.'/inc/classes/classThot.inc.php';
        $thot = new Thot();

        require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
        $Ecole = new Ecole();
        $listeClasses = $Ecole->listeClasses();
        $smarty->assign('listeClasses', $listeClasses);

        $date = isset($_POST['date']) ? $_POST['date'] : strftime('%d/%m/%Y');
        $smarty->assign('date', $date);

        $smarty->assign('corpsPage', 'stats/statsParents');
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

<?php

$etape = isset($_REQUEST['etape']) ? $_REQUEST['etape'] : null;
$mode = isset($_REQUEST['mode']) ? $_REQUEST['mode'] : null;
$id = isset($_REQUEST['id']) ? $_REQUEST['id'] : null;

$smarty->assign('PERIODESDELIBES', explode(',', PERIODESDELIBES));
$smarty->assign('PERIODEENCOURS', PERIODEENCOURS);

$application = $Application->repertoireActuel();

require_once INSTALL_DIR.'/inc/classes/classFlashInfo.inc.php';
$flashInfo = new flashInfo();

switch ($mode) {
    case 'del':
        $nb = $flashInfo->delFlashInfo($id, $application);
        $smarty->assign('message', array(
            'title' => DELETE,
            'texte' => "$nb nouvelle(s) supprimée(s)",
            'urgence' => 'warning',
            ));
        $smarty->assign('flashInfos', $flashInfo->listeFlashInfos($application));
        $smarty->assign('corpsPage', 'news/news');
        break;
    case 'edit':
        $smarty->assign('application', $application);
        switch ($etape) {
            case 'enregistrer':
                $data = $_POST;
                $data['application'] = $application;
                $nb = $flashInfo->saveFlashInfo($data);
                $smarty->assign('flashInfos', $flashInfo->listeFlashInfos($application));
                $smarty->assign('corpsPage', 'news/news');
                break;
            default:
                $lesFlashInfo = $flashInfo->getData($id);
                $smarty->assign('flashInfo', $lesFlashInfo);
                $smarty->assign('action', $action);
                $smarty->assign('mode', $mode);
                $smarty->assign('etape', 'enregistrer');
                $smarty->assign('corpsPage', 'news/editFlashInfo');
                break;
            }
        break;
    }

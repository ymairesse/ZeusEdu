<?php

$unAn = time() + 365 * 24 * 3600;
$etape = isset($_POST['etape']) ? $_POST['etape'] : null;
$bulletin = isset($_POST['bulletin']) ? $_POST['bulletin'] : PERIODEENCOURS;

if (isset($_POST['niveau'])) {
    $niveau = $_POST['niveau'];
    setcookie('niveau', $niveau, $unAn, null, null, false, true);
} else {
        $niveau = isset($_COOKIE['niveau']) ? $_COOKIE['niveau'] : null;
    }
$smarty->assign('niveau', $niveau);

$notice = isset($_POST['notice']) ? $_POST['notice'] : null;

$listeNiveaux = $Ecole->listeNiveaux();
$smarty->assign('listeNiveaux', $listeNiveaux);
$smarty->assign('nbBulletins', NBPERIODES);

switch ($etape) {
    case 'enregistrer':
        if ($niveau && $bulletin) {
            $nb = $Bulletin->saveNoticeCoordinateurs($niveau, $bulletin, $notice);
            $smarty->assign('bulletin', $bulletin);
            $smarty->assign('message', array(
                    'title' => 'Enregistrement',
                    'texte' => "$nb modification(s) enregistrée(s)",
                    'urgence' => 'success',
                    ));
        }
        // pas de break
    case 'showNiveau':
        $smarty->assign('selecteur', 'selectBulletinNiveau');
        $smarty->assign('bulletin', $bulletin);
        $smarty->assign('action', 'nota');
        if ($niveau && $bulletin) {
            $notice = $Bulletin->noticeCoordinateurs($bulletin, $niveau);
            $smarty->assign('notice', $notice);
            $smarty->assign('corpsPage', 'formNotas');
        }
        break;

    default:
        $listeNiveaux = $Ecole->listeNiveaux();
        $smarty->assign('selecteur', 'selectBulletinNiveau');
        $smarty->assign('bulletin', $bulletin);
        $smarty->assign('action', 'nota');
        $smarty->assign('mode', 'redaction');
        break;
    }

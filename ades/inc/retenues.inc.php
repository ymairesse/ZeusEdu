<?php

require_once INSTALL_DIR."/$module/inc/classes/classRetenue.inc.php";

$typeRetenue = isset($_POST['typeRetenue']) ? $_POST['typeRetenue'] : null;
$smarty->assign('typeRetenue', $typeRetenue);
$listeTypes = $Ades->getTypesRetenues();
$smarty->assign('listeTypes', $listeTypes);

switch ($mode) {
    case 'liste':
        switch ($etape) {
            case 'showListe':
                $idretenue = isset($_POST['idretenue']) ? $_POST['idretenue'] : Null;
                if ($idretenue != Null) {
                    $smarty->assign('etape', $etape);
                    $smarty->assign('idretenue', $idretenue);
                    $listeRetenues = $Ades->listeRetenues($typeRetenue, true);
                    $smarty->assign('listeRetenues', $listeRetenues);
                    $infosRetenue = $Ades->infosRetenue($idretenue);
                    $smarty->assign('infosRetenue', $infosRetenue);
                    $listeElevesRetenue = $Ades->listeElevesRetenue($idretenue);
                    $smarty->assign('listeEleves', $listeElevesRetenue);
                    $smarty->assign('selecteur', 'selecteurs/selectRetenueDate');
                    $smarty->assign('corpsPage', 'retenues/listeElevesRetenue');
                }
                break;
            default:
                $smarty->assign('etape', 'showListe');
                $smarty->assign('selecteur', 'selecteurs/selectRetenueDate');
                break;
        }
        $smarty->assign('action', $action);
        $smarty->assign('mode', $mode);
        break;

    case 'dates':
        $smarty->assign('selecteur', 'selecteurs/selectTypeRetenue');
        if (isset($typeRetenue)) {
            $listeRetenues = $Ades->listeRetenues($typeRetenue, false);
            $smarty->assign('listeRetenues', $listeRetenues);
            $infosRetenue = $Ades->infosRetenueType($typeRetenue);
            $smarty->assign('infosRetenue', $infosRetenue);
            $smarty->assign('corpsPage', 'retenues/listesRetenues');
        }
        $smarty->assign('action', $action);
        $smarty->assign('mode', $mode);
        break;

    case 'edit':
        $typeRetenue = isset($_REQUEST['typeRetenue']) ? $_REQUEST['typeRetenue'] : null;
        $idretenue = isset($_REQUEST['idretenue']) ? $_REQUEST['idretenue'] : null;
        $retenue = current((array) new Retenue($idretenue));
        $typesRetenues = $Ades->getTypesRetenues();
        $smarty->assign('typesRetenues', $typesRetenues);
        $smarty->assign('idretenue', $idretenue);
        $smarty->assign('typeRetenue', $typeRetenue);
        $smarty->assign('retenue', $retenue);
        $smarty->assign('action', $action);
        $smarty->assign('corpsPage', 'retenues/editRetenue');
        break;

    case 'new':
        $typesRetenues = $Ades->getTypesRetenues();
        $smarty->assign('typesRetenues', $typesRetenues);
        $smarty->assign('typeRetenueCourant',Null);
        $smarty->assign('idretenue','');
        $smarty->assign('typeRetenue','');
        $smarty->assign('retenue', Null);
        $smarty->assign('action', $action);
        $smarty->assign('corpsPage', 'retenues/newRetenue');
        break;

    case 'Enregistrer':
        $idretenue = $Ades->saveRetenue($_POST);
        $smarty->assign('message', array(
                    'title' => 'Enregistrement',
                    'texte' => 'Retenue enregistrée',
                    'urgence' => 'success',
                    )
                    );
        // relire dans la BD
        $typeRetenue = $_POST['typeRetenue'];
        // après enregistrement, relire la table pour avoir toutes les retenues, y compris la dernière enregistrée
        if (isset($typeRetenue)) {
            $listeRetenues = $Ades->listeRetenues($typeRetenue);
            $smarty->assign('listeRetenues', $listeRetenues);
            $smarty->assign('typeRetenue', $typeRetenue);
            $infosRetenue = $Ades->infosRetenueType($typeRetenue);
            $smarty->assign('infosRetenue', $infosRetenue);
            $smarty->assign('corpsPage', 'retenues/listesRetenues');
        }
        $smarty->assign('selecteur', 'selecteurs/selectTypeRetenue');
        $smarty->assign('action', $action);
        $smarty->assign('mode', 'dates');
        break;

    default:
        // wtf
        break;
    }

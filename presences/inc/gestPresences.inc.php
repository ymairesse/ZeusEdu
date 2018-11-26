<?php

$selectProf = isset($_POST['selectProf']) ? $_POST['selectProf'] : null;
$coursGrp = isset($_POST['coursGrp']) ? $_POST['coursGrp'] : null;
$classe = isset($_POST['classe']) ? $_POST['classe'] : null;
// la date postée dans le formulaire ou la date du jour
$date = isset($_POST['date']) ? $_POST['date'] : strftime('%d/%m/%Y');

require_once INSTALL_DIR.'/inc/classes/classFlashInfo.inc.php';
$FlashInfo = new flashInfo();

$module = Application::repertoireActuel();
$listeFlashInfos = $FlashInfo->listeFlashInfos ($module);
$smarty->assign('listeFlashInfos', $listeFlashInfos);

$listePeriodes = $Presences->lirePeriodesCours();
$smarty->assign('listePeriodes', $listePeriodes);
$lesPeriodes = range(1, count($listePeriodes));
$smarty->assign('lesPeriodes', $lesPeriodes);

$smarty->assign('listeProfs', $Ecole->listeProfs(true));

if (!empty($listePeriodes)) {
    $periode = isset($_POST['periode']) ? $_POST['periode'] : $Presences->periodeActuelle($listePeriodes);
    $smarty->assign('periode', $periode);

    // l'utilisateur peut-il changer la date de prise de présence?
    $freeDate = isset($_POST['freeDate']) ? $_POST['freeDate'] : null;
    // retrouver la date de travail à partir de la date du jour ou accepter la date postés si date libre souhaitée
    if ($freeDate == null) {
        $date = strftime('%d/%m/%Y');
    }
    $smarty->assign('freeDate', $freeDate);
    // $smarty->assign('freePeriode',$freePeriode);
    $jourSemaine = strftime('%A', $Application->dateFR2Time($date));
    $smarty->assign('jourSemaine', $jourSemaine);

    $smarty->assign('date', $date);
    switch ($mode) {
        case 'tituCours':
            require 'presencesTituCours.inc.php';
            break;
        case 'cours':
            require 'presencesCours.inc.php';
            break;
        case 'classe':
            require 'presencesClasse.inc.php';
            break;
        // case 'retards':
        //     require_once 'retards/retards.inc.php';
        //     break;
        default:
            $listeCoursGrp = $Ecole->listeCoursProf($acronyme, true);
            if (count($listeCoursGrp) > 0) {
                require 'presencesTituCours.inc.php';
            }
            break;
        }
    }
    else {
        $smarty->assign('message', array(
            'title' => 'AVERTISSEMENT',
            'texte' => "Les périodes de cours ne sont pas encore définies. Contactez l'administrateur",
            'urgence' => 'danger', ));
    }

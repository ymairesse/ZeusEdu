<?php

// prise de présence par cours par le titulaire du cours
$listeCoursGrp = $Ecole->listeCoursProf($acronyme, true);
$smarty->assign('listeCoursGrp', $listeCoursGrp);
$smarty->assign('acronyme', $acronyme);

// la date postée dans le formulaire ou la date du jour
$date = isset($_POST['date']) ? $_POST['date'] : strftime('%d/%m/%Y');

require_once INSTALL_DIR.'/inc/classes/classFlashInfo.inc.php';
$FlashInfo = new flashInfo();

$listeFlashInfos = $FlashInfo->listeFlashInfos ($module);
$smarty->assign('listeFlashInfos', $listeFlashInfos);

$listePeriodes = $Presences->lirePeriodesCours();

$appli = $Application->getModule(1);


if (!empty($listePeriodes)) {
    $periode = isset($_POST['periode']) ? $_POST['periode'] : $Presences->periodeActuelle($listePeriodes);
    $smarty->assign('periode', $periode);

    // $dateLundi = date( 'd/m/Y', strtotime( 'monday this week' ));
    // $smarty->assign('dateLundi', $dateLundi);

    $date = strftime('%d/%m/%Y');
    $smarty->assign('date', $date);
    $jourSemaine = ucfirst(strftime('%A', $Application->dateFR2Time($date)));
    $smarty->assign('dateFr', $jourSemaine.', le '.$date);

    if ($mode == 'classe') {
        $listeClasses = $Ecole->listeClasses();
        $smarty->assign('listeClasses', $listeClasses);
        $smarty->assign('corpsPage', 'choixClasse');
        }
        else {
            $listeCoursGrp = $Ecole->listeCoursProf($acronyme, true);
            $smarty->assign('listeCoursGrp', $listeCoursGrp);
            $listeProfs = $Ecole->listeProfs(true);
            $smarty->assign('listeProfs', $listeProfs);
            $smarty->assign('corpsPage', 'choixCoursProf');
        }

    }
    else {
        $smarty->assign('message', array(
            'title' => 'AVERTISSEMENT',
            'texte' => "Les périodes de cours ne sont pas encore définies. Contactez l'administrateur",
            'urgence' => 'danger', ));
    }

<?php

$smarty->assign('action', $action);
$smarty->assign('mode', $mode);

$classe = (isset($_POST['classe'])) ? $_POST['classe'] : null;
$bulletin = isset($_POST['bulletin']) ? $_POST['bulletin'] : PERIODEENCOURS;
$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : null;
$smarty->assign('bulletin', $bulletin);
$smarty->assign('nbBulletins', NBPERIODES);
$smarty->assign('acronyme', $acronyme);

$listeClasses = $Ecole->listeGroupes(array('TQ'));
$smarty->assign('listeClasses', $listeClasses);
$smarty->assign('classe', $classe);

switch ($mode) {
    case 'indivEcran':
        $smarty->assign('selecteur', 'selecteurs/selectBulletinClasseEleve');
        $listeEleves = isset($classe) ? $Ecole->listeEleves($classe, 'groupe') : null;
        $smarty->assign('listeElevesClasse', $listeEleves);
        $smarty->assign('matricule', $matricule);

        if (($etape == 'showEleve') && ($listeEleves != null)) {
            $eleve = new Eleve($matricule);
            $infoPersoEleve = $eleve->getDetailsEleve();
            $smarty->assign('eleve', $infoPersoEleve);
            $listeCoursGrp = $BullTQ->listeCoursGrpEleves($matricule);

            if (isset($listeCoursGrp) && isset($matricule)) {
                $listeCoursGrp = $listeCoursGrp[$matricule];
                $smarty->assign('listeCoursGrp', $listeCoursGrp);

                $listeProfsCoursGrp = $Ecole->listeProfsListeCoursGrp($listeCoursGrp);
                $smarty->assign('listeProfs', $listeProfsCoursGrp);

                $listeCompetences = $BullTQ->listeCompetencesListeCoursGrp($listeCoursGrp);
                $smarty->assign('listeCompetences', $listeCompetences);

                $listeCotesGlobales = $BullTQ->listeCotesGlobales($listeCoursGrp, $bulletin);

                if ($listeCotesGlobales != null) {
                    $smarty->assign('cotesGlobales', $listeCotesGlobales[$bulletin]);
                } else {
                    $smarty->assign('cotesGlobales', null);
                }

                $listeCotesGeneraux = $BullTQ->toutesCotesCoursGeneraux($listeCoursGrp, $matricule, $bulletin);
                $smarty->assign('listeCotesGeneraux', $listeCotesGeneraux);

                $listeCommentaires = $BullTQ->listeCommentaires($matricule, $listeCoursGrp);
                $smarty->assign('commentaires', $listeCommentaires);

                $listeEpreuvesQualif = $BullTQ->listeEpreuvesQualif();
                $smarty->assign('listeEpreuvesQualif', $listeEpreuvesQualif);

                $qualification = $BullTQ->mentionsQualif($matricule);
                $smarty->assign('qualification', $qualification);

                $remarqueTitu = $BullTQ->remarqueTitu($matricule, $bulletin);
                $smarty->assign('remarqueTitu', $remarqueTitu);
                $smarty->assign('corpsPage', 'bulletinEcran');
            }
        }

        break;
    case 'indivPDF':
        $smarty->assign('selecteur', 'selecteurs/selectBulletinClasseEleve');
        $listeEleves = $Ecole->listeEleves($classe, 'groupe');
        $smarty->assign('listeElevesClasse', $listeEleves);
        $smarty->assign('matricule', $matricule);
        if ($etape == 'showEleve') {
            $eleve = new Eleve($matricule);
            $infoPersoEleve = $eleve->getDetailsEleve();
            $link = $BullTQ->createPDFeleve($acronyme, $infoPersoEleve, $bulletin);
            $smarty->assign('corpsPage', 'corpsPDF');
        }

        break;
    case 'classePDF':
        $smarty->assign('etape', 'showClasse');
        $smarty->assign('selecteur', 'selecteurs/selectBulletinClasse');
        if ($etape == 'showClasse') {
            $listeEleves = $Ecole->listeEleves($classe, 'groupe');
            if ($user->userStatus($Application->repertoireActuel()) != 'admin') {
                $Application->vider("./pdf/$acronyme");
            }

            $link = $BullTQ->createPDFclasse($acronyme, $listeEleves, $classe, $bulletin);
            $smarty->assign('corpsPage', 'corpsPDF');
        }

        break;
}

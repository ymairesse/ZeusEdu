<?php

require_once INSTALL_DIR.'/inc/classes/classThot.inc.php';
$Thot = new Thot();
// recherche des dates de réunions de parents déjà existantes
$listeReunions = $Thot->listeDatesReunion();
$smarty->assign('listeDates', $listeReunions);


$idRP = isset($_POST['idRP']) ? $_POST['idRP'] : Null;
$typeRP = Null;

if ($idRP != Null) {
    // récupérer les caractéristiques de la RP sélectionnée
    $smarty->assign('idRP', $idRP);

    // toutes les informations sur la RP
    $infoRP = $Thot->getInfoRp($idRP);
    $smarty->assign('infoRP', $infoRP);

    // tous les profs ou les titulaires ou RP ciblée sur quelques profs
    $typeRP = $infoRP['typeRP'];
    $smarty->assign('typeRP', $infoRP['typeRP']);

    // gestion des RV par élève ou par prof
    $typeGestion = isset($_POST['typeGestion']) ? $_POST['typeGestion'] : null;
    $smarty->assign('typeGestion', $typeGestion);
}

switch ($mode) {
    case 'editNew':
        // création ou édition d'une réunion de parents
        if ($idRP != Null) {
            $listeProfs = $Thot->listeProfsAvecRv($idRP);
            $smarty->assign('listeProfs', $listeProfs);
            $listeHeuresRP = $Thot->getListeHeuresRP($idRP);
            $smarty->assign('listeHeuresRP', $listeHeuresRP);

            $locaux = $Thot->getLocauxRp($idRP);
            $smarty->assign('locaux', $locaux);
        }

        // recherche des dates de réunions de parents existantes
        $listeReunions = $Thot->listeDatesReunion();
        $smarty->assign('listeDates', $listeReunions);
        $smarty->assign('selecteur', 'selecteurs/selectDate');
        $smarty->assign('corpsPage', 'reunionParents/nouveau');
        break;

    // gestion des périodes de RV par un administrateur
    case 'periodesAdmin':
        // gestion des périodes de RV par un admin du module
        if ($userStatus == 'admin') {
            // une réunion de parents a été sélectionnée
            if ($idRP != '') {
                // rechercher la liste des périodes pour la liste d'attente éventuelle
                $smarty->assign('listePeriodes', $Thot->getListePeriodes($idRP));

                switch ($typeGestion) {
                    // attribution des RV par élève
                    case 'eleve':
                        $listeNiveaux = $Ecole->listeNiveaux();
                        $smarty->assign('listeNiveaux', $listeNiveaux);

                        $smarty->assign('idRP', $idRP);
                        $smarty->assign('corpsPage', 'reunionParents/adminEleves');
                        break;
                    // attribution des RV par prof
                    case 'prof':
                        $listeProfs = $Thot->listeProfsAvecRv($idRP);
                        // regroupement des profs sur base de leur initiale pour affichage à gauche

                        $smarty->assign('listeProfs', $listeProfs);
                        $smarty->assign('listeRV', null);
                        $smarty->assign('listeAttente', null);

                        $smarty->assign('corpsPage', 'reunionParents/adminProfs');
                        break;
                    default:

                        break;
                    }
            }
        $smarty->assign('selecteur', 'selecteurs/selectDateType');
        }
        break;

    // gestion des périodes de RV par les profs ordinaires
    case 'periodesProfs':
        switch ($typeRP) {
            // gestion de ses périodes de RV par un prof titulaire de classe
            // pour une RP "titulaires"
            case 'titus':
                if($idRP != '') {
                    $smarty->assign('acronyme',$acronyme);
                    $smarty->assign('listePeriodes', $Thot->getListePeriodes($idRP));

                    $listeRV = $Thot->getRVprof($acronyme, $idRP);
                    $smarty->assign('listeRV', $listeRV);

                    $listeAttente = $Thot->getListeAttenteProf($idRP, $acronyme);
                    $smarty->assign('listeAttente', $listeAttente);

                    $nomProf = User::identiteProf($acronyme);
                    $smarty->assign('nomProf', sprintf('%s %s', $nomProf['prenom'], $nomProf['nom']));

                    $listeClasses = $user->listeTitulariats();
                    $listeEleves = $Ecole->listeElevesMultiClasses($listeClasses);

                    $smarty->assign('listeEleves', $listeEleves);
                    $smarty->assign('corpsPage', 'reunionParents/adminTitu');
                }
                break;

            // gestion des RV pour la réunion de parent par le prof utilisateur
            // pour une RP "TOUS LES PROFS"
            case 'profs':
                if ($idRP != '') {
                    $smarty->assign('acronyme', $acronyme);
                    $smarty->assign('listePeriodes', $Thot->getListePeriodes($idRP));

                    $nomProf = User::identiteProf($acronyme);
                    $smarty->assign('nomProf', sprintf('%s %s', $nomProf['prenom'], $nomProf['nom']));

                    // liste des plages de RV (éventuellement occupées) pour le prof $acronyme
                    $listeRV = $Thot->getRVprof($acronyme, $idRP);
                    $smarty->assign('listeRV', $listeRV);

                    // liste des élèves en attente de RV
                    $listeAttente = $Thot->getListeAttenteProf($idRP, $acronyme);
                    $smarty->assign('listeAttente', $listeAttente);

                    $rv4eleves = $Thot->getRVeleves($idRP, $acronyme);
                    $smarty->assign('rv4eleves', $rv4eleves);

                    // liste des élèves groupés par classe pour le sélecteur d'élèves à droite
                    $listeEleves = $Thot->getElevesDeProf($acronyme);
                    $smarty->assign('listeEleves', $listeEleves);

                    $smarty->assign('corpsPage', 'reunionParents/gestionRVprof');
                    }
                break;
            }
        $smarty->assign('selecteur', 'selecteurs/selectDateType');
        break;

    case 'printEleves':
        if (isset($idRP) && ($idRP != '')) {
            $smarty->assign('listeNiveaux', Ecole::listeNiveaux());
            $smarty->assign('acronyme', $acronyme);
            $smarty->assign('idRP', $idRP);

            $smarty->assign('corpsPage', 'reunionParents/choixRVParents2pdf');
        }
        $smarty->assign('firstLine', 'Choisir une date');
        $smarty->assign('selecteur', 'selecteurs/selectDate');

        break;
    default:
        // wtf
        break;
}

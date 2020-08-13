<?php

$idRP = isset($_POST['idRP']) ? $_POST['idRP'] : Null;
$smarty->assign('idRP', $idRP);

// toutes les informations sur la RP
$infoRP = $Thot->getInfoRp($idRP);
$smarty->assign('infoRP', $infoRP);
// tous les profs ou les titulaires ou RP ciblée sur quelques profs
$typeRP = $infoRP['typeRP'];
$smarty->assign('typeRP', $infoRP['typeRP']);

echo $typeRP;

// gestion des RV par élève ou par prof
$typeGestion = isset($_POST['typeGestion']) ? $_POST['typeGestion'] : null;
$smarty->assign('typeGestion', $typeGestion);

require_once INSTALL_DIR.'/inc/classes/classThot.inc.php';
$thot = new Thot();
// recherche des dates de réunions de parents déjà existantes
$listeReunions = $thot->listeDatesReunion();
$smarty->assign('listeDates', $listeReunions);

switch ($mode) {
    case 'editNew':

        // création ou édition d'une réunion de parents
        if ($idRP != Null) {
            $smarty->assign('nbRv', $nbRv);
            $listeProfs = $thot->listeProfsAvecRv($idRP);
            $smarty->assign('listeProfs', $listeProfs);
            $listeHeuresRP = $thot->getListeHeuresRP($idRP);
            $smarty->assign('listeHeuresRP', $listeHeuresRP);

            $locaux = $thot->getLocauxRp($idRP);
            $smarty->assign('locaux', $locaux);
            $smarty->assign('readonly', true);
        }

        // recherche des dates de réunions de parents existantes
        $listeReunions = $thot->listeDatesReunion();
        $smarty->assign('listeDates', $listeReunions);
        $smarty->assign('selecteur', 'selecteurs/selectDate');
        $smarty->assign('corpsPage', 'reunionParents/nouveau');
        break;

    case 'periodesAdmin':

        // gestion des périodes de RV par un admin du module
        if ($userStatus == 'admin') {
            // une réunion de parents a été sélectionnée
            if ($idRP != '') {
                // rechercher la liste des périodes pour la liste d'attente éventuelle
                $smarty->assign('listePeriodes', $thot->getListePeriodes($idRP));

                switch ($typeGestion) {
                    // attribution des RV par élève
                    case 'eleve':
                        $smarty->assign('listeClasses', $Ecole->listeClasses(null, true));
                        $smarty->assign('corpsPage', 'reunionParents/adminEleves');
                        break;
                    // attribution des RV par prof
                    case 'prof':
                        $listeProfs = $thot->listeProfsAvecRv($idRP);
                        // regroupement des profs sur base de leur initiale pour affichage à gauche
                        $listeProfs = $Thot->initialListe($listeProfs);
                        $smarty->assign('listeProfs', $listeProfs);

                        $smarty->assign('listeRV', null);
                        $smarty->assign('listeAttente', null);

                        $smarty->assign('corpsPage', 'reunionParents/adminProfs');
                        break;
                    default: die("wtf");
                        break;
                    }
            }
        }

        $smarty->assign('selecteur', 'selecteurs/selectDateType');
        break;

    case 'periodesProfs':

        switch ($typeRP) {
            case 'titus':
                // gestion de ses périodes de RV par un prof titulaire de classe
                // pour une RP "titulaires"
                if($idRP != '') {
                    $smarty->assign('acronyme',$acronyme);
                    $smarty->assign('listePeriodes', $thot->getListePeriodes($idRP));

                    $listeRV = $thot->getRVprof($acronyme, $idRP);
                    $smarty->assign('listeRV', $listeRV);

                    $listeAttente = $thot->getListeAttenteProf($idRP, $acronyme);
                    $smarty->assign('listeAttente', $listeAttente);

                    $nomProf = User::identiteProf($acronyme);
                    $smarty->assign('nomProf', sprintf('%s %s', $nomProf['prenom'], $nomProf['nom']));

                    $listeClasses = $user->listeTitulariats();
                    $listeEleves = $Ecole->listeElevesMultiClasses($listeClasses);

                    $smarty->assign('listeEleves', $listeEleves);
                    $smarty->assign('corpsPage', 'reunionParents/adminTitu');
                }
                break;
            case 'profs':
                // gestion des RV pour la réunion de parent par le prof utilisateur
                // pour une RP "TOUS LES PROFS"
                if ($idRP != '') {
                    $smarty->assign('acronyme', $acronyme);
                    $smarty->assign('listePeriodes', $thot->getListePeriodes($idRP));

                    $nomProf = User::identiteProf($acronyme);
                    $smarty->assign('nomProf', sprintf('%s %s', $nomProf['prenom'], $nomProf['nom']));

                    $listeRV = $thot->getRVprof($acronyme, $idRP);
                    $smarty->assign('listeRV', $listeRV);

                    $listeAttente = $thot->getListeAttenteProf($idRP, $acronyme);
                    $smarty->assign('listeAttente', $listeAttente);

                    $smarty->assign('corpsPage', 'reunionParents/gestionRVprof');
                }
                break;
            case 'cible':
                echo "<h1>Ciblé</h1> TODO";
                break;
        }
        if ($typeRP == 'titulaires') {
            // if($idRP != '') {
            //     $smarty->assign('acronyme',$acronyme);
            //     $smarty->assign('listePeriodes', $thot->getListePeriodes($idRP));
            //
            //     $listeRV = $thot->getRVprof($acronyme, $idRP);
            //     $smarty->assign('listeRV', $listeRV);
            //
            //     $listeAttente = $thot->getListeAttenteProf($idRP, $acronyme);
            //     $smarty->assign('listeAttente', $listeAttente);
            //
            //     $nomProf = User::identiteProf($acronyme);
            //     $smarty->assign('nomProf', sprintf('%s %s', $nomProf['prenom'], $nomProf['nom']));
            //
            //     $infoRp = $thot->getInfoRp($idRP);
            //     $smarty->assign('infoRp', $infoRp);
            //
            //     $listeClasses = $user->listeTitulariats();
            //     $listeEleves = $Ecole->listeElevesMultiClasses($listeClasses);
            //
            //     $smarty->assign('listeEleves', $listeEleves);
            //     $smarty->assign('corpsPage', 'reunionParents/adminTitu');
            // }
        }
        else {
        // // gestion des RV pour la réunion de parent par le prof utilisateur
        // // pour une RP "TOUS LES PROFS"
        // if ($idRP != '') {
        //     $smarty->assign('acronyme', $acronyme);
        //     $smarty->assign('listePeriodes', $thot->getListePeriodes($idRP));
        //
        //     $nomProf = User::identiteProf($acronyme);
        //     $smarty->assign('nomProf', sprintf('%s %s', $nomProf['prenom'], $nomProf['nom']));
        //
        //     $infoRp = $thot->getInfoRp($idRP);
        //     $smarty->assign('infoRp', $infoRp);
        //
        //     $listeRV = $thot->getRVprof($acronyme, $idRP);
        //     $smarty->assign('listeRV', $listeRV);
        //
        //     $listeAttente = $thot->getListeAttenteProf($idRP, $acronyme);
        //     $smarty->assign('listeAttente', $listeAttente);
        //
        //     $smarty->assign('corpsPage', 'reunionParents/gestionRVprof');
        // }
    }
        $smarty->assign('selecteur', 'selecteurs/selectDateType');
        break;

    case 'enregistrer':
        // récupérer l'onglet précédemment actif (page 1)

        // enregistrement du canevas général de la réunion de parents
        $idRP = $thot->saveNewRpDate($_POST);
        $nb = $thot->saveRPinit($idRP, $_POST);

        $idRP = $_POST['idRP'];
        $smarty->assign('listeProfs', $thot->listeProfsAvecRv($idRP));

        $locaux = $thot->getLocauxRp($idRP);
        $smarty->assign('locaux', $locaux);

        // $smarty->assign('message', $message);
        $smarty->assign('mode', 'editNew');
        // recherche des dates de réunions de parents existantes
        $listeReunions = $thot->listeDatesReunion();
        $smarty->assign('listeDates', $listeReunions);
        // recherche des caractéristiques globales de le RP de la date $date
        $smarty->assign('infoRp', $thot->getInfoRp($idRP));
        $smarty->assign('listeHeuresRP', $thot->getListeHeuresRP($idRP));

        $smarty->assign('readonly', true);

        $smarty->assign('selecteur', 'selecteurs/selectDate');

        $message = array(
            'title' => SAVE,
            'texte' => sprintf('%d plages de RV enregistrées', $nb),
            'urgence' => 'success',
            );

        $smarty->assign('corpsPage', 'reunionParents/nouveau');
        break;

    case 'delRV':
        $id = isset($_POST['id']) ? $_POST['id'] : null;
        // relecture des informations
        $infoRV = $thot->getInfoRV($id);

        // envoi du mail d'information sauf si l'inscriptION a été faite par l'administration
        if ($infoRV['userParent'] != '') {
            include 'inc/reunionParents/mailAnnulation.inc.php';
        }

        // suppression effective du RV
        $nb = $thot->delRV($id);

        // la variable $acronyme est déjà prise pour le nom d'utilisateur => $abreviation
        $abreviation = $infoRV['acronyme'];
        $nomProf = User::identiteProf($abreviation);
        $smarty->assign('nomProf', sprintf('%s %s', $nomProf['prenom'], $nomProf['nom']));
        $smarty->assign('acronyme', $abreviation);

        $date = $infoRV['date'];
        $smarty->assign('date', $date);

        $smarty->assign('listePeriodes', $thot->getListePeriodes($date));

        $listeEleves = $thot->getElevesDeProf($abreviation);
        $smarty->assign('listeEleves', $listeEleves);

        $listeProfs = $thot->listeProfsRP();
        $smarty->assign('listeProfs', $listeProfs);

        $listeRV = $thot->getRVprof($abreviation, $date);
        $smarty->assign('listeRV', $listeRV);

        $listeAttente = $thot->getListeAttenteProf($date, $acronyme);
        $smarty->assign('listeAttente', $listeAttente);

        $smarty->assign('selecteur', 'selecteurs/selectDateType');

        if ($type == 'prof') {
            $smarty->assign('corpsPage', 'reunionParents/adminProfs');
        } else {
            $smarty->assign('corpsPage', 'reunionParents/adminEleves');
        }
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
}

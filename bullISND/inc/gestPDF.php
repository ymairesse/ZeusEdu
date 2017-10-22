<?php

$unAn = time() + 365 * 24 * 3600;
$etape = isset($_REQUEST['etape']) ? $_REQUEST['etape'] : null;
$bulletin = isset($_REQUEST['bulletin']) ? $_REQUEST['bulletin'] : PERIODEENCOURS;

$classe = $Application->postOrCookie('classe', $unAn);
// if (isset($_POST['classe'])) {
//     $classe = $_POST['classe'];
//     setcookie('classe', $classe, $unAn, null, null, false, true);
// } else {
//         $classe = isset($_COOKIE['classe']) ? $_COOKIE['classe'] : null;
//     }
$smarty->assign('classe', $classe);

$matricule = $Application->postOrCookie('matricule', $unAn);
// if (isset($_POST['matricule'])) {
//     $matricule = $_POST['matricule'];
//     setcookie('matricule', $matricule, $unAn, null, null, false, true);
// } else {
//         $matricule = isset($_COOKIE['matricule']) ? $_COOKIE['matricule'] : null;
//     }
$smarty->assign('matricule', $matricule);

$niveau = $Application::postOrCookie('niveau', $unAn);
// if (isset($_POST['niveau'])) {
//     $niveau = $_POST['niveau'];
//     setcookie('niveau', $niveau, $unAn, null, null, false, true);
// } else {
//         $niveau = isset($_COOKIE['niveau']) ? $_COOKIE['niveau'] : null;
//     }
$smarty->assign('niveau', $niveau);

$acronyme = $_SESSION[APPLICATION]->getAcronyme();

switch ($mode) {
    case 'archive':
        // $anneeScolaire = isset($_POST['anneeScolaire']) ? $_POST['anneeScolaire'] : null;
        $smarty->assign('listeAnnees', $Bulletin->anneesArchivesDispo());
        $smarty->assign('listeNiveaux', $Ecole->listeNiveaux());
        $smarty->assign('action', $action);
        $smarty->assign('mode', $mode);
        $smarty->assign('etape', 'showEleve');
        $smarty->assign('selecteur', 'selectAnneeNiveauEleve');
        if ($etape == 'showEleve') {
            $listeElevesArchives = $Bulletin->listeElevesArchives($anneeScolaire, $niveau);
            $smarty->assign('listeEleves', $listeElevesArchives);
            $nomEleve = isset($_POST['nomEleve']) ? $_POST['nomEleve'] : null;
            $anneeScolaire = isset($_POST['anneeScolaire']) ? $_POST['anneeScolaire'] : null;
            $smarty->assign('nomEleve', $nomEleve);
            $smarty->assign('anneeScolaire', $anneeScolaire);
            $classeArchive = $Bulletin->classeArchiveEleve($matricule, $anneeScolaire);
            $smarty->assign('periodes', $Bulletin->listePeriodes(NBPERIODES));
            $smarty->assign('classeArchive', $classeArchive);
            $smarty->assign('corpsPage', 'bulletinsArchive');
        }
        break;

    case 'bulletinIndividuel':
        $listeClasses = $Ecole->listeGroupes(array('GT', 'TT', 'S'));
        if ($classe != null) {
            $listeEleves = $Ecole->listeEleves($classe, 'groupe');
        } else {
                $listeEleves = null;
            }
        $smarty->assign('listeClasses', $listeClasses);
        $smarty->assign('listeEleves', $listeEleves);
        $smarty->assign('nbBulletins', NBPERIODES);
        $smarty->assign('bulletin', $bulletin);
        $smarty->assign('etape', 'showEleve');
        $smarty->assign('action', $action);
        $smarty->assign('mode', $mode);
        $smarty->assign('selecteur', 'selectBulletinClasseEleve');

        if ($etape == 'showEleve') {
            if ($matricule) {
                $smarty->assign('acronyme', $acronyme);
                $dataEleve = array(
                        'matricule' => $matricule,
                        'classe' => $classe,
                        'annee' => $Ecole->anneeDeClasse($classe),
                        'degre' => $Ecole->degreDeClasse($classe),
                        'titulaires' => $Ecole->titusDeGroupe($classe),
                        );
                $link = $Bulletin->createPDFeleve($dataEleve, $bulletin, $acronyme);
                $smarty->assign('link', $link);
                $smarty->assign('corpsPage', 'pdfLink');
            }
        }
        break;
    case 'bulletinClasse':
        // liste complète des noms des classes en rapport avec leur classe
        $listeClasses = $Ecole->listeGroupes(array('G', 'TT', 'S'));
        $smarty->assign('selecteur', 'selectBulletinClasse');
        $smarty->assign('listeClasses', $listeClasses);
        $smarty->assign('nbBulletins', NBPERIODES);
        $smarty->assign('bulletin', $bulletin);
        $smarty->assign('action', $action);
        $smarty->assign('mode', $mode);
        $smarty->assign('etape', 'showClasse');

        if ($etape == 'showClasse') {
            if ($classe) {
                // retourne la liste des élèves pour une classe donnée
                $listeEleves = $Ecole->listeEleves($classe, 'groupe');
                $link = $Bulletin->createPDFclasse($listeEleves, $classe, $bulletin, $acronyme);
                $smarty->assign('acronyme', $acronyme);
                $smarty->assign('link', $link);
                $smarty->assign('corpsPage', 'pdfLink');
            }
        }
        break;
    case 'niveau':
        $smarty->assign('nbBulletins', NBPERIODES);
        $listeNiveaux = $Ecole->listeNiveaux();
        $smarty->assign('selecteur', 'selectBulletinNiveau');
        $smarty->assign('listeNiveaux', $listeNiveaux);
        $smarty->assign('bulletin', $bulletin);
        $smarty->assign('action', $action);
        $smarty->assign('mode', $mode);

        if ($etape == 'showNiveau') {
            if ($niveau) {
                $listeClasses = $Ecole->listeClassesNiveau($niveau, 'groupe', array('G', 'TT', 'S'));
                // accumuler tous les bulletins dans des fichiers par classe
                $listeEleves = null;
                foreach ($listeClasses as $classe) {
                    $listeEleves = $Ecole->listeEleves($classe, 'groupe');
                    $link = $Bulletin->createPDFclasse($listeEleves, $classe, $bulletin, $acronyme, true);
                }
                // zipper l'ensemble des fichiers
                if ($listeEleves != null) {
                    $ds = DIRECTORY_SEPARATOR;
                    $module = $Application->getModule(1);
                    $chemin = INSTALL_DIR.$ds.'upload'.$ds.$acronyme.$ds.'bulletin';
                    $zipName = $Bulletin->zipFilesNiveau($chemin, $bulletin, $listeClasses);
                    $smarty->assign('acronyme', $acronyme);
                    $smarty->assign('link', $zipName);
                    $smarty->assign('corpsPage', 'pdfLink');
                }
            }
        }
        break;

    }

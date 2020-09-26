<?php

$unAn = time() + 365 * 24 * 3600;
$etape = isset($_REQUEST['etape']) ? $_REQUEST['etape'] : null;
$bulletin = isset($_REQUEST['bulletin']) ? $_REQUEST['bulletin'] : PERIODEENCOURS;

$classe = $Application->postOrCookie('classe', $unAn);
$smarty->assign('classe', $classe);

$matricule = $Application->postOrCookie('matricule', $unAn);
$smarty->assign('matricule', $matricule);

$niveau = $Application::postOrCookie('niveau', $unAn);
$smarty->assign('niveau', $niveau);

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

$module = Application::getModule(1);

switch ($mode) {
    case 'archive':
        $anneeScolaire = isset($_POST['anneeScolaire']) ? $_POST['anneeScolaire'] : null;
        $smarty->assign('anneeScolaire', $anneeScolaire);
        $listeAnnees = $Ecole->anneesArchivesDispo();
        $listeNiveaux = $Ecole->listeNiveaux();

        $smarty->assign('listeAnnees', $listeAnnees);
        $smarty->assign('listeNiveaux', $listeNiveaux);
        $smarty->assign('action', $action);
        $smarty->assign('mode', $mode);
        $smarty->assign('etape', 'showEleve');
        $smarty->assign('selecteur', 'selectAnneeNiveauEleve');
        if ($etape == 'showEleve') {
            $listeElevesArchives = $Ecole->listeElevesArchives($anneeScolaire, $niveau);
            $smarty->assign('listeEleves', $listeElevesArchives);
            $nomEleve = isset($_POST['nomEleve']) ? $_POST['nomEleve'] : null;
            $smarty->assign('nomEleve', $nomEleve);
            $classeArchive = $Ecole->classeArchiveEleve($matricule, $anneeScolaire);
            $smarty->assign('periodes', $Bulletin->listePeriodes4anScol($anneeScolaire));

            $smarty->assign('classeArchive', $classeArchive);
            $smarty->assign('corpsPage', 'bulletinsArchive');
            }
        break;

    case 'bulletinIndividuel':
        $listeClasses = $Ecole->listeGroupes();
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
                // $smarty->assign('module', $module);
                // $smarty->assign('link', $link);
                // $smarty->assign('corpsPage', 'pdfLink');
            }
        }
        break;

    case 'bulletinClasse':
        // liste complète des noms des classes en rapport avec leur classe
        $listeClasses = $Ecole->listeGroupes();
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
                $smarty->assign('module', $module);
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
                $listeClasses = $Ecole->listeClassesNiveau($niveau, 'groupe');
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
                    // $chemin = INSTALL_DIR.$ds.'upload'.$ds.$acronyme.$ds.'bulletin';
                    $chemin = INSTALL_DIR.$ds.'upload'.$ds.$acronyme.$ds.$module.$ds;
                    $zipName = $Bulletin->zipFilesNiveau($chemin, $bulletin, $listeClasses, $module);
                    $smarty->assign('acronyme', $acronyme);
                    $smarty->assign('link', $zipName);
                    $smarty->assign('corpsPage', 'pdfLink');
                }
            }
        }
        break;

    }

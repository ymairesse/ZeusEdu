<?php
// $table est le fichier éventuellement uploadé
$table = isset($_REQUEST['table']) ? $_REQUEST['table'] : null;
if ($table == null) {
    die('missing table');
}

switch ($mode) {
    case 'Confirmer':
        // enregistrement effectif du fichier CSV dans la table
        $resultat = $Application->CSV2MySQL($table);
        $titre = "Résultat de l'importation";
        $texte = sprintf('Enregistrement(s) modifié(s): %d <br>Enregistrement(s) en échec: %d', $resultat['ajouts'], $resultat['erreurs']);
        $urgence = ($resultat['erreurs'] == 0) ? 'info' : 'danger';

        $smarty->assign('message', array(
                        'title' => $titre,
                        'texte' => $texte,
                        'urgence' => $urgence,
                        ));
        break;
    case 'Envoyer':   // visualisation du fichier CSV envoyé et demande de confirmation
        $nomTemporaire = $_FILES['nomfichierCSV']['tmp_name'];    // $_FILES provenant du formulaire
        // vérification du type de fichier
        $fileType = $Application->checkFileType($nomTemporaire);
        // au minimum, 'text/plain'
        $textPlainOK = (strpos($fileType, 'text/plain') === 0);

        // lecture de la liste des champs de la table dans la BD
        $champs = $Application->SQLtableFields2array($table);
        $nomsChamps = $Application->nomsChampsBD($champs);

        $rubriquesErreurs = array();
        if ($textPlainOK) {    // c'est bien un fichier "text"
            if (!(move_uploaded_file($nomTemporaire, $table.'.csv'))) {
                die('upload failed');
            }

            $tableau = $Application->csv2array($table);
            // on ne retient que l'entête
            $entete = array_shift($tableau);
            $smarty->assign('tableau', $tableau);
            $smarty->assign('table', $table);

            // Il y a peut-être des différences entre les deux modèles
            $differences = $Application->hiatus($entete, $nomsChamps);
            if ($differences == null) {
                // les entêtes correspondent; c'est OK
                $smarty->assign('entete', $entete);
                if ($fileType != 'text/plain; charset=utf-8') {
                    // le fichier est OK mais pas UTF-8; pas forcément très grave
                    $smarty->assign('fileType', $fileType);
                    $rubriquesErreurs[] = 'utf8';
                }
            } else { // il y a des différences entre les champs fournis et les champs demandés
                    $smarty->assign('champs', $nomsChamps);
                $smarty->assign('hiatus', $differences);
                $rubriquesErreurs[] = 'hiatus';
            }
        } else {
            // ce n'est pas un fichier "text" => échec de l'importation
                $smarty->assign('fileType', $fileType);
            $smarty->assign('champs', $champs);
            $rubriquesErreurs[] = 'pageFileType'; // c'est terminé :o(
        }
        $smarty->assign('rubriquesErreurs', $rubriquesErreurs);
        $smarty->assign('action', 'import');
        $smarty->assign('mode', 'Confirmer');
        $smarty->assign('corpsPage', 'pageImport');
        break;
    default:
        $champs = $Application->SQLtableFields2array($table);
        $smarty->assign('champs', $champs);
        $smarty->assign('table', $table);
        $smarty->assign('CSVfile', 'nomfichierCSV');
        $smarty->assign('action', 'import');
        $smarty->assign('mode', 'Envoyer');
        $smarty->assign('corpsPage', 'formulaireImport');
        break;
    }

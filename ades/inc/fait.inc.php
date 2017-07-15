<?php

$idfait = isset($_REQUEST['idfait']) ? $_REQUEST['idfait'] : null;
$type = isset($_REQUEST['type']) ? $_REQUEST['type'] : null;

$module = $Application->getModule(1);
require_once INSTALL_DIR."/$module/inc/classes/classEleveAdes.inc.php";
$EleveAdes = new EleveAdes();

switch ($mode) {
    case 'enregistrer':
        $type = isset($_POST['type']) ? $_POST['type'] : null;
        $oldIdretenue = isset($_POST['oldIdretenue']) ? $_POST['oldIdretenue'] : null;
        // quand c'est une retenue et qu'il s'agit d'une édition, un problème peut se poser.
        // si la date de retenue n'est plus disponible (elle est cachée), on ne peut plus la sélectionner
        // la valeur de "oldIdretenue" est l'identifiant de la retenue avant édition.
        // si la date n'est pas modifiée, on remet gentiment "oldIdretenue" à la place de "idretenue"
        $idretenue = (isset($_POST['idretenue']) && $_POST['idretenue'] != '') ? $_POST['idretenue'] : $oldIdretenue;
        $prototype = $Ades->prototypeFait($type);

        // si c'est une retenue, on retrouve les détails (date, local,...) de celle-ci dans la BD
        $retenue = ($prototype['structure']['typeRetenue'] != 0) ? $Ades->detailsRetenue($idretenue) : null;
        $nb = $EleveAdes->enregistrerFaitDisc($_POST, $prototype, $retenue, $acronyme);
        $smarty->assign('message', array(
            'title' => SAVE,
            'texte' => sprintf('Enregistrement de: %d fait',$nb),
            'urgence' => 'success' ));
		$smarty->assign('matricule',$matricule);
		$smarty->assign('classe',$classe);
		$smarty->assign('action','');

        $ficheDisciplinaire = $EleveAdes->getListeFaits($matricule);
        $smarty->assign('listeTousFaits', $ficheDisciplinaire);
		$smarty->assign('selecteur','selecteurs/selectClasseEleve');
        $afficherEleve = true;
        break;
}

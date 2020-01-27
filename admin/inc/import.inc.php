<?php
$mode = isset($_GET['mode']:$_GET['mode']:Null;
switch ($mode)
	{
	case 'Envoyer':
		$nomTemporaire = $_FILES['nomfichierCSV']['tmp_name'];
		// liste des champs présents dans la DB pour la table choisie
		if (!uploadCSV($table, $nomTemporaire)) die("upload failed");
		// lecture de la liste des champs de la table dans la BD
		$champs = SQLtableFields2array ($table);
		// lecture de table uploadée
		$tableau = csv2array($table);
		// on ne retient que l'entête
		$entete = array_shift($tableau);
		$differences = hiatus($entete, $champs);

		$smarty->assign("table", $table);
		$smarty->assign("class","tableauAdmin");
		$smarty->assign("entete", $entete);
		$smarty->assign("tableau", $tableau);
		if ($differences)
			{
			$smarty->assign("champs", $champs);
			$smarty->assign("hiatus", $differences);
			$smarty->display("problemeImport.tpl");
			}
			else
			$smarty->display("noproblemeImport.tpl");
		break;
	case 'Confirmer':
		$smarty->assign("resultats", CSV2MySQL($table));
		$smarty->display("resultatSQL.tpl");
		break;
	default:
	$smarty->assign("table", $table);
	$smarty->display("formulaireImport.tpl");
	break;
	}
?>

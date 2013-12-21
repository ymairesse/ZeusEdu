<?php
$mode = isset($_REQUEST['mode'])?$_REQUEST['mode']:Null;
switch ($mode) {
	case 'save':
		$fileName = $Application->backupTables($_POST);
		$listeFichiers = $Application->scanDirectories ("./save");
		$smarty->assign("listeFichiers", $listeFichiers);
		$smarty->assign("fileName", $fileName);
		$smarty->assign("corpsPage", "tableauFichiersBU");
		break;
	case 'choose':
		$smarty->assign("listeTables", $Application->listeTables(BASE));
		$smarty->assign("action", "backup");
		$smarty->assign("mode","save");
		$smarty->assign("corpsPage", "choixTables");
		break;
	case 'delete':
		$fileName = isset($_GET['fileName'])?$_GET['fileName']:Null;
		$listeNomsFichiers = $Application->listeFichiers("./save");
		if (!(in_array($fileName, $listeNomsFichiers))) die("invalid file name");
		unlink("./save/$fileName");
		$smarty->assign("fileName",$fileName);
		$smarty->assign("confirmDeleteBU","confirmDelete");
		$listeFichiers = $Application->scanDirectories ("./save");
		$smarty->assign("listeFichiers", $listeFichiers);
		$smarty->assign("corpsPage", "tableauFichiersBU");		
		break;
	default:
		$listeFichiers = $Application->scanDirectories("./save");
		$smarty->assign("listeFichiers", $listeFichiers);
		$smarty->assign("corpsPage", "tableauFichiersBU");
		break;
}

?>

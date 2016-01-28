<?php
$unAn = time() + 365*24*3600;
$bulletin = isset($_POST['bulletin'])?$_POST['bulletin']:PERIODEENCOURS;
$etape = isset($_REQUEST['etape'])?$_REQUEST['etape']:Null;

if (isset($_POST['classe'])) {
	$classe = $_POST['classe'];
	setcookie('classe',$classe,$unAn, null, null, false, true);
	}
	else $classe = isset($_COOKIE['classe'])?$_COOKIE['classe']:Null;
$smarty->assign('classe', $classe);

if (isset($_POST['matricule'])) {
	$matricule = $_POST['matricule'];
	setcookie('matricule',$matricule,$unAn, null, null, false, true);
	}
	else $matricule = isset($_COOKIE['matricule'])?$_COOKIE['matricule']:Null;
$smarty->assign('matricule', $matricule);

$bulletin = isset($_POST['bulletin'])?$_POST['bulletin']:Null;
$etape = isset($_POST['etape'])?$_POST['etape']:Null;

$smarty->assign('classe',$classe);
$smarty->assign('bulletin',$bulletin);
$smarty->assign('matricule',$matricule);

$smarty->assign('action',$action);
$smarty->assign('mode',$mode);

$listePeriodes = $BullTQ->listePeriodes(true);
$listeClasses = $Ecole->listeGroupes(array('TQ'));
$smarty->assign('listeClasses', $listeClasses);
$smarty->assign('listePeriodes', $listePeriodes);

if ($classe)
	$listeEleves = $Ecole->listeEleves($classe,'classe');
	else $listeEleves = Null;
$smarty->assign('listeEleves', $listeEleves);

$estTitulaire = in_array($classe,$user->listeTitulariats());
$smarty->assign('estTitulaire',$estTitulaire);

$smarty->assign('NBPERIODES',NBPERIODES);
$smarty->assign('PERIODEENCOURS',PERIODEENCOURS);
switch ($mode) {
	case 'individuel':
		include('delibe/individuel.inc.php');
		break;
	case 'parClasse':
		include('delibe/parClasse.inc.php');
		break;

	case 'notifications':
		include('delibe/notifications.inc.php');
		break;
}

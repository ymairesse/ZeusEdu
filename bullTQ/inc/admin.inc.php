<?php
switch ($mode) {
	case 'imagesCours':
		$listeImages = $BullTQ->imagesPngBranches(200);
		$smarty->assign("listeImages", $listeImages);
		$smarty->assign("corpsPage", "imagesCours");
		break;

	default:
		break;
	}

?>
<?php

require_once INSTALL_DIR.$ds.$module.$ds.'/inc/classes/class.remediation.inc.php';
$remediation = new Remediation();

$offre = $remediation->getListeOffres($acronyme, false);

$listeNiveaux = $Ecole->listeNiveaux();

$smarty->assign('offre', $offre);
$smarty->assign('listeNiveaux', $listeNiveaux);

$smarty->assign('corpsPage', 'remediation/offreRemediation');

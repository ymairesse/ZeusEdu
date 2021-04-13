<?php

$listeClasses = $user->listeTitulariats();

$smarty->assign('listeClasses', $listeClasses);

$smarty->display('parents/statsFrequentations.tpl');

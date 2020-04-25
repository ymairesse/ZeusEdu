<?php

$min = isset($_POST['min'])?$_POST['min']:0;
$max = isset($_POST['max'])?$_POST['max']:50;
$refreshOn = isset($_POST['refreshOn'])?$_POST['refreshOn']:'0';

$listeLogins = $Thot->lookLogins($min, $max);

$smarty->assign('listeLogins',$listeLogins);
$smarty->assign('min',$min);
$smarty->assign('max',$max);
$smarty->assign('refreshOn',$refreshOn);

$smarty->assign('corpsPage','listeLogins');

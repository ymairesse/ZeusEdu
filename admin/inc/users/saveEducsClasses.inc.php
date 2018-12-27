<?php

require_once("../../../config.inc.php");

require_once(INSTALL_DIR.'/inc/classes/classApplication.inc.php');
$Application = new Application();

$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : null;
$form = array();
parse_str($formulaire, $form);

$acronyme = $form['acronyme'];

require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
$User = new User();
// quelles étaient les attributions avant ces modifications?
$oldClasses = $User->getClassesEduc($acronyme);
$newClasses = $form['groupe'];

// quelles sont les classes qui ne sont plus attribuées à cette éducateur?
$toSuppress = array_diff($oldClasses, $newClasses);

$nbDel = $User->delClassesEduc($acronyme, $toSuppress);

$nbSave = $User->saveClassesEduc($acronyme, $newClasses);

echo sprintf('%d classe(s) supprimée(s), %d classe(s) ajoutée(s)', $nbDel, $nbSave);

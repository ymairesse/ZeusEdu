<?php

require_once INSTALL_DIR.'/inc/classes/class.Formulaires.php';
$Forms = new Formulaires();

$formId = isset($_POST['idFormulaire']) ? $_POST['idFormulaire'] : null;
$smarty->assign('formId', $formId);

switch ($mode) {
    case 'newForm':
        echo 'new';

        break;
    case 'edit':
        if (isset($formId)) {
            $formProp = $Forms->getFormProp($formId);
            $listeQuestions = $Forms->listeQuestions($formId);
            $smarty->assign('formProp', $formProp);
            $smarty->assign('listeQuestions', $listeQuestions);
            $smarty->assign('corpsPage', 'forms/formEdit');
        }

        break;
    case 'voir':

        if ($etape == 'showForm') {
            $formProp = $Forms->getFormProp($formId);

            $listeQuestions = $Forms->listeQuestions($formId);
            $listeReponses = $Forms->getFormResults($listeQuestions);
            $listeRepondants = $Forms->listeRepondants($formId);
            $listeEleves = $Ecole->detailsDeListeEleves($listeRepondants);

            $smarty->assign('formProp', $formProp);
            $smarty->assign('listeEleves', $listeEleves);
            $smarty->assign('listeQuestions', $listeQuestions);
            $smarty->assign('listeReponses', $listeReponses);
            $smarty->assign('corpsPage', 'forms/showFormResult');
        }
        break;
}

$listeFormulaires = $Forms->choixFormulaires($acronyme);
$smarty->assign('listeFormulaires', $listeFormulaires);
$smarty->assign('selecteur', 'selecteurs/selectForm');

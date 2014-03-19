<?php
$etape = isset($_POST['etape'])?$_POST['etape']:Null;
$etapeFormulaire = isset($_POST['etapeFormulaire'])?$_POST['etapeFormulaire']:Null;
$matricule = isset($_POST['matricule'])?$_POST['matricule']:Null;
$matricule2 = isset($_POST['matricule2'])?$_POST['matricule2']:Null;
$classe = isset($_POST['classe'])?$_POST['classe']:Null;
$id = isset($_POST['id'])?$_POST['id']:Null;

// par défaut, action et mode reprennent leurs valeurs actuelles; on re-changera éventuellement plus tard.
$smarty->assign('action', $action);
$smarty->assign('mode', $mode);

// on prend la valeur de $matricule (le sélecteur d'élèves de la classe sélectionnée) ou de $matricule2 (la liste automatique)
$matricule = ($matricule!='')?$matricule:$matricule2;
// si un élève est déclaré, on aura certainement besoin des détails
if ($matricule != Null) {
    $eleve = new Eleve($matricule);
    $classe = $eleve->groupe();
    $matricule = $eleve->matricule();
    $smarty->assign('eleve',$eleve->getDetailsEleve());
  }

// va-t-on remontrer la liste des autorisations pour l'élève en cours? Par défaut, non...
$showAutorisations = false;

switch ($mode) {
  case 'encoder':
    $smarty->assign('matricule',$matricule);
    if ($matricule != '')
      $showAutorisations = true;
    break;
  case 'edit':
    $smarty->assign('matricule',$matricule);
    $smarty->assign('etape', 'enregistrer');
    
    $acronyme = $user->getAcronyme();
    $data = $Presences->getAutorisation($id);

    $smarty->assign('id',$data['id']);
    $smarty->assign('user',$acronyme);
    $smarty->assign('media',$data['media']);
    $smarty->assign('parent',$data['parent']);
    $smarty->assign('date',$data['date']);
    $smarty->assign('heure',$data['heure']);
    $smarty->assign('corpsPage','newAutorisation');
    $smarty->assign('mode',$mode);
    $smarty->assign('etape',Null);
    $smarty->assign('etapeFormulaire','enregistrer');
    if ($etapeFormulaire == 'enregistrer') {
      $nb = $Presences->saveAutorisation($_POST);
      $smarty->assign("message", array(
					'title'=>SAVE,
					'texte'=>"Enregistrement de: $nb autorisation(s) de sortie"),
				3000);
      // après enregistrement, le sélecteur revient en mode 'encoder'
      $smarty->assign('mode','encoder');
      // on remontrera la liste des autorisations de sortie
      $showAutorisations = true;
      // -------------------------------------------------
      }
    break;
  case 'del':
    if (isset($id)) {
      $nb = $Presences->delAutorisation($id);
            $smarty->assign("message", array(
					'title'=>'Suppression',
					'texte'=>"Suppression de: $nb autorisation(s) de sortie"),
				3000);
      $smarty->assign('matricule',$matricule);
      $smarty->assign('mode', 'encoder');
      // on remontre la liste des autorisations de sortie
      $listeAutorisations = $Presences->listeAutorisations($matricule);
      $smarty->assign('listeAutorisations',$listeAutorisations);
      $smarty->assign('corpsPage','autorisations');
    }
    break;
  case 'newAutorisation':
    $smarty->assign('matricule',$matricule);
    $smarty->assign('etapeFormulaire', 'enregistrer');
    $smarty->assign('mode',$mode);
    if ($etapeFormulaire != 'enregistrer') {
      $acronyme = $user->getAcronyme();
      $smarty->assign('user',$acronyme);
      $smarty->assign('media','Journal de classe');
      $smarty->assign('parent','Parents');
      $smarty->assign('corpsPage','newAutorisation');
      }
      else {
        $nb = $Presences->saveAutorisation($_POST);
        $smarty->assign("message", array(
                      'title'=>SAVE,
                      'texte'=>"Enregistrement de: $nb autorisation(s) de sortie"),
                  3000);
        // après enregistrement, le sélecteur revient en mode 'encoder'
        $smarty->assign('mode','encoder');
        // on remontrera la liste des autorisations de sortie
        $showAutorisations = true;
        }

    break;
  case 'listes':
    $dateDebut = isset($_POST['dateDebut'])?$_POST['dateDebut']:Null;
    $dateFin = isset($_POST['dateFin'])?$_POST['dateFin']:Null;
    $smarty->assign('dateDebut',$dateDebut);
    $smarty->assign('dateFin',$dateFin);
    $smarty->assign('etape','showListe');
    $smarty->assign('selecteur','selectPeriode');
    if ($etape == 'showListe') {
      $liste = $Presences->listeParPeriode($dateDebut,$dateFin);
      $smarty->assign('listeAutorisations',$liste);
      $smarty->assign('corpsPage','listeAutorisations');
      }
    break;
  default:
    // wtf
    break;
  }
  
if ($showAutorisations) {
  // on remontre la liste des autorisations de sortie
  $listeAutorisations = $Presences->listeAutorisations($matricule);
  $smarty->assign('listeAutorisations',$listeAutorisations);
  $smarty->assign('corpsPage','autorisations');
  }

// cas où l'on représente le sélecteur d'élèves
if (in_array($mode, array('edit','del','newAutorisation','encoder'))) {
  // informations pour le sélecteur classe/élève
  $smarty->assign('classe',$classe);
  $listeEleves = isset($classe)?$Ecole->listeEleves($classe,'groupe'):Null;
  $smarty->assign('listeEleves',$listeEleves);
  $listeClasses = $Ecole->listeGroupes();
  $smarty->assign('listeClasses', $listeClasses);
  $smarty->assign('selecteur','selectClasseEleve');
  }
?>
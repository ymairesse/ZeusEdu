<?php /* Smarty version Smarty-3.1.13, created on 2017-05-15 10:42:45
         compiled from "./templates/menu.tpl" */ ?>
<?php /*%%SmartyHeaderCode:100972780059196a057852a9-92786216%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    '243b1378187b2878c10cdd133ad5f270cdcebcd8' => 
    array (
      0 => './templates/menu.tpl',
      1 => 1481976384,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '100972780059196a057852a9-92786216',
  'function' => 
  array (
  ),
  'variables' => 
  array (
    'alias' => 0,
    'identite' => 0,
    'titulaire' => 0,
  ),
  'has_nocache_code' => false,
  'version' => 'Smarty-3.1.13',
  'unifunc' => 'content_59196a0578acf2_46032150',
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_59196a0578acf2_46032150')) {function content_59196a0578acf2_46032150($_smarty_tpl) {?><div class="container hidden-print">

<nav class="navbar navbar-default" role="navigation">

	<div class="navbar-header">
		<button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#barreNavigation">
			<span class="sr-only">Navigation portable</span>
			<span class="icon-bar"></span>
			<span class="icon-bar"></span>
			<span class="icon-bar"></span>
		</button>

		<a class="navbar-brand" href="../index.php"><button type="button" class="btn btn-primary"><span class="glyphicon glyphicon-home"></span></button></a>

	</div>

	<div class="collapse navbar-collapse" id="barreNavigation">
		<ul class="nav navbar-nav">
			<li><a href="index.php"><button class="btn btn-primary">Admin <img src="../images/adminIco.png" alt="adminIco"></button></a></li>
			<li class="dropdown"><a class="dropdown-toggle" data-toggle="dropdown" href="javascript:void(0)">Importer<b class="caret"></b></a>
				<ul class="dropdown-menu">
					<li><a href="index.php?action=import&amp;table=eleves">Élèves</a></li>
					<li><a href="index.php?action=import&amp;table=cours">Cours</a></li>
					<li><a href="index.php?action=import&amp;table=profs">Profs &amp; Educs</a></li>
					<li><a href="index.php?action=import&amp;table=profsCours">Profs/cours</a></li>
					<li><a href="index.php?action=import&amp;table=elevesCours">Élèves/cours</a></li>
					<li><a href="index.php?action=import&amp;table=titus">Titulariats</a></li>
					<li><a href="index.php?action=import&amp;table=bullCompetences">Compétences</a></li>
					<li><a href="index.php?action=import&amp;table=ecoles">Écoles</a></li>
					<li><a href="index.php?action=import&amp;table=elevesEcoles">Élèves/écoles</a></li>
					<li><a href="index.php?action=import&amp;table=bullCE1B">Résultats CEB primaire</a></li>
					<li><a href="index.php?action=import&amp;table=infirmInfos">Informations médicales</a></li>
					<li><a href="index.php?action=import&amp;table=passwd">Mots de passe élèves</a></li>
				</ul>
			</li>

			<li class="dropdown"><a class="dropdown-toggle" data-toggle="dropdown" href="javascript:void(0)">Sauvegardes<b class="caret"></b></a>
				<ul class="dropdown-menu">
					<li><a href="index.php?action=backup&amp;mode=choose">Faire une sauvegarde</a></li>
					<li><a href="index.php?action=backup&amp;mode=tables">Liste des tables</a></li>
				</ul>
			</li>

			<li class="dropdown"><a class="dropdown-toggle" data-toggle="dropdown" href="javascript:void(0)">Voir<b class="caret"></b></a>
				<ul class="dropdown-menu">
					<li><a href="index.php?action=look&amp;table=eleves">Élèves</a></li>
					<li><a href="index.php?action=look&amp;table=cours">Cours</a></li>
					<li><a href="index.php?action=look&amp;table=profs">Profs &amp; Educs</a></li>
					<li><a href="index.php?action=look&amp;table=profsCours">Profs/cours</a></li>
					<li><a href="index.php?action=look&amp;table=elevesCours">Élèves/cours</a></li>
					<li><a href="index.php?action=look&amp;table=elevesEcoles">Élèves/écoles</a></li>
					<li><a href="index.php?action=look&amp;table=titus">Titulaires</a></li>
					<li><a href="index.php?action=look&amp;table=bullCompetences">Compétences</a></li>
					<li><a href="index.php?action=look&amp;table=ecoles">Écoles</a></li>
					<li><a href="index.php?action=look&amp;table=bullCE1B">Résultats CE1B primaire</a></li>
					<li><a href="index.php?action=look&amp;table=elevesEcoles">Élèves/écoles</a></li>
					<li><a href="index.php?action=look&amp;table=infirmInfos">Informations médicales</a></li>

				</ul>
		</li>
		<li class="dropdown"><a class="dropdown-toggle" data-toggle="dropdown" href="javascript:void(0)">Vider<b class="caret"></b></a>
			<ul class="dropdown-menu">
				<li><a href="index.php?action=clear&amp;table=eleves">Élèves</a></li>
				<li><a href="index.php?action=clear&amp;table=cours">Cours</a></li>
				<li><a href="index.php?action=clear&amp;table=profs">Profs &amp; Educs</a></li>
				<li><a href="index.php?action=clear&amp;table=profsCours">Profs/cours</a></li>
				<li><a href="index.php?action=clear&amp;table=elevesCours">Élèves/cours</a></li>
				<li><a href="index.php?action=clear&amp;table=ecoles">Écoles</a></li>
				<li><a href="index.php?action=clear&amp;table=elevesEcoles">Élèves/écoles</a></li>
				<li><a href="index.php?action=clear&amp;table=titus">Titulaires</a></li>
				<li><a href="index.php?action=clear&amp;table=bullCompetences">Compétences</a></li>
				<li><a href="index.php?action=clear&amp;table=bullCE1B">Résultats CE1B primaire</a></li>
				<li><a href="index.php?action=clear&amp;table=passwd">Mots de passe élèves</a></li>
				<li><a href="index.php?action=clear&amp;table=infirmInfos">Informations médicales</a></li>

			</ul>
		</li>
		<li class="dropdown"><a class="dropdown-toggle" data-toggle="dropdown" href="javascript:void(0)">Utilisateurs<b class="caret"></b></a>
			<ul class="dropdown-menu">
				<li><a href="index.php?action=gestUsers&amp;mode=addUser">Ajouter un utilisateur</a></li>
				<li><a href="index.php?action=gestUsers&amp;mode=modifUser">Modifier un utilisateur</a></li>
				<li><a href="index.php?action=gestUsers&amp;mode=delUser">Supprimer un utilisateur</a></li>
				<li><a href="index.php?action=gestUsers&amp;mode=affectation">Affectation en masse</a></li>
			</ul>
		</li>

		<li class="dropdown"><a class="dropdown-toggle" data-toggle="dropdown" href="javascript:void(0)">Élèves<b class="caret"></b></a>
			<ul class="dropdown-menu">
				<li><a href="index.php?action=gestEleves&amp;mode=addEleve">Ajouter manuellement</a></li>
				<li><a href="index.php?action=gestEleves&amp;mode=modifEleve">Modifier manuellement</a></li>
				<li><a href="index.php?action=gestEleves&amp;mode=supprEleve">Supprimer un élève</a></li>
				<li><a href="index.php?action=gestEleves&amp;mode=envoiPhotos">Envoyer les photos</a></li>
				<li><a href="index.php?action=gestEleves&amp;mode=groupEleve">Gestion des groupes/classes</a></li>
				<li><a href="index.php?action=gestEleves&amp;mode=attribMdp">Attribuer des mots de passe</a></li>
				<li><a href="index.php?action=gestEleves&amp;mode=printPwd">Imprimer les mots de passe</a></li>
				<li><a href="index.php?action=maj&amp;table=anciens">Suppression anciens élèves</a></li>
			</ul>
		</li>

		<li class="dropdonw"><a class="dropdown-toggle" data-toggle="dropdown" href="javascript:void(0)">Autres<b class="caret"></b></a>
			<ul class="dropdown-menu">
				<li><a href="index.php?action=news&amp;mode=show">News Admin</a></li>
				<li><a href="index.php?action=autres&amp;mode=alias">Prendre un alias</a></li>
				<li><a href="index.php?action=autres&amp;mode=switchApplications">Activer/désactiver les applications</a></li>
				<li><a href="index.php?action=autres&amp;mode=config">Paramètres généraux</a></li>
			</ul>
		</li>
	</ul>

	<ul class="nav navbar-nav pull-right">
			<?php if (isset($_smarty_tpl->tpl_vars['alias']->value)){?>
			<li><a href="../aliasOut.php"><img src="../images/alias.png" alt="Alias"><?php echo $_smarty_tpl->tpl_vars['alias']->value;?>
</a></li>
			<?php }?>
			<li class="dropdown"><a class="dropdown-toggle" data-toggle="dropdown" href="#"><?php echo $_smarty_tpl->tpl_vars['identite']->value['prenom'];?>
 <?php echo $_smarty_tpl->tpl_vars['identite']->value['nom'];?>

			<?php if ($_smarty_tpl->tpl_vars['titulaire']->value){?>[<?php echo implode(',',$_smarty_tpl->tpl_vars['titulaire']->value);?>
]<?php }?><b class="caret"></b></a>
				<ul class="dropdown-menu">
					<li><a href="../profil/index.php"><span class="glyphicon glyphicon-user"></span> Modifiez votre profil</a></li>
					<li><a href="../logout.php"><span class="glyphicon glyphicon-off"></span> Déconnexion</a></li>
				</ul>
			</li>
	</ul>

	</div>  <!-- collapse -->

</nav>

</div>  <!-- container -->
<?php }} ?>
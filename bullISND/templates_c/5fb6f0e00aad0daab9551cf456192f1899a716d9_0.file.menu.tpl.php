<?php
/* Smarty version 3.1.34-dev-7, created on 2021-03-07 12:36:26
  from '/home/yves/www/sio2/peda/bullISND/templates/menu.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_6044baba7a4579_37081521',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '5fb6f0e00aad0daab9551cf456192f1899a716d9' => 
    array (
      0 => '/home/yves/www/sio2/peda/bullISND/templates/menu.tpl',
      1 => 1615116968,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_6044baba7a4579_37081521 (Smarty_Internal_Template $_smarty_tpl) {
?><div id="top"></div>
<div class="container-fluid hidden-print">

	<nav class="navbar navbar-default" role="navigation" style="margin-bottom: 0">

	<div class="navbar-header">

		<button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#barreNavigation">
			<span class="sr-only">Navigation portable</span>
			<span class="icon-bar"></span>
			<span class="icon-bar"></span>
			<span class="icon-bar"></span>
		</button>

		<a class="navbar-brand" href="../index.php"><button type="button" class="btn btn-primary btn-sm"><span class="glyphicon glyphicon-home"></span></button></a>

	</div> <!-- navbar-header <-->

	<div class="collapse navbar-collapse" id="barreNavigation">

	<ul class="nav navbar-nav">

		<li>
			<a href="index.php"><button class="btn btn-primary btn-sm">Bulletin <img src="images/bullISND.png" alt="bullISND" title="Page d'accueil du bulletin"></button></a>
		</li>

		<li class="dropdown">
			<a href="javascript:void(0)" class="dropdown-toggle" data-toggle="dropdown">Imprimer <b class="caret"></b></a>
	        <ul class="dropdown-menu">
				<li><a href="index.php?action=ecran&amp;mode=bulletinIndividuel">Bulletins individuels à l'écran</a></li>
				<li><a href="index.php?action=pdf&amp;mode=bulletinIndividuel">Bulletins individuels PDF</a></li>
				<li><a href="index.php?action=pdf&amp;mode=bulletinClasse">Bulletins par classe PDF</a></li>
				<li><a href="index.php?action=pdf&amp;mode=niveau">Bulletins par niveaux</a></li>
				<li><a href="index.php?action=pdf&amp;mode=archive">Archives des bulletins</a></li>
			</ul>
		</li>

		<?php if (($_smarty_tpl->tpl_vars['userStatus']->value == 'admin') || ($_smarty_tpl->tpl_vars['userStatus']->value == 'direction')) {?>
		<li class="dropdown"><a href="javascript:void(0)" class="dropdown-toggle" data-toggle="dropdown">Coordinateurs <b class="caret"></b></a>
			<ul class="dropdown-menu">
				<li><a href="index.php?action=nota">Notices coordinateurs/direction</a></li>
				<li><a href="index.php?action=parEcole">Résultats par école</a></li>
				<li><a href="index.php?action=direction&amp;mode=padEleve">Bloc Note Élèves</a></li>
				<li class="divider"></li>
				<li><a href="index.php?action=direction&amp;mode=pia">Couverture PIA</a></li>
				<li><a href="index.php?action=direction&amp;mode=competences">Rapports de compétences / PIA</a></li>
				<li><a href="index.php?action=direction&amp;mode=resultatsExternes">Résultats des épreuves externes</a></li>
				<li><a href="index.php?action=direction&amp;mode=recapDegre">Récapitulatif du degré</a></li>
			</ul>
		</li>
		<?php }?>

		<li class="dropdown"><a href="javascript:void(0)" class="dropdown-toggle" data-toggle="dropdown">Carnet de cotes <b class="caret"></b></a>
			<ul class="dropdown-menu">
				<li><a href="index.php?action=carnet&amp;mode=gererCotes">Gérer les cotes</a></li>
				<li><a href="index.php?action=carnet&amp;mode=poidsCompetences">Poids des compétences</a></li>
				<li><a href="index.php?action=carnet&amp;mode=oneClick">One Click Bulletin</a></li>
				<li class="divider"></li>
				<li><a href="index.php?action=carnet&amp;mode=repertoire">Répertoire / élève</a></li>
			</ul>
		</li>

		<li class="dropdown">
			<a href="javascript:void(0)" class="dropdown-toggle" data-toggle="dropdown">Bulletin <b class="caret"></b></a>
			<ul class="dropdown-menu">
				<?php if ($_smarty_tpl->tpl_vars['userStatus']->value == 'educ' || $_smarty_tpl->tpl_vars['userStatus']->value == 'admin') {?>
				<li><a href="index.php?action=educ&amp;mode=noteEduc">Note de l'éducateur</a></li>
				<?php }?>
				<li><a href="index.php?action=gestionBaremes&amp;mode=voir">Pondération par période</a></li>
				<li><a href="index.php?action=gestionCotes&amp;mode=voir">Aperçu des cotes pour vos cours</a></li>
				<li><a href="index.php?action=gestEncodageBulletins">Encodage des bulletins</a></li>
				<li><a href="index.php?action=gestEprExternes">Épreuves externes</a></li>
				<?php if ($_smarty_tpl->tpl_vars['userStatus']->value == 'admin') {?>
				<li class="divider"></li>
				<li><a href="index.php?action=admin&amp;mode=poserVerrous">Ouvrir/fermer des verrous niveau/classe</a></li>
				<li><a href="index.php?action=admin&amp;mode=verrouClasseCoursEleve">Ouvrir/fermer des Verrous classe/cours/élève</a></li>
				<li><a href="index.php?action=admin&amp;mode=verrouTabs">Verrous par classe</a></li>
				<li><a href="index.php?action=admin&amp;mode=situations">Modifier les situations</a></li>
				<li><a href="index.php?action=admin&amp;mode=eprExternes">Init. Épreuves externes</a></li>
				<li><a href="index.php?action=admin&amp;mode=ponderations">Voir les pondérations</a></li>
				<?php }?>
			</ul>
		</li>

		<?php if ($_smarty_tpl->tpl_vars['titulaire']->value) {?>
		<li class="dropdown"><a href="javascript:void(0)" class="dropdown-toggle" data-toggle="dropdown">Titu. <?php echo implode(',',$_smarty_tpl->tpl_vars['titulaire']->value);?>
 <b class="caret"></b></a>
			<ul class="dropdown-menu">
				<li><a href="index.php?action=titu&amp;mode=remarques">Remarques aux bulletins</a></li>
				<li><a href="index.php?action=titu&amp;mode=padEleve">Bloc Note Élèves</a></li>
				<li><a href="index.php?action=titu&amp;mode=verrous">(Dé)-verrouiller les bulletins</a></li>
			</ul>
		</li>
		<?php }?>

		<li class="dropdown"><a href="javascript:void(0)" class="dropdown-toggle" data-toggle="dropdown">Délibés <b class="caret"></b></a>
			<ul class="dropdown-menu">
				<li><a href="index.php?action=delibes&amp;mode=parClasse">Feuille de délibé par classe</a></li>
				<li><a href="index.php?action=delibes&amp;mode=individuel">Feuille de délibé individuelle</a></li>
				<li><a href="index.php?action=delibes&amp;mode=synthese">Synthèses des situations par période</a></li>
				<?php if ($_smarty_tpl->tpl_vars['userStatus']->value == 'admin') {?>
					<li class="divider"></li>
					<li><a href="index.php?action=delibes&amp;mode=viewNotifs">Notifications envoyées</a></li>
				<?php }?>
				<?php if ($_smarty_tpl->tpl_vars['titulaire']->value) {?>
					<li><a href="index.php?action=delibes&amp;mode=notifications">Envoi des notifications</a></li>
				<?php }?>
			</ul>
		</li>

		<li class="dropdown"><a href="javascript:void(0)" class="dropdown-toggle" data-toggle="dropdown">Préférences <b class="caret"></b></a>
			<ul class="dropdown-menu">
				<li><a href="index.php?action=admin&amp;mode=nommerCours">Nommer vos cours</a></li>
				<?php if ($_smarty_tpl->tpl_vars['userStatus']->value == 'admin') {?>
				<li class="divider"></li>
				<li><a href="index.php?action=admin&amp;mode=remplacants">Profs remplacés</a></li>
				<li><a href="index.php?action=admin&amp;mode=interim">Intérimaires</a></li>
				<li><a href="index.php?action=admin&amp;mode=titulaires">Titulariats</a></li>
				<li class="divider"></li>
				<li><a href="index.php?action=gestCours&amp;mode=matieres">Gestion des matières</a></li>
				<li><a href="index.php?action=gestCours&amp;mode=editCours">Gestion des cours</a></li>
				<li><a href="index.php?action=admin&amp;mode=statutCadre">Cadre et statut des cours</a></li>
				<li class="divider"></li>
				<li><a href="index.php?action=admin&amp;mode=attributionsProfs">Attrib. cours aux profs</a></li>
				<li><a href="index.php?action=admin&amp;mode=attributionsEleves">Attrib. élèves aux cours</a></li>
				<li><a href="index.php?action=admin&amp;mode=programmeEleve">Attrib. cours aux élèves</a></li>
				<li><a href="index.php?action=admin&amp;mode=competences">Gestion des compétences</a></li>
				<li class="divider"></li>
				<li><a href="index.php?action=init">Initialisations</a></li>
				<li><a href="index.php?action=admin&amp;mode=alias">Prendre un alias</a></li>
				<?php }?>
			</ul>
		</li>

	</ul>

	<ul class="nav navbar-nav pull-right">

		<?php if ((isset($_smarty_tpl->tpl_vars['alias']->value))) {?>
		<li>
			<a href="../aliasOut.php"><img src="../images/alias.png" alt="Alias"><?php echo $_smarty_tpl->tpl_vars['alias']->value;?>
</a>
		</li>
		<?php }?>
		<li class="dropdown">
			<a class="dropdown-toggle" data-toggle="dropdown" href="#"><?php echo $_smarty_tpl->tpl_vars['identite']->value['prenom'];?>
 <?php echo $_smarty_tpl->tpl_vars['identite']->value['nom'];?>

			<?php if ($_smarty_tpl->tpl_vars['titulaire']->value) {?>[<?php echo implode(',',$_smarty_tpl->tpl_vars['titulaire']->value);?>
]<?php }?>
			<b class="caret"></b></a>
			<ul class="dropdown-menu">
				<li><a href="../profil/index.php"><span class="glyphicon glyphicon-user"></span> Modifiez votre profil</a></li>
				<li><a href="../logout.php"><span class="glyphicon glyphicon-off"></span> Déconnexion</a></li>
			</ul>
		</li>

	</ul>

</ul>

	</div>  <!-- collapse -->

	</nav>

</div> <!-- container -->

<?php echo '<script'; ?>
 type="text/javascript">

 // listen for scroll
var positionElementInPage = $('#top').offset().top;

$(window).scroll(
	function() {
		if ($(window).scrollTop() >= positionElementInPage) {
			// fixed
			$('#menuBas').addClass("floatable");
		} else {
			// relative
			$('#menuBas').removeClass("floatable");
		}
	}
);

<?php echo '</script'; ?>
>
<?php }
}

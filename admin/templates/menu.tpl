<div class="container-fluid hidden-print">

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
				<li class="divider"></li>
				<li><a href="index.php?action=gestUsers&amp;mode=educsClasses">Gestion des éducateurs</a></li>
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
				<li><a href="index.php?action=autres&amp;mode=majAcronymes">Mise à jour des acronymes</a> </li>
			</ul>
		</li>
	</ul>

	<ul class="nav navbar-nav pull-right">
			{if isset($alias)}
			<li><a href="../aliasOut.php"><img src="../images/alias.png" alt="Alias">{$alias}</a></li>
			{/if}
			<li class="dropdown"><a class="dropdown-toggle" data-toggle="dropdown" href="#">{$identite.prenom} {$identite.nom}
			{if $titulaire}[{','|implode:$titulaire}]{/if}<b class="caret"></b></a>
				<ul class="dropdown-menu">
					<li><a href="../profil/index.php"><span class="glyphicon glyphicon-user"></span> Modifiez votre profil</a></li>
					<li><a href="../logout.php"><span class="glyphicon glyphicon-off"></span> Déconnexion</a></li>
				</ul>
			</li>
	</ul>

	</div>  <!-- collapse -->

</nav>

</div>  <!-- container -->

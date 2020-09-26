<div id="top"></div>
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

		{if ($userStatus == 'admin') || ($userStatus == 'direction')}
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
		{/if}

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
				{if $userStatus == 'educ' || $userStatus == 'admin'}
				<li><a href="index.php?action=educ&amp;mode=noteEduc">Note de l'éducateur</a></li>
				{/if}
				<li><a href="index.php?action=gestionBaremes&amp;mode=voir">Pondération par période</a></li>
				<li><a href="index.php?action=gestionCotes&amp;mode=voir">Aperçu des cotes pour vos cours</a></li>
				<li><a href="index.php?action=gestEncodageBulletins">Encodage des bulletins</a></li>
				<li><a href="index.php?action=gestEprExternes">Épreuves externes</a></li>
				{if $userStatus eq 'admin'}
				<li class="divider"></li>
				<li><a href="index.php?action=admin&amp;mode=poserVerrous">Ouvrir/fermer des verrous niveau/classe</a></li>
				<li><a href="index.php?action=admin&amp;mode=verrouClasseCoursEleve">Ouvrir/fermer des Verrous classe/cours/élève</a></li>
				<li><a href="index.php?action=admin&amp;mode=verrouTabs">Verrous par classe</a></li>
				<li><a href="index.php?action=admin&amp;mode=situations">Modifier les situations</a></li>
				<li><a href="index.php?action=admin&amp;mode=eprExternes">Init. Épreuves externes</a></li>
				<li><a href="index.php?action=admin&amp;mode=ponderations">Voir les pondérations</a></li>
				{/if}
			</ul>
		</li>

		{if $titulaire }
		<li class="dropdown"><a href="javascript:void(0)" class="dropdown-toggle" data-toggle="dropdown">Titu. {','|implode:$titulaire} <b class="caret"></b></a>
			<ul class="dropdown-menu">
				<li><a href="index.php?action=titu&amp;mode=remarques">Remarques aux bulletins</a></li>
				<li><a href="index.php?action=titu&amp;mode=padEleve">Bloc Note Élèves</a></li>
				<li><a href="index.php?action=titu&amp;mode=verrous">(Dé)-verrouiller les bulletins</a></li>
			</ul>
		</li>
		{/if}

		<li class="dropdown"><a href="javascript:void(0)" class="dropdown-toggle" data-toggle="dropdown">Délibés <b class="caret"></b></a>
			<ul class="dropdown-menu">
				<li><a href="index.php?action=delibes&amp;mode=parClasse">Feuille de délibé par classe</a></li>
				<li><a href="index.php?action=delibes&amp;mode=individuel">Feuille de délibé individuelle</a></li>
				<li><a href="index.php?action=delibes&amp;mode=synthese">Synthèses des situations par période</a></li>
				{if $userStatus == 'admin'}
					<li class="divider"></li>
					<li><a href="index.php?action=delibes&amp;mode=viewNotifs">Notifications envoyées</a></li>
				{/if}
				{if $titulaire}
					<li><a href="index.php?action=delibes&amp;mode=notifications">Envoi des notifications</a></li>
				{/if}
			</ul>
		</li>

		<li class="dropdown"><a href="javascript:void(0)" class="dropdown-toggle" data-toggle="dropdown">Préférences <b class="caret"></b></a>
			<ul class="dropdown-menu">
				<li><a href="index.php?action=admin&amp;mode=nommerCours">Nommer vos cours</a></li>
				{if $userStatus eq 'admin'}
				<li><a href="index.php?action=init">Initialisations</a></li>
				<li><a href="index.php?action=admin&amp;mode=remplacants">Profs remplacés</a></li>
				<li><a href="index.php?action=admin&amp;mode=interim">Intérimaires</a></li>
				<li><a href="index.php?action=gestCours&amp;mode=matieres">Gestion des matières</a></li>
				<li><a href="index.php?action=gestCours&amp;mode=editCours">Gestion des cours</a></li>
				<li><a href="index.php?action=admin&amp;mode=attributionsProfs">Attrib. cours aux profs</a></li>
				<li><a href="index.php?action=admin&amp;mode=attributionsEleves">Attrib. élèves aux cours</a></li>
				<li><a href="index.php?action=admin&amp;mode=programmeEleve">Attrib. cours aux élèves</a></li>
				<li><a href="index.php?action=admin&amp;mode=competences">Gestion des compétences</a></li>
				<li><a href="index.php?action=admin&amp;mode=alias">Prendre un alias</a></li>
				<li><a href="index.php?action=admin&amp;mode=titulaires">Titulariats</a></li>
				<li><a href="index.php?action=admin&amp;mode=statutCadre">Cadre et statut des cours</a></li>
				{/if}
			</ul>
		</li>

	</ul>

	<ul class="nav navbar-nav pull-right">

		{if isset($alias)}
		<li>
			<a href="../aliasOut.php"><img src="../images/alias.png" alt="Alias">{$alias}</a>
		</li>
		{/if}
		<li class="dropdown">
			<a class="dropdown-toggle" data-toggle="dropdown" href="#">{$identite.prenom} {$identite.nom}
			{if $titulaire}[{','|implode:$titulaire}]{/if}
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

<script type="text/javascript">

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

</script>

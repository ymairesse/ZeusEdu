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
			<li><a href="index.php"><button class="btn btn-primary">ADES <img src="images/adesIco.png" alt="ADES" title="Page d'accueil de ADES"></button></a></li>
			<li class="dropdown"><a href="javascript.void(0)" class="dropdown-toggle" data-toggle="dropdown">
				Élèves <b class="caret"></b></a>
				<ul class="dropdown-menu">
					<li><a href="index.php?action=eleve&amp;mode=classeEleve">Sélection nom / classe</a></li>
					<li><a href="index.php?action=eleve&amp;mode=trombinoscope">Par le trombinoscope</a></li>
				</ul>
			</li>

			<li class="dropdown"><a href="javascript:void(0)" class="dropdown-toggle" data-toggle="dropdown">
				Retenues <b class="caret"></b></a>
				<ul class="dropdown-menu">
					<li><a href="index.php?action=retenues&amp;mode=liste">Listes d'élèves en retenues</a></li>
					{if ($userStatus == 'admin') || ($userStatus == 'educ')}<li><a href="index.php?action=retenues&amp;mode=dates">Dates et clonages</a></li>{/if}
					{if ($userStatus == 'admin') || ($userStatus == 'educ')}<li><a href="index.php?action=retenues&amp;mode=new">Nouvelle retenue</a></li>{/if}
				</ul>
			</li>

			<li class="dropdown"><a href="javascript:void(0)" class="dropdown-toggle" data-toggle="dropdown">
				Synthèses <b class="caret"></b></a>
				<ul class="dropdown-menu">
					<li><a href="index.php?action=synthese&amp;mode=showFiches">Fiches de comportement</a></li>
					<li><a href="index.php?action=synthese&amp;mode=statistiques">Statistiques par niveau</a></li>
				</ul>
			</li>

			<li class="dropdown"><a href="javascript:void(0)" class="dropdown-toggle" data-toggle="dropdown">
				Admin <b class="caret"></b></a>
				<ul class="dropdown-menu">
					<li><a href="index.php?action=admin&amp;mode=remAuto">Gestion des textes automatiques</a></li>
					{if $userStatus == 'admin'}
					<li><a href="index.php?action=admin&amp;mode=editBilletRetenue">Édition des billets de retenue</a></li>
					<li><a href="index.php?action=admin&amp;mode=editSignature">Édition de la signature des mails</a></li>
					<li><a href="index.php?action=admin&amp;mode=editMailRetenue">Édition du texte type des mails</a></li>
					<li><a href="index.php?action=admin&amp;mode=users">Utilisateurs</a></li>
					<li><a href="index.php?action=admin&amp;mode=printPublish">Gestion des publications</a></li>
					<li class="divider"></li>
					<li><a href="index.php?action=admin&amp;mode=editTypesFaits">Construction des faits disciplinaires</a></li>
					{/if}
				</ul>
			</li>
			</ul>
				<ul class="nav navbar-nav pull-right">
				{if isset($alias)}
					<li><a href="../aliasOut.php"><img src="../images/alias.png" alt="Alias">{$alias}</a></li>
				{/if}
				<li class="dropdown">
					<a href="javascript.void(0)" class="dropdown-toggle" data-toggle="dropdown">
						<span class="glyphicon glyphicon-user"></span>
						<strong>{$identite.prenom} {$identite.nom}
							{if $titulaire}[{','|implode:$titulaire}]{/if}
						</strong><b class="caret"></b></a>
						<ul class="dropdown-menu">
							<li><a href="../profil/index.php">Modifier le profil</a></li>
							<li><a href="../logout.php">Déconnexion <span class="glyphicon glyphicon-off"></span></a></li>
						</ul>
				</li>
			</ul>
	</div>  <!-- collapse -->
	</nav>
</div>

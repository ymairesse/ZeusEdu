<div class="container hidden-print">

	<nav class="navbar navbar-default" role="navigation">

	<div class="navbar-header">

		<button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#barreNavigation">
			<span class="sr-only">Navigation portable</span>
			<span class="icon-bar"></span>
			<span class="icon-bar"></span>
			<span class="icon-bar"></span>
		</button>
		<a class="navbar-brand" href="../index.php"><button type="button" class="btn btn-primary"><span class="glyphicon glyphicon-home"></span></button></a>

	</div>  <!-- navbar-header <-->

	<div class="collapse navbar-collapse" id="barreNavigation">

		<ul class="nav navbar-nav">

			<li><a href="index.php"><button class="btn btn-primary">THOT <img src="images/thotIco.png" alt="THOT" title="Page d'accueil de THOT"></button></a></li>
			<li class="dropdown"><a class="dropdown-toogle" data-toggle="dropdown" href="javascript:void(0)">Annonces <b class="caret"></b></a>
				<ul class="dropdown-menu">
					<li><a href="index.php?action=notification&amp;mode=classes">Sélection par classe</a></li>
					<li><a href="index.php?action=notification&amp;mode=coursGrp">Sélection par cours</a></li>

					{if ($userStatus == 'admin') || ($userStatus == 'direction')}
					<li><a href="index.php?action=notification&amp;mode=niveau">À un niveau d'étude</a></li>
					<li><a href="index.php?action=notification&amp;mode=ecole">À tous les élèves</a></li>
					{/if}
					<li role="separator" class="divider"></li>
					<li><a href="index.php?action=notification&amp;mode=historique">Historique des annonces</a></li>
				</ul>
			</li>

			<li class="dropdown"><a class="dropdown-toogle" data-toggle="dropdown" href="javascript:void(0)">J. de classe <b class="caret"></b></a>
				<ul class="dropdown-menu">
					{if !empty($titulaire)}
					<li><a href="index.php?action=jdc&amp;mode=classe&amp;destinataire={','|implode:$titulaire}">Titulaire de [{','|implode:$titulaire}]</a></li>
					{/if}
					{if $listeCours != Null}
					<li><a href="index.php?action=jdc&amp;mode=cours">Journal de classe par cours</a></li>
					{/if}
					<li><a href="index.php?action=jdc&amp;mode=eleves">Journal de classe élève</a></li>
				</ul>
			</li>

			{if !empty($titulaire) || ($userStatus == 'direction')}
			<li class="dropdown"><a class="dropdown-toggle" data-toggle="dropdown" href="javascript:void(0)">Gestion <b class="caret"></b></a>
				<ul class="dropdown-menu">
					{if !empty($titulaire)}
					<li><a href="index.php?action=gestion&amp;mode=parents">Liste des parents de {','|implode:$titulaire}</a></li>
					{/if}
					{if $userStatus == 'direction'}
					<li><a href="index.php?action=gestion&amp;mode=rv">Mes rendez-vous</a></li>
					{/if}
				</ul>
			</li>
			{/if}

			<li class="dropdown"><a href="javascript.void(0)" class="dropdown-toggle" data-toggle="dropdown">
				Documents <b class="caret"></b></a>
				<ul class="dropdown-menu">
					<li><a href="index.php?action=files&amp;mode=share"><i class="fa fa-arrow-right"></i> Je partage</a></li>
					<li><a href="index.php?action=files&amp;mode=e-docs">Partagés avec moi <i class="fa fa-arrow-left"></i></a></li>
					<li><a href="index.php?action=files&amp;mode=casier">Mon casier virtuel</a></li>
				</ul>
			</li>

			<li class="dropdown"><a class="dropdown-toggle" data-toggle="dropdown" href="javascript:void(0)">Réunion de parents <b class="caret"></b></a>
				<ul class="dropdown-menu">
					{if $userStatus == 'admin'}
					<li><a href="index.php?action=reunionParents&amp;mode=editNew">Nouvelle RP ou modification</a></li>
					<li><a href="index.php?action=reunionParents&amp;mode=periodesAdmin">Gestion des périodes de rendez-vous</a></li>
					{else}
					<li><a href="index.php?action=reunionParents&amp;mode=periodesProfs">Gestion des périodes de rendez-vous</a></li>
					{/if}

					{if $userStatus == 'admin'}
					<li><a href="index.php?action=reunionParents&amp;mode=printEleves">Imprimer les fiches "parents"</a></li>
					{/if}

				</ul>
			</li>

			<li class="dropdown"><a class="dropdown-toggle" data-toggle="dropdown" href="javascript:void(0)">Formulaires <b class="caret"></b></a>
				<ul class="dropdown-menu">
					<li><a href="index.php?action=formulaires&amp;mode=edit">Création/modification d'un formulaire</a></li>
					<li><a href="index.php?action=formulaires&amp;mode=voir">Consulter mes formulaires</a></li>
				</ul>
			</li>

			{if ($userStatus == 'admin')}
				<li class="dropdown"><a class="dropdown-toggle" data-toggle="dropdown" href="javascript:void(0)">Admin <b class="caret"></b></a>
					<ul class="dropdown-menu">
						<li><a href="index.php?action=connexions&amp;mode=date">Connexions par date</a></li>
						<li><a href="index.php?action=connexions&amp;mode=logins">Logins en temps réel</a></li>
						<li><a href="index.php?action=stats">Statistiques</a></li>
						<li><a href="index.php?action=admin&amp;mode=bulletin">Accès aux bulletins</a></li>
					</ul>
				</li>
			{/if}

		</ul>  <!-- nav navbar-nav -->

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

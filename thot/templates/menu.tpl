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

	</div>  <!-- navbar-header <--></-->

	<div class="collapse navbar-collapse" id="barreNavigation">

		<ul class="nav navbar-nav">
			<li><a href="index.php"><button class="btn btn-primary">THOT <img src="images/thotIco.png" alt="THOT" title="Page d'accueil de THOT"></button></a></li>
			<li class="dropdown"><a class="dropdown-toogle" data-toggle="dropdown" href="javascript:void(0)">Notifications <b class="caret"></b></a>
				<ul class="dropdown-menu">
					<li><a href="index.php?action=notification&amp;mode=eleves">À un élève</a></li>
					<li><a href="index.php?action=notification&amp;mode=classes">À une classe</a></li>
					{if ($userStatus == 'admin') || ($userStatus == 'direction')}
					<li><a href="index.php?action=notification&amp;mode=niveau">À un niveau d'étude</a></li>
					<li><a href="index.php?action=notification&amp;mode=ecole">À tous les élèves</a></li>
					{/if}
				</ul>
			</li>

			<li class="dropdown"><a class="dropdown-toggle" data-toggle="dropdown" href="javascript:void(0)">Gestion <b class="caret"></b></a>
				<ul class="dropdown-menu">
					<li><a href="index.php?action=admin&amp;mode=edition">Edition des notifications</a></li>
					<li><a href="index.php?action=admin&amp;mode=gestAccuses">Gestion des accusés de lecture</a></li>
					{if ($userStatus == 'admin')}
					<li><a href="index.php?action=admin&amp;mode=bulletin">Accès aux bulletins</a></li>
					{/if}
				</ul>
			</li>

			{if ($userStatus == 'admin')}
				<li class="dropdown"><a class="dropdown-toggle" data-toggle="dropdown" href="javascript:void(0)">Big Brother <b class="caret"></b></a>
				<ul class="dropdown-menu">
					<li><a href="index.php?action=connexions&amp;mode=date">Connexions par date</a></li>
					<li><a href="index.php?action=connexions&amp;mode=logins">Logins en temps réel</a></li>
				</ul>
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

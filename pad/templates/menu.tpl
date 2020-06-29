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
			<li>
				<a href="index.php"><button class="btn btn-primary">Bloc-Notes <img src="images/padIco.png" alt="Bloc-notes" title="Page d'accueil du bloc-notes"></button></a>
			</li>

			<li class="dropdown"><a class="dropdown-toogle" data-toggle="dropdown" href="javascript:void(0)">Blocs Notes <b class="caret"></b></a>
				<ul class="dropdown-menu">
					<li><a href="index.php?action=parClasse">Par classe</a></li>
					{if $listeCours != Null}
						<li><a href="index.php?action=parCours">Par cours</a></li>
					{/if}
				</ul>

			<li class="dropdown"><a class="dropdown-toogle" data-toggle="dropdown" href="javascript:void(0)">Partages<b class="caret"></b></a>
				<ul class="dropdown-menu">
					<li><a href="index.php?action=partager&amp;mode=parCours">Partager par cours</a></li>
					<li><a href="index.php?action=partager&amp;mode=parClasse">Partager par classe</a></li>
					<li class="divider"></li>
					<li><a href="index.php?action=mesPartages&amp;mode=parCours">Mes partages par cours</a></li>
					<li><a href="index.php?action=mesPartages&amp;mode=parClasse">Mes partages par classe</a></li>
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

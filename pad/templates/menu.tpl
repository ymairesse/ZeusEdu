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

	</div>
	
	<div class="collapse navbar-collapse" id="barreNavigation">

		<ul class="nav navbar-nav">
			<li><a href="index.php"><button class="btn btn-primary">Bloc-Notes <img src="images/padIco.png" alt="Bloc-notes" title="Page d'accueil du bloc-notes"></button></a></li>
			<li><a href="index.php?action=parClasse">Par classe</a></li>
			{if $listeCours != Null}
				<li class="dropdown"><a class="dropdown-toogle" data-toggle="dropdown" href="javascript:void(0)" id="parCours">Par Cours<b class="caret"></b></a>
					<ul class="dropdown-menu">
					{foreach from=$listeCours key=option item=unCours}
						<li><a href="index.php?action=parCours&amp;coursGrp={$option}">
							{$unCours.statut} {$unCours.libelle} {$unCours.annee}e {$unCours.nbheures}h ({$unCours.coursGrp})
						</a></li>
					{/foreach}
					</ul>
				</li>
			{/if}
			<li class="dropdown"><a class="dropdown-toogle" data-toggle="dropdown" href="javascript:void(0)">Partager<b class="caret"></b></a>
				<ul class="dropdown-menu">
					<li><a href="index.php?action=partager&amp;mode=parCours">Partager par cours</a></li>
					<li><a href="index.php?action=partager&amp;mode=parClasse">Partager par classe</a></li>
				</ul>
			</li>
			<li class="dropdown"><a class="dropdown-toogle" data-toggle="dropdown" href="javascript:void(0)">Mes partages<b class="caret"></b></a>
				<ul class="dropdown-menu">
					<li><a href="index.php?action=mesPartages&amp;mode=parClasse">Mes partages par classe</a></li>
					<li><a href="index.php?action=mesPartages&amp;mode=parCours">Mes partages par cours</a></li>
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
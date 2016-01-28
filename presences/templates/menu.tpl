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
			<li><a href="index.php"><button type="button" class="btn btn-primary">Présences <img src="images/presencesIco.png" alt="P"></button></a></li>
			{if isset($lesCours) && ($lesCours != Null)}
				<li><a href="index.php?action=presences&amp;mode=tituCours">Profs</a></li>
			{/if}
			
			{if ($userStatus == 'educ') || ($userStatus == 'admin') || ($userStatus == 'coordinateur')}
				<li class="dropdown"><a class="dropdown-toggle" data-toggle="dropdown" href="#">Educs<b class="caret"></b></a>
					<ul class="dropdown-menu">
						<li><a href="index.php?action=presences&amp;mode=cours">Présences par cours</a></li>
						<li><a href="index.php?action=presences&amp;mode=classe">Présences par classe</a></li>
					</ul>
				</li>
			{/if}
			
			{if ($userStatus != 'accueil')}
			<li class="dropdown"><a class="dropdown-toggle" data-toggle="dropdown" href="#">Listes<b class="caret"></b></a>
				<ul class="dropdown-menu">
					<li><a href="index.php?action=listes&amp;mode=parDate">Absences par date</a></li>
					<li><a href="index.php?action=listes&amp;mode=parClasse">Absences par classe</a></li>
					<li><a href="index.php?action=listes&amp;mode=parEleve">Absences par élève</a></li>
				</ul>
			</li>
			{/if}
			
			{if ($userStatus == 'educ') || ($userStatus == 'admin') || ($userStatus == 'accueil')}
			<li class="dropdown"><a class="dropdown-toggle" data-toggle="dropdown" href="#">Justifications<b class="caret"></b></a>
				<ul class="dropdown-menu">
					<li><a href="index.php?action=signalements&amp;mode=absence">Signalements d'absences</a></li>
					<li><a href="index.php?action=signalements&amp;mode=sortie">Autorisations de sortie</a></li>
				</ul>
			</li>
			{/if}
			
			{if $userStatus == 'admin'}
			<li class="dropdown"><a classe="dropdown-toggle" data-toggle="dropdown" href="#">Admin<b class="caret"></b></a>
				<ul class="dropdown-menu">
					<li><a href="index.php?action=admin&amp;mode=heures">Liste des périodes de cours</a></li>
				</ul>
			</li>
			{/if}
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

</div>
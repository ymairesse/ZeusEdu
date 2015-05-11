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
			<li><a href="index.php"><button type="button" class="btn btn-primary">Manuel <img src="images/manuelIco.png" alt="P"></button></a></li>
			<li class="dropdown"><a class="dropdown-toggle" data-toggle="dropdown" href="javascript:void(0)">Informations générales</a>
				<ul class="dropdown-menu">
					<li><a href="index.php?page=info">Infos</a></li>
					<li><a href="index.php?page=info&amp;cible=ip">Adresse IP</a></li>
					<li><a href="index.php?page=info&amp;cible=licence">Licence du logiciel</a></li>
				</ul>
			</li>
			<li class="dropdown"><a class="drop-down-toggle" data-toggle="dropdown" href="javascript:void(0)">Profil</a>
				<ul class="dropdown-menu">
					<li><a href="index.php?page=profil">Infos</a></li>
					<li><a href="index.php?page=profil&amp;cible=modifierprofilperso">Modifier son profil</a></li>
					<li><a href="index.php?page=profil&amp;cible=listeconnexions">La liste des connexions</a></li>
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
		
	</div>
	
	</nav>

</div> <!-- container -->

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
			<li><a href="index.php"><button class="btn btn-primary">Trombi Élèves <img src="images/trombi.png" alt="T" title="Trombinoscope des élèves" data-placement="bottom"></button></a></li>
			{if $lesCours != Null}
			<li class="dropdown">
				<a href="javascript:void(0)"
					id="parCours"
					class="dropdown-toggle"
					data-toggle="dropdown">
					Par Cours<b class="caret"></b>
				</a>
				<ul class="dropdown-menu">
					{foreach from=$lesCours key=option item=unCours}
						<li >
							<a href="index.php?action=parCours&amp;cours={$option}">
							{$unCours.statut} {$unCours.libelle} {$unCours.annee}e {$unCours.nbheures}h ({$unCours.coursGrp})
							{if $unCours.nomCours != ''}<strong>{$unCours.nomCours}</strong>{/if}
							</a>
						</li>
					{/foreach}
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

</div>  <!-- container -->

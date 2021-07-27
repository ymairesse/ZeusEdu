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
			<li><a href="index.php"><button class="btn btn-primary">EDT <img src="images/edtIco.png" alt="Agenda" title="Page d'accueil de EDT"></button></a>
			</li>
			{if in_array($userStatus, array('admin','educ','direction'))}
			<li class="dropdown"><a href="javascript:void(0)" class="dropdown-toggle" data-toggle="dropdown">
				Absences <b class="caret"></b></a>
				<ul class="dropdown-menu">
					<li><a href="index.php?action=absencesProfs">Gestion des absences</a></li>
				</ul>
			</li>
			{/if}
			{if $userStatus == 'admin'}
			<li class="dropdown"><a href="javascript:void(0)" class="dropdown-toggle" data-toggle="dropdown">
				Gestion <b class="caret"></b></a>
				<ul class="dropdown-menu">
					<li><a href="index.php?action=compilation">Compilation élèves et professeurs</a></li>
					<li><a href="index.php?action=sendICal">Importation iCal</a></li>
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

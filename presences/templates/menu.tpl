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
			<li><a href="index.php"><button type="button" class="btn btn-primary">Présences <img src="images/presencesIco.png" alt="P"></button></a></li>

			{if ($userStatus == 'educ') || ($userStatus == 'admin')}
			<li class="dropdown"><a class="dropdown-toggle" data-toggle="dropdown" href="#">Educs<b class="caret"></b></a>
				<ul class="dropdown-menu">
					<li><a href="index.php?action=presences&amp;mode=cours">Présences par cours</a></li>
					<li><a href="index.php?action=presences&amp;mode=classe">Présences par classe</a></li>
				</ul>
			</li>
			{/if}

			{if ($userStatus == 'educ') || ($userStatus == 'admin') || ($userStatus == 'coordinateur')}
			<li class="dropdown"><a class="dropdown-toggle" data-toggle="dropdown" href="#">Retards<b class="caret"></b></a>
				<ul class="dropdown-menu">
					<li><a href="index.php?action=retard&amp;mode=scan">Scan des retards</a></li>
					<li role="separator" class="divider"></li>
					<li><a href="index.php?action=retard&amp;mode=traitement">Traitement des retards</a></li>
					<li><a href="index.php?action=retard&amp;mode=synthese">Synthèse des retards</a></li>
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
					<li><a href="index.php?action=signaler&amp;mode=normal">Signalements d'absences</a></li>
					<li><a href="index.php?action=signaler&amp;mode=speed"><i class="fa fa-bolt"></i> Signalements rapides</a></li>
				</ul>
			</li>
			{/if}

			{if ($userStatus == 'admin') || ($userStatus == 'direction')}
			<li class="dropdown"><a class="dropdown-toggle" data-toggle="dropdown" href="#">Admin<b class="caret"></b></a>
				<ul class="dropdown-menu">
					{if $userStatus == 'admin'}
						<li><a href="index.php?action=admin&amp;mode=heures">Liste des périodes de cours</a></li>
						<li><a href="index.php?action=admin&amp;mode=justifications">Liste des motifs d'absences</a></li>
						<li role="separator" class="divider"></li>
						<li><a href="index.php?action=admin&amp;mode=nettoyer">Nettoyer les archives</a></li>
					{/if}
					<li><a href="index.php?action=admin&amp;mode=assiduite">Assiduité à la prise de présence</a></li>
				</ul>
			</li>
			{/if}
			<li class="dropdown"><a class="dropdown-toggle" data-toggle="dropdown" href="#">Préférences <b class="caret"></b></a>
				<ul class="dropdown-menu">
					<li><a href="javascript:void(0)" id="vis">Photos actuellement <span>{if $photosVis == 'visible'}invisibles{else}visibles{/if}</span></a></li>
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

</div>

<script type="text/javascript">

	$(document).ready(function(){
		$('#vis').click(function(){
			var visible = Cookies.get('photosVis');
			if (visible == 'visible') {
				Cookies.set('photosVis', 'invisible', { expires: 30 });
				var texte = 'invisibles';
			}
				else {
				Cookies.set('photosVis', 'visible', { expires: 30 });
				var texte = 'visibles';
			}
			$('#vis span').text(texte);
			bootbox.alert({
				title: 'Photos visibles / invisibles',
				message: 'Les photos seront ' + texte + ' au prochain chargement.'
			})
		})
	})

</script>

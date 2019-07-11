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
			{if isset($listeCoursGrp) && ($listeCoursGrp != Null)}
				<li><a href="index.php?action=presences&amp;mode=tituCours">Profs</a></li>
			{/if}
		</ul>

	</div>  <!-- collapse -->

</nav>

</div>

<div id="top"></div>
<div class="container-fluid hidden-print">

	<nav class="navbar navbar-default" role="navigation">

	<div class="navbar-header">
		<button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#barreNavigation">
			<span class="sr-only">Navigation portable</span>
			<span class="icon-bar"></span>
			<span class="icon-bar"></span>
			<span class="icon-bar"></span>
		</button>

		<a class="navbar-brand" href="../index.php"><button type="button" class="btn btn-primary btn-sm"><span class="glyphicon glyphicon-home"></span></button></a>

	</div>

	<div class="collapse navbar-collapse" id="barreNavigation">

	<ul class="nav navbar-nav">

		<li><a href="index.php"><button class="btn btn-primary btn-sm">Hercule <img src="images/hercule.png" alt="bullISND" title="Page d'accueil de Hercule"></button></a>
		</li>

	</ul>

	<ul class="nav navbar-nav pull-right">
		{if isset($alias)}
		<li><a href="../aliasOut.php"><img src="../images/alias.png" alt="Alias">{$alias}</a></li>
		{/if}
		<li class="dropdown"><a class="dropdown-toggle" data-toggle="dropdown" href="javascript:void(0)">{$identite.prenom} {$identite.nom}
		{if $titulaire}[{','|implode:$titulaire}]{/if}<b class="caret"></b></a>
			<ul class="dropdown-menu">
				<li><a href="../profil/index.php"><span class="glyphicon glyphicon-user"></span> Modifiez votre profil</a></li>
				<li><a href="../logout.php"><span class="glyphicon glyphicon-off"></span> Déconnexion</a></li>
			</ul>
		</li>
	</ul>

	</div>  <!-- collapse -->

	</nav>

</div> <!-- container -->

<script type="text/javascript">

 // listen for scroll
var positionElementInPage = $('#top').offset().top;

$(window).scroll(
	function() {
		if ($(window).scrollTop() >= positionElementInPage) {
			// fixed
			$('#menuBas').addClass("floatable");
		} else {
			// relative
			$('#menuBas').removeClass("floatable");
		}
	}
);

</script>

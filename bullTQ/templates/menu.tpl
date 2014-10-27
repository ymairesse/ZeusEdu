<ul id="menuBas">
	<li class="titreMenu">Bulletin TQ</li>
    <li><a href="../index.php"><img src="../images/homeIco.png" title="Retour" alt="-"></a></li>
    <li><a href="index.php"><img src="images/bullTQIco.png" title="Accueil" alt="TQ"></a></li>
	<li><a href="javascript:void(0)">Impression</a>
		<ul>
			<li><a href="index.php?action=print&amp;mode=indivEcran">Bulletin individuel à l'écran</a></li>
			<li><a href="index.php?action=print&amp;mode=indivPDF">Bulletin individuel PDF</a></li>
			<li><a href="index.php?action=print&amp;mode=classePDF">Bulletin par classe PDF</a></li> 
		</ul>
	</li>
	<li><a href="javascript:void(0)">Bulletin</a>
		<ul>
			<li><a href="index.php?action=bulletin">Encodage des bulletins</a></li>
		</ul>	
	</li>

	{if ($tituTQ)}
	<li><a href="javascript:void(0)">Titulaire {','|implode:$tituTQ}</a>
		<ul>
			<li><a href="index.php?action=titu&amp;mode=remarques">Remarques aux bulletins</a></li>
		</ul>
	</li>
	{/if}
	<li><a href="javascript:void(0)">Délibés</a>
		<ul>
			<li><a href="index.php?action=delibe&amp;mode=parClasse">Feuille de synthèse par classe</a></li>
			<li><a href="index.php?action=delibe&amp;mode=individuel">Feuille de délibé individuelle</a></li>
		</ul>
	</li>
	{if $userStatus == 'admin'}
	<li><a href="javascript:void(0)">Admin</a>
		<ul>
			<li><a href="index.php?action=admin&amp;mode=imagesCours">Initialiser images des noms des cours</a></li>
			<li><a href="index.php?action=admin&amp;mode=typologie">Typologie des cours</a></li>
			<li><a href="index.php?action=admin&amp;mode=competences">Gestion des compétences</a></li>
			<li><a href="index.php?action=admin&amp;mode=initialiser">Initialiser les bulletins</a></li>
			<li><a href="index.php?action=admin&amp;mode=titulaires">Titulariats</a></li>
		</ul>
	</li>
	{/if}

</ul>

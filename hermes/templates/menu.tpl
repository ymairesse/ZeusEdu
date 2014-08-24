<ul id="menuBas">
	<li class="titreMenu">Hermes</li>
    <li><a href="../index.php"><img src="../images/homeIco.png" title="Retour" alt="home"></a></li>
    <li><a href="index.php"><img src="../images/hermesIco.png" title="Page d'accueil de Hermes" alt="hermesIco"></a></li>
    <li><a href="index.php">Envoyer un mail</a></li>
	<li><a href="javascript:void(0)">Gestion</a>
		<ul>
			<li><a href="index.php?action=archives">Consulter mes archives</a></li>
			<li><a href="index.php?action=gestion">Gérer les listes de destinataires</a></li>
		</ul>
	</li>
	{if $userStatus == 'admin'}
	<li><a href="javascript:void(0)">Préférences</a>
		<ul>
			<li><a href="index.php?action=preferences&amp;mode=signature">Editeur de signature</a></li>
		</ul>
	</li>
	{/if}

</ul>

<script type="text/javascript">
{literal}
$(document).ready(function(){
	$("#menuBas li ul a").click(function(){
		$("#wait").show();
		})
})
{/literal}
</script>

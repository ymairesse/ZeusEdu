<ul id="menuBas">
	<li class="titreMenu">Administration</li>
    <li><a href="../index.php"><img src="../images/homeIco.png" title="Retour" alt="home"></a></li>
    <li><a href="index.php"><img src="../images/hermesIco.png" title="Page d'accueil de Hermes" alt="hermesIco"></a></li>
    <li><a href="javascript:void(0)">Envoyer un mail</a>
        <ul>
			<li><a href="index.php?action=mail">Envoyer un mail</a></li>
        </ul>
	</li>
	<li><a href="javascript:void(0)">Archives</a>
		<ul>
			<li><a href="index.php?action=archives">Consulter les archives</a></li>
		</ul>
	</li>


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

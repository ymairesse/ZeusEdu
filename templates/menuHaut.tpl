<ul id="menuHaut" class="menu" style="float:right">
    {if isset($alias)}<li><a href="../aliasOut.php"><img src="../images/alias.png" alt="alias">{$alias}</a></li>{/if}
    <li id="perso"><a href="../profil/index.php" title="Modifiez votre profil">
		<strong>{$identite.prenom} {$identite.nom}
		{if $titulaire}[{','|implode:$titulaire}]{/if}
		</strong></a></li>
    <li id="deconnexion"><a href="../logout.php"><img src="../images/logout.png" title="Déconnexion" alt="X"></a></li>
</ul>



<script type="text/javascript">

	$(document).ready(function(){
		
		$("#menuHaut").click(function(e){
			$("#widgetMenu").toggle();
			})
		
		})

</script>

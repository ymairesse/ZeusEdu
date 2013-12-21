<script type="text/javascript">
{literal}
$(document).ready(function(){
	$(".titulaire").click(function(){
		$("#choixTitu").submit();
	})
	
	$("#choixTitu").submit(function(){
		$("#wait").show();
		})
})
{/literal}
</script>
<h2 class="attention">
	<span class="icon">helpIco</span>
	<span class="title">Choix à effectuer</span>
	<span class="texte">Cette classe compte plusieurs titulaires</span>
</h2>
<form name="choixTitu" id="choixTitu" action="index.php" method="POST">
<h4>Choix du titulaire de {$groupe}</h4>
{foreach from=$listeTitus key=acronyme item=unTitu}
<input type="radio" name="acronyme[]" value="{$acronyme}" class="titulaire">{$unTitu} <br />
{/foreach}
<input type="submit" value="OK" name="OK" id="envoi">
<input type="hidden" name="action" value="titulaire">
<input type="hidden" name="mode" value="tituDeListe">
<input type="hidden" name="groupe" value="{$groupe}">
</form>

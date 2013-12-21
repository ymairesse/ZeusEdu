<h2 style="clear:both">Verrouillage des bulletins n° {$bulletin}</h2>
<form name="formulaire" id="formulaire" method="POST" action="index.php">
<input type="hidden" name="action" value="admin">
<input type="hidden" name="mode" value="poserVerrous">
<input type="hidden" name="etape" value="enregistrer">
<input type="hidden" name="bulletin" value="{$bulletin}">
<div style="float:left; padding: 1em; border:1px solid grey; width: 80%; display: inline-block"  id="niveaux">
	<h3>Choix des classes</h3>
	{foreach from=$listeClasses key=degre item=niveauxDegre}
	<div style="width:32%;display:inline-block;">
	<h4>Degré {$degre}</h4>
	<ul>
	{foreach from=$niveauxDegre key=niveaux item=classes}
		<li><span class="collapsible">Classes de {$niveaux}e</span>
			<input type="radio" value="{$niveaux}" name="radioNiveau" class="niveau">
		<ul>
			{foreach from=$classes item=uneClasse}
				<li>{$uneClasse}
				<input type="checkbox" name="classe_{$uneClasse}" value="1" class="classe">
				</li>
			{/foreach}
		</ul>
		</li>
	{/foreach}
	</ul>
	</div>
{/foreach}
	<input type="reset" name="annuler" value="Annuler" id="reset" style="clear:both">
</div>
<div style="float:left; margin-left:1em; padding: 1em; border:1px solid grey">
	<h3>Action</h3>
Déverrouiller: <input type="radio" name="verrou" value="0" {if $verrou == 0}checked="checked"{/if}><br>
Verrouiller: <input type="radio" name="verrou" value="1" {if $verrou == 1}checked="checked"{/if}><br>
<input type="submit" name="submit" value="Enregistrer">
</div>
</form>
</div>
<script type="text/javascript">
{literal}
$(document).ready(function(){

	$(".niveau").click(function(){
		$(".niveau").nextAll("ul").find("li input").attr("checked", false)
		var coche = $(this).attr("checked");
		coche = (coche == "checked")?true:false;
		$(this).nextAll("ul").find("li input").attr("checked", coche)
		})
		
	$(".classe").click(function(){
		$("#niveaux").find("input:checkbox").not($(this).parent().parent().find("input:checkbox")).attr("checked", false);
		$(".niveau").siblings().next().filter("input").attr("checked", false);
		$(this).parent().parent().parent().find("input:radio").attr("checked", true);
		})
	
	$(".collapsible").click(function(){
		$(this).parent().children().filter("ul").toggle("slow")
		})

	$(".collapsible").parent().children().filter("ul").hide();
	
	$("#reset").click(function(){
		$(".classe").attr("checked", false);
		})

	$("#formulaire").submit(function(){
		$.blockUI();
		$("#wait").show();
		})
})	
{/literal}
</script>

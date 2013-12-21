<h2>Fiches disciplinaires pour le bulletin {$bulletin}</h2>
<form name="formulaire" method="POST" action="index.php">
<input type="hidden" name="action" value="{$action}">
<input type="hidden" name="mode" value="{$mode}">
<input type="hidden" name="etape" value="enregistrer">
<input type="hidden" name="date_0" value="{$dates[0]}">
<input type="hidden" name="date_1" value="{$dates[1]}">
<input type="hidden" name="bulletin" value="{$bulletin}">
<table style="clear:both">
{foreach from=$selection key=codeInfo item=unEleve}
{if ($selection.$codeInfo.disc != Null) || ($selection.$codeInfo.fiche != Null) }
<tr>
	<td colspan="4" class="nomEleve" title="{$codeInfo}" style="border-top:1px solid black">
		<h3>{$classe} : {$unEleve.nom}</h3>
	</td>
	<td width="130px" style="border-top:1px solid black" title="Fiche pour {$unEleve.nom}" >
		<img src="../photos/{$codeInfo}.jpg" width="80px" alt="{$codeInfo}" class="photo" 
			style="position: relative; cursor:pointer; top:2em">
		<input type="checkbox"  value="1" 
			{if $unEleve.fiche ==1}checked="checked"{/if} name="fiche_{$codeInfo}">
	</td>
</tr>
	{foreach from=$unEleve.disc item=unFait}
	<tr>
		<td width="15%">{$unFait.ladate}</td>
		<td width="15%">{$unFait.titreFait}</td>
		<td width="5%">{$unFait.professeur}</td>
		<td>{$unFait.motif}</td>
	</tr>
	{/foreach}
{/if}
{/foreach}
</table>
<div style="padding:2em; border:1px solid black">
	<input type="submit" value="Enregistrer" name="submit2" style="float:right">
</div>
</form>

<script type="text/javascript">
{literal}
$(document).ready(function(){

	$(".photo").click(function(){
		var valeur = $(this).siblings("input").attr("checked");
		valeur = !(valeur);
		$(this).siblings("input").attr("checked", valeur);
		if (valeur)
			$(this).css("border","2px solid red");
			else $(this).css("border","");
	})
})
{/literal}
</script>

<div id="selecteur" class="noprint" style="clear:both">
	<form name="formulaire" method="POST" action="index.php">
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	<input type="hidden" name="etape" value="{$etape}">
	<p>Classe: 
		<select name="classe" id="selectClasse">
			<option value="">Classe</option>
			{foreach from=$listeClasses key=uneClasse item=wtf}
			<option value="{$uneClasse}"{if $uneClasse == $classe} selected{/if}>{$uneClasse}</option>
			{/foreach}
		</select>
	Date de début de période <input type="text" name="date_0" size="12" value="{$dates[0]}" id="dateDebut" class="date">
	Date de fin de période <input type="text" name="date_1" size="12" value="{$dates[1]}" id="dateFin" class="date">
	<input style="clear:both" type="submit" name="submit" value="OK"></p>
	</form>
</div>

<script type="text/javascript">

$(document).ready(function(){
	
	$(".check").click(function(){
		var checked = $(this).attr("checked");
		$(this).parent().children().children().filter("li").children().filter("input").attr("checked",checked)	
	})
	
	$("#dateDebut, #dateFin").datepicker({ 
		dateFormat: "dd/mm/yy",
		prevText: "Avant",
		nextText: "Après",
		monthNames: ["Janvier","Février","Mars","Avril","Mai","Juin","Juillet","Août","Septembre","Octobre","Novembre","Décembre"],
		dayNamesMin: ["Di", "Lu", "Ma", "Me", "Je", "Ve", "Sa"],
		firstDay: 1	'
		});
})	

</script>

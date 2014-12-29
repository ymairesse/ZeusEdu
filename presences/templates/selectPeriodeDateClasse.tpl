<div id="selecteur" class="noprint" style="clear:both">

	<form name="selecteur" id="formSelecteur" method="POST" action="index.php">
		
	Période <span class="micro" title="{if !$freePeriode}Période actuelle{else}période {$periode}{/if}">[{$periode}]</span>
	<input type="checkbox" value="1" id="freePeriode" name="freePeriode"{if $freePeriode} checked="checked"{/if}>	
		
	<select name="periode" id="selectPeriode"{if !($freePeriode)} style="display:none"{/if}>
		<option value=''>Période</option>
		{foreach from=$listePeriodes key=laPeriode item=data}
		<option value="{$laPeriode}"{if $laPeriode==$periode} selected="selected"{/if}>[{$laPeriode}] : {$data.debut}-{$data.fin}</option>
		{/foreach}
	</select>

	{if $userStatus == 'admin'}
	<span>
		<span title="{if $freeDate}{$date} {else}Aujourd'hui{/if}">Date</span>
		<input type="checkbox" value="1" id="freeDate" name="freeDate"{if $freeDate} checked="checked"{/if}>
	</span>
	<input type="text" name="date" id="date" class="datepicker" maxlength="10" size="10" value="{$date}"{if !($freeDate)} style="display:none"{/if}>
	{/if}

		<select name="classe" id="selectClasse">
		<option value="">Classe</option>
		{foreach from=$listeClasses item=uneClasse}
			<option value="{$uneClasse}"{if (isset($classe)) && ($uneClasse == $classe)} selected="selected"{/if}>{$uneClasse}</option>
		{/foreach}
		</select>
		
	<input type="submit" value="OK" name="OK" id="envoi">
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	<input type="hidden" name="etape" value="showClasse">
	<input type="hidden" name="onglet" class="onglet" value="{$onglet|default:0}">
	</form>
</div>

<script type="text/javascript">

var freePeriode = false;
var freeDate = false;

$(document).ready (function() {

	$("#formSelecteur").submit(function(){
		if ($("#selectClasse").val() != '') {
			$("#wait").show();
			$.blockUI();
			}
			else return false;
	})
	
	$("#selectClasse").change(function(){
		if ($(this).val() != '')
			$("#formSelecteur").submit();
		})

	// $("#dialog").dialog();
	
	$(".datepicker").datepicker({
		dateFormat: "dd/mm/yy",
		prevText: "Avant",
		nextText: "Après",
		monthNames: ["Janvier","Février","Mars","Avril","Mai","Juin","Juillet","Août","Septembre","Octobre","Novembre","Décembre"],
		dayNamesMin: ["Di", "Lu", "Ma", "Me", "Je", "Ve", "Sa"],
		firstDay: 1
		});
	
	$("#freePeriode").click(function(){
		freePeriode = !(freePeriode);
		if (freePeriode)
		$("#selectPeriode").show()
		else $("#selectPeriode").hide();
		}) 
	
	$("#freeDate").click(function(){
		freeDate = !(freeDate);
		if (freeDate) 
			$("#date").show()
			else $("#date").hide();
		})
	
	
	// si la période choisie change
	$("#selectPeriode").change(function(){
		$("#formSelecteur").submit();
		})
		
	})

</script>


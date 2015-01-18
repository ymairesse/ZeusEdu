<div class="noprint" class="noprint" style="clear:both">
	
	<form name="selecteur" id="formSelecteur" method="POST" action="index.php">
		
		Période <span class="micro" title="{if !$freePeriode}Période actuelle{else}période {$periode}{/if}">[{$periode}]</span>
		<input type="checkbox" value="1" id="freePeriode" name="freePeriode"{if $freePeriode} checked="checked"{/if}>
		<select name="periode" id="selectPeriode"{if !($freePeriode)} style="display:none"{/if}>
			<option value=''>Période</option>
			{foreach from=$listePeriodes key=laPeriode item=data}
			<option value="{$laPeriode}"{if $laPeriode==$periode} selected="selected"{/if}>[{$laPeriode}] : {$data.debut}-{$data.fin}</option>
			{/foreach}
		</select>
		
		<input type="hidden" value="{$coursGrp}" name="coursGrp">
		<input type="submit" value="OK" name="OK" id="envoi">
		<input type="hidden" name="action" value="{$action}">
		<input type="hidden" name="mode" value="{$mode}">
	</form>

{if (empty($listePeriodes))}
<div id="dialog" title="Avertissement">
	<p>Attention! Les périodes de cours ne sont pas encore définies. Contactez l'administrateur</p>
</div>
{/if}
	
	
</div>

<script type="text/javascript">
{literal}

	var freePeriode = false;
	var freeDate = false;

	$(document).ready (function() {

		$("#dialog").dialog();
		
		// ajustement de la liste des cours en fonction du prof sélectionné
		$("#selectProf").change(function(){
			var acronyme = $(this).val();
			if (acronyme != '')
				$.post("inc/listeCoursProf.inc.php",
				{'acronyme': acronyme},
					function (resultat){
						$("#selectCoursGrp").html(resultat)
					}
				)
			})

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
		
		// si le cours change
		// on emploie "on" puisque la liste est générée à chaque changement de prof
		$("#selectCoursGrp").on("change","#coursGrp", function(){
			$("#formSelecteur").submit();
			})
		
		// si la période choisie change
		$("#selectPeriode").change(function(){
			$("#formSelecteur").submit();
			})
		
		// on vérifie que le formulaire peut être soumis si toutes les informations sont présentes
		$("#formSelecteur").submit(function(){
			if (($("#selectProf").val() == '') || ($("#coursGrp").val() == '') || $("#selectPeriode").val() == '') {
				return false;
				}
				else {
					//$.blockUI();	// apparemment, souci sous Safari/iPad
					// $("#wait").show();
					}
			})
		
	})
{/literal}
</script>

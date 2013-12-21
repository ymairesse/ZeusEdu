<div id="selecteur" class="noprint" style="clear:both">
	<form name="selecteur" id="formSelecteur" method="POST" action="index.php">
		<select name="type" id="selectType">
		<option value="">Type de retenue</option>
		{foreach from=$listeTypes key=ceType item=unType}
			<option value="{$ceType}"{if isset($type) && ($type == $ceType)} selected="selected"{/if}>{$unType.titreFait}</option>
		{/foreach}
		</select>

		<span id="choixDateRetenue">

		{include file="listeRetenues.tpl"}
<!--			<select name="retenue" id="selectRetenue">
				<option value="">Choisir une retenue</option>
				{if isset($listeRetenues)}
					{foreach from=$listeRetenues key=idretenue item=uneRetenue}
					<option value="{$idretenue}"{if (isset($retenue)) && ($retenue == $idretenue)} selected="selected"{/if}>
						{$uneRetenue.jourSemaine} le {$uneRetenue.dateRetenue} {$uneRetenue.heure} {$uneRetenue.duree}h [{$uneRetenue.local}] ({$uneRetenue.occupation}/{$uneRetenue.places})</option>
					{/foreach}
				{/if}
			</select>-->
		</span>
		
	<input type="submit" value="OK" name="OK" id="envoi" {if (!isset($listeRetenues))}style="display:none"{/if}>
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	{if isset($etape)}<input type="hidden" name="etape" value="{$etape}">{/if}
	</form>
</div>

<script type="text/javascript">
{literal}
$(document).ready (function() {

	$("#formSelecteur").submit(function(){
		if ($("#selectType").val() != '') {
			$("#wait").show();
			$.blockUI();
			}
			else return false;
	})
	

	$("#selectType").change(function(){
		// on a choisi une classe dans la liste déroulante
		var type = $(this).val();

		if (type != '') $("#envoi").show();
		// la fonction listeRetenues.inc.php renvoie la liste déroulante
		// des retenues du type sélectionné
		$.post("inc/listeRetenues.inc.php",
			{'type': type},
				function (resultat){
					$("#choixDateRetenue").html(resultat)
				}
			)
	});

	$("#choixDateRetenue").on("change", "#selectRetenue", function(){
		if ($(this).val() != '') {
			$("#formSelecteur").submit();
		}
		
		
		})
	
/*	$("#selectEleve").live("change", function(){
		if ($(this).val() > 0) {
			// si la liste de sélection des élèves renvoie une valeur significative
			// le formulaire est soumis
			$("#formSelecteur").submit();
			$("#envoi").show();
		}
			else $("#envoi").hide();
		}) */
		

})
{/literal}
</script>
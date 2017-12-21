<div class="container">

<h3>Liste des verrous à modifier en période {$bulletin} au niveau {$niveau}</h3>

<form name="formVerrouiller" id="formVerrouiller" action="index.php" method="POST" class="form-vertical">
{if $listeVerrous|@count == 0}
	Rien à modifier
	{else}
	<div style="width:40%; float:right" class="inv" id="notice">Attention! Cette fonctionnalité peut demander plusieurs passages si le nombre de verrous à modifier est trop grand</div>

	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	<input type="hidden" name="etape" value="enregistrer">
	<input type="hidden" name="niveau" value="{$niveau}">
	<input type="hidden" name="bulletin" value="{$bulletin}">
	<input type="hidden" name="verrouiller" value="{$verrouiller}">
	<button type="submit" class="btn btn-primary" name="submit" id="submit">Enregistrer</button>
	{foreach from=$listeVerrous key=niveau item=verrousClasse}
		<ul>
			<li>
				<span class="collapisble">Tout le niveau {$niveau}:</span> {if $verrouiller >= 1}Verrouiller{else}Déverrouiller{/if}
				<input class="check" type="checkbox" name="niveau%{$niveau}" value="{$verrouiller}">
				{foreach from=$verrousClasse key=classe item=listeCours}
					<ul>
						<li><span class="collapsible">{$classe}</span> {if $verrouiller >= 1}Verrouiller{else}Déverrouiller{/if}
							<input class="check" type="checkbox" name="classe%{$classe}" value="{$verrouiller}">
							<ul>
							{foreach from=$listeCours key=coursGrp item=listeEleves}
								<li><span class="collapsible">{$coursGrp}</span>{if isset($listeProfs.$coursGrp)} [{$listeProfs.$coursGrp|@implode:', '}]{/if} {if $verrouiller == 1}Verrouiller{else}Déverrouiller{/if}
									<input class="check" type="checkbox" name="coursGrp_{$coursGrp|replace:' ':'#'}" value="{$verrouiller}">
									<ul>
										{foreach from=$listeEleves key=matricule item=eleve}
										<li title="{$matricule}">{$eleve} {if $verrouiller == 1}Verrouiller{else}Déverrouiller{/if}
											<input type="checkbox" name="eleve%{$matricule}_coursGrp%{$coursGrp|replace:' ':'#'}" value="{$verrouiller}">
										{/foreach}
									</ul>
								</li>
							{/foreach}
							</ul>
						</li>
					</ul>
				{/foreach}
			</li>
		</ul>
	{/foreach}
{/if}
</form>

</div>  <!-- container -->

<script type="text/javascript">

$(document).ready(function(){
	$(".collapsible").click(function(){
		$(this).parent().children().filter("ul").toggle("slow")
		})

	$(".collapsible").parent().children().filter("ul").hide();

	$(".check").click(function(){
		var checked = $(this).prop("checked");
		if (checked)
			$(this).siblings().find("input:checkbox").prop("checked", true);
			else $(this).siblings().find("input:checkbox").prop("checked", false);
		})

	$("#formVerrouiller").submit(function(){
		$("#wait").show();
		$.blockUI();
		})
	})

</script>

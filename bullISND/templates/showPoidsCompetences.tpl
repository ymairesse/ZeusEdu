<h2>Poids des compétences par période {$coursGrp}</h2>
<form name="poidsCompetences" method="POST" action="index.php" id="formPoids">

<table class="tableauAdmin">
	<tr>
	<th>&nbsp;</th>
	{section name=boucleBulletin start=1 loop=$nbBulletins+1}
		<th colspan="2">Pér. {$smarty.section.boucleBulletin.index}</th>
	{/section}
	</tr>
	<tr>
	<th>Compétences</th>
	{section name=boucleBulletin start=1 loop=$nbBulletins+1}
		<th>Form</th><th>Cert</th>
	{/section}
	</tr>
	{assign var=tabIndex value=1}
	{assign var=nbComp value=$listeCompetences|@count}
	{assign var=noCompetence value=1}
	{foreach from=$listeCompetences key=idComp item=competence}
		{assign var=noCompetence value=$noCompetence}
		<tr>
			<td>{$competence.libelle|truncate:25}</td>
			{section name=boucleBulletin start=1 loop=$nbBulletins+1}
				{assign var=nbull value=$smarty.section.boucleBulletin.index}
				<td class="cote">
					<input type="text" size="4" maxlength="4" name="comp_{$idComp}-bull_{$nbull}-form" 
						value="{$tableauPoids.$nbull.$idComp.form|default:''}" tabIndex="{$tabIndex}" 
						class="poids"
						{if $ponderations.all.$nbull.form == ''}readonly="readonly"{/if}>
				</td>
				<td class="cote">
					<input type="text" size="4" name="comp_{$idComp}-bull_{$nbull}-cert" 
					value="{$tableauPoids.$nbull.$idComp.cert|default:''}" tabIndex="{$tabIndex+$nbComp}" 
					class="poids"
					{if $ponderations.all.$nbull.cert == ''}readonly="readonly"{/if}>
				</td>
				{assign var=tabIndex value=$tabIndex+2*$nbComp}
			{/section}
			{assign var=noCompetence value=$noCompetence+1}
		</tr>
		{assign var=tabIndex value=$noCompetence}
	{/foreach}
</table>

<input type="submit" name="Enregistrer" value="Enregistrer" id="submit">
<input type="reset" name="reset" value="Annuler" id="reset">
<input type="hidden" name="coursGrp" value="{$coursGrp}">
<input type="hidden" name="action" value="{$action}">
<input type="hidden" name="mode" value="{$mode}">
<input type="hidden" name="etape" value="{$etape}">
</form>
{include  file="noticePoidsCompetences.html"}

<script type="text/javascript">
{literal}

	var noPonderation = "Aucune pondération n'est prévue pour cette période";
	var confirmationReset = "Êtes-vous sûr(e) de vouloir annuler?\nToutes les informations modifiées depuis le dernier enregistrement seront perdues.\nCliquez sur 'OK' si vous êtes sûr(e).";	
	var confirmationBeforeUnload = "Vous allez perdre toutes les modifications. Annulez pour rester sur la page.";
	var modifie = false;

	function is_numeric(input){
		return !isNaN(input);
	  }
	function trim(input) {
		return str.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
		}

	$(document).ready(function(){
		$("#formPoids").submit(function(){
			var toutNumerique = true;
			$(".poids").each(function(){
				var unPoids = $(this).val().replace(',','.');
				if (!(is_numeric(unPoids))) {
					$(this).parent().addClass("erreurEncodage");
					toutNumerique = false;
					}
					else $(this).parent().removeClass("erreurEncodage");
				})
			if (!(toutNumerique)) {
				alert("Attention, toutes les cotes doivent être numériques.\nVeuillez corriger.");
				return false;
				}	
			})

		$("#formPoids input:text").each(function(){
			if ($(this).attr("readonly") == "readonly")
				$(this).attr("title", noPonderation);
			})
		
		})

		$(".poids").keyup(function(){
			modifie = true;
			window.onbeforeunload = function(){
				if (confirm (confirmationBeforeUnload))
					return true;
					else {
						$("#wait").hide();
						return false;
						}
				};			
			})

		$("#submit").click(function(){
			modifie = false;
			window.onbeforeunload = function(){};
			})
			
		$("#reset").click(function(){
			if (modifie && confirm(confirmationReset)) {
				$('.carnetCotes input').attr('disabled', true).hide().next("span").show();
				$('.verrou').fadeIn();
				modifie = false;
				window.onbeforeunload = function(){};
				}
			})

{/literal}
</script>

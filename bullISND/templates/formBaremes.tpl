<h2>Voir et modfier les pondérations</h2>
Bulletin en cours: {$bulletin}
<h3 title="{$intituleCours.coursGrp}">
	{$intituleCours.annee} : {$intituleCours.statut}
	{if $intituleCours.nomCours}  {$intituleCours.nomCours} 
	{else} {$intituleCours.libelle} 
	{/if}
	{$intituleCours.nbheures}h ({$listeClasses}) </h3>
	{if $matricule != 'all'}<strong>{$nomEleve.nom} {$nomEleve.prenom} {$nomEleve.classe}</strong>
		{else}Pondération pour tous les élèves{/if}

	<form name="formPonderations" method="POST" action="index.php" id="formPonderations">
		<table class="tableauAdmin" style="width: 600px">
			<tr>
				<td style="width:7em">Période</td>
				<td>Formatif</td>
				<td>Certificatif</td>
			</tr>
			
		{section name=periodes start=1 loop=$nbPeriodes+1}
		{assign var=ponderation value=$ponderations.$coursGrp.$matricule}
		{assign var=n value=$smarty.section.periodes.index}
			<tr>
				<td>{$n}: <strong>{$periodes.{$n-1}}</strong></td>
				<td><input type="text" class="poids" value="{$ponderation.$n.form}"
						   {if (($bulletin > $n) && ($admin!='admin'))} readonly class="readonly"{/if}
						   name="formatif_{$n}" maxlength="3" size="3"></td>
				<td><input type="text" class="poids" value="{$ponderation.$n.cert}"
						   {if (($bulletin > $n) && ($admin!='admin'))} readonly class="readonly"{/if}
						   name="certif_{$n}" maxlength="3" size="3"></td>
			</tr>
		{/section}
		</table>
	<input type="hidden" name="coursGrp" value="{$coursGrp}">
	<input type="hidden" name="matricule" value="{$matricule}">
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	<input type="hidden" name="etape" value="{$etape}">
	<p><input type="submit" name="submit" value="Enregistrer" id="submit">
	<input type="reset" name="reset" value="Annuler">
	<a href="index.php?action=gestionBaremes&mode=voir&amp;coursGrp={$coursGrp}"><span class="fauxBouton">Retour sans enregistrer</span></a></p>
</form>
{include file="noticeBaremes.html"}
<script type="text/javascript" src="../js/jquery.validate.js"></script>
<script type="text/javascript">
{literal}

$(document).ready(function(){
	
	$("input").tabEnter();
	$(".poids").each(function(index, value){
		$(this).attr("tabIndex",index+1)
		})
	
	$("#formPonderations").validate();
	$(".poids").each(function(item){
            $(this).rules("add", {
                number: true,
                min: 0
                })
        })
	
	$(".readonly").html(" > Plus modifiable, bulletin distribué");
	
	$("#formPonderations").submit(function(){
		if ($("#formPonderations").valid()) {
			$.blockUI();
			$("#wait").show();
			}
			else alert("Veuillez corriger les données");
		})
	
	});
		
{/literal}
</script>

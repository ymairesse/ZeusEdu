<h2>Situations | classe: {$classe} | Période: {$bulletin}</h2>
<form name="formSituations" id="formSituations" method="POST" action="index.php">
<table class="tableauAdmin">
	
	<tr>
		<th>Nom de l'élève</th>
		
		<!-- titres des colonnes = noms des cours -->
		{foreach from=$listeCoursClasse key=cours item=detailsCours}
		<th class="tooltip">
			<span class="tip" style="display:none">{$detailsCours.dataCours.libelle}<br>
			{foreach from=$detailsCours.profs key=coursGrp item=data}
				{$data.nom} ({$data.acronyme}) => {$coursGrp} <br>
			{/foreach}
			</span>
			<img src="imagesCours/{$cours}.png" alt="{$cours}"><br>
			{$detailsCours.dataCours.nbheures}h {$detailsCours.dataCours.statut}
		</th>
		{/foreach}
	</tr>
	
	{assign var=tabIndex value=1}
	{foreach from=$listeEleves key=matricule item=detailsEleve}
	<tr class="eleve">
		<td class="tooltip">
			<div class="tip"><img src="../photos/{$detailsEleve.photo}.jpg" alt="{$matricule}" style="width:100px">
			<br><span class="micro">{$matricule}</span></div>
			{$detailsEleve.nom} {$detailsEleve.prenom}
		</td>
		
		<!-- pour chaque cours existant dans la classe, on recherche le coursGrp de l'élève et la cote de situation -->
		{foreach from=$listeCoursClasse key=cours item=detailsCours}
		
		<td class="inputSituations">
				{if isset($listeSituations.$matricule.$cours)}
					{assign var=dataCote value=$listeSituations.$matricule.$cours}
					{else}
					{assign var=dataCote value=Null}
				{/if}
				<!-- si l'élève suit ce cours -->
				{if isset($listeCoursEleves.$cours.$matricule)}
					{* suppression de l'espace dans le nom de champ et remplacement par un '!' -nécessaire pour D2 et D3 *}
					{assign var=coursGrp value=$listeCoursEleves.$cours.$matricule.coursGrp}
					{assign var=coursGrpProtect value=$coursGrp|replace:' ':'!'}
					<input type="text" size="1em" name="sit#eleve_{$matricule}#coursGrp_{$coursGrpProtect}"
					value="{$dataCote.sit|default:''}" tabIndex="{$tabIndex}" title="{$coursGrp}: {$listeCoursClasse.$cours.profs.$coursGrp.acronyme}">/
					<input type="text" size="1em" name="max#eleve_{$matricule}#coursGrp_{$coursGrpProtect}"
					value="{$dataCote.max|default:''}" tabIndex="{$tabIndex+1}" class="max">
					{assign var=tabIndex value=$tabIndex+2}
				{else}&nbsp;
				{/if}

		</td>
		{/foreach}
	</tr> 
	{/foreach}
</table>
<input type="hidden" name="bulletin" value="{$bulletin}">
<input type="hidden" name="classe" value="{$classe}">
<input type="hidden" name="action" value="{$action}">
<input type="hidden" name="mode" value="{$mode}">
<input type="hidden" name="etape" value="{$etape}">
<input type="submit" name="submit" id="submit" value="Enregistrer">
<input type="reset" name="reset" value="Annuler">
</form>

<script type="text/javascript">

	$(document).ready(function(){

		$("#formSituations").submit(function(){
			$.blockUI();
			$("#wait").show();
			})
		})
		
		$(".inputSituations input").click(function(){
			$(this).closest('tr').addClass("eleveSelectionne");
			})
		$(".inputSituations input").blur(function(){
			$(this).closest('tr').removeClass("eleveSelectionne");
			})
			
		$('tbody td, th').hover(function() {
			$(this).closest('tr').find('td,th').addClass('eleveActif');
			var col = $(this).index()+1;
			$(this).closest('table').find('tr :nth-child('+col+')').addClass('eleveActif');
			}, function() {
			$(this).closest('tr').find('td,th').removeClass('eleveActif');
			var col = $(this).index()+1;
			$(this).closest('table').find('tr :nth-child('+col+')').removeClass('eleveActif');
			}
			);

</script>

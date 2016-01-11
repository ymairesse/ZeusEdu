<div class="container">

<div class="row">
	<div class="col-md-9 col-sm-9">
		<h2>Situations | classe: {$classe} | Période: {$bulletin}</h2>
	</div>
	<div class="col-md-3 col-sm-3">
		<button type="button" class="btn btn-primary btn-lg pull-right" id="readOnlyMax">Figer les maxima</button>
	</div>
</div>  <!-- row -->

<form name="formSituations" id="formSituations" method="POST" action="index.php" role="form" class="form-vertical">
<table class="tableauAdmin table-hover table">

	<tr>
		<th>Nom de l'élève</th>

		<!-- titres des colonnes = noms des cours -->
		{foreach from=$listeCoursClasse key=cours item=detailsCours}
			{assign var=profs value=""}
			{foreach from=$detailsCours.profs key=coursGrp item=data}
				{assign var=profs value=$data.nom|cat:"("|cat:$data.acronyme|cat:") => "|cat:$coursGrp|cat:"<br>"}
			{/foreach}
		<th class="pop"
				style="cursor: pointer"
				data-html="true"
				data-placement="right"
				data-container="body"
				data-original-title="{$detailsCours.dataCours.libelle}"
				data-content = "{$profs}">
				<img src="imagesCours/{$cours}.png" alt="{$cours}"><br>
				{$detailsCours.dataCours.nbheures}h {$detailsCours.dataCours.statut}
		</th>
		{/foreach}
	</tr>

	{assign var=tabIndex value=1}
	{foreach from=$listeEleves key=matricule item=detailsEleve}
	<tr class="eleve">
		<td class="pop"
			data-content="<img src='../photos/{$detailsEleve.photo}.jpg' alt='{$matricule}' style='width:100px'><br><span class='micro'>{$matricule}</span>"
			data-container="body"
			data-html="true"
			data-placement="right">
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
					<input type="text" size="2" name="sit#eleve_{$matricule}#coursGrp_{$coursGrpProtect}"
					value="{$dataCote.sit|default:''}" tabIndex="{$tabIndex}" title="{$coursGrp}: {$listeCoursClasse.$cours.profs.$coursGrp.acronyme}">/
					<input type="text" size="2" name="max#eleve_{$matricule}#coursGrp_{$coursGrpProtect}"
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
<div class="btn-group">
	<button type="reset" class="btn btn-default">Annuler</button>
	<button type="submit" class="btn btn-primary">Enregistrer</button>
</div>

</form>

</div>

<script type="text/javascript">

	$(document).ready(function(){

		$("#readOnlyMax").click(function(){
			$(".max").each(function(){
				$(this).prop('disabled', true);
			})
		})

		$("#formSituations").submit(function(){
			// éventuellement, réactiver les maxima
			$(".max").each(function(){
				$(this).prop('disabled', false);
			})
			$.blockUI();
			$("#wait").show();
			})
		})

		$(".pop").popover('hover');
		$(".pop").not(this).popover('hide');

</script>

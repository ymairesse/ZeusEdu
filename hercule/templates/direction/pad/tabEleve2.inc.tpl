<div>
	<span id="ajaxLoader" class="hidden">
        <img src="images/ajax-loader.gif" alt="loading">
    </span>
	<button type="button" class="btn btn-success pull-right" id="btnPrintTab2"><i class="fa fa-print"></i> Imprimer</button>
</div>

{if isset($degre) && ($degre == 1)}

<h3>Résultats du CEB</h3>
<table class="table table-condensed table-hover">
	<tr>
		<th style="width:17%">Matières</th>
		<th style="width:17%">Français</th>
		<th style="width:17%">Math</th>
		<th style="width:17%">Sciences</th>
		<th style="width:17%">Histoire/géo</th>
		<th style="width:17%">Deuxième langue</th>
	</tr>
	<tr>
		<th>Cotes obtenues</th>
		<td class="cote">{$ceb.fr}</td>
		<td class="cote">{$ceb.math}</td>
		<td class="cote">{$ceb.sc}</td>
		<td class="cote">{$ceb.hg}</td>
		<td class="cote">{$ceb.l2}</td>
	</tr>
</table>

{/if}

<!-- année scolaire en cours -->
{assign var=annee value=$classe|substr:0:1}
<h3>Résultats de {$annee}e année (année scolaire en cours)</h3>
<div class="table-responsive">

<table class="table table-condensed">
	<tr>
		<th>&nbsp;</th>
		{foreach from=$listeCoursGrp key=coursGrp item=dataCours}
			<th style="text-align:center"
				class="pop"
				data-content="{$dataCours.coursGrp} <br>{$dataCours.prenom} {$dataCours.nom}"
				data-original-title="{$dataCours.libelle}"
				data-container="body"
				data-html="true">
				{$dataCours.cours}<br>
				{$dataCours.nbheures}h<br>{$dataCours.statut}
			</th>
		{/foreach}
	<th>Mentions</th>
	</tr>

	{foreach from=$anneeEnCours key=periode item=data}
	<tr>
		<th>{$periode}</th>
		{foreach from=$listeCoursGrp key=coursGrp item=dataCours}
			<td class="cote mention{$anneeEnCours.$periode.$coursGrp.mention|trim:'+'|default:''}"
				title="{$coursGrp}"
				data-container="body">
			{if isset($anneeEnCours.$periode.$coursGrp) && isset($anneeEnCours.$periode.$coursGrp.sitDelibe) && ($anneeEnCours.$periode.$coursGrp.sitDelibe != '')}
				<span class="micro">Délibé</span>
				<strong>{$anneeEnCours.$periode.$coursGrp.sitDelibe|default:''}</strong><br>
			{/if}
			{if isset($anneeEnCours.$periode.$coursGrp) && ($anneeEnCours.$periode.$coursGrp.situation|trim:' ' != '')}
				{$anneeEnCours.$periode.$coursGrp.situation|default:''}/{$anneeEnCours.$periode.$coursGrp.maxSituation|default:''}<br>
				<span class="micro">={$anneeEnCours.$periode.$coursGrp.pourcent|default:''}</span>
			{else}
				&nbsp;
			{/if}
			</td>
		{/foreach}
		<td class="cote"><strong>{$mentions.$matricule.$ANNEESCOLAIRE.$annee.$periode|default:'&nbsp;'}</strong></td>
	</tr>
	{/foreach}
</table>

</div>  <!-- table-responsive -->

<!-- Années scolaires précédentes -->
<h3>Année(s) scolaire(s) précédentes</h3>

{foreach from=$syntheseToutesAnnees key=anScolaire item=syntheseAnnee}

	<!-- les éprevues externes de cette année scolaire -->
	{if isset($epreuvesExternes.$anScolaire)}
		<h4>Épreuves externes en {$anScolaire}</h4>
		<div class="table-responsive">
			<table class="table table-striped">
				<tr>
				{foreach from=$epreuvesExternes.$anScolaire key=cours item=cote}
					<td class="{if $cote < 50}mentionI {/if}cote">{$cours}: <strong>{$cote} / 100</strong></td>
				{/foreach}
				</tr>
			</table>
		</div>
	{/if}

	{foreach from=$syntheseAnnee key=annee item=dataSynthese}

	{assign var=listeCoursGrp value=$dataSynthese.listeCours}
	{assign var=resultats value=$dataSynthese.resultats}
	<h4>{$anScolaire} - Résultats de {$annee}e année</h4>

	<div class="table-responsive">

		<table class="table table-condensed">
			<tr>
				<th>&nbsp;</th>
				{foreach from=$listeCoursGrp key=coursGrp item=dataCours}
					<th style="text-align:center"
						class="pop"
						data-original-title="{$dataCours.libelle}"
						data-content="{$coursGrp}"
						data-container="body"
						data-html="true">
					{$dataCours.cours}<br>
					{$dataCours.nbheures}h<br>{$dataCours.statut}
					</th>
				{/foreach}
				<th>Mentions</th>
			</tr>

			{foreach from=$resultats key=periode item=bulletin}
			<tr>
				<th>{$periode}</th>
				{foreach from=$listeCoursGrp key=coursGrp item=data}
					{if in_array($coursGrp, array_keys($resultats.$periode))}
						<td class="cote mention{$resultats.$periode.$coursGrp.mention|trim:'+'|default:''}"
							title="{$coursGrp}"
							data-container="body">
							{if isset($resultats.$periode.$coursGrp.sitDelibe) && ($resultats.$periode.$coursGrp.sitDelibe != '')}
								<span class="micro">Délibé </span>
								<strong>{$resultats.$periode.$coursGrp.sitDelibe}</strong><br>
							{/if}

							{if isset($resultats.$periode.$coursGrp.pourcent) && ($resultats.$periode.$coursGrp.pourcent != '') }
							{$resultats.$periode.$coursGrp.situation}/{$resultats.$periode.$coursGrp.maxSituation}<br>
							<span class="micro">={$resultats.$periode.$coursGrp.pourcent}</span>
							{/if}
						 </td>
						{else}
						<td>&nbsp;</td>
					{/if}
				{/foreach}
				<td class="cote"><strong>{$mentions.$matricule.$anScolaire.$annee.$periode|default:'&nbsp;'}</strong></td>
			</tr>

			{/foreach}

		</table>

	</div>  <!-- table-responsive -->
	{/foreach}
{/foreach}

{include file="tableauMentions.tpl"}


{if $ecoles}
<table class="table table-condensed table-hover">
	<tr>
	<th>Année</th>
	<th>École</th>
	<th>Adresse</th>
	</tr>
	{foreach from=$ecoles item=uneEcole}
	<tr>
	<td>{$uneEcole.annee}</td>
	<td>{$uneEcole.nomEcole}</td>
	<td>{$uneEcole.adresse} {$uneEcole.cPostal} {$uneEcole.commune}</td>
	</tr>
	{/foreach}
</table>
{/if}

<script type="text/javascript">

	$(document).ready(function(){

		$(document).ajaxStart(function() {
			$('#ajaxLoader').removeClass('hidden');
		}).ajaxComplete(function() {
			$('#ajaxLoader').addClass('hidden');
		});

		$('#btnPrintTab2').click(function(){
			var matricule = $('#selectEleve').val();
			$.post('inc/printPad/printPadScolaire.inc.php', {
				matricule: matricule
			}, function(resultat){
				bootbox.alert({
					title: 'Le document est prêt',
					message: 'Veuillez cliquer sur <a href="inc/download.php?type=pfN&amp;f='+resultat+'"><i class="fa fa fa-file-pdf-o fa-2x"></i></a> pour le télécharger<br>Ce document restera disponible dans votre répertoire personnel dans l\'application Thot' 
				})
			})

		})

	})

</script>

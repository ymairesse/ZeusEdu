<div class="container-fluid">

	<h2>Situations | classe: {$classe} | Période: {$bulletin}</h2>

	<div class="alert alert-warning">
	<p><i class="fa fa-exclamation-triangle fa-2x"></i> Attention: ceci n'est pas la feuille de délibération. <strong>Les valeurs présentées sont les situations actuelles ramenées à 100 points. </strong></p>
	</div>

	<button class="btn btn-primary couleur">Désactiver la couleur</button>

	<div class="table-responsive">
		<table class="tableauBull table table-striped table-condensed">
			<tr>
				<th style="vertical-align: bottom;">
					<p>Nom de l'élève</p>
				</th>
			{foreach from=$listeCours key=cours item=detailsCours}
			<th>
				<span class="pop"
					  style="cursor:pointer"
					  data-original-title="{$detailsCours.cours.libelle}"
					  data-content="{$cours}"
					  data-placement="top"
					  data-html="true">
				<img src="imagesCours/{$cours}.png" alt="{$cours}"><br>
				{$detailsCours.cours.statut} {$detailsCours.cours.nbheures}h
				</span>
			</th>
			{/foreach}
			<th>Moyenne</th>
			</tr>
			{foreach from=$listeEleves key=matricule item=detailsEleve}
			{assign var=nomPrenom value={$detailsEleve.nom|cat:" "|cat:$detailsEleve.prenom}}
			<tr>
				<td>
					<span class="pop"
						  style="cursor:pointer"
						  data-content="<img src='../photos/{$detailsEleve.photo}.jpg' alt='{$matricule}' style='width:100px'><br>{$matricule}"
						  data-html="true"
						  data-placement="right"
						  data-container="body"
						  data-original-title="{$nomPrenom|truncate:15}">
						{$detailsEleve.classe} {$nomPrenom}
					</span>
				</td>

				{foreach from=$listeCours key=cours item=detailsCours}
					{if isset($listeSituations100.$matricule.$cours)	}
					{assign var=coursGrp value=$listeSituations100.$matricule.$cours.coursGrp}
					{else}
					{assign var=coursGrp value=Null}
					{/if}

					{if isset($coursGrp)}
						<td class="mention{$listeSituations100.$matricule.$cours.mention}">
							<span class="pop"
								  data-original-title="{$coursGrp}"
								  data-content="{$listeCours.$cours.$coursGrp.profs|@implode:'<br>'}"
								  data-placement="top"
								  data-html="true"
								  data-container="body">
								{$listeSituations100.$matricule.$cours.sit100|default:'&nbsp;'}
							</span>
						</td>
						{else}
						<td class="cote">-</td>
					{/if}
				{/foreach}
				<td style="text-align:center; font-weight:bold; border: 2px solid black;" class="mention{$moyennes[$matricule]['mention']}">
					{$moyennes[$matricule]['cote']}
				</td>

			</tr>
			{/foreach}
		</table>

		<table class="micro">
		<tr>
			<td colspan="6">Code de couleurs</td>
		</tr>
		<tr>
			<td class="mentionI">< 50</td>
			<td class="mentionF">50</td>
			<td class="mentionS">60</td>
			<td class="mentionAB">65</td>
			<td class="mentionB">70</td>
			<td class="mentionBplus">75</td>
			<td class="mentionTB">80</td>
			<td class="mentionTBplus">85</td>
			<td class="mentionE">>90</td>
		</tr>
		</table>

		</div>  <!-- table-responsive -->

</div>  <!-- container -->

<script type="text/javascript">

$(document).ready(function(){
	$(".couleur").click(function(){
		if ($(this).text() == 'Désactiver la couleur') {
			$(".mentionS").removeClass("mentionS").addClass("xmentionS");
			$(".mentionAB").removeClass("mentionAB").addClass("xmentionAB");
			$(".mentionB").removeClass("mentionB").addClass("xmentionB");
			$(".mentionBplus").removeClass("mentionBplus").addClass("xmentionBplus");
			$(".mentionTB").removeClass("mentionTB").addClass("xmentionTB");
			$(".mentionTBplus").removeClass("mentionTBplus").addClass("xmentionTBplus");
			$(".mentionE").removeClass("mentionE").addClass("xmentionE");
			$(this).text("Activer la couleur");
			}
			else {
				$(".xmentionS").removeClass("xmentionS").addClass("mentionS");
				$(".xmentionAB").removeClass("xmentionAB").addClass("mentionAB");
				$(".xmentionB").removeClass("xmentionB").addClass("mentionB");
				$(".xmentionBplus").removeClass("xmentionBplus").addClass("mentionBplus");
				$(".xmentionTB").removeClass("xmentionTB").addClass("mentionTB");
				$(".xmentionTBplus").removeClass("xmentionTBplus").addClass("mentionTBplus");
				$(".xmentionE").removeClass("xmentionE").addClass("mentionE");
				$(this).text("Désactiver la couleur");
				}
		})
	})

</script>

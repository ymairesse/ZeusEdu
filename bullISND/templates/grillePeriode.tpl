<h2>Situations | classe: {$classe} | Période: {$bulletin}</h2>
<p class="noprint">Attention: ceci n'est pas la feuille de délibération. <strong>Les valeurs présentées sont les situations actuelles ramenées à 100 points. </strong>
<span class="fauxBouton couleur">Désactiver la couleur</span></p>
<table class="tableauAdmin">
	<tr>
	<th>Nom de l'élève</th>
	{foreach from=$listeCours key=cours item=detailsCours}
	<th class="tooltip">
		<span class="tip" style="display:none">{$detailsCours.cours.libelle}<br>{$cours}</span>
		<img src="imagesCours/{$cours}.png" alt="{$cours}"><br>
		{$detailsCours.cours.nbheures}h
	</th>
	{/foreach}
	</tr>
	{foreach from=$listeEleves key=matricule item=detailsEleve}
	<tr>
		<td class="tooltip">
			<div class="tip" style="display:none"><img src="../photos/{$detailsEleve.photo}.jpg" alt="{$matricule}" style="width:100px"><br>{$matricule}</div>
			{$detailsEleve.classe} {$detailsEleve.nom} {$detailsEleve.prenom}
		</td>

		{foreach from=$listeCours key=cours item=detailsCours}
			{if isset($listeSituations100.$matricule.$cours)	}
			{assign var=coursGrp value=$listeSituations100.$matricule.$cours.coursGrp}
			{else}
			{assign var=coursGrp value=Null}
			{/if}

			{if isset($coursGrp)}
				<td class="mention{$listeSituations100.$matricule.$cours.mention}"
					title="{$coursGrp}|{$listeCours.$cours.$coursGrp.profs|@implode:'<br>'}">
				{$listeSituations100.$matricule.$cours.sit100|default:'&nbsp;'}
				</td>
				{else}
				<td class="cote">-</td>
			{/if}
		{/foreach}

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

<script type="text/javascript">
{literal}
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
{/literal}
</script>
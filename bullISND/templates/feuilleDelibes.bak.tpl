<div class="container">

<h2>Classe: | {$classe} | {$titusClasse|implode:','} -> Période: {$bulletin}</h2>

<div class="table-responsive">
	<table class="table table-condensed table-hover fdelibe">
		<tr>
			<th style="vertical-align: bottom;">
				<p>Nom de l'élève</p>
			</th>

			{foreach from=$listeCours key=cours item=detailsCours}
			<th>
				<span class="pop"
					  style="cursor:pointer"
					  data-content="{$detailsCours.cours.libelle}<br>{$cours}"
					  data-html="true"
					  data-container="body"
					  data-placement="left">
				<img src="imagesCours/{$cours}.png" alt="{$cours}"><br>
				{$detailsCours.cours.statut}<br>{$detailsCours.cours.nbheures}h
				 </span>
			</th>
			{/foreach}
			<th><img src="images/moyenne.png" alt="moyenne"></th>
			<th><img src="images/nbEchecs.png" alt="nombre d'échecs"></th>
			<th><img src="images/heuresEchecs.png" alt="nombre d'heures d'échec"></th>
			<th><img src="images/mentionInit.png" alt="mention Initiale"></th>
			<th><img src="images/mentionFinale.png" alt="mention Finale"></th>
		</tr>

		<!-- fin de l'entête ----------------------------------------------------------------- -->

		{foreach from=$listeEleves key=matricule item=unEleve}
		<tr>
			{assign var=nomPrenom value=$unEleve.nom|cat:' '|cat:$unEleve.prenom}
			<td class="pop"
				data-content="<img src='../photos/{$unEleve.photo}.jpg' alt='{$matricule}' style='width:100px'><br>{$nomPrenom|truncate:15:'...'}<br> {$matricule}"
				data-html="true"
				data-placement="top"
				data-container="body"
				data-original-title="{$nomPrenom|truncate:20}">
				{$unEleve.classe} {$nomPrenom|truncate:25:'...'}
			</td>

			{foreach from=$listeCours key=cours item=detailsCours}
				{if !(isset($listeCoursListeEleves.$matricule.$cours))}
					<td class="pasCours">&nbsp;</td>
				{else}
					{assign var=coursGrp value=$listeSituations.$matricule.$cours.coursGrp|default:Null}
					{if $coursGrp != Null}
					{assign var=attributDelibe value=$listeSituations.$matricule.$cours.attributDelibe}
					<td class="pop cote {$listeSituations.$matricule.$cours.statut} {$listeSituations.$matricule.$cours.echec}"
						data-container="body"
						data-original-title="{$coursGrp}"
						data-content="{if $attributDelibe == 'externe'}Épreuve externe<br>{/if}
									{$listeCours.$cours.$coursGrp.profs|@implode:'<br>'}
									{if isset($listeSituations.$matricule.$cours.choixProf)}
										<br>Sit. interne {$listeSituations.$matricule.$cours.situationPourcent}%
									{/if}"
						data-placement="top"
						data-html="true">
						{if $attributDelibe == 'hook'}
							[{$listeSituations.$matricule.$cours.sitDelibe|default:'&nbsp;'}]
						{else}
							{$listeSituations.$matricule.$cours.sitDelibe|default:'&nbsp;'}
							{$listeSituations.$matricule.$cours.symbole}
						{/if}
					</td>
					{else}
					<td class="cote">-</td>
					{/if}
				{/if}
			{/foreach}

			<td class="delibe">{$delibe.$matricule.moyenne|default:'&nbsp;'}</td>
			<td class="pop delibe"
				{if ($delibe.$matricule.nbEchecs >0)}
					data-original-title="{$delibe.$matricule.nbEchecs} échec(s)"
					data-content="{$delibe.$matricule.nbHeuresEchec}h|{$delibe.$matricule.coursEchec}"
					data-html="true"
					data-placement="top"
					data-container="body"
				{/if}>
				{if ($delibe.$matricule.nbEchecs >0)}{$delibe.$matricule.nbEchecs}{else}&nbsp;{/if}
			</td>
			<td class="pop delibe"
				{if $delibe.$matricule.nbEchecs > 0}
					data-original-title="{$delibe.$matricule.nbEchecs} échec(s) {$delibe.$matricule.nbHeuresEchec}h de cours "
					data-content="{$delibe.$matricule.coursEchec}"
					data-html="true"
					data-placement="top"
					data-container="body"
				{/if}>
				{if $delibe.$matricule.nbEchecs > 0}{$delibe.$matricule.nbHeuresEchec|default:'-'}h{else}&nbsp;{/if}
			</td>
			<td class="cote delibe">{$delibe.$matricule.mention|default:'&nbsp;'}</td>
			<td class="delibe">{$listeMentions.$matricule.$ANNEESCOLAIRE.$annee.$bulletin|default:'&nbsp;'}</td>
		</tr>
		{/foreach}
	</table>

</div>  <!-- table-responsive -->

{$listeEleves|@count} élèves

<p class="notice">Ce document est basé sur les cotes de délibération fournies dans le bulletin. Il ne devient définitif que la veille de la délibération à 17h00</p>

<p>Symbolique:</p>
<ul class="symbolique">
<li>² => réussite degré</li>
<li>* => cote étoilée</li>
<li>↗ => baguette magique</li>
<li>~ => reussite 50%</li>
<li>$ => épreuve externe</li>
<li>[xx] => non significatif</li>
</ul>

</div>

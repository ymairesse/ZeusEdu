{if isset($infoPerso)}
<div id="resultat">
<h1 style="clear:both" title="{$infoPerso.matricule}">{$infoPerso.nom} {$infoPerso.prenom} : {$infoPerso.classe} | Bulletin n° {$bulletin}</h1>
<img src="../photos/{$infoPerso.matricule}.jpg" title="{$infoPerso.matricule}" alt="{$infoPerso.matricule}"
	style="position: absolute; top: 0em; right: 0; width: 100px" class="photo">
{/if}
{if isset($listeCoursGrp)}

{foreach from=$listeCoursGrp key=coursGrp item=unCours}
<div class="unCours">
	<h2 class="titreCours" title="{$coursGrp}">{$unCours.libelle} {$unCours.nbheures}h</h2>
	
	<p style="text-align:right; margin-right:1em">{$listeProfsCoursGrp.$coursGrp}</p>
	<p>
	{if isset($sitPrecedentes.$matricule.$coursGrp.sit)}
		<strong>Situation précédente:</strong> {$sitPrecedentes.$matricule.$coursGrp.sit} / {$sitPrecedentes.$matricule.$coursGrp.maxSit} 
	{/if}

	{if isset($sitActuelles.$matricule.$coursGrp.sit)}
		{assign var=sitActuelle value=$sitActuelles.$matricule.$coursGrp}
		<span style="float:right; display:block; border: 1px solid black; color: white; background-color: black;">
		<strong>Situation actuelle: {$sitActuelle.sit} / {$sitActuelle.maxSit}</strong>
		{if $sitActuelle.maxSit > 0}
			{assign var=sitAct value=100*$sitActuelle.sit/$sitActuelle.maxSit}
			<span class="micro">soit {$sitAct|number_format:1}%</span>
		{/if}

		{if isset($sitActuelle.sitDelibe) && $sitActuelle.sitDelibe != ''}
			<strong>Délibé:
			{if $sitActuelle.attribut == 'hook'}[{$sitActuelle.sitDelibe}] %
			{else}
			{$sitActuelle.sitDelibe}<sup>{$sitActuelle.symbole}</sup> %
			{/if}
			</strong>
		{/if}
		</span>
	{/if}
	</p>
	
	<table style="clear:both; width:100%">
		<tr>
			<td style="width:50%; vertical-align:top">
				<table class="tableauBulletin">
					<tr>
						<th style="width:15em">Compétence</th>
						<th style="width: 6em; text-align:center" colspan="2" class="{$cotesPonderees.$matricule.$coursGrp.form.echec|default:''}">
							TJ: <strong>
								{if isset($cotesPonderees.$matricule.$coursGrp.form.cote)}
									{$cotesPonderees.$matricule.$coursGrp.form.cote}/{$cotesPonderees.$matricule.$coursGrp.form.max}
								{else}
									&nbsp;
								{/if}
								</strong>
						</th>
						<th style="width: 6em; text-align:center" colspan="2" class="{$cotesPonderees.$matricule.$coursGrp.cert.echec|default:''}">
							Cert: <strong>
								{if isset($cotesPonderees.$matricule.$coursGrp.cert.cote)}
									{$cotesPonderees.$matricule.$coursGrp.cert.cote}/{$cotesPonderees.$matricule.$coursGrp.cert.max}
								{else}
									&nbsp;
							{/if}
							</strong>
						</th>
					</tr>
					{* s'il y a des cotes pour ce coursGrp *}
					{if isset($listeCotes.$matricule.$coursGrp)}
					
					{assign var='lesCotes' value=$listeCotes.$matricule.$coursGrp}
					{assign var='cours' value=$unCours.cours}
						{foreach from=$listeCotes.$matricule.$coursGrp key=idComp item=uneCote}
						{if ($uneCote.form.cote != '') || ($uneCote.cert.cote != '')}
						<tr>
							<td>{$listeCompetences.$cours.$idComp.libelle}</td>
							<td style="width: 3em; text-align:center" class="{$uneCote.form.echec|default:''}">
								{$uneCote.form.cote|default:'&nbsp;'}</td>
							<td style="width: 3em; text-align:center" class="{$uneCote.form.echec|default:''}">
								{$uneCote.form.maxForm|default:'&nbsp;'}</td>
							<td style="width: 3em; text-align:center" class="{$uneCote.cert.echec|default:''}">
								{$uneCote.cert.cote|default:'&nbsp;'}</td>
							<td style="width: 3em; text-align:center" class="{$uneCote.cert.echec|default:''}">
								{$uneCote.cert.maxCert|default:'&nbsp;'}</td>
						</tr>
						{/if}
						{/foreach}
						
					{/if}
				</table>
			</td>
			<td style="vertical-align:top">
			<table class="tableauBulletin">
				<tr>
					<th>Remarque</th>
				</tr>
				<tr>
					<td>{$commentaires.$matricule.$coursGrp.$bulletin|default:'&nbsp;'}</td>
				</tr>
			</table>
			</td>
		</tr>
	</table>

</div>
{/foreach}

<!-- attitudes -->
{if $attitudes}
	<table class="tableauBulletin attitudes">
		<tr>
			<th>Attitudes</th>
			{foreach from=$attitudes.$bulletin.$matricule key=coursGrp item=uneBranche}
				<th>{$coursGrp}</th>
			{/foreach}
		</tr>
		<tr>
			<td>Respect des autres</td>
			{foreach from=$attitudes.$bulletin.$matricule item=uneBranche}
				<td {if $uneBranche.att1 == 'N'}class="echec"{/if}>{$uneBranche.att1}</td>
			{/foreach}
		</tr>
			<tr>
			<td>Respect des consignes</td>
			{foreach from=$attitudes.$bulletin.$matricule item=uneBranche}
				<td {if $uneBranche.att2 == 'N'}class="echec"{/if}>{$uneBranche.att2}</td>
			{/foreach}
		</tr>
			<tr>
			<td>Volonté de progresser</td>
			{foreach from=$attitudes.$bulletin.$matricule item=uneBranche}
				<td {if $uneBranche.att3 == 'N'}class="echec"{/if}>{$uneBranche.att3}</td>
			{/foreach}
		</tr>
			<tr>
			<td>Ordre et soin</td>
			{foreach from=$attitudes.$bulletin.$matricule item=uneBranche}
				<td {if $uneBranche.att4 == 'N'}class="echec"{/if}>{$uneBranche.att4}</td>
			{/foreach}
		</tr>
	</table>
{/if}

<!-- Éducateurs -->
{if $ficheEduc == 1}
<table class="tableauBulletin remarque">
	<tr>
		<th>Note des éducateurs</th>
	</tr>
	<tr>
		<td>Feuille de comportements jointe au bulletin; à signer par les parents.</td>
	</tr>
</table>
{/if}
{if isset($mention.$matricule.$annee.$bulletin)}
	<p>
	<strong>Mention: 
		<span class="mention {$mention.$matricule.$annee.$bulletin}">{$mention.$matricule.$annee.$bulletin}</strong></span>
	</strong> <img src="../images/info.png" 
	title="figure dans la feuille de délibé individuelle; sera reportée dans le bulletin imprimé" alt="info">
	</p>
	{else}
	<p><img src="../images/info.png" title="La mention obtenue par l'élève ne figure pas encore dans la feuille de délibé individuelle" alt="info"></p>
{/if}
<table class="tableauBulletin remarque">
	<tr>
		<th>Avis du titulaire ou du Conseil de Classe</th>
	</tr>
	<tr>
		<td>{$remTitu|nl2br|default:'&nbsp;'}</td>
	</tr>
</table>

{if isset($noticeDirection)}
<table class="tableauBulletin remarque">
	<tr>
		<th>Informations de la direction et des coordinateurs</th>
	</tr>
	<tr>
		<td>{$noticeDirection|nl2br}</td>
	</tr>
</table>
{/if}
</div>
{/if}
<script type="text/javascript">
{literal}
	$(document).ready(function(){
		
		$().UItoTop({ easingType: 'easeOutQuart' });
		
		$(".photo").draggable();
	})
{/literal}
</script>

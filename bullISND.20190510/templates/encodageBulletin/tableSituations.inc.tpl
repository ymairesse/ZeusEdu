{* ---------------------------------------------------------------------- *}
{* tableau récapitulatif période, situation, étoile, crochets, délibé     *}
{* ---------------------------------------------------------------------- *}
{assign var="cotes" value=$listeGlobalPeriodePondere.$matricule.$coursGrp|default:Null}
{assign var="bullPrec" value=$bulletin-1}
<div class="table-responsive">
<table class="table tableauBull situationActuelle">
	<tr>
		<th width="10%">Situation Précédente</th>
		<th width="15%">Période</th>
		<th width="10%">Situation au bulletin <strong>{$bulletin}</strong></th>
		<th width="10%"{if $sitDeuxiemes == Null} class="disabled"{/if}>2e année du degré</th>
		<th width="10%"{if $listeCotesExternes == Null} class="disabled"{/if}>Épr. externe</th>
		<th width="20%">Choix de situation<br>(en %)</th>
		<th width="10%">Votre choix<br>(en %)</th>
		<th width="15%">Délibé<br>(en %)</th>
	</tr>
	<tr>
		{* ------------------------------------------------------ *}
		{* situation au bulletin précédent ---------------------- *}
		{* ------------------------------------------------------ *}
		<td>
		{if isset($situationsPrecedentes.$matricule.$coursGrp.maxSit) &&  ($situationsPrecedentes.$matricule.$coursGrp.maxSit!= Null)}
			{assign var=sit value=$situationsPrecedentes.$matricule.$coursGrp.sit}
			{assign var=max value=$situationsPrecedentes.$matricule.$coursGrp.maxSit}
			{assign var=echec value=''}
			{if ($max > 0)}
				{if ($sit / $max) < 0.5}
					{assign var=echec value='echec'}
				{/if}
			{/if}
		<div class="fraction {$echec}">
			<div class="num">{$sit|default:'&nbsp;'}</div>
			<div class="den">{$max|default:'&nbsp;'}</div>
		</div>
		{assign var=pourcent value= 100 * $sit / $max}
		<span class="micro">= {$pourcent|string_format:"%.0f"} %</span>
		{/if}
		</td>

		{* ------------------------------------------------------ *}
		{* cotes de période, Formatif et/ou Certificatif ---------*}
		{* ------------------------------------------------------ *}
		<td>
			{if is_numeric($cotes.form.cote)}
			{assign var=echec value=''}
			{if ($cotes.form.max > 0)}
				{if ($cotes.form.cote / $cotes.form.max) < 0.5}
					{assign var=echec value='echec'}
				{/if}
			{/if}
				<div class="lblFraction">TJ</div>
				<div class="fraction {$echec}">
					<div class="num">{$cotes.form.cote}</div>
					<div class="den">{$cotes.form.max}</div>
				</div>
			{/if}
			{if is_numeric($cotes.cert.cote)}
				{assign var=echec value=''}
				{if ($cotes.cert.max > 0)}
					{if ($cotes.cert.cote / $cotes.cert.max) < 0.5}
						{assign var=echec value='echec'}
					{/if}
				{/if}
				<div class="lblFraction">Cert.</div>
				<div class="fraction {$echec}">
					<div class="num">{$cotes.cert.cote}</div>
					<div class="den">{$cotes.cert.max}</div>
				</div>
			{/if}
		</td>


		{* si des cotes de situation existent pour ce bulletin pour cet élève et pour ce cours   *}
		{assign var=sitEleve value=$listeSituations.$matricule.$coursGrp.$bulletin|default:Null}

		{* -------------------------------------------------------*}
		{* nouvelle cote de situation y compris en % -------------*}
		{* ------------------------------------------------------ *}
		<td>
			{if isset($sitEleve.sit) && is_numeric($sitEleve.sit)}
				{assign var=echec value=''}
				{if ($sitEleve.max > 0)}
					{if ($sitEleve.sit / $sitEleve.max) < 0.5}
						{assign var=echec value='echec'}
					{/if}
				{/if}
				{if $sitEleve.max > 0}
				<div class="fraction {$echec}">
					<div class="num">{$sitEleve.sit}</div>
					<div class="den">{$sitEleve.max}</div>
				</div>
				<span class="micro">= {$sitEleve.pourcent}%</span>
				{/if}
			{/if}
		</td>

		{* -------------------------------------------------------*}
		{* -rien que la deuxième année du degré ------------------*}
		{* -------------------------------------------------------*}

		<td class="cote{if $sitDeuxiemes == Null} disabled{/if}">
			{if ($sitDeuxiemes != Null) && isset($sitDeuxiemes.$coursGrp.$matricule.sit2.sit)}
			<div class="fraction">
				<div class="num">{$sitDeuxiemes.$coursGrp.$matricule.sit2.sit}</div>
				<div class="den">{$sitDeuxiemes.$coursGrp.$matricule.sit2.max}</div>
			</div>
			= {$sitDeuxiemes.$coursGrp.$matricule.sit2.pourcent|default:'&nbsp;'}%
			{else}
			-
			{/if}
		</td>


	{* Faut-il traiter le cas d'une période avec délibération? *}
	{if in_array($bulletin,$PERIODESDELIBES)}
		{* si c'est une période de délibé, on recueille les cotes de bilan *}
		{if ($bulletin == $nbBulletins) &&  isset($listeCotesExternes.$matricule)}
			{* si c'est la dernière période de l'année scolaire, on traite la cote externe *}
			{include file='encodageBulletin/avecExterne.tpl'}
			{else}
			{include file='encodageBulletin/sansExterne.tpl'}
		{/if}

	{else}
		<td>-</td>
		<td>-</td>
		<td>-</td>
		<td>-</td>
	{/if}
	</tr>
</table>
</div>  <!-- table-responsive -->
{assign var="tabIndexAutres" value=$tabIndexAutres+5}

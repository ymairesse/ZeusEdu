<!-- Aperçu des cotes pour vos cours -->
<h2 title="[{$intituleCours.option} | {$intituleCours.cours_ID}]">{$intituleCours.nom} {$intituleCours.heures}h -> {$intituleCours.classes} Bulletin {$bulletin}</h2>
<table class="tableauAdmin">
	<tr>
		<th>Classe</th>
		<th>Nom</th>
		{foreach from=$competencesTJEX.compTJ key=k item=uneCompetence}
			<th {popup caption="Compétence" text="$uneCompetence"} colspan="2">{$uneCompetence|truncate:7:".."}<span class="nano">{$k}</span></th>
		{/foreach}
		<th>&nbsp;</th>
		{foreach from=$competencesTJEX.compEX key=k item=uneCompetence}
			<th {popup caption="Compétence" text="$uneCompetence"} colspan="2">{$uneCompetence|truncate:7:".."}</th>
		{/foreach}
		<th>&nbsp;</th>
		<th colspan="2" title="Moyenne TJ">Moy. TJ</th>
		<th colspan="2" title="Moyenne EX">Moy. Ex</th>
	</tr>
{foreach from=$resultatsEleves item=unResultat}
	{assign var="matricule" value=$unResultat.data.eleve_ID}
	<tr class="{cycle values="ligneClaire,ligneFoncee"}">
		<td>{$unResultat.data.classe}</td>
		<td {popup fullhtml="true" text="<img src='../photos/$matricule.jpg' width='100px'>"} title="matricule {$unResultat.data.eleve_ID}">{$unResultat.data.nom}</td>
		{foreach from=$unResultat.TJ item=uneCote}
			<td class="TJ {$uneCote.echec}">{$uneCote.cote}</td>
			<td>{$uneCote.max}</td>
		{/foreach}

		<td>&nbsp;</td>
		{foreach from=$unResultat.EX item=uneCote}
			<td class="EX {$uneCote.echec}">{$uneCote.cote}</td>
			<td>{$uneCote.max}</td>
		{/foreach}

		<td>&nbsp;</td>
		<td class="TJ {$unResultat.moyennes.TJ.echec}">
			{$unResultat.moyennes.TJ.cote|default:'&nbsp;'}
			</td>
			<td>{$unResultat.moyennes.TJ.max|default:'&nbsp;'}
		</td>
		<td class="EX {$unResultat.moyennes.EX.echec}">
				{$unResultat.moyennes.EX.cote|default:'&nbsp;'}
			</td>
			<td>{$unResultat.moyennes.EX.max|default:'&nbsp;'}

		</td>
	</tr>
{/foreach}
</table>

{if $competencesTJEX.compTJ}
<h4>Compétences TJ</h4>
<ul>
	{foreach from=$competencesTJEX.compTJ key=k item=uneCompetence}
	<li>{$k} = {$uneCompetence}</li>
	{/foreach}
</ul>
{/if}

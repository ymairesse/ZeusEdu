<page backtop="10mm" backbottom="7mm" backleft="10mm" backright="10mm">
    <page_header>
        <table style="width:100%">
            <tr>
                <td style="width:70%">Carnet de cotes {$coursGrp}: {$nomProf}</td>
                <td style="width:30%; text-align:right">
                    <strong style="float:right">Année scolaire {$ANNEESCOLAIRE} Période {$bulletin}</strong>
                </td>
            </tr>
        </table>

    </page_header>

    <page_footer style="text-align:right">
        Généré le {$date}
    </page_footer>

	<table id="carnet" style="border-collapse:collapse">
		<thead>
		<tr>
			<th width="20">&nbsp;</th>
			<th>&nbsp;</th>
			{assign var=counter value=1}
			{foreach from=$listeTravaux key=idCarnet item=travail}
				<th id="idCarnet{$idCarnet}" style="width:4em;" >[ {$counter++} ]</th>
			{/foreach}
		</tr>

		<tr>
			<th>Classe</th>
			<th>Nom</th>
			{assign var=counter value=1}
			{foreach from=$listeTravaux key=idCarnet item=travail}
				{assign var=idComp value=$travail.idComp}
			<th id="idCarnet{$idCarnet}"
				style="width:4em">
				{$travail.date|substr:0:5}<br>
				<span class="micro">C{$travail.ordre}</span> / <strong>{$travail.max}</strong>
			</th>
			{/foreach}
		</tr>
		</thead>

		<tbody>
		{assign var=tabIndex value=1}
		{assign var=nbEleves value=$listeEleves|@count}
		{assign var=nbTravaux value=$listeTravaux|@count}
		{foreach from=$listeEleves key=matricule item=unEleve}
		<tr>
		<td style="border: 1px solid black;">{$unEleve.classe}</td>
		{assign var=nomPrenom value=$unEleve.nom|cat:' '|cat:$unEleve.prenom}
		<td style="border: 1px solid black;"> {$nomPrenom} </td>

		{foreach from=$listeTravaux key=idCarnet item=travail}
			{assign var=couleur value=$travail.idComp|substr:-1}
			<td style="border: solid 1px black; text-align:right;" class="{$travail.formCert} couleur{$couleur} idCarnet{$idCarnet}
				{if (isset($listeCotes.$matricule.$idCarnet)) && $listeCotes.$matricule.$idCarnet.echec} echec{/if} cote">

				<span class="{if (isset($listeCotes.$matricule.$idCarnet)) && $listeCotes.$matricule.$idCarnet.erreurEncodage} erreurEncodage{/if}">
					{$listeCotes.$matricule.$idCarnet.cote|default:'&nbsp;'}
				</span>

				{assign var=tabIndex value=$tabIndex+$nbEleves}
			</td>
		{/foreach}
		{assign var=tabIndex value=$tabIndex-($nbTravaux*$nbEleves)+1}
		</tr>
		{/foreach}
		<tr>
			<th style="text-align:right; padding-right:1em" colspan="2">Moyennes</th>
			{foreach from=$listeTravaux key=idCarnet item=travail}
				<th class="{$travail.formCert}"><strong>
					{if $listeMoyennes}
					{$listeMoyennes.$idCarnet|@round:1|default:'&nbsp;'}
					{else}
					&nbsp;
					{/if}</strong></th>
			{/foreach}
		</tr>
		</tbody>
	</table>

	<ol>
	{foreach from=$listeTravaux key=idCarnet item=travail}
	{assign var=idComp value=$travail.idComp}
		<li>{$travail.date|substr:0:5}: {$travail.libelle|truncate:50:'...'} {$travail.formCert} <strong>/{$travail.max}</strong> : <strong>C{$travail.ordre}</strong> {$listeCompetences.$idComp.libelle}</li>
	{/foreach}
	</ol>

</page>

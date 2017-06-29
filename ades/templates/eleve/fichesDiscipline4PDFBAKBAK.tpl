<style>
    td,
    th {
        border: solid 1px #ccc; border-collapse: collapse;
        padding: 5px;
        font-size: 9pt;
    }
</style>

<page backtop="25mm" backbottom="7mm" backleft="7mm" backright="10mm" footer="date">
    <page_header>
        <img src="../images/logoEcole.png" alt="LOGO" style="float:right">
        <p>{$ECOLE}
            <br> {$ADRESSE} {$COMMUNE}
            <br>Téléphone: {$TELEPHONE}</p>
    </page_header>
    <page_footer>
        {$Eleve.prenom} {$Eleve.nom}
    </page_footer>

    <img src="{$BASEDIR}/photos/{$Eleve.photo}.jpg" alt=" " style="float:right; width: 80px">
    <h3>Fiche disciplinaire de {$Eleve.prenom} {$Eleve.nom} Classe: {$Eleve.groupe}</h3>

    <h4>Année scolaire {$ANNEESCOLAIRE} - en date du {$DATE}</h4>

    {foreach from=$listeFaits key=classe item=tousLesEleves}

    	{foreach from=$tousLesEleves key=matricule item=ficheEleve}
            {* --------------------- traitement de la fiche d'un élève ------------------------------- *}

    		{foreach from=$ficheEleve key=typeFait item=listeFaits}
    			{assign var=dataFait value=$listeTypesFaits.$typeFait}

    			<h4 style="clear:both; color:{$dataFait.couleurTexte}; background:{$dataFait.couleurFond}">{$dataFait.titreFait}</h4>

				<table class="table table-condensed table-hover table-striped tableauSynthese">
					<thead>
						<tr>
							{foreach from=$listeChamps.$typeFait item=champ}
                                {if in_array($contexte, $listeChamps.$champ.contextes)}
                                    <th>{$descriptionsChamps.$champ.label}</th>
                                {/if}
							{/foreach}
						</tr>
					</thead>
					{foreach from=$listeFaits key=wtf item=faits}
					<tr>
						{foreach from=$listeChamps.$typeFait key=wtf item=unChamp}
                            {if in_array($contexte, $listeChamps.$champ.contextes)}
                                <td>{$faits.$unChamp|default:''}</td>
                            {/if}
						{/foreach}
					</tr>
					{/foreach}

				</table>
    		{/foreach}

    	{/foreach}
    {/foreach}

</page>

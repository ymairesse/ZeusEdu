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
        <img src="{$BASEDIR}images/logoEcole.png" alt="LOGO" style="float:right">
        <p>{$ECOLE}
            <br> {$ADRESSE} {$COMMUNE}
            <br>Téléphone: {$TELEPHONE}</p>
    </page_header>
    <page_footer>
        {$Eleve.prenom} {$Eleve.nom}
    </page_footer>

    <h3>Fiche de comportement de {$Eleve.prenom} {$Eleve.nom} Classe: {$Eleve.groupe}</h3>

    <h4>Année scolaire {$ANNEESCOLAIRE} - en date du {$DATE}</h4>
    <p>Période du {$debut} au {$fin}</p>

    {* parcourir la liste de tous les types de faits existants *}
    {foreach from=$listeTypesFaits key=type item=descriptionTypeFait}
        {* si ce type de fait est imputé à l'élève, on le traite *}
        {if isset($lesFaits.$type)}

        <h3>{$listeTypesFaits.$type.titreFait}</h3>
        <table>
            {* ----------------- ligne de titre du tableau -------------------------- *}
            <tr>
                {* on examine chacun des champs qui décrivent le fait *}
                {foreach from=$descriptionTypeFait.listeChamps item=champ}
                    {* si le champ intervient dans le contexte (ici, "tableau"), on écrit le label correspondant *}
                    {if in_array($contexte, $listeChamps.$champ.contextes)}
                    <th>
                        <div style="width:{$echelles.$type.$champ}px">
                            {$listeChamps.$champ.label}
                        </div>
                    </th>
                    {/if}
                {/foreach}
            </tr>
            {* // ----------------- ligne de titre du tableau -------------------------- *}

            <tbody>
                {* ------------------ description du fait -------------------------------- *}
                {foreach from=$lesFaits.$type key=idfait item=unFaitDeCeType}
                <tr>
                    {foreach from=$descriptionTypeFait.listeChamps item=champ}
                        {if in_array($contexte, $listeChamps.$champ.contextes)}
                        <td>
                            <div style="width:{$echelles.$type.$champ}px">
                                {* s'il s'agit d'une retenue, les informations suivantes se trouvent dans la liste des retenues de cet élève *}
                                {assign var=type value=$descriptionTypeFait.type}

                                {if ($listeTypesFaits.$type.typeRetenue > 0) && (in_array($champ, array('dateRetenue','heure','duree')))}
                                    {assign var=idretenue value=$unFaitDeCeType.idretenue}
                                    {if isset($listeRetenues.$idretenue)}
                                        {assign var=typeRetenue value=$listeRetenues.$idretenue}
                                        {$listeRetenues.$idretenue.$champ|default:'&nbsp;'}
                                    {/if}
                                {else}
                                    {$unFaitDeCeType.$champ|default:'&nbsp;'}
                                {/if}
                            </div>
                        </td>
                        {/if}
                    {/foreach}

                </tr>
                {/foreach} {* // ------------------ description du fait -------------------------------- *}
            </tbody>
        </table>

    {/if}
{/foreach}

</page>

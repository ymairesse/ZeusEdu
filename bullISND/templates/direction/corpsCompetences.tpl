<style type="text/css">
    table.competence { border: solid 1px #ccc; border-collapse: collapse }
    table.competence td { border: solid 1px #ccc; font-size: 8pt;}
    table.competence td.title { background-color: #ccc; font-size: 10pt; }
</style>

<table style="width:100%" class="competence">
    <tr>
        <th style="width:75%">Compétences</th>
        <th style="width:25%; text-align:center">Statut</th>
    </tr>
    {if isset($listeAcquis.$matricule)}
    {assign var=lesCoursEleve value=$listeAcquis.$matricule}
    {* $lesCours = liste des cours de l'élève courant avec les informations de cotes et d'acquisition OK ou KO *}

        {foreach from=$lesCoursEleve key=leCours item=dataCompetences}
        <tr>
            <td colspan="2" class="title">
                <h4 style="margin: 0; ">{$listeCours.$leCours.dataCours.libelle}</h4>
            </td>
        </tr>

            {foreach from=$dataCompetences key=idComp item=uneCompetence}
            <tr>
                <td>
                    {$listeCompetences.$leCours.$idComp.libelle}
                </td>
                <td style="text-align:center">
                    {if isset($listeAcquis.$matricule)} {$listeAcquis.$matricule.$leCours.$idComp.acq} {/if}
                </td>
            </tr>
            {/foreach}
        {/foreach}

    {/if}
</table>

{if $typeDoc == 'competences'}
    <p>Dans le cas où l'élève est orienté vers une année complémentaire au premier degré, le présent rapport sera complété par un plan individuel d'apprentissage élaboré par le Conseil de Guidance.</p>
{/if}

<p>Donné à ANDERLECHT, le {$laDate}</p>

<table style="width:100%;">
    <tr>
        <td style="width:60%; padding: 2em">Sceau de l'établissement</td>
        <td style="width:40%; padding: 2em">{$DIRECTION}</td>
    </tr>
    {if $signature == 1}
    <tr>
        <td style="width:60%"><img src="../../images/sceauECOLE.png" width="240" border="0" alt="Sceau de l'École"></td>
        <td style="width:40%"><img src="../../images/direction.jpg" width="200" border="0" alt="Signature"></td>
    </tr>
    {/if}
</table>

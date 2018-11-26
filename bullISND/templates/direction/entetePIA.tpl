<h3 style="text-align:center">PLAN INDIVIDUEL D'APPRENTISSAGE</h3>

<p><span style="text-decoration: underline;">Dénomination et siège de l'établissement</span><br>
<strong>{$ECOLE}</strong><br>
{$ADRESSE}</p>

<p style="padding-top:0.5em;">Le/la soussigné-e, <strong>{$DIRECTION}</strong>,<br>
chef de l'établissement susmentionné, certifie que</p>

<table style="width:100%;">
    <tr>
        <td style="width:60%; padding: 2em">
            <p><strong style="font-size:1.5em">{$unEleve.nom} {$unEleve.prenom}</strong><br>
        né(e) à <strong>{$unEleve.commNaissance}</strong><br>
        le <strong>{$unEleve.DateNaiss}</strong><br>
        Sexe: {$unEleve.sexe}</p>
    </td>
        <td style="width:40%; padding: 2em; text-align: right">
            <p>Responsable légal: <br>
            <strong>{$unEleve.nomResp}</strong><br>
            {$unEleve.adresseResp}<br>
            {$unEleve.cpostResp} {$unEleve.localiteResp}
            </p>
        </td>
    </tr>
</table>


<p>élève de <strong>{$unEleve.classe}</strong> au cours de l'année scolaire <strong>
{assign var=thisyear value=$smarty.now|date_format:"%Y"}
{section name=yearValue start=$thisyear-1 loop=$thisyear+1}
{$smarty.section.yearValue.index}{if $smarty.section.yearValue.index eq $thisyear-1}/{/if}
{/section}
</strong> a acquis le niveau de compétences suivant:</p>

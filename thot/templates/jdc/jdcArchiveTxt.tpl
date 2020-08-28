<!DOCTYPE html>
<html lang="fr" dir="ltr">
    <head>
        <meta charset="utf-8">
        <title>{$jdcDe}</title>
        <style type="text/css">
            td {
                border: 1px solid black;
            }
        </style>
    </head>
    <body>
        <table style="width:100%;">
            <tr>
                <th style="width:30%">Date</th>
                <th style="width:70%">Note</th>
            </tr>
            {assign var=n value=0}
            {foreach from=$jdcExtract key=wtf item=data}
            <tr>
                <td style="width:30%">
                    {$data.destinataire}<br>
                    {$data.nomProf}<br>
                    <strong>{$data.libelle} <br> {$data.categorie}</strong><br>
                    {$data.startDate}
                    {if $data.startHeure != '00:00:00'}{$data.startHeure|truncate:5:''}{/if}
                    {if $data.endHeure != $data.startHeure|truncate:5:''} - {$data.endHeure|truncate:5:''}{/if}
                </td>
                <td style="width:70%">{$data.enonce}</td>
            </tr>
            {/foreach}

        </table>
    </body>
</html>

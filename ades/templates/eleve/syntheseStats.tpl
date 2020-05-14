<p>
    Entre le <strong>{$debut}</strong> et le <strong>{$fin}</strong></p>

<h3>{$groupe}</h3>

<table class="table table-condensed">
    <thead>
        <tr>
            <th style="width: 12em">Nombre de faits</th>
            <th>Type de fait</th>
        </tr>
    </thead>
    {foreach from=$statistiques item=typeFait}
    <tr style="background-color: {$typeFait.couleurFond}; color: {$typeFait.couleurTexte}">
        <td>{$typeFait.nbFaits}</td>
        <td>{$typeFait.titreFait}</td>
    </tr>
    {/foreach}
</table>

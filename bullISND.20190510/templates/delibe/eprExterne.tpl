<div class="container">

<h3>Traitement des épreuves externes</h3>

<table class="table table-condensed">
    <thead>
        <tr>
            <th>Nom</th>
            {foreach from=$listeCours key=coursGrp item=dataCours}
                <th colspan="3" style="text-align:center">
                    <img
                        src="imagesCours/{$dataCours.cours}.png"
                        alt="{$dataCours.cours}"
                        title="{$dataCours.libelle}"
                        data-placement="bottom"><br>
                        {$dataCours.nbHeures}h
                </th>
            {/foreach}
            <th colspan="3">&nbsp;</th>
        </tr>
        <tr>
            <th>&nbsp;</th>
            {foreach from=$listeCours key=coursGrp item=dataCours}
            <th class="interne">Int</th>
            <th class="externe">Ext</th>
            <th>&nbsp;</th>
            {/foreach}
        </tr>
    </thead>

    <tbody>
        {foreach from=$listeEleves key=matricule item=dataEleve}
        <tr>
            <td class="pop"
				data-content="<img src='../photos/{$unEleve.photo}.jpg' alt='{$matricule}' style='width:100px'><br>{$dataEleve.nom|cat:' '|cat:$dataEleve.prenom|truncate:15:'...'}<br> {$matricule}"
				data-html="true"
				data-placement="top"
				data-container="body"
				data-original-title="{$dataEleve.nom|cat:' '|cat:$dataEleve.prenom|truncate:20}">{$dataEleve.nom} {$dataEleve.prenom}</td>
            {foreach from=$listeCours key=coursGrp item=dataCours}
                <td class="interne">{$listeSituationsInternes.$matricule.$coursGrp.sitDelibe|default:'&nbsp;'}</td>
                <td class="externe">{$listeCotesExternes.$matricule.$coursGrp.coteExterne}</td>
                <td>
                    <button type="button" class="btn btn-primary btn-xs">50</button>
                </td>
            {/foreach}
        </tr>
        {/foreach}
    </tbody>
</table>


</div>

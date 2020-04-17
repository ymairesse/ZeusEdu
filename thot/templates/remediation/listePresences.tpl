<table class="table table-condensed">
    <thead>
        <tr>
            <th style="width: 3em;">Classe</th>
            <th style="width: 20em">Nom</th>
            <th>Présences</th>
        </tr>
    </thead>
    <tbody>
        {foreach from=$listePresences key=matricule item=lesPresences}
        <tr>
            <td>{$lesPresences.dataEleve.classe}</td>
            <td>{$lesPresences.dataEleve.nom}</td>
            <td>
                {foreach from=$lesPresences.offres key=idOffre item=dataPresence}
                <span
                    class="{$dataPresence.presence} presence pop"
                    data-title="[{$dataPresence.acronyme}] {$dataPresence.prenomProf} {$dataPresence.nomProf}"
                    data-content="{$dataPresence.title}"
                    data-container='body'
                    data-html="true"
                    data-placement="top">
                    {$dataPresence.date|truncate:5:''} {$dataPresence.heure}</span>
                {/foreach}
            </td>
        </tr>
        {/foreach}
    </tbody>

</table>

<script type="text/javascript">

    $(document).ready(function(){
        $(".pop").popover({
            trigger:'hover'
            });
    })

</script>

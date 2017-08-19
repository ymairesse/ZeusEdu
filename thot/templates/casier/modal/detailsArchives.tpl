<form id='formArchives'>

    <table class="table table-condensed">
        <tr>
            <th>Date début</th>
            <th>Date fin</th>
            <th>Titre</th>
            <th>Statut</th>
        </tr>
        {foreach from=$listeTravaux key=idTravail item=unTravail}
        <tr data-idtravail="{$idTravail}" data-coursgrp="{$unTravail.coursGrp}">
            <td>{$unTravail.dateDebut}</td>
            <td>{$unTravail.dateFin}</td>
            <td>
                <a href="#"
                    data-toggle="popover"
                    data-html="true"
                    data-content="{$unTravail.consigne|escape:'htmlall'}"
                    title="Consigne">
                {$unTravail.titre}
                </a></td>
            <td>
                <select name="statut_{$idTravail}" id="statut_{$idTravail}" class="form-control">
                    {foreach from=$listeStatuts key=statut item=libelle}
                    <option value="{$statut}"{if $statut == $unTravail.statut} selected{/if}>{$libelle}</option>
                    {/foreach}
                </select>

            </td>
        </tr>
        {/foreach}

    </table>

</form>

<script type="text/javascript">
    $(document).ready(function(){
        {literal}
        $('a').popover({trigger:'hover'});
        {/literal}
    })
</script>

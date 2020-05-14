<h4>{$infosRetenue.titrefait}: {$infosRetenue.local} {$infosRetenue.heure} durée: {$infosRetenue.duree}h</h4>

<p>Nombre d'élèves: {$infosRetenue.occupation} inscrits / {$infosRetenue.places} places</p>

<table class="table table-hover table-responsive">

    <thead>
        <tr>
            <th>&nbsp;</th>
            <th>Nom de l'élève</th>
            <th>Classe</th>
            <th class="hidden-xs">Travail à effectuer</th>
            <th class="hidden-xs">Professeur</th>
            <th id="checkAllPresent"
                style="cursor:pointer"
                title="Cocher toutes les cases"
                data-container="body">
                Présent <i class="fa fa-arrow-down"></i>
            </th>
            <th id="checkAllSigne"
                style="cursor:pointer"
                title="Cocher toutes les cases"
                data-container="body">
                Signé <i class="fa fa-arrow-down"></i>
            </th>
        </tr>
    </thead>
    {assign var=n value=1}
    {foreach from=$listeEleves key=matricule item=unEleve}
    <tr>
        <th>{$n}</th>
        <td class="pop"
            style="max-width:200px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;"
            data-toggle="popover"
            data-content="<img src='../photos/{$unEleve.photo}.jpg' style='width:100px' alt='{$matricule}' class='noprint'>"
            data-container="body"
            data-html="true"
            data-placement="right"
            data-original-title="<span class='noprint'>{$unEleve.nom|cat:' '|cat:$unEleve.prenom|truncate:15:''}</span>">
            {$unEleve.nomPrenom}
        </td>
        <td>{$unEleve.groupe|default:'&nbsp;'}</td>
        <td class="hidden-xs">{$unEleve.travail|default:'&nbsp;'}</td>
        <td class="hidden-xs">{$unEleve.professeur|default:'&nbsp;'}</td>
        <td><input type="checkbox" class="present" name="present[{$matricule}]" value="1" {if $unEleve.present}checked{/if}></td>
        <td><input type="checkbox" class="signe" name="signe[{$matricule}]" value="1" {if $unEleve.signe}checked{/if}></td>
        {assign var=n value=$n+1}
    </tr>
    {/foreach}

</table>

<script type="text/javascript">

    $(document).ready(function(){

        $("#checkAllPresent").click(function(){
            $("input.present").trigger('click');
        })

        $("#checkAllSigne").click(function(){
            $("input.signe").trigger('click');
        })


    })

</script>

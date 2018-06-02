<select class="form-control" name="coursGrp" id='coursGrp'>
    <option value="all">Tout imprimer</option>

    {foreach from=$listeCoursProf key=unCoursGrp item=data}
        <option value="{$unCoursGrp}"{if $unCoursGrp == $coursGrp} selected{/if}>
            {$data.statut} {$data.nbheures} {$data.libelle} ({$unCoursGrp})</option>
    {/foreach}
</select>

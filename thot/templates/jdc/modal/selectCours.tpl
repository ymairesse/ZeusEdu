<select class="form-control" name="coursGrp" id='coursGrp'>
    <option value="all">Tous mes cours</option>
    {foreach from=$listeCoursProf key=unCoursGrp item=data}
        <option value="{$unCoursGrp}"{if $unCoursGrp == $coursGrp} selected{/if}>
            {if $data.nomCours != ''}{$data.nomCours}{/if} {$data.statut} {$data.nbheures} {$data.libelle} ({$unCoursGrp})</option>
    {/foreach}
</select>

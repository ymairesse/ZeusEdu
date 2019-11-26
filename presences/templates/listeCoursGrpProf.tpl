<div style="height: 35em; overflow:auto">
<label>Choisir un cours</label>

{foreach from=$listeCoursGrp key=coursGrp item=data}

    <button type="button"
        class="btn btn-block {if $data.virtuel == 1}btn-info{else}btn-default{/if} btn-presenceCours"
        data-coursgrp="{$coursGrp}"
        title="{$data.statut} {$data.libelle} {$data.nbheures}h">
        {if isset($data.nomCours) && ($data.nomCours != '')}
            {$data.nomCours} [{$coursGrp}]
        {else}
            [{$coursGrp}] {$data.statut} {$data.libelle} {$data.nbheures}h
        {/if}
    </button>

{/foreach}

</div>

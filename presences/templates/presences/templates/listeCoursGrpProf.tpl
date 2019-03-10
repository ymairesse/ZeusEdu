<div style="height: 35em; overflow:auto">

{foreach from=$listeCoursGrp key=coursGrp item=data}

    <button type="button"
        class="btn btn-block {if $data.virtuel == 1}btn-info{else}btn-default{/if} btn-presenceCours"
        data-coursgrp="{$coursGrp}"
        data-container="body"
        data-placement="left"
        title="{$data.statut} {$data.libelle} {$data.nbheures}h">
        {if isset($data.nomCours) && ($data.nomCours != '')}
            {$data.nomCours} [{$coursGrp}]
        {else}
            [{$coursGrp}] {$data.statut} {$data.libelle} {$data.nbheures}h
        {/if}
    </button>

{/foreach}

</div>

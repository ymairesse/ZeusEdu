<option value="">Sélection du cours</option>
{foreach from=$listeCours key=coursGrp item=data}
    <option value="{$coursGrp}">{if $data.nomCours != ''}{$data.nomCours} - {/if}{$data.libelle} [{$coursGrp} ] {$data.statut} {$data.nbheures}h</option>
{/foreach}

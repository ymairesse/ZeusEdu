<option value="">Sélection du cours</option>
{foreach from=$listeCours key=coursGrp item=data}
    <option value="{$coursGrp}">{$data.libelle} [{$coursGrp} ] {$data.statut} {$data.nbHeures}h</option>
{/foreach}

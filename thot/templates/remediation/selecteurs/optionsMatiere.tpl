<option value="">Matière</option>
{foreach from=$listeMatieres key=matiere item=data}
<option value="{$matiere}">{$data.libelle} [{$matiere} ] {$data.statut} {$data.nbHeures}h</option>
{/foreach}

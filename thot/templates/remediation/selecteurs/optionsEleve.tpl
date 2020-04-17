{foreach from=$listeEleves key=matricule item=data}
    <option value="{$matricule}">{$data.nom} {$data.prenom}</option>
{/foreach}

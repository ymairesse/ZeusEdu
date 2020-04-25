<select class="form-control" name="matricule" id="selectEleve">
    <option value="">Choix d'un élève</option>
    {foreach from=$listeEleves key=matricule item=data}
    <option value="{$matricule}">{$data.nomPrenom} [{$data.classe}]</option>
    {/foreach}
</select>

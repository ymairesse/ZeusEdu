<div class="col-sm-7">
    <div class="form-group">
        <label for="niveau">Niveau d'étude</label>
        <select class="form-control" name="niveau" id="niveau">
            <option value="">Choisir le niveau</option>
            {foreach from=$listeNiveaux item=niveau}
                <option value="{$niveau}">{$niveau}e année</option>
            {/foreach}
        </select>
    </div>
</div>

<div class="col-sm-5" id="selectClasse">
    <div class="form-group">
        <label for="classe">Classe</label>
        <select class="form-control" name="classe" id="classeGroupe">
            <option value="">Classe</option>
        </select>
    </div>
</div>

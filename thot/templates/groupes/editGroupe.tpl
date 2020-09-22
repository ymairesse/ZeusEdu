<form id="formGroupe">
    <div class="row">

    <div class="col-md-7 col-xs-12">
        <h3>Caractéristiques</h3>

        <div class="form-group">
            <label for="nomGroupe">Nom du groupe</label>
            <input type="text" class="form-control" id="nomGroupe" name="nomGroupe" value="{$datasGroupe.intitule|default:''}" maxlength="20" placeholder="Nom du groupe">
        </div>

        <div class="form-group">
            <label for="Description">Description</label>
            <textarea name="description" id="description" class="form-control" rows="8" placeholder="Description du groupe">{$datasGroupe.description|default:''}</textarea>
        </div>

        <div class="form-group">
            <label for="type">Type</label>
            <select class="form-control" name="type" id="type">
                <option value="">Sélectionner un type</option>
                {foreach from=$statutsGroupes key=type item=libelle}
                <option value="{$type}"{if $type == $datasGroupe.type} selected{/if}>{$libelle}</option>
                {/foreach}
            </select>
        </div>

        <div class="form-group">
            <label for="max">Nombre max de membres</label>
            <input type="text" class="form-control" name="maxMembres" value="{$datasGroupe.maxMembres}">
        </div>

        <button type="button" class="btn btn-primary btn-block" id="btn-saveGroupe">Enregistrer</button>

    </div>

</form>

    <div class="col-md-5 col-xs-12">
        <h3>Membres</h3>
        {$membresGroupe|print_r}
    </div>

</div>

{if isset($listeClasses)}

    <div class="form-group">
        <label>Liste des classes pour ce niveau</label>
        
        <select class="form-control" name="listeClasses" id="listeClasses" size="12">
            {foreach from=$listeClasses key=wtf item=uneClasse}
                <option value="{$uneClasse}" class="uneClasse">{$uneClasse}</option>
            {/foreach}
        </select>

    </div>

{/if}

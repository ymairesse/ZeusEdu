<button type="button" class="btn btn-primary btn-block" id="createCollec">Créer une collection</button>

{foreach from=$listeCollections item=uneCollection}
{assign var=idCollection value=$uneCollection.idCollection}
<div class="input-group">
    <span class="input-group-btn">
    {if isset($listeQuestionsCollection.$idCollection) && ($listeQuestionsCollection.$idCollection > 0) }
        <button  class="btn btn-info btn-sm"
            type="button"
            name="button"><span class="badge">{$listeQuestionsCollection.$idCollection|count}</span>
        </button>
    {else}
        <button class="btn btn-danger btn-delCollection"
                type="button"
                title="Effacer cette collection"
                data-idcollection="{$idCollection}"
                data-nomcollection="{$uneCollection.nom}"><i class="fa fa-eraser"></i>
        </button>
    {/if}
    </span>
    <button type="button"
            class="btn btn-default btn-block btn-collection"
            data-idcollection="{$uneCollection.idCollection}"
            data-nomcollection="{$uneCollection.nom}">{$uneCollection.nom}
    </button>

    <span class="input-group-btn">
    <button class="btn btn-success btn-editCollection"
            type="button"
            title="Editer cette collection"
            data-idcollection="{$idCollection}"><i class="fa fa-pencil"></i>
    </button>
    </span>
</div>
{/foreach}

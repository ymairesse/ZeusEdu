<div class="row">

    <div class="col-md-4 col-sm-12">

        <fieldset class="form-group">
            <label for="titre">Titre de l'ouvrage</label>
            <input type="text" class="form-control typeahead" name="modalTitre" id="modalTitre" value="{$livre->title|default:''}" placeholder="Titre de l'ouvrage" autocomplete="off" data-minlength="4" tabindex="101">
        </fieldset>

        <fieldset class="form-group">
            <label for="sousTitre">Sous-titre</label>
            <input type="text" class="form-control typeahead" name="modalSousTitre" id="modalSousTitre" value="{$livre->subtitle|default:''}" placeholder="Sous-titre" autocomplete="off" data-minlength="4" tabindex="102">
        </fieldset>

        <label>Auteurs</label>
        <div id="lesAuteurs">
            {assign var=n value=103}
            {foreach from=$livre->authors item=unAuteur}
                <input type="text" class="form-control modalLesAuteurs input-sm" name="auteurs[]" value="{$unAuteur}" tabindex="{$n}">
            {assign var=n value=$n+1}
            {/foreach}
        </div>

    </div>

    <div class="col-md-4 col-sm-12">

        <fieldset class="form-group">
            <label for="editeur">Éditeur</label>
            <input type="text" class="form-control typeahead" name="modalEditeur" id="modalEditeur" value="{$livre->publisher|default:''}" placeholder="Éditeur" autocomplete="off" data-minlength="2" tabindex="120">
        </fieldset>

        <fieldset class="form-group">
            <label for="annee">Année d'édition</label>
            <input type="text" class="form-control" name="modalAnnee" id="modalAnnee" value="{$livre->publishedDate|date_format:'%Y'|default:''}" placeholder="Année" autocomplete="off" tabindex="121">
        </fieldset>

    </div>

    <div class="col-md-4 col-sm-12">

        <fieldset class="form-group">
            <label for="modalIsbn">ISBN</label>
            <input type="text" class="form-control typeahead" name="modalIsbn" id="modalIsbn" value="{$livre->industryIdentifiers.1->identifier}" placeholder="ISBN (10 ou 13 chiffres)" disabled autocomplete="off" data-minlength="4" tabindex="124">
            </div>
        </fieldset>

        {if isset($livre->imageLinks->thumbnail)}
            <img src="{$livre->imageLinks->thumbnail}" class="img-responsive">
        {/if}

    </div>

</div>

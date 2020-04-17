<div class="input-group">
    <span class="input-group-btn">
        <button type="button"
                class="btn btn-danger btn-sm btn-delAuteur"
                data-idbook="{$book.idBook|default:''}"
                data-idauteur="{$idAuteur}">
            <i class="fa fa-minus"></i>
        </button>
    </span>
    <input type="text" class="form-control listeAuteurs" readonly name="auteurs[]" value="{$auteur}">
</div>

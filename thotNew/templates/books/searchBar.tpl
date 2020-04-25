<div class="container-fluid">

    <div class="input-group">

        <div class="input-group-btn">
            <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
            {if isset($champ) && $champ != Null}{$critere}{else}Critère{/if}
            <span class="caret"></span>
            </button>
            <ul class="dropdown-menu">
                <li><a href="javascript:void(0)" class="critere" data-champ="nom" data-critere="Auteur">Auteur</a></li>
                <li><a href="javascript:void(0)" class="critere" data-champ="titre" data-critere="Titre">Titre</a></li>
                <li><a href="javascript:void(0)" class="critere" data-champ="editeur" data-critere="Éditeur">Éditeur</a></li>
                <li><a href="javascript:void(0)" class="critere" data-champ="annee" data-critere="Annee">Année</a></li>
                <li><a href="javascript:void(0)" class="critere" data-champ="lieu" data-critere="Lieu">Lieu</a></li>
                <li><a href="javascript:void(0)" class="critere" data-champ="collection" data-critere="Collection">Collection</a></li>
                <li><a href="javascript:void(0)" class="critere" data-champ="isbn" data-critere="ISBN">ISBN</a></li>
                <li><a href="javascript:void(0)" class="critere" data-champ="cdu" data-critere="CDU">CDU</a></li>
            </ul>
        </div>

        <input type="text" id="recherche" name="recherche"
            {if !(isset($champ)) || $champ == Null}readonly{/if}
            autocomplete="off"
            placeholder="{if isset($champ) && $champ != Null}{$critere}{else}Sélectionnez d'abord un criètre de recherche à gauche{/if}"
            value=""
            class="form-control typeahead">

        <div class="input-group-btn">
            <button type="button" class="btn btn-primary" id="btnOKSearch">OK</button>
        </div>
    </div>

    <input type="hidden" name="critereBook" id="critereBook" value="{$champ|default:''}">

</div>

<script type="text/javascript">
    $(document).ready(function() {

        $('#bookList').on('click', '.btn-edit', function(){
            var idBook = $(this).data('idbook');
            $.post('inc/books/getFormBookInput.inc.php', {
                idBook: idBook,
                mode: 'edit'
            },
            function(resultat){
                $("#formulaire").html(resultat);
            })
        })

        $("#btnOKSearch").click(function(){
            var champ = $("#critereBook").val();
            var query = $("#recherche").val();
            $.post('inc/books/getBookList.inc.php', {
                champ: champ,
                query: query
            },
            function(resultat){
                $("#formulaire").html(resultat);
            })
        })

        $(".dropdown-menu li a").click(function() {
            var critere = $(this).data('critere');
            $(this).parents('.input-group-btn').find('.btn').html(critere + ' <span class="caret"></span>');
            var champ = $(this).data('champ');
            $("#critereBook").val(champ);
            $("#recherche").attr('readonly', false).focus().attr('placeholder', critere);

        })

        $("#critereBook").change(function() {
            if ($("#critereBook").val() != "") {
                $("#btnOK").removeClass('hidden');
                $("#recherche").attr('readonly', false);
            }
        })

        $(".typeahead").typeahead({
            minLength: 3,
            delay: 500,
            source: function(query, process) {
                $.post('inc/books/searchItem.inc.php', {
                        'query': query,
                        'champ': $("#critereBook").val(),
                        'minLength': 3
                    },
                    function(data) {
                        if (data.length > 0)
                            process(JSON.parse(data))
                    }
                );
            }
        })

    })
</script>

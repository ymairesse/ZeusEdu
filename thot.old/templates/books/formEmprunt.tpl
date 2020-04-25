<div class="container-fluid">

    <div class="col-md-6 col-sm-12">

        <h2>Recherche d'un ouvrage</h2>

        <form id="formBook">

            <div class="form-group">
                <label for="critere">Critère de recherche</label>
                <select class="form-control" name="critere" id="critereBook">
                <option value="titre">Titre de l'ouvrage</option>
                <option value="nom">Auteur</option>
                <option value="editeur">Éditeur</option>
                <option value="isbn">ISBN</option>
            </select>
            </div>

            <div class="form-group">
                <label for="recherche">Recherche de</label>
                <input type="text" name="search" id="searchBook" value="" class="form-control typeahead">
                <p class="help-block">Ce que vous recherchez</p>
            </div>

            <div class="btn-group pull-right">
                <button type="button" class="btn btn-primary" id="btn-search">Trouver</button>
                <button type="reset" class="btn btn-default" name="reset">Annuler</button>
            </div>

            <div class="clearfix"></div>
        </form>

    </div>

    <div class="col-md-6 col-sm-12" id="listBooks" style="max-height: 25em; overflow: auto">

    </div>

</div>

<script type="text/javascript">
    $(document).ready(function() {

        $("#btn-search").click(function() {
            var champ = $("#critereBook").val();
            var query = $("#searchBook").val();
            $.post('inc/books/getBookSmallList.inc.php', {
                    champ: champ,
                    query: query
                },
                function(resultat) {
                    $("#listBooks").html(resultat)
                })
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

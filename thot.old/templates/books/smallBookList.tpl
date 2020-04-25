    {if $bookList|count == 0}
    <div class="alert alert-danger" role="alert">
        <span class="glyphicon glyphicon-exclamation-sign" aria-hidden="true"></span>
        Aucun résultat pour cette recherche
    </div>

    {else}
    <table class="table table-responsive table-striped">
        <tr>
            <th>&nbsp;</th>
            <th>Auteur(s)</th>
            <th>Titre</th>
            <th>Sous-titre</th>
            <th>Éditeur</th>
            <th>&nbsp;</th>
        </tr>
        <tbody>
            {foreach $bookList key=idBook item=book}
            <tr>
                <td>
                    <button data-idbook="{$idBook}" type="button" class="btn btn-blue btn-xs btn-choose">
                        <i class="fa fa-arrow-right"></i>
                    </button>
                </td>
                <td>{$book.nom}</td>
                <td>{$book.titre}</td>
                <td>{$book.sousTitre}</td>
                <td>{$book.editeur}</td>
            </tr>
            {/foreach}
        </tbody>

    </table>
    {/if}


<script type="text/javascript">
    $(document).ready(function() {

        $('#formulaire').on('click', '.btn-edit', function() {
            var idBook = $(this).data('idbook');
            $.post('inc/books/getFormBookInput.inc.php', {
                    idBook: idBook,
                    mode: 'edit'
                },
                function(resultat) {
                    $("#formulaire").html(resultat);
                })
        })

        $(".btn-choose").click(function(){
            var idBook = $(this).data('idbook');
            $.post('inc/books/getBookById.inc.php', {
                idBook: idBook
            }, function(resultat){
                $("#listBooks").html(resultat);
            })
        })

    })
</script>

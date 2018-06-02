<div class="container-fluid">

    <div class="row">

        <div class="col-md-4 col-xs-12">
            <button type="button" class="btn btn-lg btn-block btn-xl btn-pink" id="btnNewBook">
        <i class="fa fa-pencil fa-2x"></i> Nouvel ouvrage
      </button>
        </div>

        <div class="col-md-4 col-xs-12">
            <button type="button" class="btn btn-lg btn-block btn-xl btn-blue" id="btnEditBook">
        <i class="fa fa-edit fa-2x"></i> Modification d'un ouvrage
      </button>
        </div>

    </div>

</div>


<script type="text/javascript">
    $(document).ready(function() {

        $("#btnNewBook").click(function() {
            $.post('inc/books/newBook.inc.php', {},
                function(resultat) {
                    $('#formulaire').html(resultat);
                })
        })

        $("#btnEditBook").click(function(){
            $.post('inc/books/editBook.inc.php', {},
                function (resultat){
                    $("#searchBar").html(resultat);
                })
            $("#formulaire").html('');
        })

    })
</script>

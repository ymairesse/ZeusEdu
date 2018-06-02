<div class="container-fluid">

    <div class="row">

        <div class="col-md-4">

            <div class="panel panel-default">
              <div class="panel-heading">
                <h3 class="panel-title">Mes collections</h3>
              </div>
              <div class="panel-body" id="listeCollections">
                  {include file='exercices/listeCollections.tpl'}
              </div>
              <div class="panel-footer">
                  Sélectionner une collection
              </div>
            </div>

        </div>

        <div class="col-md-6">
            <div class="panel panel-default">
              <div class="panel-heading">
                <h3 class="panel-title" id="nomCollection">Nom de la collection</h3>
              </div>
              <div class="panel-body" id="listeQuestions">

              </div>
              <div class="panel-footer">
                Sélectionner une question
              </div>
            </div>

        </div>

    </div>

</div>

<script type="text/javascript">

$(document).ready(function(){

    $(".btn-delCollection").click(function(){
        var idCollection = $(this).data('idcollection');
        var nomCollection = $(this).data('nomcollection');
        $("#nomCollection").text(nomCollection);

        alert(idCollection+" "+nomCollection);
    })

    $(".btn-collection").click(function(){
        var idCollection = $(this).data('idcollection');
        var nomCollection = $(this).data('nomcollection');
        $("#nomCollection").text(nomCollection);
        $.post('inc/exercices/listeQuestions.inc.php', {
            idCollection: idCollection
        },
        function(resulatt){
            $("#listeQuestions").html(resulatt)
        })
    })
})

</script>

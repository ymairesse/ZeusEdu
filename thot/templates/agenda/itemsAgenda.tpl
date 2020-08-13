<div class="container-fluid">
    <div class="row">
        <div class="col-md-7 col-xs-12">

            <form id="formItemsAgenda">
                <h3>Mentions disponibles dans les agandas</h3>

                <div id="tableSort">
                    {include file="agenda/include/tableSort.tpl"}
                </div>

            </form>

        </div>

        <div class="col-md-5 col-xs-12">

            <div class="panel panel-info">
                <div class="panel-heading">
                    Organisation des catégories pour le JDC
                </div>

                <div class="panel-body">
                    <p>Organisez ici les différentes catégories d'événements à prévoir pour les agendas.</p>
                    <p>Utilisez les boutons fléchés pour changer l'ordre des catégories.</p>
                    <p>Les catégories qui sont actuellement utilisées dans les agandas ne peuvent plus être ni modifiées, ni supprimées. Leur ordre d'apparition reste toutefois modifiable.</p>
                    <p>Pour ajouter une catégorie, utilisez la zone <span style="background: #afa">de couleur verte</span> au bas du tableau. Cette nouvelle catégorie se place, par défaut, en dernière position. Il vous appartient ensuite de modifier son ordre d'apparition.</p>
                </div>

            </div>

        </div>

    </div>

</div>

<script type="text/javascript">

    $(document).ready(function(){

        $('#tableSort').on('click', '.btn-delCategorie', function(){
            var idCategorie = $(this).data('idcategorie');
            var texte = $('input[data-idcategorie="' + idCategorie +'"]').val();
            bootbox.confirm({
                title: 'Suppression de la catégorie',
                message: 'Veuille confirmer la suppresion définitive de la catégorie <strong>"' + texte + '"</strong>',
                callback: function(result){
                    if (result == true) {
                        $.post('inc/agenda/deleteCategorie.inc.php', {
                            idCategorie : idCategorie
                        }, function(resultat){
                            $.post('inc/agenda/reloadMentions.inc.php', {},
                            function(resultat){
                                $('#tableSort').html(resultat);
                            })
                         });
                    }
                 }
            })

        })

        $('#tableSort').on('click', '.btn-saveNewMention', function(){
            var newMention = $('#newMention').val();
            $.post('inc/agenda/saveMention.inc.php', {
                mention : newMention
            }, function(resultat){
                $.post('inc/agenda/reloadMentions.inc.php', {},
                function(resultat){
                    $('#newMention').val('');
                    $('#tableSort').html(resultat);
                })
            })
        })

        $('#tableSort').on('click', '.btn-saveMention', function(){
            var idCategorie = $(this).closest('tr').data('idcategorie');
            var mention = $(this).closest('td').find('input').val();
            var ordre = $(this).closest('tr').data('ordre');
            $.post('inc/agenda/saveMention.inc.php', {
                idCategorie: idCategorie,
                mention: mention,
                ordre: ordre
            }, function(resultat){
                bootbox.alert({
                    title: 'Enregistrement',
                    message: 'Mention enregistrée'
                })
            })
        })

        $('#tableSort').on('click', '.btn-down', function(){
            var thisRow = $(this).closest('tr');
            var ordre1 = thisRow.data('ordre');
            var idCategorie1 = thisRow.data('idcategorie');

            var nextRow = thisRow.next();
            var ordre2 = nextRow.data('ordre');
            var idCategorie2 = nextRow.data('idcategorie');

            $.post('inc/agenda/swapOrdreCategoriesJdc.inc.php', {
                ordre1: ordre1,
                idCategorie1: idCategorie1,
                ordre2: ordre2,
                idCategorie2: idCategorie2
            }, function (resultat){
                $('#tableSort').html(resultat);
            })
        })

        $('#tableSort').on('click', '.btn-up', function(){
            var thisRow = $(this).closest('tr');
            var ordre1 = $(this).closest('tr').data('ordre');
            var idCategorie1 = $(this).closest('tr').data('idcategorie');

            var prevRow = thisRow.prev();
            var ordre2 = prevRow.data('ordre');
            var idCategorie2 = prevRow.data('idcategorie');

            $.post('inc/agenda/swapOrdreCategoriesJdc.inc.php', {
                ordre1: ordre1,
                idCategorie1: idCategorie1,
                ordre2: ordre2,
                idCategorie2: idCategorie2
            }, function (resultat){
                $('#tableSort').html(resultat);
            })
        })

    })

</script>

<div class="container">

    <h3>Nettoyage des archives</h3>

    <div class="row">
        <div class="col-xs-12 col-md-8">
            <table class="table table-condensed">
                <thead>
                    <tr>
                        <th>Année</th>
                        <th>Mois</th>
                        <th>Prises de présences</th>
                        <th>Nettoyer</th>
                    </tr>
                </thead>
                {foreach from=$history key=annee item=lesMois}
                    {foreach from=$lesMois key=mois item=nb}
                    <tr>
                        <td>{$annee}</td>
                        <td>{$mois}</td>
                        <td>{$nb}</td>
                        <td>
                            <button data-year="{$annee}" data-month="{$mois}" type="button" class="btn btn-danger btn-sm btn-clean" name="button">
                                <i class="fa fa-times"></i>
                            </button>
                        </td>

                    </tr>
                    {/foreach}
                {/foreach}
            </table>
        </div>

        <div class="col-xs-12 col-md-4">
            <span id="ajaxLoader" class="hidden pull-right">
            <img src="../images/ajax-loader.gif" alt="loading">
            </span>
            <div class="notice">
                <p>Pour alléger la base de données, il est possible de supprimer les informations de prise de présences devenues inutiles.</p>
                <p>Attention, il n'est pas possible de récupérer les informations effacées.</p>

            </div>

        </div>
    </div>

</div>

<script type="text/javascript">

    $(document).ready(function(){

        $(document).ajaxStart(function() {
            $('#ajaxLoader').removeClass('hidden');
        }).ajaxComplete(function() {
            $('#ajaxLoader').addClass('hidden');
        });

        $('.btn-clean').click(function(){
            var bouton = $(this);
            var year = $(this).data('year');
            var month = $(this).data('month');
            $.post('inc/cleanArchives.inc.php', {
                year: year,
                month: month
                },
                function(nb){
                    bouton.closest('tr').fadeOut('slow');
                    bootbox.alert(nb + ' enregistrements effacés des tables "logs" et "eleves"');
                })
            })
        })
</script>

<div class="container">

    <div class="row">

        <div class="col-md-5 col-sm-12">

            <div class="panel panel-default">
                <div class="panel-heading">
                    <h4 class="panel-title">Liste des membres du personnel</h4>
                </div>
                <div class="panel-body">
                    <div id="listeProfs" style="height:30em; overflow: auto">
                        <table class="table table-condensed">
                            {foreach from=$listeProfs key=acronyme item=data}
                            <tr class="unProf" data-acronyme="{$data.acronyme}" data-nomprof="{$data.prenom} {$data.nom}">
                                <td>{$data.acronyme}</td>
                                <td>{$data.nom} {$data.prenom}</td>
                                <td>{if $data.boolCours == 1}
                                    <i title="Cours affectés" class="fa fa-graduation-cap"></i> {else}&nbsp;{/if}
                                </td>
                                <td>
                                    <input type="radio" name="prof" data-acronyme="{$data.acronyme}">
                                </td>
                            </tr>
                            {/foreach}
                        </table>
                    </div>
                </div>
                <div class="panel-footer">

                </div>
            </div>

        </div>
        <!-- col-md-... -->

        <div class="col-md-7 col-sm-12">

            <img src="../images/ajax-loader.gif" alt="Patience" id="ajaxLoader" class="hidden">

            <div id="listeCours">
                <!-- emplacement pour l'éventuelle liste des affectations de cours à supprimer -->
            </div>

        </div>

    </div>
    <!-- row -->

</div>
<!-- container -->


<script type="text/javascript">
    $(document).ready(function() {

        $(document).ajaxStart(function(){
            $('#ajaxLoader').removeClass('hidden');
        }).ajaxComplete(function(){
            $('#ajaxLoader').addClass('hidden');
        });

        $('.unProf').click(function() {
            $(this).find('input:radio').prop('checked', true);
            $('.unProf').removeClass('selected');
            $(this).addClass('selected');
            var acronyme = $(this).data('acronyme');
            var nomProf = $(this).data('nomprof');
            $.post('inc/users/listeAffectations.inc.php', {
                    acronyme: acronyme,
                    nomProf: nomProf
                },
                function(resultat) {
                    $("#listeCours").html(resultat);
                })
        })

    })
</script>

<div class="container-fluid">

    <div class="row">
        <div class="col-md-8 col-sm-12">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h2>Listes des faits imprimables et publiables</h2>
                </div>
                <div class="panel-body">
                    <form id="printPublish">
                        {foreach from=$listeTypesFaits key=wtf item=unTypeFait}
                        <div class="checkbox">
                            <label><input type="checkbox" name="type[{$unTypeFait.type}]" value="1"{if $unTypeFait.print == 1} checked{/if}> {$unTypeFait.titreFait}</label>
                        </div>
                        {/foreach}
                        <div class="btn-group pull-right">
                            <button type="reset" class="btn btn-default">Annuler</button>
                            <button type="button" class="btn btn-primary" id="btnSavePrintPublish">Enregistrer</button>
                        </div>
                        <div class="clearfix"></div>
                    </form>
                </div>
            </div>

        </div>

        <div class="col-md-4 col-sm-12">
            <p class="notice">
                Les faits disciplinaires de la liste ci-contre seront imprimés dans les fiches de comportement et seront publiés sur la plate-forme Thot si la case correspondante est cochée.<br>
                Plus d'options pour la gestion des faits disciplinaires dans l'utilitaire <a href="index.php?action=admin&mode=editTypesFaits">"Construction des faits disciplinaires"</a>.
            </p>
            <p></p>
        </div>
    </div>

</div>

<script type="text/javascript">

    $(document).ready(function(){

        $('#btnSavePrintPublish').click(function(){
            var formulaire = $('#printPublish').serialize();
            $.post('inc/admin/savePublish.inc.php', {
                formulaire: formulaire
            }, function(resultat){
                bootbox.alert(resultat + " modification(s) enregistrée(s)")
            })
        })
    })

</script>

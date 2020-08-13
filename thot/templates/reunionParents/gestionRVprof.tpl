GESTIONRVPROF.tpl
<div class="container-fluid">

    <div class="row">

        <div class="col-md-9 col-sm-12">

            <div class="panel panel-default" style="height: 40em; overflow: auto;">

                <div class="panel-heading">
                    <h3 class="panel-title">Les RV de <span id="nomProf">{$nomProf}</span>
                    <button
                        type="button"
                        id="printProf"
                        title="Imprimer"
                        class="btn btn-primary pull-right btn-sm"
                        data-idrp="{$idRP}"
                        data-acronyme="{$acronyme}">
                        <i class="fa fa-print fa-2x"></i></button>
                </h3>
                </div>

                <div class="panel-body">

                    <div id="listeRV">
                        {include file="reunionParents/tableRVprof.tpl"}
                    </div>

                    <h4>Liste d'attente</h4>
                    <div id="listeAttenteProf">
                        {include file="reunionParents/listeAttenteProf.tpl"}
                    </div>

                </div>

                <div class="panel-footer">
                    <strong class="indisponible pull-right">Lignes grisées = indisponibles</strong>
                    <div class="clearfix"></div>
                </div>

            </div>
            <!-- panel-default -->

        </div>
        <!-- col-md-... -->

        <div class="col-md-3 col-sm-12">

            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">infomation</h3>
                </div>
                <div class="panel-body">
                    <h4>Disponibilité</h4>
                    <p>Les périodes de RV peuvent être <span class="indisponible">désactivées</span> en utilisant les commutateurs <i class="fa fa-toggle-on"></i>. Les périodes <span class="indisponible">désactivées</span> sont marquées "occupées" pour les parents, sans autre signe distinctif.</p>
                    <p>Il vous appartient de réserver suffisamment de périodes disponibles pour recevoir les parents qui le souhaitent.</p>
                    <div class="alert alert-info">La modification du statut "disponible / indisponible" est immédiate. Il ne faut pas enregistrer ou sauvegarder quoi que ce soit.</div>

                </div>
                <div class="panel-footer">

                </div>
            </div>

        </div>

        {include file="reunionParents/modal/modalDel.tpl"}
        {include file="reunionParents/modal/modalDoublonRV.tpl"}
        {include file="reunionParents/modal/heureNonSelect.tpl"}
        {include file="reunionParents/modal/modalPrintRV.tpl"}
        {include file="reunionParents/modal/modalMaxRV.tpl"}

    </div>

</div>


<script type="text/javascript">
    $(document).ready(function() {

        $('#printProf').click(function() {
            var idRP = $(this).data('idrp');
            var acronyme = $(this).data('acronyme');
            $.post('inc/reunionParents/RV2pdf.inc.php',{
                idRP: idRP,
                acronyme: acronyme,
                module: 'thot'
            },
        function(resultat){
            bootbox.alert({
                title: 'Votre document est prêt',
                message: resultat
                });
            })

        })

    })
</script>

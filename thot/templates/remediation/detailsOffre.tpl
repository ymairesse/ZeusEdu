<div class="panel panel-default">

    <div class="panel-heading">
        <h2>Détails de cette remédiation</h2>
    </div>

    <div class="panel-body">

        <div class="row">
            <div class="col-md-8 col-xs-12">
                <div class="form-group">
                    <label>Matière</label>
                    <p class="form-control-static">{$offre.title}
                        <p>
                </div>
            </div>
            <div class="col-md-2 col-xs-6">
                <div class="form-group">
                    <label>Date</label>
                    <p class="form-control-static">{substr($offre.startDate,0,5)}</p>
                </div>
            </div>

            <div class="col-md-2 col-xs-6">
                <div class="form-group">
                    <label for="time">Heure</label>
                    <p class="form-control-static">{$offre.heure}</p>
                </div>
            </div>

            <div class="col-xs-12">
                <div class="form-group">
                    <label for="contenu">Objet de la remédiation, prérequis, matériel nécessaire,...</label>
                    <div class="form-control-static">{nl2br($offre.contenu)}</div>
                </div>
            </div>

            <div class="col-md-3 col-xs-6">
                <div class="form-group">
                    <label>Local</label>
                    <p class="form-control-static">{$offre.local}</p>
                </div>
            </div>

            <div class="col-md-3 col-xs-6">
                <div class="form-group">
                    <label>Places</label>
                    <p class="form-control-static">{$offre.places}</p>
                </div>
            </div>

            <div class="col-md-3 col-xs-6">
                <div class="form-group">
                    <label>Durée</label>
                    <p class="form-control-static">{$offre.duree}</p>
                </div>
            </div>

            <div class="col-md-3 col-xs-6" title="Les élèves ne voient pas les remédiations cachées">
                <label class="checkbox-inline">
                        <input type="checkbox" name="cache" value="1" {if $offre.cache==1 }checked{/if} disabled>Caché</label>
            </div>

        </div>

    </div>

    <div class="panel-footer">
        <button type="button" class="btn btn-danger pull-left" data-idoffre="{$offre.idOffre}" id="btn-delOffre"><i class="fa fa-times"></i> Supprimer</button>
        <div class="btn-group pull-right">
            <button type="button" class="btn btn-success" data-idoffre="{$offre.idOffre}" id="btn-clone"><i class="fa fa-clone"></i> Cloner</button>
            <button type="button" class="btn btn-info" data-idoffre="{$offre.idOffre}" id="btn-edit">Modifier <i class="fa fa-edit"></i></button>
        </div>
        <div class="clearfix"></div>
    </div>

</div>


<script type="text/javascript">

    $('document').ready(function() {

        $(document).ajaxStart(function() {
            $('body').addClass('wait');
        }).ajaxComplete(function() {
            $('body').removeClass('wait');
        });

    })
</script>

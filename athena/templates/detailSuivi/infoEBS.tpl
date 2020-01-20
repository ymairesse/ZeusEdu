<form id="formEBS">

    <div class="row">

        <div class="col-sm-12 col-md-6" id="listeTroubles">

            {include file="detailSuivi/listeTroubles.tpl"}

        </div>

        <div class="col-sm-12 col-md-6" id="listeAmenagements">

            {include file="detailSuivi/listeAmenagements.tpl"}
        </div>

    </div>

    <div class="row">
        <div class="col-xs-12">
            <fieldset class="form-group">
              <label for="memo">Mémo</label>
              <textarea class="form-control" id="memo" name="memo" rows="3">{$infoEBS['memo']}</textarea>
            </fieldset>
        </div>

    </div>

    <button type="button" class="btn btn-primary pull-right" name="button" id="btn-saveEBS">Enregistrer</button>
    <input type="hidden" name="matricule" value="{$matricule}">
    <div class="clearfix"></div>

</form>

<script type="text/javascript">

    $('document').ready(function(){

        $('#btn-saveEBS').click(function(){
            var formulaire = $('#formEBS').serialize();
            $.post('inc/suivi/saveEBS.inc.php', {
                formulaire: formulaire
            }, function(resultat){
                if (resultat > 0)
                    bootbox.alert('Informations enregistrées')
            })
        })

        $('#formEBS').on('click', '#btn-addTrouble', function(){
            var newTrouble = $('#plusTrouble').val().trim();
            var matricule = $(this).data('matricule');
            if (newTrouble != '') {
                $.post('inc/suivi/addTrouble.inc.php', {
                    trouble: newTrouble,
                    matricule: matricule
                }, function(resultat){
                    $('#listeTroubles').html(resultat);
                })
            }
        })

        $('#formEBS').on('click', '#btn-addAmenagement', function(){
            var newAmenagement = $('#plusAmenagement').val().trim();
            var matricule = $(this).data('matricule');
            if (newAmenagement != '') {
                $.post('inc/suivi/addAmenagement.inc.php', {
                    amenagement: newAmenagement,
                    matricule: matricule
                }, function(resultat){
                    $('#listeAmenagements').html(resultat);
                })
            }
        })

    })

</script>

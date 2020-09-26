<div class="container-fluid">

    <div class="row">
        <div class="col-md-2 col-sm-12">
            <ul class="list-unstyled">
                {foreach from=$listeCours key=coursGrp item=unCours}
                    <button type="button"
                        class="btn btn-primary btn-block selectCours"
                        data-coursgrp="{$coursGrp}"
                        title="{$unCours.statut} {$unCours.libelle} {$unCours.nbheures}h">
                        {if $unCours.nomCours != ''}
                            {$unCours.nomCours} {$coursGrp}
                        {else}
                            {$coursGrp} {$unCours.statut} {$unCours.nbheures}h
                        {/if}
                    </button>
                {/foreach}
            </ul>

        </div>

        <div class="col-md-10 col-sm-12">

            <input type="hidden" name="coursGrp" id="coursGrp" value="">
            <input type="hidden" name="periode" id="periode" value="0">

            <div id="selectEleves">

            </div>

            <div id="repertoire">
                <p class="avertissement">Veuillez choisir un cours</p>
            </div>

        </div>

    </div>

</div>

<script type="text/javascript">

    $(document).ready(function(){

        $('.selectCours').click(function(){
            var coursGrp = $(this).data('coursgrp');
            $('.selectCours').removeClass('btn-success').addClass('btn-primary');
            $(this).removeClass('btn-primary').addClass('btn-success');
            $.post('inc/carnet/listeElevesCoursGrp.inc.php', {
                coursGrp: coursGrp
            }, function(resultat){
                $('#selectEleves').html(resultat);
                $('#coursGrp').val(coursGrp);
                $('#repertoire').html('');
            })
        })

        $('#selectEleves').on('change', '#matricule', function(){
            var matricule = $('#matricule').val();
            var coursGrp = $('#coursGrp').val();
            var periode = $('#periode').val();
            $.post('inc/carnet/getListeCotesEleve.inc.php', {
                coursGrp: coursGrp,
                matricule: matricule,
                periode: periode
            }, function(resultat){
                if (resultat == '')
                    aler('ko');
                    else $('#repertoire').html(resultat)
            })
        })

        $('#repertoire').on('click', '.oneTab', function(){
            var periode = $(this).data('periode');
            $('#periode').val(periode);
        })
    })

</script>

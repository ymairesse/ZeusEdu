<div class="panel panel-default">
    <div class="panel-heading">
        <h4 class="panel-title" id="titrePanneau">Sélection</h4>
    </div>

    <div class="panel-body">
        <div class="btn-group btn-group-xs">
            <button type="button" class="btn btn-primary" id="checkAll" title="Cocher tout" disabled> <i class="fa fa-arrow-down"></i> </button>
            <button type="button" class="btn btn-warning" id="invert" title="Inverser la sélection" disabled>&nbsp;<i class="fa fa-check-square"></i>&nbsp;</button>
        </div>

        <div class="btn-group btn-group-xs pull-right">
            <button type="button" class="btn btn-success" id="all" title="Selection du groupe" disabled>&nbsp;<i class="fa fa-users"></i>&nbsp;</button>
            <button type="button" class="btn btn-info" id="select" title="Sélectionner certains élèves">&nbsp;<i class="fa fa-check-square-o"></i>&nbsp;</button>
        </div>

        <div id="listeEleves" class="hidden" style="height:35em; overflow:auto;">
            {foreach from=$listeEleves key=matricule item=eleve}
            <div class="checkbox" title="{$eleve.nom} {$eleve.prenom}" data-container="body">
                <label style="overflow:hidden;white-space:nowrap;text-overflow:ellipsis">
                    <input type="checkbox" class="eleve" name="matricules[]" value="{$matricule}" disabled> <span class="nomEleve spanDisabled">{$eleve.nom} {$eleve.prenom}</span>
                </label>
            </div>
            {/foreach}
        </div>

        <div id="tousLesEleves" style="padding-top: 1em; height:40em; overflow:auto;" class="micro">
            <p><strong>Si vous souhaitez sélectionner certains élèves du groupe,</strong> (<u>et seulement dans ce cas-là</u>), cliquez sur le bouton <button type="button" class="btn btn-info btn-xs">&nbsp;<i class="fa fa-check-square-o"></i>&nbsp;</button> et choisissez les destinataires.</p>
            <p>Pour envoyer à tout le groupe, ne sélectionnez aucun élève en particulier.</p>
            <p>Pour revenir à la sélection de tout le groupe, cliquez sur <button type="button" class="btn btn-success btn-xs" style="float:left;margin-right:0.5em;">&nbsp;<i class="fa fa-users"></i>&nbsp;</button></p>
            <p style="clear:both"><strong>Préférez toujours l'envoi groupé à l'envoi sélectif.</strong></p>
        </div>

    </div>
</div>

<script type="text/javascript">
    $(document).ready(function() {

        $("#all").click(function() {
            $(this).prop('disabled', true);
            $('#select').prop('disabled', false);
            $('#invert').prop('disabled', true);
            $('.eleve').prop('disabled', true);
            $('#checkAll').prop('disabled', true);
            $('.nomEleve').addClass('spanDisabled');
            $('#listeEleves').addClass('hidden');
            $('#tousLesEleves').removeClass('hidden');
            var classe = $('input#classe').val();
            if (classe != undefined) {
                $('#destinataire').val(classe);
                $('#type').val('classes');
            }
            var coursGrp = $('input#coursGrp').val();
            if (coursGrp != undefined) {
                $('#destinataire').val(coursGrp);
                $('#type').val('cours');
            }
            $('#titrePanneau').text('Tous les élèves')
        })

        $("#select").click(function() {
            $(this).prop('disabled', true);
            $('#invert').prop('disabled', false);
            $('.eleve').prop('disabled', false);
            $('#all').prop('disabled', false);
            $('#checkAll').prop('disabled', false);
            $('.nomEleve').removeClass('spanDisabled');
            $('#listeEleves').removeClass('hidden');
            $('#tousLesEleves').addClass('hidden');
            $('#destinataire').val('eleves');
            $('#type').val('eleves');
            $('#titrePanneau').text('Sélection')
        })

        $("#invert").click(function() {
            $('.eleve').each(function() {
                var check = $(this).prop('checked')
                $(this).prop('checked', !check);
            })
        })

        $("#checkAll").click(function(){
            $('.eleve').prop('checked', true);
        })

    })
</script>

<div class="container-fluid">

    <ul class="nav nav-tabs">
    	<li class="active"><a data-toggle="tab" href="#newAnnonce">Nouvelle annonce</a></li>
    	<li><a data-toggle="tab" id="historique" href="#historique">Historique</a></li>
    </ul>

    <div class="tab-content">

    	<div id="newAnnonce" class="tab-pane fade in active row">

            <div class="col-md-3 col-sm-12" id="selecteur">

                <div class="input-group">
                    <select class="form-control" name="cible" id="selectPrincipal">
                        <option value="">Choisir la cible</option>
                        <option value="tous">Tous les élèves</option>
                        <option value="niveau">Un niveau d'étude</option>
                        <option value="classe">Une classe</option>
                        <option value="coursGrp">Un cours</option>
                        <option value="matiere">Une matière</option>
                        <option value="groupe">Un groupe</option>
                    </select>
                    <span class="input-group-btn">
                        <button type="button" class="btn btn-primary" name="button" data-type="tous" disabled>
                            <i class="fa fa-arrow-right"></i>
                        </button>
                    </span>
                </div>

                <div class="hidden sousSelecteur input-group" id="formNiveau">
                    <select class="form-control" name="niveau" id="niveau">
                        <option value="">Choix du niveau</option>
                        {foreach from=$listeNiveaux key=wtf item=niveau}
                            <option value="{$niveau}">{$niveau}e année</option>
                        {/foreach}
                    </select>
                    <span class="input-group-btn">
                        <button type="button" class="btn btn-primary" name="button" data-type="niveau" disabled>
                            <i class="fa fa-arrow-right"></i>
                        </button>
                    </span>
                </div>

                <div class="hidden sousSelecteur input-group" id="formCoursGrp">
                    <select class="form-control" name="coursGrp" id="coursGrp">
                        <option value="">Choix du cours</option>
                        {foreach from=$listeCours key=coursGrp item=data}
                        <option value="{$coursGrp}">
                            {$data.statut} {$data.nbheures}h {if ($data.nomCours != '')} {$data.nomCours}{else}{$data.libelle}{/if} [{$coursGrp}]
                        </option>
                        {/foreach}
                    </select>
                    <span class="input-group-btn">
                        <button type="button" class="btn btn-primary" name="button" data-type="coursgrp" disabled>
                            <i class="fa fa-arrow-right"></i>
                        </button>
                    </span>
                </div>

                <div class="hidden sousSelecteur input-group" id="formClasses">
                </div>

                <div class="hidden sousSelecteur input-group" id="formMatieres">
                </div>


                <div class="hidden sousSelecteur btn-group btn-group-justified" id="formEleves">
                    <div class="btn-group">
                        <button type="button" class="btn btn-success btn-eleve" data-type="tous">
                            Tous les élèves <i class="fa fa-lg users"></i>
                        </button>
                    </div>
                    <div class="btn-group">
                        <button type="button" class="btn btn-warning btn-eleve" data-type="selection">
                            Sélection <i class="fa fa-lg user-plus"></i>
                        </button>
                    </div>
                </div>

                <div class="hidden sousSelecteur" id="selectEleves">
                    bla bla

                </div>

    		</div>

    		<div class="col-md-9 col-sm-12">



    		</div>
    	</div>

    	<div id="historique" class="tab-pane fade row">

            <div class="col-md-12">


            </div>

    	</div>

    </div>

</div>

<script type="text/javascript">

    $(document).ready(function(){

        $('#niveau').change(function(){
            var niveau = $(this).val();
            console.log(niveau);
            if (niveau != '')
                $('button[data-type="niveau"]').prop('disabled', false);
                else $('button[data-type="niveau"]').prop('disabled', true);

            var type = $('#selectPrincipal').val();
            switch (type) {
                case 'niveau':
                    $.post('inc/getListeClasses.inc.php', {
                        niveau: niveau
                    }, function(resultat){
                        $('#formClasses').html(resultat).removeClass('hidden');
                    });
                    break;
                case 'matiere':
                    $.post('inc/getListeMatieres.inc.php', {
                        niveau: niveau
                    }, function(resultat){
                        $('#formMatieres').html(resultat).removeClass('hidden');
                    });
                    break;
                case 'classe':
                    $.post('inc/getListeClasses.inc.php', {
                        niveau: niveau
                    }, function(resultat){
                        $('#formClasses').html(resultat).removeClass('hidden');
                    });
                    break;
                }

        })

        $('#coursGrp').change(function(){
            var coursGrp = $(this).val();
            if (coursGrp != '') {
                $('button[data-type="coursgrp"]').prop('disabled', false);
                }
                else {
                    $('button[data-type="coursgrp"]').prop('disabled', true);
                    }
            $.post('inc/getListeEleves.inc.php', {
                coursGrp: coursGrp
            }, function(resultat){
                $('#formEleves').removeClass('hidden');
                })
            })

        $('#selecteur').on('change', '#selectEleve', function(){
            var matricule = $(this).val();
            if (matricule != '') {
                $('button[data-type="eleve"]').prop('disabled', false);
                }
                else {
                    $('button[data-type="eleve"]').prop('disabled', true);
                    }
            })

        $('#selecteur').on('change', '#selectClasse', function(){
            var classe = $(this).val();
            if (classe != '') {
                $('button[data-type="classe"]').prop('disabled', false);
                }
                else {
                    $('button[data-type="classe"]').prop('disabled', true);
                    }
            $('#formEleves').removeClass('hidden');
            // $.post('inc/getListeEleves.inc.php', {
            //     classe: classe
            // }, function(resultat){
            //     $('#formEleves').removeClass('hidden');
            // })
        })

        $('#selecteur').on('change', '#selectMatieres', function(){
            var matiere = $(this).val();
            if (matiere != '') {
                $('button[data-type="matiere"]').prop('disabled', false);
                }
                else {
                    $('button[data-type="matiere"]').prop('disabled', true);
                    }
            })

        $('#selectPrincipal').change(function(){
            var item=$(this).val();
            if (item == 'tous')
                $('button[data-type="tous"]').removeAttr('disabled');
                else $('button[data-type="tous"]').prop('disabled', true);
            $('.sousSelecteur').addClass('hidden');
            switch (item) {
                case 'matiere':
                    $('#formNiveau').removeClass('hidden');
                    break;
                case 'tous':

                    break;
                case 'coursGrp':
                    $('#formCoursGrp').removeClass('hidden');
                    break;
                case 'niveau':
                    $('#formNiveau').removeClass('hidden');
                    break;
                case 'classe':
                    $('#formNiveau').removeClass('hidden');
                    break;
            }
        })
    })

</script>

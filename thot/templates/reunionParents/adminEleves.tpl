<div class="container-fluid">

    <div class="row">

        <div class="col-md-2 col-sm-4">

            <div class="panel-group" id="listeClasses">
                {foreach from=$listeClasses key=niveau item=lesClasses}
                <div class="panel panel-default">

                    <div class="panel-heading">
                        <h4 class="panel-title">
                            <a data-toggle="collapse" data-parent="#listeClasses" href="#niv{$niveau}">
                            Niveau {$niveau}
                            </a>
                        </h4>
                    </div>

                    <div id="niv{$niveau}" class="panel-collapse collapse">
                        <div class="panel-body">
                            <ul class="list-unstyled">
                                {foreach from=$lesClasses item=classe}
                                <li>
                                    <button type="button" class="btn btn-default btn-xs btn-block uneClasse" data-classe="{$classe}">{$classe}</button>
                                </li>
                                {/foreach}
                            </ul>
                        </div>
                    </div>

                </div>
                {/foreach}
            </div>

        </div>
        <!-- col-md-... -->

        <div class="col-md-3 col-sm-8">

            <div id="listeEleves" style="height:40em; overflow:auto">

                <div class="alert alert-info">
                    Sélectionnez une classe dans la colonne de gauche
                </div>

            </div>

        </div>
        <!-- col-md-... -->

        <div class="col-md-7 col-sm-12">

            <div id="listeProfs">

            </div>

            <!-- liste des RV et liste d'attente -->
            <div id="listeRV" style="max-height:40em; overflow: auto">

            </div>

            <div id="listeAttenteProf">

            </div>

        </div>
        <!-- col-md-... -->

    </div>
    <!-- row -->

    {include file="reunionParents/modal/modalDelRV.tpl"}
    {include file="reunionParents/modal/modalMaxRV.tpl"}
    {include file="reunionParents/modal/modalDoublonRV.tpl"}
    {include file="reunionParents/modal/modalAttente.tpl"}
    {include file="reunionParents/modal/modalHeureRvPlz.tpl"}

</div>
<!-- container -->


<script type="text/javascript">
    $(document).ready(function() {

        // sélection d'une classe
        $(".uneClasse").click(function() {
            $(".popover").popover('hide');
            var classe = $(this).data('classe');
            var idRP = $("#idRP").val();
            $(".uneClasse").removeClass('btn-primary');
            $(this).addClass('btn-primary');
            $.post('inc/reunionParents/listeElevesDeployee.inc.php', {
                    classe: classe,
                    idRP: idRP
                },
                function(resultat) {
                    $('#listeEleves').html(resultat);
                    $("#listeProfs").html('');
                    $("#listeRV").html('');
                    $("#listeAttenteProf").html('');
                })
        })

        // sélection d'un élève
        $(document).on('click', '.btn-eleve', function() {
            var matricule = $(this).data('matricule');
            var idRP = $('#idRP').val();
            $(".btn-eleve").removeClass('btn-primary');
            $(this).addClass('btn-primary');
            $.post('inc/reunionParents/listeProfsRPcible.inc.php', {
                    idRP: idRP
                },
                function(resultat) {
                    $("#listeProfs").html(resultat);
                    var nb = $("#selectProf option").length;
                    $("#selectProf").attr('size', nb);
                    $("#listeRV").html('');
                    $("#listeAttenteProf").html('');
                }
            )
        })

        // sélection d'un prof
        $("#listeProfs").on('change', '#selectProf', function() {
            var acronyme = $(this).val();
            var idRP = $("#idRP").val();
            var nomProf = $(this).find(':selected').data('nomprof');
            $("#attenteAcronyme").val(acronyme);
            $("#selectProf").attr('size', 1);
            $.post('inc/reunionParents/listeRvAdmin.inc.php', {
                    userStatus: 'admin',
                    acronyme: acronyme,
                    idRP: idRP,
                    nomProf: nomProf
                },
                function(resultat) {
                    $("#listeRV").html(resultat);
                });
            $.post('inc/reunionParents/listeAttenteAdmin.inc.php', {
                    idRP: idRP,
                    acronyme: acronyme
                },
                function(resultat) {
                    $("#listeAttenteProf").html(resultat);
                })
        })

        // attribution d'un RV à un élève
        $("#listeRV").on('click', '.lien', function() {
            var idRV = $(this).data('idrv');
            var matricule = $('.btn-eleve.btn-primary').data('matricule');
            var acronyme = $('#selectProf').val();
            var idRP = $("#idRP").val();

            if ((idRV > 0) && (matricule > 0)) {
                $.post('inc/reunionParents/inscriptionEleve.inc.php', {
                        matricule: matricule,
                        idRV: idRV,
                        idRP: idRP,
                        acronyme: acronyme
                    },
                    function(resultat) {
                        switch (resultat) {
                            case '1':
                                // visualisation du changement pour la zone des RV
                                $("#selectProf").trigger('change');

                                // Mise à jour du popover
                                $.post('inc/reunionParents/ulRvEleves.inc.php', {
                                        matricule: matricule,
                                        idRP: idRP
                                    },
                                    function(resultat) {
                                        var btnEleve = $('#listeEleves').find('[data-matricule=' + matricule + ']');
                                        btnEleve.attr('data-content', resultat).attr('data-placement', 'left');
                                        btnEleve.data('bs.popover').setContent();
                                    })

                                // Mise à jour du badge du nombre de RV de l'élève
                                var nb = parseInt($('#listeEleves').find('[data-matricule=' + matricule + ']').find('.badge').text());
                                $('#listeEleves').find('[data-matricule=' + matricule + ']').find('.badge').text(nb + 1);

                                break;
                            case '0':
                                alert("L'enregistrement s'est mal passé...")
                                break;
                            case '-1':
                                $("#modalMaxRV").modal('show');
                                break;
                            case '-2':
                                $("#modalDoublonRV").modal('show');
                                break;
                        }
                    }
                )
            }
        })

        // suppression d'un RV établi
        $("#listeRV").on('click', '.unlink', function() {
            var idRV = $(this).data('idrv');
            var matricule = $(this).data('matricule');
            var idRP = $("#idRP").val();
            var mail = $(this).data('mail');
            if (mail == '') {
                // il ne s'agit pas d'un RV pris par les parents
                $.post('inc/reunionParents/delRV.inc.php', {
                        idRV: idRV,
                        idRP: idRP
                    },
                    function(resultat) {
                        if (resultat == 1) {
                            // visualisation du changement pour la zone des RV
                            $("#selectProf").trigger('change');
                            // Mise à jour du popover
                            $.post('inc/reunionParents/ulRvEleves.inc.php', {
                                    matricule: matricule,
                                    idRP: idRP
                                },
                                function(resultat) {
                                    var btnEleve = $('#listeEleves').find('[data-matricule=' + matricule + ']');
                                    btnEleve.attr('data-content', resultat).attr('data-placement', 'left');
                                    btnEleve.data('bs.popover').setContent();
                                })

                            // Mise à jour du badge du nombre de RV de l'élève
                            var nb = parseInt($('#listeEleves').find('[data-matricule=' + matricule + ']').find('.badge').text());
                            $('#listeEleves').find('[data-matricule=' + matricule + ']').find('.badge').text(nb - 1);
                        }
                    }
                )
            } else {
                // il s'agit d'une réservation prise par les parents, il faut réaliser la procédure complète
                var nomEleve = $(this).data('nomEleve');
                $("#modalId").val(idRV);
                $("#modalNomEleve").html(nomEleve);
                $("#modalDelRV").modal('show');
            }
        })

        // attribution d'un RV à un élève qui se trouve en liste d'attente
        $(document).on('click','.unlinkAttente', function() {
            var matricule = $(this).data('matricule');
            var acronyme = $(this).data('acronyme');
            var periode = $(this).data('periode');
            var idRP = $('#idRP').val();
            // quelle est l'heure de RV cochée?
            var idRV = $('.idRV:checked').val();
            var userName = $(this).data('userName');
            var typeGestion = $("#typeGestion").val();

            if (idRV > 0) {
                $.post('inc/reunionParents/inscriptionEleve.inc.php', {
                    matricule: matricule,
                    idRP: idRP,
                    idRV: idRV,
                    acronyme: acronyme,
                    periode: periode,
                    userName: userName,
                    },
                    function(resultat){
                        switch (resultat) {
                            case '-1':
                                // le nombre max de RV est atteint
                                $('#modalMaxRV').modal('show');
                                break;
                            case '-2':
                                // il y a déjà un RV à cette heure-là
                                $('#modalDoublonRV').modal('show');
                                break;
                            default:
                                // si le mode est "adminEleves", il faut mettre à jour le "badge" et le "popover" des RV de l'élève
                                if (typeGestion == 'eleve') {
                                    // mise à jour du badge -nombre de RV- près du nom de l'élève
                                    var badge = parseInt($('#listeEleves').find('[data-matricule='+matricule+']').closest('li').find('.badge').text());
                                    $('#listeEleves').find('[data-matricule='+matricule+']').closest('li').find('.badge').text(badge+1);

                                    // Mise à jour du popover de la liste de RV
                                    $.post('inc/reunionParents/ulRvEleves.inc.php', {
                                            matricule: matricule,
                                            date: date
                                        },
                                        function(resultat) {
                                            var btnEleve = $('#listeEleves').find('[data-matricule=' + matricule + ']');
                                            btnEleve.attr('data-content', resultat).attr('data-placement', 'left');
                                            btnEleve.data('bs.popover').setContent();
                                        })
                                    }
                                // reconstruire la liste des RV mise à jour pour le prof désigné
                                $.post('inc/reunionParents/listeRvAdmin.inc.php', {
                                            acronyme: acronyme,
                                            date: date
                                        },
                                        function(resultat) {
                                            $('#listeRV').html(resultat);
                                        }
                                    )
                                // reconstruire la liste d'attente
                                $.post('inc/reunionParents/listeAttenteAdmin.inc.php', {
                                    date: date,
                                    acronyme: acronyme,
                                    matricule: matricule,
                                    periode: periode
                                }, function(resultat) {
                                    $('#listeAttenteProf').html(resultat);
                                });
                                break;
                            }
                        });
            }
            else $("#modalHeureRvPlz").modal('show');

        })

    // effacement de la liste d'attente
    $(document).on('click','.delAttente', function() {
        var matricule = $(this).data('matricule');
        var idRP = $('#idRP').val();
        var acronyme = $(this).data('acronyme');
        var periode = $(this).data('periode');

        $.post('inc/reunionParents/delAttente.inc.php', {
            idRP: idRP,
            acronyme: acronyme,
            matricule: matricule,
            periode: periode
            },
        function (resultat){
            $("#listeAttenteProf").html(resultat);
        })
    })

    $(document).on('click', '.popover .close', function() {
        $(this).closest('.popover').popover('hide');
    });

    $(document).on('click','#listeAttente', function(){
        var matricule = $('.btn-eleve.btn-primary').data('matricule');
        var date = $('#date').val();
        $('#attenteMatricule').val(matricule);
        $('#modalAttente').modal('show');
        })

    })
</script>

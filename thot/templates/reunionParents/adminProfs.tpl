ADMINPROF.tpl

<div class="container-fluid">

    <div class="row">

<div class="col-md-2 col-sm-6" style="max-height:40em; overflow:auto">

<div class="panel-group" id="profs">
    {foreach from=$listeProfs key=initiale item=desProfs}

      <div class="panel panel-default">

        <div class="panel-heading">
          <h4 class="panel-title">
            <a data-toggle="collapse" data-parent="#" href="#{$initiale}">
              <button type="button" class="btn btn-default btn-block">{$initiale}</button>
            </a>
          </h4>
        </div>
        <div id="{$initiale}" class="panel-collapse collapse">
          <div class="panel-body">
              <ul class="list-unstyled">
                  {foreach from=$desProfs key=abr item=data}
                  <li title="{$data.nom} {$data.prenom}">
                      <button
                          type="button"
                          class="btn btn-sm btn-block btn-prof{if (isset($acronyme)) && ($abr == $acronyme)} btn-primary{else btn-default}{/if}"
                          data-abreviation="{$data.acronyme}"
                          data-nomprof="{$data.prenom} {$data.nom}"
                          data-statut="{$data.statut}">
                          {$data.nom} {$data.prenom}
                      </button>
                  </li>
                  {/foreach}

              </ul>

          </div>
        </div>
      </div>
    {/foreach}
</div>

</div>  <!-- col-md-... -->


        <div class="col-md-7 col-sm-6">

            <!-- liste des RV et liste d'attente -->
            <div id="listeRV" style="max-height:40em; overflow: auto">
                {if isset($listeRV)}
                    {include file="reunionParents/tableRVAdmin.tpl"}
                {/if}
            </div>

            <div id="listeAttenteProf">
                {if isset($listeAttente)}
                    {include file="reunionParents/listeAttenteAdmin.tpl"}
                {/if}
            </div>

        </div>
        <!-- col-md-... -->


        <div class="col-md-3 col-sm-12">

            <div id="listeEleves" style="max-height: 40em; overflow:auto;">
                {if isset($listeEleves)} {include file="reunionParents/listeElevesProf.tpl"} {/if}
            </div>

        </div>
        <!-- col-md-... -->

    </div>
    <!-- row -->

    {include file="reunionParents/modal/modalDelRV.tpl"}
    {include file="reunionParents/modal/modalMaxRV.tpl"}
    {include file="reunionParents/modal/modalDoublonRV.tpl"}
    {include file="reunionParents/modal/modalAttente.tpl"}
    {include file="reunionParents/modal/modalElevePlz.tpl"}
    {include file="reunionParents/modal/modalHeureRvPlz.tpl"}

</div>
<!-- container -->


<script type="text/javascript">

var typeRP="{$typeRP}"

    $(document).ready(function() {

        // sélection d'un prof
        $(document).on('click', '.btn-prof', function() {
            var acronyme = $(this).data('abreviation');
            var idRP = $("#idRP").val();
            var nomProf = $(this).data('nomprof');
            var statut = $(this).data('statut');
            $(".btn-prof").removeClass('btn-primary');
            $(this).addClass('btn-primary');
            // produire la liste des RV pour le prof désigné
            $.post('inc/reunionParents/listeRvAdmin.inc.php', {
                        acronyme: acronyme,
                        idRP: idRP,
                    },
                    function(resultat) {
                        $("#listeRV").html(resultat);
                    }
                )
            // produire la liste d'attente admin pour ce prof
            $.post('inc/reunionParents/listeAttenteAdmin.inc.php', {
                        idRP: idRP,
                        acronyme: acronyme
                    },
                    function(resultat) {
                        $("#listeAttenteProf").html(resultat);
                    }
                )
            // produire la liste des élèves possibles pour un prof donné
            $.post('inc/reunionParents/listeEleves.inc.php', {
                    acronyme: acronyme,
                    statut: statut,
                    typeRP: typeRP
                },
                function(resultat) {
                    $("#listeEleves").html(resultat);
                }
            )
        })

        // attribution d'un RV à un élève
        $("#listeRV").on('click', '.lien', function() {
            var idRV = $(this).data('idrv');
            var matricule = $('.btn-eleve.btn-primary').data('matricule');
            var acronyme = $('.btn-prof.btn-primary').data('abreviation');
            var idRP = $("#idRP").val();

            if ((idRV > 0) && (matricule > 0)) {
                $.post('inc/reunionParents/inscriptionEleve.inc.php', {
                        matricule: matricule,
                        idRV: idRV,
                        idRP: idRP
                    },
                    function(resultat) {
                        switch (resultat) {
                            case '1':
                                // visualisation du changement pour la zone des RV
                                $.post('inc/reunionParents/listeRvAdmin.inc.php', {
                                        acronyme: acronyme,
                                        idRP: idRP
                                    },
                                    function(resultat) {
                                        $("#listeRV").html(resultat);
                                    }
                                )
                                // régénérer la liste d'attente
                                $.post('inc/reunionParents/listeAttente.inc.php', {
                                    acronyme: acronyme,
                                    idRP: idRP,
                                    matricule: matricule
                                },
                                function(resultat){
                                    $("#listeAttenteProf").html(resultat);
                                }
                            )
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

        // effacement d'un RV
        $("#listeRV").on('click', '.unlink', function() {
            var idRV = $(this).data('idrv');
            var matricule = $(this).data('matricule');
            var mail = $(this).data('mail');
            var acronyme = $('.btn-prof.btn-primary').data('abreviation');
            var idRP = $("#idRP").val();
            if (mail == '') {
                // on n'a pas l'adresse mail des parents (c'est donc une inscription par un admin)
                $.post('inc/reunionParents/delRV.inc.php', {
                        idRV: idRV,
                        idRP: idRP
                    },
                    function(resultat) {
                        switch (resultat) {
                            case '1':
                                // visualisation du changement pour la zone des RV
                                $.post('inc/reunionParents/listeRvAdmin.inc.php', {
                                        acronyme: acronyme,
                                        idRP: idRP,
                                    },
                                    function(resultat) {
                                        $("#listeRV").html(resultat);
                                    }
                                );
                                // régénérer la liste d'attente
                                $.post('inc/reunionParents/listeAttenteAdmin.inc.php', {
                                    acronyme: acronyme,
                                    idRP: idRP,
                                    },
                                    function(resultat){
                                        $("#listeAttenteProf").html(resultat);
                                    }
                                );
                                break;
                            case '0':
                                alert("Rien n'a été effacé")
                                break;
                        }
                    }
                )
            } else {
                $("#modalId").val(idRV);
                $("#modalNomEleve").html(MATRICULE);
                $("#modalDelRV").modal('show');
            }
        })

        $(document).on('click', '#listeAttente', function() {
            var matricule = $('.btn-eleve.btn-primary').data('matricule');
            var acronyme = $('.btn-prof.btn-primary').data('abreviation');
            var idRP = $('#idRP').val();
            if (matricule !== undefined) {
                $('#attenteMatricule').val(matricule);
                $('#attenteAcronyme').val(acronyme);
                $('#modalAttente').modal('show');
            } else $("#modalElevePlz").modal('show');
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

            // On envoie l'élève dans la RP $idRP
            if (idRV > 0) {
                // AJOUTER L'ÉLÈVES DANS LA TABLE DÉJÀ INITIALISÉE
                $.post('inc/reunionParents/inscriptionEleve.inc.php', {
                    matricule: matricule,
                    idRP: idRP,
                    idRV: idRV,
                    acronyme: acronyme,
                    periode: periode,
                    userName: userName
                    },
                    function(resultat){
                        switch (resultat) {
                            case '-1':
                                // le nombre max de RV est atteint
                                $("#modalMaxRV").modal('show');
                                break;
                            case '-2':
                                // il y a déjà un RV à cette heure-là
                                $("#modalDoublonRV").modal('show');
                                break;
                            default:
                                // si le type de gestion est "eleve", il faut mettre à jour le "badge" et le "popover" des RV de l'élève
                                if (typeGestion == 'eleve') {
                                    // mise à jour du badge -nombre de RV- près du nom de l'élève
                                    var badge = parseInt($("#listeEleves").find('[data-matricule='+matricule+']').closest('li').find('.badge').text());
                                    $("#listeEleves").find('[data-matricule='+matricule+']').closest('li').find('.badge').text(badge+1);

                                    // Mise à jour du popover de la liste de RV
                                    $.post('inc/reunionParents/ulRvEleves.inc.php', {
                                            matricule: matricule,
                                            idRP: idRP
                                        },
                                        function(resultat) {
                                            var btnEleve = $("#listeEleves").find('[data-matricule=' + matricule + ']');
                                            btnEleve.attr('data-content', resultat).attr('data-placement', 'left');
                                            btnEleve.data('bs.popover').setContent();
                                        })
                                    }

                                // reconstruire la liste des RV mise à jour pour le prof désigné
                                $.post('inc/reunionParents/listeRvAdmin.inc.php', {
                                            acronyme: acronyme,
                                            idRP: idRP
                                        },
                                        function(resultat) {
                                            $("#listeRV").html(resultat);
                                        }
                                    )

                                // reconstruire la liste d'attente
                                $.post('inc/reunionParents/listeAttenteAdmin.inc.php', {
                                    idRP: idRP,
                                    acronyme: acronyme,
                                    matricule: matricule,
                                    periode: periode
                                }, function(resultat) {
                                    $("#listeAttenteProf").html(resultat);
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

    })
</script>

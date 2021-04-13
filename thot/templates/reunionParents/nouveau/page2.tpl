<style media="screen">
    .non {
        background: pink !important;
    }
</style>

<div class="row">

    <div class="col-md-9 col-sm-12">

        <div class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title">Détails de la réunion de parents</h3>
            </div>

             <div class="panel-body">
                {if !(isset($idRP))}
                <div class="alert alert-info">
                    Définissez d'abord l'horaire et la liste des enseignants concernés à la page 1.
                </div>
                {/if}

            <form id="formDetails2">

            <div class="row">

                <div class="col-md-9 col-sm-12">
                    <div class="form-group">
                        <label for="texte">Note aux parents</label>
                        <textarea name="notice" id="texte" class="form-control summernote" placeholder="Rédigez votre note aux parents ici">{$infoRP.generalites.notice|default:''}</textarea>
                        <p class="help-block">Notice destinée aux parents pour l'inscription à la réunion</p>
                    </div>
                </div>  <!-- col-md-... -->

                <div class="col-md-3 col-sm-12">
                    <div class="checkbox">
                      <label>
                          <input type="checkbox" id="active" name="active" value="1"
                          {if isset($infoRP.generalites.active) && ($infoRP.generalites.active==1)}checked{/if}>
                          Activation
                     </label>
                     <p class="help-block">La réunion de parents est-elle activée</p>
                    </div>

                    <div class="checkbox">
                      <label>
                          <input type="checkbox" id="ouvert" name="ouvert" value="1"
                          {if isset($infoRP.generalites.ouvert) && ($infoRP.generalites.ouvert==1)}checked{/if}>
                          Ouverture
                     </label>
                     <p class="help-block">La réunion de parents est-elle ouverte à l'inscription</p>
                    </div>

                    <fieldset disabled>
                        <legend>Listes d'attente</legend>
                        <table class="table table-condensed">
                            <tr>
                                <td>1</td>
                                <td><input
                                    type="text"
                                    class="form-control periodes minPer1 non"
                                    size="3"
                                    name="minPer1"
                                    id="minPer1"
                                    value="{$infoRP.heures.minPer1|default:$infoRP.heuresLimites.min|truncate:5:''|default:''}" readonly>
                                </td>
                                <td>
                                    <input
                                    type="text"
                                    class="heure form-control periodes minPer1"
                                    size="3"
                                    name="maxPer1"
                                    id="maxPer1"
                                    value="{$infoRP.heures.maxPer1|default:$infoRP.heuresLimites.min|truncate:5:''|default:''}"></td>
                            </tr>
                            <tr>
                                <td>2</td>
                                <td><input
                                    type="text"
                                    class="form-control periodes minPer1 non"
                                    size="3"
                                    name="minPer2"
                                    id="minPer2"
                                    value="{$infoRP.heures.minPer2|default:$infoRP.heuresLimites.min|truncate:5:''|default:''}" readonly></td>
                                <td><input
                                    type="text"
                                    class="form-control periodes maxPer2 non"
                                    size="3"
                                    name="maxPer2"
                                    id="maxPer2"
                                    value="{$infoRP.heures.maxPer2|default:$infoRP.heuresLimites.max|truncate:5:''|default:''}" readonly></td>
                            </tr>
                            <tr>
                                <td>3</td>
                                <td><input
                                    type="text"
                                    class="heure form-control periodes maxPer2"
                                    size="3"
                                    name="minPer3"
                                    id="minPer3"
                                    value="{$infoRP.heures.minPer3|default:$infoRP.heuresLimites.max|truncate:5:''|default:''}"></td>
                                <td><input
                                    type="text"
                                    class="form-control periodes maxPer2 non"
                                    size="3"
                                    name="maxPer3"
                                    id="maxPer3"
                                    value="{$infoRP.heures.maxPer3|default:$infoRP.heuresLimites.max|truncate:5:''|default:''}" readonly></td>
                            </tr>
                        </table>

                    </fieldset>

                    <div class="btn-group pull-right">
                        <button type="button" id="btn-page2" class="btn btn-primary" data-idrp="{$idRP|default:''}">Enregistrer</button>
                    </div>

                </div>

                </div>  <!-- row -->

                <input type="hidden" name="idRP" value="{$idRP|default:''}">

              </form>
          </div>
        </div>


    </div>

    <div class="col-md-3 col-sm-12">

        <div class="panel panel-default">
          <div class="panel-heading">
            <h3 class="panel-title">Informations</h3>
          </div>
          <div class="panel-body">
            <h4>Note aux parents</h4>
            <p>Informations affichées aux parents qui s'inscrivent.</p>
            <h4>Activation</h4>
            <p>Visible par les parents (mais pas d'inscription possible).</p>
            <h4>Ouverture</h4>
            <p>Inscription des parents possible.</p>
            <h4>Listes d'attente</h4>
            <p>Les parents qui n'ont pu s'inscrire faute de place sont invités à indiquer une période durant laquelle il peuvent accepter un rendez-vous si une place se libère.</p>
            <p>Les heures des périodes en liste d'attente ne sont plus modifiables après enregistrement.</p>

          </div>
          <div class="panel-footer">

          </div>

        </div>

    </div>

</div>

<script type="text/javascript">

    $(document).ready(function(){

        var idRP = $('#formDetails2 input[name="idRP"]').val();
        if (idRP != '')
            $('#formPage1 input[type="text"]').attr('disabled', true);
            else $('#formPage1 input').attr('disabled', false);

        // visiblement, l'enregistrement des périodes s'est mal passé
        // car les périodes de liste d'attente ne sont pas synchro
        if ((idRP != '') && $('#minPer1').val() == $('#maxPer1').val()){
            bootbox.alert({
                title: 'Problème',
                message: "Il semble que les périodes de liste d'attente ne soient pas bien configurées à la page 2"
            })
            $('fieldset').attr('disabled', false).addClass('erreur');
        }

    })

</script>

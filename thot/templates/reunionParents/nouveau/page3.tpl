<div class="row">

    <div class="col-md-6 col-sm-12">

            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">Attribution des locaux {$infoRp.date}</h3>
                </div>

                <div class="panel-body">

                    {if isset($locaux)}

                    <form id="formDetails3">
                        <div style="height:30em; overflow:auto">
                            <table class="table table-condensed">
                                <thead>
                                    <th>Abr</th>
                                    <th>Nom</th>
                                    <th style="width:10em">Local</th>
                                    <th>&nbsp;</th>
                                </thead>

                                <tbody>
                                    {foreach from=$locaux key=acronyme item=data}
                                    <tr>
                                        <td>{$acronyme}</td>
                                        <td>{$data.nom} {$data.prenom}</td>
                                        <td>
                                            <input type="text" name="local_{$acronyme}" value="{$data.local}" class="form-control" maxlength="12">
                                        </td>
                                        <td>
                                            <button type="button" class="btn btn-default down" title="recopier vers le bas">
                                                <i class="fa fa-arrow-down"></i>
                                            </button>
                                        </td>
                                    </tr>
                                    {/foreach}
                                </tbody>

                            </table>
                        </div>
                        <!-- overflow -->

                        <div class="btn-group pull-right">
                            <button type="reset" class="btn btn-default">Annuler</button>
                            <button class="btn btn-primary" type="button" id="btn-page3" data-idrp="{$idRP|default:''}">Enregistrer</button>
                        </div>

                    </form>
                {else}
                <div class="alert alert-info">
                    Définissez d'abord l'horaire et la liste des enseignants concernés à la page 1.
                </div>

                {/if}  <!-- isset($locaux) -->
                </div>

                <div class="panel-footer">

                </div>

            </div>
            <!-- col-md-... -->

        </div>

</div>

<script type="text/javascript">
    $(document).ready(function() {

        $(".down").click(function() {
            var local = $(this).closest('tr').find('input:text').val()
            suivant = $(this).closest('tr').next();
            suivant.find('input:text').val(local);
        })
    })
</script>

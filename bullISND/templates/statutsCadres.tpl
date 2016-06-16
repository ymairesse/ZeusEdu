<div class="container">

    <div class="row">

        <div class="col-md-9 col-sm-12">

            <form action="index.php" method="POST" role="form" class="form-vertical" id="statutsCadres" name="statutsCadres">

                <table class="table table-condensed">
                    <thead>
                        <tr>
                            <th>
                                Cadre du cours<br>
                                (officiel)
                            </th>
                            <th>
                                Ordre
                            </th>
                            <th>
                                Statut du cours<br>
                                (dans l'application)
                            </th>
                        </tr>
                    </thead>

                    <tbody>
                        {foreach from=$statutsCadres key=cadre item=data}
                        <tr>
                            <td>
                                <p class="form-control-static">
                                {$cadre}
                                </p>
                            </td>
                            <td>
                                <input type="text" name="ordre_{$cadre}" value="{$data.rang}" class="form-control rang" required number="true" max="100">
                            </td>
                            <td>
                                <input type="text" name="statut_{$cadre}" value="{$data.statut}" class="form-control statut" required maxlength="6">
                            </td>
                        </tr>
                        {/foreach}
                    </tbody>

                </table>

                <input type="hidden" name="action" value="{$action}">
                <input type="hidden" name="mode" value="{$mode}">
                <input type="hidden" name="etape" value="enregistrer">

                <div class="btn-group pull-right">
                    <button type="reset" class="btn btn-default">Annuler</button>
                    <button type="submit" class="btn btn-primary">Enregistrer</button>
                </div>
                <div class="clearfix"></div>

            </form>

        </div>

        <div class="col-md-3 col-sm-12">

        </div>



    </div>  <!-- row -->

</div>


<script type="text/javascript">

$(document).ready(function(){

    $("#statutsCadres").validate()

})

</script>

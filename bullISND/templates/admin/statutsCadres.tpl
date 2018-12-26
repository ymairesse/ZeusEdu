<div class="container">

    <div class="row">

        <div class="col-md-9 col-sm-12">

            <form action="index.php" method="POST" role="form" class="form-vertical" id="statutsCadres" name="statutsCadres">

                <table class="table table-condensed" style="text-align:center">
                    <thead>
                        <tr>
                            <th style="text-align:center !important">
                                Cadre du cours<br>
                                (officiel)
                            </th>
                            <th style="text-align:center !important">
                                Ordre
                            </th>
                            <th style="text-align:center !important">
                                Statut du cours<br>
                                (dans l'application)
                            </th>
                            <th style="text-align:center !important">
                                Pas d'échec
                            </th>
                            <th style="text-align:center !important">
                                Pas de totalisation
                            </th>
                        </tr>
                    </thead>

                    <tbody>
                        {foreach from=$statutsCadres key=cadre item=data}
                        <tr>
                            <td>
                                <input type="hidden" name="cadre[]" value="{$cadre}">
                                {$cadre}
                            </td>
                            <td>
                                <input type="text" name="rang_{$cadre}" value="{$data.rang}" class="form-control" required number="true" max="100">
                            </td>
                            <td>
                                <input type="text" name="statut_{$cadre}" value="{$data.statut}" class="form-control" required maxlength="6">
                            </td>
                            <td>
                                <input type="checkbox" name="echec_{$cadre}" value="1" {if $data.echec == 1}checked{/if}>
                            </td>
                            <td>
                                <input type="checkbox" name="total_{$cadre}" value="1" {if $data.total == 1}checked{/if}>
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

            {include file="admin/manuel_cadre.html"}

        </div>



    </div>  <!-- row -->

</div>


<script type="text/javascript">

$(document).ready(function(){

    $("#statutsCadres").validate()

})

</script>

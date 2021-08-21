<div class="container-fluid">
    <div class="row">

        <div class="col-xs-3">
            <form id="formRem">

            <div class="form-group">
                <label for="niveau" class="sr-only">Niveau</label>
                <select class="form-control" name="niveau" id="niveau">
                    <option value="">Niveau d'étude</option>
                    {foreach from=$listeNiveaux item=niveau}
                    <option value="{$niveau}">{$niveau}e année</option>
                    {/foreach}
                </select>
            </div>

            <div class="row">
                <div class="form-group col-xs-12 col-md-6">
                    <label for="dateFrom">Depuis le</label>
                    <input type="text" class="datepicker form-control" id="dateFrom" name="dateFrom" value="">
                </div>
                <div class="form-group col-xs-12 col-md-6">
                    <label for="dateTo">Jusqu'au</label>
                    <input type="text" class="datepicker form-control" id="dateTo" name="dateTo" value="">
                </div>

                <div class="col-xs-12">
                    <button type="button" class="btn btn-primary btn-block" id="btn-searchRem">Chercher</button>
                </div>

            </div>

            </form>

        </div>
        <div class="col-xs-9">
            <h3>Liste des offres de remédiation</h3>

            <div id="remediations">
                <p class="avertissement">Sélectionner les critères à gauche</p>
            </div>

        </div>
    </div>

</div>


<script type="text/javascript">

    $(document).ready(function(){



        $('#btn-searchRem').click(function(){
            var formulaire = $('#formRem').serialize();
            $.post('inc/remediations/searchRemediations.inc.php', {
                formulaire: formulaire
            }, function(resultat){
                $('#remediations').html(resultat);
            })
        })


        $('.datepicker').datepicker({
            format: "dd/mm/yyyy",
            clearBtn: true,
            language: "fr",
            calendarWeeks: true,
            autoclose: true,
            todayHighlight: true,
        })
    })

</script>

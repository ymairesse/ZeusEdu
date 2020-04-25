<div class="container-fluid">

    <div class="row">

        <div class="col-md-2 col-sm-12">

            <form id="formSelection" class="hidden-print">

                <h2>Statistiques des connexions</h2>

                <span id="ajaxLoader" class="hidden">
                    <img src="../images/ajax-loader.gif" alt="loading" class="img-responsive">
                </span>

                <div class="form-group">
                    <label for="dateDebut">Depuis</label>
                   <input type="text" name="dateDebut" value="{$date}" id="dateDebut" class="datepicker form-control">
                </div>

                <div class="form-group">
                    <label for="dateFin">Jusqu'à</label>
                   <input type="text" name="dateFin" value="{$date}" id="dateFin" class="datepicker form-control">
                </div>

                <div class="radio">
                    <label><input type="radio" name="cible" value="parents">Parents</label>
                </div>

                <div class="radio">
                    <label><input type="radio" name="cible" value="eleves" checked>Élèves</label>
                </div>

                <div class="form-group">
                    <label for="classe">Classe</label>
                   <select class="form-control" name="classe" id="classe">
                       <option value="">Classe</option>
                       {foreach from=$listeClasses key=wtf item=classe}
                       <option value="{$classe}">{$classe}</option>
                       {/foreach}
                   </select>
                </div>

                <button type="button" class="btn btn-primary btn-block" id="btn-statsParents">Envoyer</button>


            </form>
        </div>

        <div class="col-md-10 col-sm-12" id="lesStats">

        </div>


    </div>

</div>

<script type="text/javascript">

    $(document).ready(function(){

        $(document).ajaxStart(function() {
            $('#ajaxLoader').removeClass('hidden');
        }).ajaxComplete(function() {
            $('#ajaxLoader').addClass('hidden');
        });

        $(".datepicker").datepicker({
            format: "dd/mm/yyyy",
            clearBtn: true,
            language: "fr",
            calendarWeeks: true,
            autoclose: true,
            todayHighlight: true
            });

        $('#btn-statsParents').click(function(){
            var formulaire = $('#formSelection').serialize();
            $.post('inc/stats/statsParents.inc.php', {
                formulaire: formulaire
            }, function(resultat){
                $('#lesStats').html(resultat);
            })
        })
    })

</script>

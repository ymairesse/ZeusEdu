<div class="container">

    <div class="row">

        <h3>Impression des mots de passe "élèves"</h3>

        <div class="col-md-2 col-sm-3">
            <select class="selectClasse form-control" name="selectClasse">
                <option value="">Classe</option>

                {foreach from=$listeClasses item=classe}
                <option value="{$classe}">{$classe}</option>
                {/foreach}

            </select>

        </div>

        <div class="col-md-4 col-sm-4">
            <img src="../images/ajax-loader.gif" alt="wait" class="hidden" id="ajaxLoader">
            <br>
            <button type="button" class="btn btn-primary btn-block hidden" id="tous">Tous les élèves</button>

            <div id="eleves">

            </div>

        </div>

        <div class="col-md-6 col-sm-5" id="print">


        </div>

    </div>

</div>


<script type="text/javascript">
    $(document).ready(function() {

        $(document).ajaxStart(function() {
            $('#ajaxLoader').removeClass('hidden');
        }).ajaxComplete(function() {
            $('#ajaxLoader').addClass('hidden');
        });

        $(".selectClasse").change(function() {
            var classe = $(".selectClasse").val();
            $("#print").addClass('hidden');
            $.post('inc/listeEleves.inc.php', {
                    classe: classe
                },
                function(resultat) {
                    $("#eleves").html(resultat);
                    if (classe != '')
                        $("#tous").removeClass('hidden');
                    else $("#tous").addClass('hidden');
                })
        })

        $("#eleves").on('change', '#selectEleve', function() {
            var matricule = $("#selectEleve").val();
            $.post('inc/eleves/pw2pdf.inc.php', {
                    matricule: matricule
                },
                function(resultat) {
                    $("#print").removeClass('hidden');
                    $("#print").html(resultat);
                })
        })

        $("#tous").click(function() {
            $("#print").addClass('hidden');
            var classe = $(".selectClasse").val();
            if (classe != '')
                $.post('inc/eleves/pwClasse2pdf.inc.php', {
                        classe: classe
                    },
                    function(resultat) {
                        $("#print").removeClass('hidden');
                        $("#print").html(resultat);
                    })
        })
    })
</script>

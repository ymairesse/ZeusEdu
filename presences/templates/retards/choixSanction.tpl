<div class="col-xs-12 col-md-7">
    {if $EDTInstalle}
        {if ($imageEDT != '') && (file_exists('../edt/eleves/{$imageEDT}'))}
        <img src="../edt/eleves/{$imageEDT}" alt="{$imageEDT}" class="img img-responsive">
        {else}
        <p class="avertissement">Horaire EDT non disponible</p>
        {/if}
        {else}
        <p class="avertissement">Le module "EDT (Index Education)" doit être installé pour accéder à l'horaire individuel de l'élève</p>
        <p>Ce module n'est livré que sur demande.</p>
        {/if}
</div>


<div class="col-xs-12 col-md-5">
    <form id="formSanctions">
        <h2>{$eleve.nom} {$eleve.prenom} [{$eleve.classe}]</h2>
        <h3>Liste des retards pour la période</h3>

        <div style="max-height:10em; overflow:auto;">
            {foreach from=$listeRetards key=idRetard item=data}
            <div class="checkbox">
                {assign var=periode value=$data.periode}
                <label><input type="checkbox" class="idRetard" name="idRetards[]" value="{$idRetard}">{$data.date} {$listePeriodes.$periode.debut} (<strong>{$periode}e</strong> heure)</label>

            </div>
            {/foreach}
        </div>

        <h3>Dates de sanctions</h3>
        <div class="input-group">
            <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
            <input type="text"
                readonly
                value=''
                id="datesSanctions"
                class="datepicker form-control"
                placeholder="Cliquer pour ouvrir le calendrier"
                style="color:#aaa;">
        </div>

        <ol id="listeDates">

        </ol>
        <input type="hidden" id="matricule" name="matricule" value="{$matricule}">

        <button type="button" class="btn btn-primary pull-right" id="btn-saveSanction">Enregistrer</button>

        <div class="clearfix"></div>

    </form>

</div>

<script type="text/javascript">

    function putDates(lesDates){
        var listeDates = lesDates.split(',');
        var html = '';
        $.each(listeDates, function(index, value){
            var shortDate = value.split(' ')[1];
            html += '<li>' + value + '<input type="hidden" class="sanctions" name="datesSanctions[]" value="' + shortDate +'"></li>';
        })
        $('#listeDates').html(html);
    }

    $(document).ready(function() {

        $('#formSanctions').validate({
            rules: {
                'idRetards[]': {
                    required: true,
                    minlength: 1
                },
                'datesSanctions': {
                    required: true
                }
            }
        });

        $("#datesSanctions").datepicker({
            multidate: true,
            format: "DD dd/mm/yyyy",
            daysOfWeekDisabled: [0, 6],
            clearBtn: true,
            language: "fr",
            calendarWeeks: true,
            todayHighlight: true,
            autoclose: false
        }).on('changeDate', function(e) {
            var lesDates = $('#datesSanctions').val();
            if (lesDates.length > 0)
                putDates(lesDates);
                else $('#listeDates').html('');
            });

    })
</script>

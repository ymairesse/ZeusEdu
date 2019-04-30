<div class="col-xs-12 col-md-7">
    {if $imageEDT != ''}
    <img src="../edt/eleves/{$imageEDT}" alt="{$imageEDT}" class="img img-responsive">
    {else}
    <p>Horaire non disponible</p>
    {/if}
</div>


<div class="col-xs-12 col-md-5">
    <form id="formSanctions">

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

        {* <ol id="ulDates">

        </ol> *}

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

        $('#btn-saveSanction').click(function(){
            var listeRetards = $('.idRetard:checked');
            var datesSanctions = $('.sanctions');
            if ((listeRetards.length > 0) && (datesSanctions.length > 0)) {
                var formulaire = $('#formSanctions').serialize();
                $.post('inc/retards/saveSanctionRetard.inc.php', {
                    formulaire: formulaire
                }, function(nbTraites){
                    var formulaire = $('#formSelect').serialize();
                    $.post('inc/retards/generateListeRetards.inc.php', {
                        formulaire: formulaire
                        },
                    function (resultat){
                        $("#zoneSynthese").html(resultat);
                        $('.nav-tabs a').eq(0).trigger('click');
                    })
                })
            }
            else bootbox.alert({
                title: 'Erreur',
                message: 'Sélectionnez au moins une date de retard et une date de sanction'
            })
        })

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
            });;

        $('#btnAddDate').click(function() {
            var date = $('#datesSanctions').val();
            if (date != '') {
                var date2 = date.split(' ')[1];
                $('#ulDates').append('<li>' + date + '<input type="hidden" name="dateF[]" value="' + date2 + '"></li>');
                $('#btn-save').prop('disabled', false);
            }
        })

    })
</script>

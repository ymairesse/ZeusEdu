<form class="form-inline microform" id="formListePresences">

    <div class="form-group">
        <select class="form-control" id="niveauPresences" name="niveauPresences">
            <option value="">Choisir le niveau</option>
            {foreach from=$listeNiveaux item=niveau}
                <option value="{$niveau}">{$niveau}e année</option>
            {/foreach}
        </select>
        <label for="niveauPresences" generated="true" class="error"></label>
    </div>

    <div class="form-group">
        <select class="form-control" id="classePresences" name="classePresences">
            <option value="">Choisir la classe</option>
        </select>
        <label for="classePresences" generated="true" class="error"></label>
    </div>

    <div class="form-group">
        <input type="text" class="form-control datepickerFrom" name="debutPresences" id="debutPresences" value="" placeholder="Depuis le">
        <label for="debutPresences" generated="true" class="error"></label>
    </div>

    <div class="form-group">
        <input type="text" class="form-control datepickerTo" name="finPresences" id="finPresences" value="" placeholder="Jusqu'au">
        <label for="finPresences" generated="true" class="error"></label>
    </div>

    <button type="button" class="btn btn-primary btn-sm" id="btn-listePresences">OK</button>

</form>

<script type="text/javascript">

    $(document).ready(function(){

        today = moment().format('DD/MM/YYYY');
        prevDate = moment().subtract(1, 'months').format('DD/MM/YYYY');

        $('#debutPresences').val(prevDate);
        $('#finPresences').val(today);

        $(".datepickerFrom").datepicker({
            format: "dd/mm/yyyy",
            clearBtn: true,
            language: "fr",
            calendarWeeks: true,
            autoclose: true,
            todayHighlight: true,
            daysOfWeekDisabled: [0,6],
        });

        $(".datepickerTo").datepicker({
            format: "dd/mm/yyyy",
            clearBtn: true,
            language: "fr",
            calendarWeeks: true,
            autoclose: true,
            todayHighlight: true,
            daysOfWeekDisabled: [0,6],
        });

        $('#formPresences').validate({
            rules: {
                niveauPresences: {
                    required: true
                },
                classePresences: {
                    required: true
                },
                debutPresences: {
                    required: true,
                    uneDate: true
                },
                finPresences: {
                    required: true,
                    uneDate: true
                }
            }
        })

    })

</script>

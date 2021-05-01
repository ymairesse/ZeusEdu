<form id="formJustif">

    <input type="hidden" name="educ" value="{$identite.acronyme}">

    <h3>{if $mode == 'speed'}<i class="fa fa-bolt"></i>{/if} {$eleve.nom} {$eleve.prenom}: {$eleve.groupe}</h3>

    <input type="hidden" name="matricule" id="matricule" value="{$matricule}">

    <div class="input-group">
        {if $mode == 'speed'}
            {* il s'agit de traiter une autorisation de sortie rapide *}
            <input type="text" name="parent" id="parent" maxlength="40" value="Parents" placeholder="Correspondant" class="form-control speed">
        {else} {* c'est une justification d'absence "classique" *}
            <input type="text" name="parent" id="parent" maxlength="40" value="" placeholder="Correspondant" class="form-control">
        {/if}

        <div class="input-group-btn">
            <button type="button" class="btn btn-primary dropdown-toggle" data-toggle="dropdown">
                Choisir <span class="caret"></span>
            </button>
            <ul class="dropdown-menu pull-right" id="choixCorrespondant">
                <li><a data-correspondant="Parents" href="javascript:void(0)"><strong>Parents</strong></a></li>
                <li><a data-correspondant="{$eleve.nomResp}" href="javascript:void(0)"><strong>Responsable:</strong>
                    {$eleve.nomResp|truncate:40}
                </a></li>
                <li><a href="javascript:void(0)" data-correspondant="{$eleve.nomMere}"><strong>Mère:</strong>
                    {$eleve.nomMere|truncate:40}
                </a></li>
                <li><a href="javascript:void(0)" data-correspondant="{$eleve.nomPere}"><strong>Père:</strong>
                    {$eleve.nomPere|truncate:40}
                </a></li>
                <li><a href="javascript:void(0)" data-correspondant="Autre"><strong>Autre</strong></a></li>
            </ul>
        </div>
    </div>
    <!-- input-group -->

    <div class="input-group">
        {if $mode == 'speed'}
            <input type="text" name="media" id="media" maxlength="30" value="Journal de classe" placeholder="Média" class="form-control speed">
        {else}
            <input type="text" name="media" id="media" maxlength="30" value="{$post.media|default:''}" placeholder="Média" class="form-control">
        {/if}
        <div class="input-group-btn">
            <button type="button" class="btn btn-primary dropdown-toggle" data-toggle="dropdown">
                Choisir <span class="caret"></span>
            </button>
            <ul class="dropdown-menu pull-right" id="choixMedia">
                <li><a href="javascript:void(0)" data-value="Journal de Classe">Journal de Classe</a></li>
                <li><a href="javascript:void(0)" data-value="Motif manuscrit">Motif mansucrit</a></li>
                <li><a href="javascript:void(0)" data-value="Téléphone">Par téléphone</a></li>
                <li><a href="javascript:void(0)" data-value="Mail">Mail</a></li>
                <li><a href="javascript:void(0)" data-value="Autre">Autre</a></li>
            </ul>
        </div>
        <!-- input-group-btn -->
    </div>
    <!-- input-group -->

    <label for="periodeFrom">Depuis</label>
    <div class="input-group">
        <select class="form-control" name="periodeFrom" id="periodeFrom" autocomplete="off">
            {foreach from=$listePeriodes key=periode item=data}
                <option value="{$periode}"{if $periode == $periodeFrom} selected{/if}>{$data.debut}</option>
            {/foreach}
        </select>
        <span class="input-group-btn" style="width:0"></span>
        <input type="text" class="form-control datepicker" id="dateFrom" name="dateFrom" value="{$dateFrom}" autocomplete="off">
        <span class="input-group-btn">
        <button class="btn btn-default openCal" type="button"><i class="fa fa-calendar"></i></button>
        </span>
    </div>

    <label for="periodeTo">Jusqu'à</label>
    <div class="input-group">
        <select class="form-control" name="periodeTo" id="periodeTo" autocomplete="off">
            {foreach from=$listePeriodes key=periode item=data}
                <option value="{$periode}"{if $periode == $periodeTo} selected{/if}>{$data.debut}</option>
            {/foreach}
        </select>
        <span class="input-group-btn" style="width:0"></span>
        <input type="text" class="form-control datepicker" id="dateTo" name="dateTo" value="{$dateTo}" autocomplete="off">
        <span class="input-group-btn">
        <button class="btn btn-default openCal" type="button"><i class="fa fa-calendar"></i></button>
        </span>
    </div>

    <div class="input-group">
        <select class="form-control" name="justification" id="selectJustification">
            <option value="">Sélectionner une justification</option>
            {foreach from=$statutsAbs key=uneJustification item=data}
                <option value="{$uneJustification}" {if (($mode == 'speed') && ($uneJustification == $justification))}selected{/if}>{$data.libelle}</option>
            {/foreach}
        </select>
        <span class="input-group-btn">
        <button class="btn btn-default openSelect" type="button">
            <i class="fa fa-arrow-down"></i> <i class="fa fa-arrow-down"></i> <i class="fa fa-arrow-down"></i>
        </button>
        </span>
    </div>

    <ul class="erreurEncodage"></ul>

    <div class="btn-group  btn-group-justified" style="padding: 1em 0 2em">
        <a href="javascript:void(0)" class="btn btn-default" id="resetForm">Annuler</a>
        <a href="javascript:void(0)" class="btn btn-primary" id="btn-saveJustification">Enregistrer</a>
    </div>

    <div id="tableauAbsences" style="max-height:20em; overflow:auto;">

    </div>


    {include file='legendeAbsences.tpl'}

</form>

<script type="text/javascript">

    function veryMuch(dateFrom, dateTo){
        var a = moment(dateFrom, 'D/M/YYYY');
        var b = moment(dateTo, 'D/M/YYYY');
        var diffDays = b.diff(a, 'days');
        if (diffDays > 15)
            bootbox.alert({
                title: 'Veuillez vérifier',
                message: 'Vous avez sélectionné <strong>' + diffDays +' jours d\'absences</strong>. Est-ce normal?'
            });
    }

    function ordreDates(dateFrom, dateTo){
        var a = moment(dateFrom,'D/M/YYYY');
        var b = moment(dateTo,'D/M/YYYY');
        var diffDays = b.diff(a, 'days');
        if (diffDays < 0)
            bootbox.alert({
                title: 'Veuillez vérifier',
                message: 'La date de début est ultérieure à la date de fin.'
            })
    }

    $(document).ready(function(){

        jQuery.validator.addMethod("fromToDate", function(value, element) {
            var a = moment($('#dateFrom').val(),'D/M/YYYY');
            var b = moment($('#dateTo').val(),'D/M/YYYY');
            var diffDays = b.diff(a, 'days');
            return this.optional(element) || (diffDays >= 0);
        }, "La date de début est < date de fin");

        $('#formJustif').validate({
            rules: {
                parent: 'required',
                media: 'required',
                dateTo: 'fromToDate',
                justification: 'required',
            },
            messages: {
                matricule: 'quel élève?',
                parent: 'Précisez un correspondant',
                media: 'Précisez un média',
                justification: 'Précisez une justification',
                dateTo: 'La date de début est ultérieure à la date de fin'
            },
            errorElement : 'li',
            errorLabelContainer: '.erreurEncodage'
        })

        $('#btn-saveJustification').click(function(){
            if ($('#formJustif').valid()){
                var formulaire = $('#formJustif').serialize();
                var matricule = $('#matricule').val();
                $.post('inc/absences/saveJustifications.inc.php', {
                    formulaire: formulaire
                }, function(resultat){
                    if (resultat > 0) {
                        bootbox.alert({
                            title: 'Enregistrement',
                            message: resultat +' enregistrements effectués'
                        });
                        $.post('inc/absences/getListeAbsencesEleve.inc.php', {
                            matricule: matricule
                        }, function(resultat){
                            $('#listeAbsences').html(resultat)
                        })
                    }
                    else bootbox.alert({
                        title: 'Enregistrement',
                        message: 'Aucune information enregistrée'
                    })
                })
            }
        })

        $('#resetForm').click(function(){
            $('#formJustif').trigger('reset');
        })

        $('.openCal').click(function(){
            $(this).closest('span').prev('.datepicker').datepicker().focus();
        })
        $('.openSelect').click(function(){
            $(this).closest('span').prev('select').focus();
        })

        $('#selectJustification').change(function(){
            var justif = $(this).val();
            if (justif != '') {
                var fgColor = $('.justif[data-justif="' + justif + '"]').css('color');
                var bgColor = $('.justif[data-justif="' + justif + '"]').css('background-color');
            }
            else {
                var fgColor = '';
                var bgColor = '';
            }
            $('.openSelect').css({ 'color': fgColor, 'background-color': bgColor });
        })

        $("#choixMedia li a").click(function() {
            $('#media').val($(this).attr('data-value'));
        })

        $('#choixCorrespondant li a').click(function() {
            var correspondant = $(this).data('correspondant');
            $('#parent').val(correspondant);
        })

        {if $mode == 'speed'}
            var dateFrom = $('#dateFrom').val();
            var dateTo = $('#dateTo').val();
            var periodeFrom = $('#periodeFrom').val();
            var periodeTo = $('#periodeTo').val();
            var justification = $('#selectJustification').val();
            $.post('inc/absences/getCalendrier.inc.php', {
                dateFrom: dateFrom,
                dateTo: dateTo,
                periodeFrom: periodeFrom,
                periodeTo: periodeTo,
                justification: justification
            }, function(resultat){
                $('#tableauAbsences').html(resultat);
            })

            var fgColor = $('.justif[data-justif="' + justification + '"]').css('color');
            var bgColor = $('.justif[data-justif="' + justification + '"]').css('background-color');
            $('.openSelect').css({ 'color': fgColor, 'background-color': bgColor });
        {/if}

        $('#periodeFrom, #periodeTo, #selectJustification').on('change', function(){
            var dateFrom = $('#dateFrom').val();
            var dateTo = $('#dateTo').val();
            var periodeFrom = $('#periodeFrom').val();
            var periodeTo = $('#periodeTo').val();
            var justification = $('#selectJustification').val();
            $.post('inc/absences/getCalendrier.inc.php', {
                dateFrom: dateFrom,
                dateTo: dateTo,
                periodeFrom: periodeFrom,
                periodeTo: periodeTo,
                justification: justification
            }, function(resultat){
                $('#tableauAbsences').html(resultat);
            })
        })

        $('#dateFrom, #dateTo').datepicker({
            format: "dd/mm/yyyy",
            clearBtn: true,
            language: "fr",
            calendarWeeks: true,
            autoclose: true,
            todayHighlight: true,
            daysOfWeekDisabled: [0,6],
        }).on('changeDate', function(e){
            var dateFrom = $('#dateFrom').val();
            var dateTo = $('#dateTo').val();
            var periodeFrom = $('#periodeFrom').val();
            var periodeTo = $('#periodeTo').val();
            var justification = $('#selectJustification').val();
            veryMuch(dateFrom, dateTo);
            ordreDates(dateFrom, dateTo)
            $.post('inc/absences/getCalendrier.inc.php', {
                dateFrom: dateFrom,
                dateTo: dateTo,
                periodeFrom: periodeFrom,
                periodeTo: periodeTo,
                justification: justification
            }, function(resultat){
                $('#tableauAbsences').html(resultat);
            })
        })

    })

</script>

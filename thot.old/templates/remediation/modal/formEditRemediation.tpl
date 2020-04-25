<div class="row">

    <div class="col-md-6 col-sm-12">
        <div class="form-group">
            <label for="title">Matière</label>
            <input type="text" class="form-control" name="title" id="title" value="{$offre.title}" placeholder="Matière de la remédiation" maxlength="50">
        </div>
    </div>
    <div class="col-md-3 col-sm-6">
        <div class="form-group">
            <label for="date">Date</label>
            <input type="text" name="date" value="{$offre.startDate}" id="date" class="form-control datepicker" maxlength="10">
        </div>
    </div>
    <div class="col-md-3 col-sm-6">
        <div class="form-group">
            <label for="time">Heure</label>
            <input type="text" name="heure" value="{$offre.heure|truncate:5:''}" class="form-control timepicker" id="time" placeholder="heure" maxlength="5">
        </div>

    </div>

    <div class="col-sm-12">
        <div class="form-group">
            <label for="contenu">Objet de la remédiation, prérequis, matériel nécessaire,...</label>
            <textarea name="contenu" id="contenu" cols="30" rows="2" class="form-control" placeholder="Objet de votre remédiation">{$offre.contenu}</textarea>
        </div>
    </div>

</div>

<div class="row">

    <div class="col-md-3 col-sm-6">
        <div class="form-group">
            <label for="local">Local</label>
            <input type="text" name="local" id="local" class="form-control" value="{$offre.local}" placeholder="Local" maxlength="12">
        </div>
    </div>

    <div class="col-md-3 col-sm-6">
        <div class="form-group">
            <label for="places">Places</label>
            <input type="text" name="places" id="places" class="form-control" value="{$offre.places}" maxlength="2">
        </div>
    </div>

    <div class="col-md-4 col-sm-6">

        <div class="form-group">
            <label for="duree">Durée (min)</label>
            <div class="input-group">
            <input type="text" name="duree" id="duree" class="form-control input-sm" value="{$offre.duree|default:''}" autocomplete="off">

            <div class="input-group-btn">
                <button id="listeDurees" type="button" class="btn btn-primary btn-sm dropdown-toggle" data-toggle="dropdown">(min) <span class="caret"></span>
                </button>
                {assign var=heures value=range(0,8)}
                <ul class="dropdown-menu pull-right" id="choixDuree">
                    {foreach from=$heures item=duree}
                        <li><a href="javascript:void(0)" data-value="{$duree*50}">{$duree}x50'</a></li>
                    {/foreach}
                        <li><a href="javascript:void(0)" data-value="-">Autre</a></li>
                </ul>
            </div>    <!-- input-group-btn -->
        </div>
    </div>  <!-- form-group -->

    </div>

    <div class="col-md-2 col-sm-6" title="Les élèves ne voient pas les remédiations cachées">
        <label class="checkbox-inline">
      <input type="checkbox" name="cache" value="1" {if $offre.cache==1 }checked{/if}>Caché</label>
    </div>

</div>

<input type="hidden" name="idOffre" value="{$offre.idOffre}">
<input type="hidden" name="idClone" value="{$offre.idClone|default:''}">

<script type="text/javascript">

    $('document').ready(function() {

        var today = new Date();
        today.setDate(today.getDate());

        $("#choixDuree li a").click(function(){
            $("#duree").val($(this).attr("data-value"))
            })

        $(".timepicker").timepicker({
            defaultTime: 'current',
            minuteStep: 10,
            showSeconds: false,
            showMeridian: false
        });

        $(".datepicker").datepicker({
            startDate: today,
            format: "dd/mm/yyyy",
            clearBtn: true,
            language: "fr",
            calendarWeeks: true,
            autoclose: true,
            todayHighlight: true,
            daysOfWeekDisabled: [0,6],
        });

    })

</script>

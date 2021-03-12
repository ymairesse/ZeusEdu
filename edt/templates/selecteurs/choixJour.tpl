<div class="input-group pull-right" style="width:350px">
    <span class="input-group-btn">
        <a href="#" class="btn btn-primary changeDate" data-change="-7" title="- 1 semaine">
            <i class="fa fa-fast-backward"></i>
        </a>
        <a href="#" class="btn btn-primary changeDate"  data-change="-1" title="-1 jour">
            <i class="fa fa-arrow-left"></i>
        </a>
    </span>

    <input class="form-control datepicker" name="date" id="choixDate" style="font-size:16pt;" value="">

    <span class="input-group-btn">
        <a href="#" class="btn btn-success" id="btn-confirmDate" title="Confirmer">
            <i class="fa fa-check"></i>
        </a>
        <a href="#" class="btn btn-primary changeDate"  data-change="+1" title="+1 jour">
            <i class="fa fa-arrow-right"></i>
        </a>
        <a href="#" class="btn btn-primary changeDate"  data-change="+7" title="+ 1 semaine">
            <i class="fa fa-fast-forward"></i>
        </a>
    </span>
</div>
<div class="clearfix"></div>

<script type="text/javascript">
    $(document).ready(function() {

        $('#choixDate').datepicker({
            clearBtn: true,
            language: "fr",
            calendarWeeks: true,
            autoclose: true,
            todayHighlight: true,
            daysOfWeekDisabled: '06',
        });

    })
</script>

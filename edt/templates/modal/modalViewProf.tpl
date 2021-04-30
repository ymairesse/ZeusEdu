<div id="modalViewProf" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalViewProfLabel" aria-hidden="true" data-acronyme="{$acronyme}">
  <div class="modal-dialog">
    <div class="modal-content" style="width:500px">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalViewProfLabel">Absences de {$acronyme}</h4>
      </div>
      <div class="modal-body" id="calendar">

      </div>

    </div>
  </div>
</div>

<style media="screen">
    #calendar {
        margin: 0 auto;
        font-size: 10px;
    }

    .fc-toolbar {
    font-size: .9em;
    }
    .fc-toolbar h2 {
    font-size: 12px;
    white-space: normal !important;
    }
    /* click +2 more for popup */
    .fc-more-cell a {
    display: block;
    width: 85%;
    margin: 1px auto 0 auto;
    border-radius: 3px;
    background: grey;
    color: transparent;
    overflow: hidden;
    height: 4px;
    }
    .fc-more-popover {
    width: 100px;
    }
    .fc-view-month .fc-event, .fc-view-agendaWeek .fc-event, .fc-content {
    font-size: 0;
    overflow: hidden;
    height: 2px;
    }
    .fc-view-agendaWeek .fc-event-vert {
    font-size: 0;
    overflow: hidden;
    width: 2px !important;
    }
    .fc-agenda-axis {
    width: 20px !important;
    font-size: .7em;
    }

    .fc-button-content {
    padding: 0;
    }
</style>

<script type="text/javascript">

    $(document).ready(function(){

        $('#calendar').fullCalendar({
       header: {
           left: 'prev,next today',
           center: 'title',
           right: ''
       },
       // add event name to title attribute on mouseover
       eventMouseover: function (event, jsEvent, view) {
           if (view.name !== 'agendaDay') {
               $(jsEvent.target).attr('title', event.title);
           }
       },
       eventLimit: true, // allow "more" link when too many events
       eventSources: [
           {
           url: 'inc/eventsCalendar.json.php',
           type: 'POST',
           data: {
               acronyme: $('#modalViewProf').data('acronyme'),
               },
           error: function() {
               alert('Attention, vous semblez avoir perdu la connexion à l\'Internet');
               }
           }
       ]
   });

})

</script>

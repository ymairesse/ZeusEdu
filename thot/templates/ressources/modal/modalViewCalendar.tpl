<div id="modalViewCalendar" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalViewCalendarLabel" aria-hidden="true" data-idressource="{$idRessource}">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalViewCalendarLabel">{$description} Réf: [{$reference}]</h4>
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
        width: 65%;
        margin: 5px auto 5px auto;
        border-radius: 3px;
        background: orangered;
        color: transparent;
        overflow: hidden;
        float: right;
        height: 5px;
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
            weekends: false,
            navLinks: true,
            header: {
               left: 'prev,next today',
               center: 'title',
               right: 'month,agendaWeek,agendaDay'
           },
           minTime: "08:00:00",
           maxTime: "22:00:00",
           eventLimit: 3,
           defaultTimedEventDuration: '00:50',
           // add event name to title attribute on mouseover
           eventMouseover: function (event, jsEvent, view) {
               if (view.name !== 'agendaDay') {
                   $(jsEvent.target).attr('title', event.title);
               }
           },
           eventRender: function(event, element, view) {
               if (view.name == 'month')
                    element.html(event.reservation);
                    else element.html(event.title);
           },
           eventSources: [
               {
               url: 'inc/ressources/eventsCalendar.json.php',
               type: 'POST',
               data: {
                   idRessource: $('#modalViewCalendar').data('idressource'),
                   },
               error: function() {
                   alert('Attention, vous semblez avoir perdu la connexion à l\'Internet');
                   }
               }
           ]
       });

})

</script>

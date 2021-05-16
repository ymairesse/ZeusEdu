<div class="container-fluid" style="height:35em; overflow:auto">

    <table class="table table-condensed">
        <thead>
            <tr>
                <th>Nom</th>
                <th>Dates sanction</th>
                <th>Date retour</th>
                <th>Total<br>Retards</th>
            </tr>
        </thead>

        <tbody>
            {foreach from=$listeRetards key=matricule item=data}
                {foreach from=$data key=idTraitement item=unTraitement}
                <tr>
                    <td>{$unTraitement.npc}</td>
                    <td>{$unTraitement.datesSanction|implode:'<br>'}</td>
                    <td>{$unTraitement.dateRetour|truncate:5:''|default:"-"}</td>
                    <td data-toggle="popover"
                        data-title="Retards de {$unTraitement.npc}"
                        data-content="<div style='max-height:15em;overflow:auto'>{'<li>'|implode:$allRetards.$matricule}</div>">
                        <span class="badge" style="cursor:pointer">{$allRetards.$matricule|@count}</span>
                    </td>
                </tr>
                {/foreach}
            {/foreach}
        </tbody>

    </table>

</div>

<script type="text/javascript">

    $(document).ready(function(){

    $('.popover').remove();
    $('body').on('click', '.popover', function(){
        $('.popover').hide();
    })

    $('[data-toggle="popover"]').click(function(){
        $("[data-toggle='popover']").not(this).popover('hide');
      });

      $('[data-toggle="popover"]').popover({
           container: 'body',
           trigger: 'click',
           html: true,
           placement: 'left',
      });

    });

</script>

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
                    <td class="pop"
                        data-toggle="popover"
                        data-trigger="hover"
                        data-html="true"
    					data-container="body"
                        data-placement="left"
                        data-content="<h4>Dates des retards</h4><br>{'<br>'|implode:$allRetards.$matricule}">
                        <span class="badge">{$allRetards.$matricule|@count}</span>
                    </td>
                </tr>
                {/foreach}
            {/foreach}
        </tbody>

    </table>

</div>

<script type="text/javascript">

    $(document).ready(function(){

      $('[data-toggle="popover"]').popover();
      
    });

</script>

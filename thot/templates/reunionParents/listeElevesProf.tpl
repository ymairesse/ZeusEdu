<div class="panel-group" id="elevesProfs">

{foreach from=$listeEleves key=classe item=lesEleves}

  <div class="panel panel-default">

    <div class="panel-heading">
      <h4 class="panel-title">
        <a data-toggle="collapse" data-parent="#" href="#{$classe}">{$classe} </a>
      </h4>
    </div>

    <div id="{$classe}" class="panel-collapse collapse">

      <div class="panel-body" style="max-height: 35em; overflow:auto;">

        <ul class="list-unstyled" id="listeElevesClasse">
        {foreach from=$lesEleves key=matricule item=data}
        <li>
            <button type="button" class="btn btn-default btn-sm btn-block btn-eleve" data-matricule="{$matricule}">{$data.nom} {$data.prenom}</button>
        </li>
        {/foreach}
        </ul>

      </div>

    </div>

</div>  <!-- panel-default -->

 {/foreach}
</div>

<script type="text/javascript">

$(document).ready(function(){

    $(".btn-eleve").click(function(){
        $(".btn-eleve").removeClass('btn-primary').addClass('btn-default');
        $(this).addClass('btn-primary').removeClass('btn-default');
    })

})

</script>

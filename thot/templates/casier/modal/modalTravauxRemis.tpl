<div id="modalTravauxRemis" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalTravauxRemisLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalTravauxRemisLabel">État de la remise du travail</h4>
      </div>
      <div class="modal-body" style="max-height:35em; overflow: auto">

          <table class="table table-condensed">

              <thead>
                  <tr>
                      <th>Classe</th>
                      <th>Nom</th>
                      <th>Remis</th>
                      <th>Note</th>
                  </tr>
              </thead>
              <tbody>
                  {assign var=remis value=0}
                  {foreach from=$travauxRemis key=matricule item=data}
                  {if $data.remis == 1}
                    {assign var=remis value=$remis+1}
                  {/if}
                  <tr class="{if $data.remis == 1}bg-success{else}bg-danger{/if}" data-matricule="{$matricule}">
                      <td>{$data.groupe}</td>
                      <td>{$data.nom} {$data.prenom}</td>
                      <td>{if $data.remis > 0}{$data.remis} <i class="fa fa-file-o"></i> {else}&nbsp;{/if}</td>
                      <td>
                        {assign var=eval value=$listeEvaluations.$matricule.total}
                        {if $eval.cote|is_numeric}
                            {$eval.cote} / {$eval.max}
                        {else}
                            &nbsp;
                        {/if}
                    </td>
                  </tr>
                  {/foreach}
              </tbody>

          </table>
      </div>
      <div class="modal-footer">
          {assign var=nonRemis value=$travauxRemis|count - $remis}
        <span class="micro">{$travauxRemis|count} élèves [<i class="bg-success">{$remis}R</i> / <i class="bg-danger">{$nonRemis}NR]</i></span>
      </div>
    </div>
  </div>
</div>

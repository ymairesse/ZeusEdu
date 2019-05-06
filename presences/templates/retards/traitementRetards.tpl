<h2>Traitement des retards
    {if isset($form.matricule) && $form.matricule != Null} d'un élève
        {elseif isset($form.classe) && ($form.classe != Null)} de la classe {$form.classe}
        {elseif $form.niveau != Null} des élèves de {$form.niveau}e année
        {else}de tous les élèves
    {/if}
</h2>

<h3>Du {$form.debut} au {$form.fin}</h3>

<ul class="nav nav-tabs">
  <li class="active"><a data-toggle="tab" href="#liste">Liste des élèves</a></li>
  <li><a class="btn disabled" data-toggle="tab" href="#traitement">Traitement</a></li>
</ul>

<div class="tab-content">

  <div id="liste" class="tab-pane fade in active" style="max-height:25em; overflow: auto;">

      <strong>{$listeRetards|@count} élèves</strong>

      <form name="formPrint" id="formPrint" action="inc/retards/printRetards.inc.php" method="POST">

          <button type="submit" name="printRetards" id="printRetards" class="btn btn-primary pull-right" disabled>Imprimer</button>
          <table class="table table-condensed">
              <tr>
                  <th>Classe</th>
                  <th>Nom</th>
                  <th style="width:6em" title="Carte prête à distribuer">Traité</th>
                  <th style="width:6em" title="Carte complétée reçue">Retour</th>
                  <th style="width:6em">Non traité</th>
                  <th style="width:6em">Impression</th>
                  <th style="width:4em">&nbsp;</th>
              </tr>

              {foreach from=$listeRetards key=matricule item=dataRetards}
                  {assign var=nonTraite value=$dataRetards.nonTraite|@count|default:0}
                  <tr data-matricule="{$matricule}"
                    data-traite="{$dataRetards.traite|@count}"
                    data-nonTraite="{$nonTraite}">
                      <td>{$dataRetards.classe}</td>
                      <td title="{$matricule}">{$dataRetards.nom}</td>
                      <td>
                          {foreach from=$dataRetards.traite key=idTraitement item=data}
                              <button
                                type="button"
                                data-matricule="{$matricule}"
                                data-idtraitement="{$idTraitement}"
                                class="btn btn-danger btn-sm btn-edit btn-block">
                                    <i class="fa fa-pencil"></i> {$idTraitement}
                                </button>
                            {/foreach}
                      </td>
                      <td>
                          {foreach from=$dataRetards.retourne key=idTraitement item=data}
                          <button
                            type="button"
                            data-matricule="{$matricule}"
                            data-idtraitement="{$idTraitement}"
                            class="btn btn-warning btn-xs btn-edit btn-block"
                            style="color: black">
                                <i class="fa fa-pencil"></i> {$idTraitement}
                            </button>
                          {/foreach}
                      </td>
                      <td>
                          <span class="label label-info nonTraite" style="color: black;">{$nonTraite}</span>
                      </td>
                      <td>
                          {foreach from=$dataRetards.traite key=idTraitement item=data}
                              <button
                                type="button"
                                data-matricule="{$matricule}"
                                data-idtraitement="{$idTraitement}"
                                class="btn btn-default btn-sm btn-printer btn-block"
                                style="margin-bottom:4px">  {* pour que le bouton ait la même hauteur que les boutons de traitement... strange...*}
                                    <i class="fa fa-print"></i> {$idTraitement}
                                </button>
                                <input type="hidden" name="toPrint[]" class="toPrint" value="" style="padding">
                            {/foreach}
                      </td>
                      <td data-toggle="popover"
                            data-placement="left"
                            data-trigger="hover"
                            data-content="{if $nonTraite > 0}Intervention{else}Entièrement traité{/if}">
                          <button
                              type="button"
                              class="btn btn-success btn-sm btn-block btn-traitement"
                              {if $nonTraite == 0} disabled{/if}
                              data-matricule="{$matricule}"
                              data-debut="{$form.debut}"
                              data-fin="{$form.fin}">
                              <i class="fa fa-pencil"></i>
                          </button>
                      </td>
                  </tr>

              {/foreach}

          </table>

        </form>
  </div>

  <div id="traitement" class="tab-pane fade">

  </div>

</div>

<div id=modal>

</div>

<script type="text/javascript">

    $(document).ready(function(){
        $('[data-toggle="popover"]').popover();
    })

    $('#liste').on('click', '.btn-edit', function(){
        var matricule = $(this).data('matricule');
        var idTraitement = $(this).data('idtraitement');
        $.post('inc/retards/getEditBilletRetard.inc.php', {
            matricule: matricule,
            idTraitement: idTraitement
        }, function(resultat){
            $('#modal').html(resultat);
            $('#modalEditRetard').modal('show');
        })

    })

    $('.btn-traitement').click(function(){
        var matricule = $(this).data('matricule');
        var debut = $(this).data('debut');
        var fin = $(this).data('fin');
        $.post('inc/retards/getTraitementEleve.inc.php', {
            matricule: matricule,
            debut: debut,
            fin: fin
        }, function(resultat){
            $('#traitement').html(resultat);
            $('a[href="#traitement"]').removeClass('disabled').trigger('click');
        })
    })

</script>

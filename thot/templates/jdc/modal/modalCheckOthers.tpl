
<div id="modalCheck" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalCheckLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalCheckLabel">Autres travaux pour le {$date}</h4>
      </div>
      <div class="modal-body" style="height:25em; overflow:auto;">

          <table class="table table-condensed">
              {foreach from=$listeEleves key=matricule item=dataEleve}
                <tr>
                    <td style="width:15em;">{$dataEleve.nom} {$dataEleve.prenom} {$dataEleve.groupe}</td>
                    <td>
                        {foreach from=$events.$matricule key=wtf item=dataEvent}
                        <span class="{$dataEvent.className} hidden" title="{$dataEvent.title} {$dataEvent.enonce}">{$dataEvent.start|substr:11:5} {$dataEvent.destinataire}</span>
                        {/foreach}
                    </td>
                </tr>
              {/foreach}
          </table>

      </div>

      <div class="modal-footer">

          {foreach from=$categories key=id item=data name=loop}
            {$checkItem[$smarty.foreach.loop.index]}
              {assign var=long value=$data.categorie|strpos:' '}
              {$long = ($long == Null) ? 99 : $long}
              <label class="checkbox-inline cat_{$id}" title="{$data.categorie}">
                  <input type="checkbox" data-id="{$id}" value="{$id}" class="cb-item" checked>
                  {$data.categorie|substr:0:$long}
              </label>

          {/foreach}
      </div>

    </div>
  </div>
</div>

<script type="text/javascript">

    $(document).ready(function(){

        if (Cookies.get('checkItem') != undefined) {
            var checkItem = JSON.parse(Cookies.get('checkItem'));
            $('.cb-item').each(function(){
                var id = parseInt($(this).val());
                if (checkItem.includes(id)) {
                    $(this).prop('checked', true);
                    $('#modalCheck table .cat_' + id).removeClass('hidden');
                    }
                    else ($(this).prop('checked', false));
                })
            }
            else { // 1ère fois dans la fonction, le Cookie n'existe pas encore
                    $('.cb-item').each(function(){
                    var id = parseInt($(this).val());
                    $('#modalCheck table .cat_' + id).removeClass('hidden');
                    })
                }

        $('.cb-item').change(function(){
            var arItem = [];
            $('.cb-item').each(function(){
                id = parseInt($(this).val());
                if ($(this).is(':checked'))
                    arItem.push(+id)
                    else arItem.push(-id)
            })
            Cookies.set('checkItem', JSON.stringify(arItem), { expires: 30, path: '/peda/thot/' });
        })

        $('#modalCheck input:checkbox').change(function(){
            var checked = $(this).is(':checked');
            var id=$(this).data('id');
            $('#modalCheck table .cat_' + id).toggleClass('hidden');
        })
    })

</script>

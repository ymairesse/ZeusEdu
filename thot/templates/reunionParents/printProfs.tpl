<div class="container-fluid">

    <div class="row">

        <div class="col-md-4 col-sm-6">

            <form class="form-vertical" name="formProfs" id="formProfs">

            <div class="form-group">
              <label for="listeDates">Dates des réunions de parents</label>
              <select class="form-control" name="listeDates" id="listeDates">
                  {if $listeDates|count != 1}
                  <option value="">Sélectionner la date</option>
                  {/if}
                  {foreach from=$listeDates item=uneDate}
                      <option value="{$uneDate}" {if $listeDates|count == 1}selected{/if}>{$uneDate}</option>
                  {/foreach}
              </select>
            </div>



            <div id="listeProfs">

                {include file='reunionParents/listeProfsRP.tpl'}

            </div>

            </form>
        </div>

        <div class="col-md-4 col-sm-6">

            <p><i class="fa fa-info-circle fa-2x"></i> Sélectionner la date de la réunion de parents et les professeurs dont vous souhaitez imprimer la liste des RV.</p>

            <button type="button" class="btn btn-primary btn-block" id="generateListes">Générer les listes de RV</button>

        </div>

    </div>

</div>

<script type="text/javascript">

    $(document).ready(function(){

        $("#listeProfs").on('click', '#btnSelectProfs', function(){
            $("#selectProfs option").prop('selected', true);
        })

        $("#generateListes").click(function(){
            var post = $("#formProfs").serialize();
            $.post('inc/reunionParents/pdfProfs.inc.php', {
                post: post
            },
            function(resultat){

            })
        })
    })

</script>

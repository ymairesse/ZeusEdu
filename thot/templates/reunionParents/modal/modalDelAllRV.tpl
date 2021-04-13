<div id="modalDelAllRV" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalDelAllRVLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalDelAllRVLabel">Annulation des RV</h4>
      </div>
      <div class="modal-body">

          <p>Vous allez annuler <strong>{$listeRV|@count} rendez-vous</strong></p>

          <form id="form-delAllRV">
          <div style="height:8em; overflow: auto; margin-bottom: 1em;">
              <table class="table table-condensed">
                  <tr>
                      <th>&nbsp;</th>
                      <th>Heure</th>
                      <th>Élève</th>
                      <th>Parent</th>
                      <th>Mail</th>
                  </tr>
                  {foreach from=$listeRV key=idRV item=data name=boucle}
                    {if $data.dispo == 0}
                    <tr>
                        <td>{$smarty.foreach.boucle.iteration}</td>
                        <td>{$data.heure}</td>
                        <td>{$data.nom} {$data.prenom} {$data.groupe}</td>
                        <td>{$data.formule} {$data.nomParent} {$data.prenomParent}</td>
                        <td>{$data.mail}</td>
                    </tr>
                    {/if}
                  {/foreach}
              </table>
          </div>

          <p><strong>Veuillez préciser ci-dessous la raison de l'annulation des rendez-vous.</strong></p>
          <p>Cette information sera transmise par mail à tous les parents déjà inscrits et dont l'adresse figure dans la liste ci-dessus. Les élèves inscrits par vous-même pour par l'administrateur du module doivent être prévenus séparément.</p>

          <div style="font-style: italic">

              <p>Le rendez-vous à la réunion de parents du <strong>{$infoRP.date}</strong> a dû être annulé pour la raison suivante:</p>
              <textarea name="raison" id="raisonDel" class="form-control" rows="2" placeholder="Votre texte ici" style="background:pink;"></textarea>
              </form>

          </div>
      </div>
      <div class="modal-footer">
          <button type="button" class="btn btn-danger" id="btn-delAllRV">Annuler tous les {$listeRV|@count} rendez-vous</button>
      </div>
    </div>
  </div>
</div>


<script type="text/javascript">

    $(document).ready(function(){

        $('#form-delAllRV').validate({
            rules: {
                raison: {
                    required: true
                }
            }
        })
    })

</script>

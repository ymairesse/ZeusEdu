<div id="modalAnswerPost" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalAnswerPostLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="modalAnswerPostLabel">
                    {if isset($postAncien.from)}
                    En réponse à {$postAncien.from}
                    {else}
                    Nouvelle contribution au sujet
                    {/if}
                </h4>
            </div>
            <div class="modal-body">
                {if isset($postAncien.from)}
                <label for="texteAncien">{$postAncien.from} écrivait</label>
                <textarea name="texteAncien" id="texteAncien" class="form-control" rows="3" style="height:5em; overflow:auto" readonly>{$postAncien.post}</textarea>
                {/if}
                <form id="formModalAnswer">
                    <label for="myPost">
                        {if isset($postAncien.from)}
                        Je lui réponds
                        {else}
                        Ma contribution
                        {/if}
                    </label>
                    <textarea name="myPost" id="myPost" rows="5" class="form-control"></textarea>

                    <input type="hidden" name="postId" id="postId" value="{$postAncien.postId}">
                    <input type="hidden" name="idSujet" id="idSujet" value="{$postAncien.idSujet}">
                    <input type="hidden" name="idCategorie" id="idCategorie" value="{$postAncien.idCategorie}">

                </form>
            </div>
            <div class="modal-footer">
                <div class="btn-group pull-right">
                    <button type="button" class="btn btn-default" id="resetNewPost">Annuler</button>
                    <button type="button" class="btn btn-primary" id="saveNewPost">Enregistrer</button>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
    $(document).ready(function() {

        $('#resetNewPost').click(function() {
            $('#myPost').val('');
        })

        $('#formModalAnswer').validate({
            rules: {
                myPost: {
                    required: true,
                    minlength: 20
                }
            }
        })
    })
</script>

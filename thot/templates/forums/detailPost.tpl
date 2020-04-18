{if $post != Null}
    <h3>{$post.libelle} - {$post.sujet} <span class="pull-right">{$post.ladate} {$post.heure}</span></h3>
    <form id="formEditPost">

        <div class="form-group">
            <label for="texte">Texte </label>
            {if $post.auteur == $acronyme}
            <div class="button-group pull-right">
                <button title="Modifier" type="button" class="btn btn-success btn-xs" id="btn-edit"><i class="fa fa-pencil-square-o"></i> </button>
                <button title="Enregistrer" type="button" class="btn btn-danger btn-xs hidden" id="btn-saveEditedPost"><i class="fa fa-floppy-o"></i> </button>
            </div>
            {/if}
            <textarea name="texte" id="post" class="form-control" rows="4" readonly>{$post.post}</textarea>
        </div>

        <input type="hidden" name="postId" value="{$post.postId}">
        <input type="hidden" name="idCategorie" value="{$post.idCategorie}">
        <input type="hidden" name="parentId" value="{$post.parentId}">
        <input type="hidden" name="idSujet" value="{$idSujet}">
        <input type="hidden" name="modifie" value="1">

        <button type="button" class="btn btn-primary pull-right" id="btn-answer">Répondre</button>

    </form>
{/if}

<form id="formNewPost" {if $post != Null}class="hidden"{/if}>

    <div class="form-group">
        {if $post == Null}
            <label for="reponse">Votre contribution</label>
            {else}
            <label for="reponse">En réponse à {$post.from}</label>
        {/if}
        <textarea name="reponse" id="reponse" class="form-control" rows="4"></textarea>
    </div>

    <input type="hidden" name="parentId" value="{$post.postId|default:0}">
    <input type="hidden" name="idCategorie" value="{$post.idCategorie|default:$idCategorie}">
    <input type="hidden" name="idSujet" value="{$post.idSujet|default:$idSujet}">
    <input type="hidden" name="modifie" value="0">

    <div class="button-group pull-right">
        <button type="reset" class="btn btn-default">Annuler</button>
        <button type="button" class="btn btn-primary" id="btn-saveAnswer">Envoyer</button>
    </div>

</form>

<script type="text/javascript">

    $(document).ready(function(){

        $('#formNewPost').validate({
            rules: {
                reponse: {
                    required: true,
                    minlength: 20
                    }
            }
        })

        $('#formEditPost').validate({
            rules: {
                texte: {
                    required: true,
                    minlength: 20
                }
            }
        })
    })

</script>

<div class="container-fluid">

    <div class="row">
        <div class="col-sm-10">
            <h2>{$titre}</h2>
        </div>

        <div class="col-sm-2">
            <button type="button" class="btn btn-primary" id="showQuestion">Rappel du formulaire</button>
        </div>

    </div>

    <div class="table-responsive">

        {foreach from=$listeQuestions key=numQ item=dataQuestion}
        <table class="table table-condensed">
            <thead>
                <tr>
                    <th>Question {$numQ}</th>

                    {foreach from=$listeQuestions key=numQ item=dataQuestion}
                    <th colspan="{$listeQuestions.$numQ.reponses|@count+2}">
                        <span title="{$dataQuestion.question}">{$dataQuestion.question|truncate:100}</span>
                    </th>
                    {/foreach}
                </tr>
                <tr>
                    <th>&nbsp;</th>
                    <th>Classe</th>
                    <th>nom</th>
                    {foreach from=$listeQuestions.$numQ.reponses item=uneReponse}
                    <th>{$uneReponse}</th>
                    {/foreach}
                </tr>
            </thead>

            {foreach from=$listeReponses.$numQ key=matricule item=dataReponses name=boucleReponses}
                <tr>
                    <td>{$smarty.foreach.boucleReponses.iteration}</td>
                    <td>{$listeEleves.$matricule.groupe}</td>
                    <td>{$listeEleves.$matricule.nom} {$listeEleves.$matricule.prenom}</td>

                    {foreach from=$dataQuestion.reponses key=numReponse item=uneReponse}
                    <td>
                        {if isset($listeReponses.$numQ.$matricule.$numReponse)}
                            {$uneReponse}
                        {else}
                            --
                        {/if}
                    </td>
                    {/foreach}
                </tr>

             {/foreach}


        </table>
        {/foreach}

    </div>

{include file='forms/modalRappelQuestion.tpl'}


</div>

<script type="text/javascript">
    $(document).ready(function() {

        $("#showQuestion").click(function() {
            $("#modalQuestion").modal('show');
        })

    })
</script>

<div class="modal fade" id="modalQuestion" tabindex="-1" role="dialog" aria-labelledby="RappelQuestions" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="RappelQuestions">{$titre}</h4>
            </div>
            <div class="modal-body">
                <h3>{$formProp.titre}</h3>
                <div style="height:4em; overflow:auto">
                {$formProp.explication}
                </div>

                <div style="height:12em; overflow:auto">

                    {foreach from=$listeQuestions key=numQ item=dataQuestion}

                        <h3>Question {$numQ}: {$dataQuestion.question}</h3>
                        {if $dataQuestion.type == 'select'}
                        <ul>
                            {foreach from=$dataQuestion.reponses key=numReponse item=reponse}
                            <li>[{$numReponse+1}] => {$reponse}</li>
                            {/foreach}
                        </ul>

                        {elseif $dataQuestion.type == 'checkbox'}
                        <ul>
                            {foreach from=$dataQuestion.reponses key=numReponse item=reponse}
                            <li>[{$numReponse+1}] => {$reponse}</li>
                            {/foreach}
                        </ul>
                        {elseif $dataQuestion.type == 'radio'}
                            radio

                        {/if}

                    {/foreach}

                </div>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Fermer </button>
            </div>
        </div>
    </div>
</div>

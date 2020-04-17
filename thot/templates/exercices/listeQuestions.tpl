<button type="button" class="btn btn-primary btn-block" id="creerQuestion" data-collection="{$idCollection}">
Créer une question
</button>
{foreach from=$listeQuestions key=idQuestion item=question}
    <div class="input-group">
        <span class="input-group-btn">
            <button class="btn btn-danger btn-delQuestion"
                    type="button"
                    title="Effacer cette question"
                    data-idQuestion="{$idQuestion}">
                    <i class="fa fa-eraser"></i>
            </button>
        </span>
        <button
            type="button"
            class="btn btn-default btn-block q_{$question.type}"
            data-idquestion="{$idQuestion}"
            title="{$question.type}: {$question.details.question}">{$question.details.question|truncate:50:"..."}
        </button>
        <span class="input-group-btn">
            <button class="btn btn-success btn-editQuestion"
                    type="button"
                    title="Editer cette question"
                    data-idcollection="{$idQuestion}"><i class="fa fa-pencil"></i>
            </button>
        </span>
    </div>
{/foreach}

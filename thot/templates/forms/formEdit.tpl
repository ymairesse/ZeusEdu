<div class="container-fluid">

    <div class="row">

        <ul class="nav nav-tabs">
            <li class="active"><a data-toggle="tab" href="#consignes">Consignes</a></li>
            {foreach from=$listeQuestions item=uneQuestion}
            <li>
                <a data-toggle="tab" href="#Q{$uneQuestion.numQuestion}">{$uneQuestion.numQuestion}</a>
            </li>
            {/foreach}
            <li>
                <a data-toggle="tab" href="javascript:void(0)" {if $formProp.actif == 1} disabled{/if} id="plus">+</a>
            </li>
        </ul>

        <div class="tab-content">
            <div id="consignes" class="tab-pane fade in active">
                {$formProp|print_r}
            </div>
            {foreach from=$listeQuestions item=uneQuestion}
            <div id="Q{$uneQuestion.numQuestion}" class="tab-pane fade">
                <pre>{$uneQuestion|print_r}</pre>
            </div>
            {/foreach}

        </div>

    </div>

</div>

<div class="panel panel-default">

    <div class="panel-heading">
        <h4 class="panel-title">Attributs</h4>
    </div>
    <!-- panel-heading.. -->

    <div class="panel-body">

        <div class="form-group col-md-6 col-sm-12">
            <label for="dateDebut">Date de début</label>
            <input type="text" name="dateDebut" id="dateDebut" placeholder="Début" class="datepicker form-control" value="{$notification.dateDebut}" title="La notification apparaît à partir de cette date">
        </div>

        <div class="form-group col-md-6 col-sm-12">
            <label for="dateFin">Date de fin</label>
            <input type="text" name="dateFin" id="dateFin" placeholder="Fin" class="datepicker form-control" value="{$notification.dateFin}" title="La notification disparaît à partir de cette date">
            <div class="help-block">Déf: Début+1mois</div>
        </div>

        <div class="form-group col-md-4 col-sm-12">
            <label for="mail" title="Un mail d'avertissement est envoyé">Envoi<br>mail</label>
            <input type="checkbox" name="mail" id="mail" class="form-control-inline" value="1"
            {if isset($notification.mail) && $notification.mail==1 } checked='checked' {/if}
            {if $notification.type=='ecole' || $notification.type=='niveau' || isset($edition)} disabled{/if}>
            {* disabled pour l'envoi de mail à toute l'école ou à tout un niveau afin d'éviter les over quota d'envois *}
            {* disabled en cas d'édition (on ne change pas les règles en cours de route) *}
        </div>

        <div class="form-group col-md-4 col-sm-12">
            <label for="accuse" title="Un accusé de lecture est demandé">Accusé<br>lecture</label>
            <input type="checkbox" name="accuse" id="accuse" class="form-control-inline" value="1"
            {if isset($notification.accuse) && $notification.accuse==1 } checked='checked' {/if}
            {if $notification.type=='ecole' || isset($edition)} disabled{/if}>
            {* disabled pour toute l'école car ingérable *}
            {* disabled en cas d'édition (on ne change pas les règles en cours de route) *}
        </div>

        <div class="form-group col-md-4 col-sm-12">
            <label for="freeze" title="Notification permanente, n'est pas effacée après la date finale">Perma-<br>nent</label>
            <input type='checkbox' name='freeze' id='freeze' class='form-control-inline' value='1'
            {if (isset($notification.freeze)) && ($notification.freeze==1 )} checked{/if}>
        </div>

    </div>
    <!-- panel-body -->

    <div class="panel-footer">

        {if $notification.type == 'niveau' || $notification.type == 'ecole'}
            <p>L'envoi de mails est désactivé pour les notifications à tout un niveau ou à toute l'école</p>
        {/if}
        {if $notification.type == 'ecole'}
            <p>La demande d'accusé de lecture est désactivée pour les notifications à l'ensemble de l'école</p>
        {/if}
        {if isset($edition)}
            Certaines options ne sont pas modifiables
        {/if}

    </div>
</div>
<!-- panel-info -->

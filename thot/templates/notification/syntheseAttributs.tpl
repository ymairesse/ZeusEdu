<div class="panel panel-default">

    <div class="panel-heading">

        <h4 class="panel-title">Attributs</h4>

    </div>
    <!-- panel-heading.. -->

    <div class="panel-body" style="height:35em; overflow:auto;">

        {if $notification.type == 'classes'}
        <div class="geant">{$classe}</div>
        {/if}
        {if $notification.type == 'niveau'}
        <div class="geant">{$notification.destinataire}<sup>e</sup></div>
        {/if}
        {if $notification.type == 'ecole'}
        <div class="geant">Tous</div>
        {/if}

        <div class="form-group">
            <label for="dateDebut">Date de début</label>
            <p class="form-control-static"  title="La notification apparaît à partir de cette date">{$notification.dateDebut}</p>
        </div>

        <div class="form-group">
            <label for="dateFin">Date de fin</label>
            <p class="form-control-static" title="La notification disparaît à partir de cette date">{$notification.dateFin}</p>
        </div>

        <div class="form-group">
            <p title="Un mail d'avertissement est envoyé">Envoi mail
            {if isset($notification.mail) && $notification.mail==1 } <i class="fa fa-check-square-o fa-lg"></i>{else}<i class="fa fa-square-o fa-lg"></i> {/if}
            </p>
        </div>

        <div class="form-group">
            <p title="Un accusé de lecture est demandé">Acc. lecture
            {if isset($notification.accuse) && $notification.accuse==1 } <i class="fa fa-check-square-o fa-lg"></i>{else}<i class="fa fa-square-o fa-lg"></i>{/if}
            </p>
        </div>

        <div class="form-group">
            <p title="La notification n'est pas effacée après la date finale">Permanent
            {if (isset($notification.freeze)) && ($notification.freeze==1 )} <i class="fa fa-check-square-o fa-lg"></i>{else}<i class="fa fa-square-o fa-lg"></i> {/if}
            </p>
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

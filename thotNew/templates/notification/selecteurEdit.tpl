<form id="formSelecteur">
<div class="panel panel-default">
    <div class="panel-heading">
        Sélection
    </div>
    <div class="panel-body">
        <div class="input-group">
            <select class="form-control" name="typeDisabled" id="selectPrincipal" disabled>
                <option value="">Choisir la cible</option>
                <option value="ecole" {if $notification.type == 'ecole'}selected{/if}>Tous les élèves</option>
                <option value="niveau" {if $notification.type == 'niveau'}selected{/if}>Un niveau d'étude</option>
                <option value="classes" {if $notification.type == 'classes'}selected{/if}>Une classe</option>
                <option value="coursGrp" {if $notification.type == 'coursGrp'}selected{/if}>Un cours</option>
                <option value="cours" {if $notification.type == 'cours'}selected{/if}>Une matière</option>
                <option value="groupe" {if $notification.type == 'groupe'}selected{/if}>Un groupe</option>
                <option value="eleves" {if $notification.type == 'eleves'}selected{/if}>Un élève</option>
            </select>
            <span class="input-group-btn">
                <button type="button" class="btn btn-primary" name="button" data-type="tous" disabled>
                    <i class="fa fa-arrow-right"></i>
                </button>
            </span>
        </div>

        {if $notification.type == 'niveau' && ($notification.eleve == 0)}
            <h4>Niveau: {$notification.destinataire}e année</h4>
        {/if}

        {if $notification.type == 'coursGrp' && ($notification.eleve == 0)}
            <h4>Votre cours {$notification.destinataire}</h4>
        {/if}

        {if $notification.type == 'classes' && ($notification.eleve == 0)}
            <h4>Classe: {$notification.destinataire}</h4>
        {/if}

        {if $notification.type == 'cours'}
            <h4>Cours: {$notification.destinataire}</h4>
        {/if}

        {if $notification.type == 'groupe' && ($notification.eleve == 0)}
            <h4>Groupe: {$notification.destinataire}</h4>
        {/if}

        {if $notification.eleve == 1}
            <h4>{$notification.trueDest}</h4>
        {/if}

    </div>

    <input type="hidden" name="destinataire" value="{$notification.destinataire}">
    <input type="hidden" name="type" value="{$notification.type}">
    <input type="hidden" name="TOUS" value="TOUS" id="TOUS">

</div>
</form>

<button type="button" class="btn btn-danger btn-block" id="annulEdit">Annuler la modification</button>

<script type="text/javascript">

    $('document').ready(function(){

    })

</script>

<div class="box">

    <h3>{$infoTravail.titre}</h3>

    <p>Date de début: <strong>{$infoTravail.dateDebut}</strong> <br>
    Date de fin: <strong>{$infoTravail.dateFin}</strong><br>
    Statut:
        <strong>{if $infoTravail.statut == 'hidden'}
            Invisible
        {elseif $infoTravail.statut == 'readonly'}
            Lecture autorisée
        {elseif $infoTravail.statut == 'readwrite'}
            Dépôt autorisé
        {elseif $infoTravail.statut == 'termine'}
            Travail achevé
        {/if}</strong>
    </p>
    <button type="button"
            id="btnVoirConsignes"
            class="btn btn-primary btn-block"
            data-consigne="{$infoTravail.consigne|escape:'htmlall'}">
            Voir les consignes
    </button>

</div>

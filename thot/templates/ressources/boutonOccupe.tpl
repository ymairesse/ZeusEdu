<button type="button"
    class="btn btn-danger btn-xs btn-block btn-reserved {if $abreviation == $acronyme}btn-lightBlue{/if}"
    data-acronyme="{$abreviation}"
    data-heure="{$heure}"
    data-date="{$date}"
    data-idressource="{$idRessource}"
    title="{$nom}">
    <span class="micro">{$abreviation}</span>
</button>

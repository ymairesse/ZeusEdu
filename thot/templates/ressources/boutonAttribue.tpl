<button type="button"
    class="btn btn-warning btn-xs btn-block btn-attribue {if $abreviation == $acronyme}btn-blue{/if}"
    data-acronyme="{$abreviation}"
    data-heure="{$heure}"
    data-date="{$date}"
    data-idressource="{$idRessource}"
    title="{$nom}">
    <span class="micro">{$abreviation}</span>
</button>

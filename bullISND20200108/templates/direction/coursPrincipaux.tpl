<form id="formCours">

    {foreach from=$listeCoursPrincipaux key=idCours item=nomCours}

        <div class="checkbox">
          <label><input type="checkbox" name="cours_{$idCours}" value="{$idCours}" {if in_array($idCours, $listeIdCours)}checked{/if}>{$nomCours}</label>
        </div>

    {/foreach}

</form>

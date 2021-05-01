{if isset($photo)} {* ?rand=$smarty.now = astuce pour forcer la mise à jour de l'image après upload *}

<img class="img-responsive" style="margin:auto; width:100px;" src="../photosProfs/{$photo}?rand={$smarty.now}"> {else} {if $identite.sexe == 'M'}
<img class="img-responsive" style="margin:auto; width:100px;" src="../images/profMasculin.jpg" alt="M"> {else}
<img class="img-responsive" style="margin:auto; width:100px;" src="../images/profFeminin.jpg" alt="F"> {/if}

{/if}

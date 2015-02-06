{if isset($acronyme)}

<form name="listeEleves" id="listeEleves" action="index.php" method="POST" style="padding:0; margin:0">

<input type="hidden" name="educ" value="{$identite.acronyme}">
<input type="hidden" name="date" value="{$date}">
<input type="hidden" name="action" value="{$action}">
<input type="hidden" name="mode" value="{$mode}">
<input type="hidden" name="etape" value="enregistrer">
<input type="hidden" name="freeDate" value="{$freeDate}">
<input type="hidden" name="freePeriode" value="{$freePeriode}">
<input type="hidden" name="parent" value="prof/educ">
<input type="hidden" name="media" value="en classe">
<input type="hidden" name="periode" value="{$periode}">
<input type="hidden" name="coursGrp" value="{$coursGrp}">
<input type="hidden" name="selectProf" value="{$acronyme|default:''}">

<h2>{$listeProfs.$acronyme.prenom} {$listeProfs.$acronyme.nom|truncate:20} | {$listeCoursGrp.$coursGrp.libelle} -> [{$coursGrp}]</h2>

{include file="feuillePresences.tpl"}

{/if}

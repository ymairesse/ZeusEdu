<h3>Remarque pour la période {$bulletin}</h3>
{* si $blocage.$coursGrp > 1, les commentaires sont verrouillés *}
<textarea
	{if $blocage >= 1} readonly="readonly"{/if}
	class="remarque form-control"
	rows="8"
	name="commentaire-eleve_{$matricule}"
	tabIndex="{$tabIndexAutres}"
	>{$listeCommentaires.$matricule.$bulletin|default:Null}</textarea>
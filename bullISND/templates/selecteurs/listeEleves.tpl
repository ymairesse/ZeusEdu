{if isset($listeEleves)}

<select name="matricule" id="selectEleve" {if isset($size)}size="{$size}"{/if}{if isset($multiple)} multiple{/if} class="form-control input-sm">
	<option value="">Choisir un élève</option>
	{if isset($listeEleves)}
		{foreach from=$listeEleves key=leMatricule item=unEleve}
			<option value="{$leMatricule}"
			class="{if isset($listeSelectionEleves) && ($listeSelectionEleves != Null)  && (!in_array($leMatricule, $listeSelectionEleves))}hidden{/if}"
			{if isset($listeSelectionEleves) && ($listeSelectionEleves != Null)  && (!in_array($leMatricule, $listeSelectionEleves))} disabled{/if}
			 {if isset($matricule) && ($leMatricule==$matricule)} selected{/if}>
			 {$unEleve.nom} {$unEleve.prenom}
		 	</option>
		{/foreach}
	{/if}
</select>

{/if}

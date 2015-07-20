{if ()$userStatus == admin) || ()$userStatus == 'direction')}
	<!-- Notifications à un niveau d'études -->
	<div class="tab-pane hidden-print" id="tabs-3">
    {assign var=liste value=$listeNotifications.niveau}
    <table class="table table-condensed">
		<thead>
        <tr>
			<th colspan="5">
			{if $liste|@count > 0}
			<input type="checkbox" class="selectAll"> Sélectionner <i class="fa fa-arrow-left"></i>
			<button class="btn btn-warning delModal" type="button">
				<i class="fa fa-times text-danger"></i> Effacer
			</button>
			{else}
			Aucune notification à un niveau d'études
			{/if}
			</th>
        </tr>
      </thead>
    {foreach from=$liste item=uneNote}
		{assign var=matricule value=$uneNote.destinataire}
      <tr title="Toutes les {$uneNote.destinataire}e"
          data-container="body">
        <td style="width:1em"><input type="checkbox" class="checkDelete" id="check{$uneNote.id}" data-id="{$uneNote.id}"></td>
		<td style="width:1em">
			<form class="microForm" method="POST" action="index.php" role="form">
				<button type="submit" class="btn btn-default btn-sm"><i class="fa fa-pencil-square-o fa-lg text-success editNote"></i></button>
				<input type="hidden" name="niveau" value="{$uneNote.destinataire}">
				<input type="hidden" name="id" value="{$uneNote.id}">
				<input type="hidden" name="onglet" class="onglet" value="{$onglet|default:0}">
				<input type="hidden" name="action" value="editNotification">
				<input type="hidden" name="mode" value="niveau">
				<input type="hidden" name="etape" value="show">
			</form>
		</td>
		<td style="width:1em">
			<button type="button" class="btn btn-warning btn-delete" data-id="{$uneNote.id}"><i class="fa fa-times text-danger"></i></button>
		</td>
		<td>
			<h4 class="urgence{$uneNote.urgence}"><span class="dateDebut">{$uneNote.dateDebut}</span>: <span class="objet">{$uneNote.objet}</span></h4>
		</td>
		<td style="width:20%; text-align:right;">
			Toutes les {$uneNote.destinataire}e
		</td>
      </tr>
      <tr>
        <td colspan="5">
         <span class="texte">{$uneNote.texte|truncate:150:'...'}</span>
       </td>
      </tr>
    {/foreach}
    </table>
	</div>
{/if}

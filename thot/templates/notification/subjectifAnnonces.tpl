<div class="container-fluid">

    <div class="row">

        <div id="listeAnnonces" style="max-height: 35em; overflow: auto" class="col-xs-12">

        	<table class="table table-condensed table-hover table-responsive">
        		<tr>
        			<th style="width:1em">&nbsp;</th>
        			<th>Publié le</th>
        			<th>Objet</th>
        			<th>PJ</th>
        			<th>Responsable</th>
        			<th>Destinataire</th>
        			<th>Acc. lecture</th>
        		</tr>
        		{foreach from=$listeAnnonces key=id item=dataAnnonce name=n}
        			<tr
        				data-id="{$id}"
        				data-accuse="
        					{if ($dataAnnonce.accuse == 1)}
        					 	{if $dataAnnonce.flags.dateHeure == Null}
        						1
        						{else}
        						0
        						{/if}
        					{else}
        					0
        					{/if}"

        				class="notification {$dataAnnonce.type}{if !(isset($listeFlags.$id.lu)) || ($listeFlags.$id.lu == 0 )} nonLu{/if}">
        				<td>{$smarty.foreach.n.iteration}</td>
        				<td>{$dataAnnonce.dateDebut}</td>
        				<td class="texteAnnonce">{$dataAnnonce.objet}</td>
        				<td>{if isset($listePJ.$id) && ($listePJ.$id|@count > 0)}<i class="fa fa-paperclip"></i>{else}&nbsp;{/if}</td>
        				<td>{$dataAnnonce.proprietaire}</td>
        				<td>
        					{if $dataAnnonce.destinataire == $matricule}
        						<i class="fa fa-user text-success" title="{$dataAnnonce.pourQui}"></i>
        						{else}
        						<i class="fa fa-users text-info" title="{$dataAnnonce.pourQui}"></i>
        					{/if}
        				</td>
        				<td class="dateHeure">
        					{if $dataAnnonce.accuse == 1}
        						{if (!(isset($listeFlags.$id.dateHeure)))}
        							<i class="fa fa-warning fa-lg faa-flash animated text-danger"></i>
        							{else}
        							{$listeFlags.$id.dateHeure}
        						{/if}
        					{else}
        					-
        					{/if}
        				</td>

        			</tr>

        		{/foreach}

        	</table>

        </div>

        <div class="col-xs-12">

            <p class="help-block pull-right">Total: {$listeAnnonces|@count} annonces.</p>

            <table class="table table-condensed">
                <tr>
                    <td class="notification">Annonce lue</td>
                </tr>
                <tr class="nonLu">
                    <td class="notification">Annonce non lue</td>
                </tr>
            </table>

            <h4>Code des couleurs</h4>
            <ul class="list-inline">
            	<li class="ecole">Pour tous les élèves</li>
            	<li class="niveau">Pour tous les élèves d'un niveau</li>
            	<li class="cours">Pour un ou plusieurs élèves d'un cours</li>
            	<li class="classes">Pour un ou plusieurs élèves de la classe</li>
            </ul>

        </div>

    </div>

</div>

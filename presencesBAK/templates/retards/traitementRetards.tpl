<h2>Traitement des retards
    {if isset($form.matricule) && $form.matricule != Null} d'un élève
        {elseif $form.classe != Null} de la classe {$form.classe}
        {elseif $form.niveau != Null} des élèves de {$form.niveau}e année
    {/if}
</h2>

<h3>Du {$form.debut} au {$form.fin}</h3>

<table class="table tabl-condensed">
    <tr>
        <th>&nbsp;</th>
        <th>Nom</th>
        <th>Date</th>
        <th>Heure de cours</th>
        <th>Par</th>
        <th>Traité</th>
        <th>Sanction</th>
        <th>Imprimer</th>
        <th>Retour</th>
    </tr>
    {assign var=oldRef value=''}
    {assign var=oldMatricule value=''}
    {foreach from=$listeRetards key=matricule item=dataRetards}

        {foreach from=$dataRetards key=id item=unRetard name=boucleRetards}

            <tr data-id="{$unRetard.id}">
                <td>
                    {if $smarty.foreach.boucleRetards.first}
                    <span class="badge badge-danger">{$dataRetards|@count}</span>
                    {else}
                    &nbsp;
                    {/if}
                </td>
                <td>
                    {if $smarty.foreach.boucleRetards.first}
                        {$unRetard.groupe} {$unRetard.nomEl} {$unRetard.prenomEl}
                        {else}&nbsp;
                    {/if}
                <td>{$unRetard.date}</td>

                {assign var=periode value=$unRetard.periode}

                <td title="{$periode}e heure">{$listePeriodes.$periode.debut}</td>
                <td title="{$unRetard.nom} {$unRetard.prenom}">{$unRetard.educ}</td>

                {* checkbox pour demande de traitement *}
                <td>
                    <input type="checkbox"
                        value="1"
                        data-matricule="{$matricule}"
                        data-id="{$id}"
                        class="cbDate"
                        data-ref="{$listeSanctions.$id.ref|default:''}"
                        {if isset($listeSanctions.$id) && ($matricule == $listeSanctions.$id.matricule)} checked disabled{/if}>
                    {if isset($listeSanctions.$id) && ($listeSanctions.$id.ref != $oldRef) && ($matricule == $listeSanctions.$id.matricule)}
                        <span class="discret" data-ref="{$listeSanctions.$id.ref|default:''}">{$listeSanctions.$id.dateTraitement|truncate:5:''|default:'-'}</span>
                    {/if}
                </td>

                <td>
                    {* bouton d'action de traitement des retards cochés *}
                    {* C'est un nouvel élève et il n'est pas encore traité *}
                    <button type="button"
                        class="btn btn-primary btn-xs btn-sanction{if ($matricule == $oldMatricule) || ((isset($listeSanctions.$id)) && ($listeSanctions.$id.ref != ''))} hidden{/if}"
                        data-matricule="{$matricule}"
                        data-ref="{$listeSanctions.$id.ref|default:''}">
                        <i class="fa fa-calendar"></i>
                    </button>

                    {* Suppression du billet de retard *}
                    <button type="button"
                        class="btn btn-danger btn-xs btn-delete{if !(isset($listeSanctions.$id.ref)) || $listeSanctions.$id.ref == $oldRef} hidden{/if}"
                        title="Effacer la sanction"
                        data-ref="{$listeSanctions.$id.ref|default:''}">
                            <i class="fa fa-times-circle-o"></i>
                    </button>
                    {assign var=ref value=$listeSanctions.$id.ref|default:''}
                    {* Voir les dates de sanction pour le billet $ref *}
                    <button type="button"
                        class="btn btn-info btn-xs btn-look{if !(isset($listeSanctions.$id.ref)) || $listeSanctions.$id.ref == $oldRef} hidden{/if}"
                        data-content="{if isset($listeRefsDates.$ref)} {$listeRefsDates.$ref|implode:', '}{/if}"
                        data-html="true"
                        data-container="body"
                        data-title="Dates de sanction"
                        data-trigger="focus"
                        data-toggle="popover"
                        data-ref="{$listeSanctions.$id.ref|default:''}">
                            <i class="fa fa-eye"></i>
                    </button>
                    {assign var=oldMatricule value=$matricule}

                </td>
                <td>
                    {* impression du billet de retard *}
                    {if isset($listeSanctions.$id.ref) && $listeSanctions.$id.ref != $oldRef}
                        <button type="button"
                            class="btn btn-primary btn-xs btn-print"
                            data-matricule="{$matricule}"
                            data-ref="{$listeSanctions.$id.ref|default:''}"
                            {if !(isset($listeSanctions.$id.ref))} disabled{/if}>
                                <i class="fa fa-print"></i>
                        </button>
                    {/if}
                </td>
                <td>
                    {* Retour du billet de retard *}
                    {if isset($listeSanctions.$id.ref) && $listeSanctions.$id.ref != $oldRef}
                        {$synthese.retour|default:''}
                        {$synthese.retour|default:'-'} <input type="checkbox" name="cbRetour_{$unRetard.id}" value="1">
                        {assign var=oldRef value=$listeSanctions.$id.ref}
                    {/if}
                </td>
            </tr>
        {/foreach}

    {/foreach}

</table>

<div id="modal">

</div>

<script type="text/javascript">

    $(document).ready(function(){
        $('[data-toggle="popover"]').popover();
    })

</script>

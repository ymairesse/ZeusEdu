listeAttenteProf

<div class="panel panel-default">

    <div class="panel-heading">
        <div class="row">

            <div class="col-md-2 col-sm-4">
                <button class="btn btn-success btn-sm pull-right btn-block"
                    data-idrp="{$idRP}"
                    id="listeAttente"
                    data-acronyme="{$acronyme|default:''}"
                    title="Placer l'élèves sélectionné en liste d'attente"><i class="fa fa-arrow-right"></i> <i class="fa fa-user"></i> <i class="fa fa-user"></i> <i class="fa fa-user-plus"></i>
                </button>
            </div>
            <div class="col-md-10 col-sm-8">
                <h3 class="panel-title">Liste d'attente</h3>
            </div>

        </div>

    </div>

    <div class="panel-body">
    <table class="table table-condensed" style="font-size:10pt" id="tbl-attente">

        <thead>
            <tr>
                <th>Période</th>
                <th>Élève</th>
                <th>Parent</th>
                <th style="width:2.5em">&nbsp;</th>
                <th style="width:2.5em">&nbsp;</th>
                <th style="width:2.5em">&nbsp;</th>
            </tr>
        </thead>
        <tbody>
            {foreach from=$listeAttente key=wtf item=data}
            <tr class="attente{$data.periode}" data-matricule="{$data.matricule}" data-periode="{$data.periode}">
                <td>{$data.heures}</td>
                <td>{$data.groupe} {$data.nom} {$data.prenom}</td>
                <td>{if $data.mail != ''}
                    <a href="mailto:{$data.mail}">{$data.formule} {$data.nomParent} {$data.prenomParent}</a>
                    {else}
                    {$data.formule} {$data.nomParent} {$data.prenomParent}
                    {/if}
                </td>
                <td>{if $data.userName == ''}
                    <button
                        type="button"
                        class="btn btn-danger btn-xs delAttente"
                        data-matricule="{$data.matricule}"
                        data-idrp="{$idRP}"
                        data-acronyme="{$acronyme}"
                        data-periode="{$data.periode}">
                        <i class="fa fa-trash"></i>
                    </button>
                    {/if}
                </td>
                <td style="width:2.5em">&nbsp;</td>
                <td><button
                    type="button"
                    class="btn btn-success btn-xs unlinkAttente"
                    data-matricule="{$data.matricule}"
                    data-idrp="{$idRP}"
                    data-acronyme="{$acronyme}"
                    data-periode="{$data.periode}"
                    data-userName="{$data.userName}">
                    <i class="fa fa-arrow-up"></i>
                </td>
            </tr>
            {/foreach}
        </tbody>
    </table>

    </div>  <!-- panel-body -->

</div>  <!-- panel-default -->

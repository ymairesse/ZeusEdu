<div class="row">
    <div class="col-md-6 col-sm-12">
        <dl>
            <dt>Adresse</dt>
            <dd>{$identite.adresse|default:'-'}</dd>
            <dt>Commune</dt>
            <dd>{$identite.commune|default:'-'}</dd>
            <dt>Code Postal</dt>
            <dd>{$identite.codePostal|default:'-'}</dd>
            <dt>Pays</dt>
            <dd>{$identite.pays|default:'-'}</dd>
        </dl>
    </div>

    <div class="col-md-6 col-sm-12">
        <dl>
            <dt>Fonction</dt>
            <dd>{$identite.titre|default:'-'}</dd>
            <dt>Mail</dt>
            <dd>
                {if isset($identite.mail) && ($identite.mail != '')}
                <a href="mailto:{$identite.mail}">{$identite.mail}</a> {else} - {/if}
            </dd>
            <dt>Téléphone</dt>
            <dd> {$identite.telephone|default:'-'}</dd>
            <dt>GSM</dt>
            <dd> {$identite.GSM|default:'-'}</dd>
        </dl>
    </div>

</div>

<a class="btn btn-primary btn-block" id="btnModifPerso">Modifier</a>

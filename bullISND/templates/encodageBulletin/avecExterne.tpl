{* ------------------------------------------------------ *}
{* -cote de l'épreuve externe --------------------------- *}
{* ------------------------------------------------------ *}
{assign var=coteExterne value=$listeCotesExternes.$matricule.coteExterne}


<td class="cote{if isset($coteExterne) && ($coteExterne != '') && ($coteExterne < 50)} echec{/if}">

    <button
        type="button"
        class="btn btn-primary externe {if $blocage == 1}disabled{/if}"
        data-matricule="{$matricule}"
        data-cote="{$coteExterne}">
            {$coteExterne|cat:'%'}
    </button>
</td>

{* ------------------------------------------------------ *}
{*  Choix de la cote de délibé     ---------------------- *}
{* ------------------------------------------------------ *}
<td style="text-align:center">
    {if $blocage == 0}

    {* ------------------------------------------------------ *}
    {* cote entre crochets? ----------------------------------*}
    {* Deux boutons: avec ou sans crochets -------------------*}
    {* ------------------------------------------------------ *}

    {if isset($sitEleve.pourcent)}

        <button class="btn btn-default btn-sm pop hook {if $coteExterne != ''} disabled{/if}"
            type="button"
            name="btnHook-eleve_{$matricule}"
            tabIndex="{$tabIndexAutres+1}"
            value="[{$sitEleve.pourcent|default:''}]"
            data-original-title="Cote entre crochets"
            data-content="Peut être attribuée s'il est impossible de décider d'une cote pour l'élève (absences aux évaluations,...).<br>Cette cote empêche la délibération en fin d'année scolaire."
            data-html="true"
            data-placement="top"
            {if $blocage > 0}disabled="disabled"{/if}>
        [{$sitEleve.pourcent|default:''}]
        </button>

        <button class="btn btn-default btn-sm btn-success pop nohook disabled"
            type="button"
            name="btnNohook-eleve_{$matricule}"
            tabIndex="{$tabIndexAutres+2}"
            data-original-title="Cote 'sèche'"
            data-content="Totalisation de l'année.<br>C'est la cote qui est généralement attribuée."
            data-placement="top"
            data-html="true"
            value="{$sitEleve.pourcent|default:''}"
            {if $blocage > 0}disabled="disabled"{/if}>
            {$sitEleve.pourcent|default:''}
        </button>
        {else}
            -
        {/if}
    {else}
        &nbsp;
    {/if}

    {* ------------------------------------------------------ *}
    {* ces boutons n'apparaîssent qu'à la dernière période    *}
    {* Quand le bulletin est le dernier de l'année            *}
    {* ------------------------------------------------------ *}
    {if $bulletin == $nbBulletins}

        {* cote étoilée? -----------------------------------------*}
        {* Un bouton à cliquer si la situation le permet----------*}
        {if isset($listeCotesEtoilees[$matricule]) && $listeCotesEtoilees[$matricule] != Null}
        <button
            type="button"
            class="btn btn-info btn-sm star pop disabled"
            name="btnStar-eleve_{$matricule}"
            tabIndex="{$tabIndexAutres+3}"
            value="{$listeSommesFormCert.$matricule.pourcentCert}*"
            data-original-title="Attribuer la cote étoilée"
            data-content="La cote étoilée est attribuable si <ol><li>le 'certificatif' est meilleur que l'ensemble 'formatif'+'certificatif' et</li><li>tous les travaux ont été remis</li></ol>"
            data-container="body"
            data-placement="top"
            data-html="true"
            {if $blocage > 0} disabled="disabled"{/if}
            >
            {$listeSommesFormCert.$matricule.pourcentCert}
            </button>
        {/if}

        {* cote réussite du degré? ------------------------------------*}
        {* Un bouton à cliquer si                                      *}
        {* il y a une cote de situation pour le bulletin               *}
        {* l'élève est en échec pour le degré ---                      *}
        {* il y a une cote de deuxième année du degré                  *}

        {if ($sitEleve.pourcent < 50)
            && ($sitDeuxiemes.$coursGrp.$matricule.sit2)}

            {* attribution de la cote 50% en cas de réussite en deuxième; la cote de deuxième se trouve dans sit2 *}
            {if $sitDeuxiemes.$coursGrp.$matricule.sit2.pourcent >= 50}
                <button
                    type="button"
                    class="btn btn-danger btn-sm degre pop disabled"
                    name="btnDegre-eleve_{$matricule}"
                    tabIndex="{$tabIndexAutres+4}"
                    data-original-title="Cote de réussite du degré"
                    data-content="L'élève est en échec à cause de la première année du degré mais il a atteint {$sitDeuxiemes.$coursGrp.$matricule.sit2.pourcent}% en 2ème année; on lui attribue donc la réussite à {$sitDeuxiemes.$coursGrp.$matricule.sit2.pourcent}% pour le degré"
                    data-container="body"
                    data-placement="top"
                    data-html="true"
                    value="{$sitDeuxiemes.$coursGrp.$matricule.sit2.pourcent}"
                    {if $blocage > 0} disabled{/if}
                    >
                    {$sitDeuxiemes.$coursGrp.$matricule.sit2.pourcent}²
                </button>
            {/if}
        {/if}
    {/if}
</td>

{* --------------------------------------------------------*}
{* cote de situation choisie par le titulaire du cours     *}
{* une fois dans un texte à l'écran ---------------------- *}
{* une fois dans un champ caché pour POST ---------------- *}
{* --------------------------------------------------------*}
<td class="cote">

    <i class="fa fa-warning faa-flash animated pop {if (isset($sitEleve.choixProf)) && ($sitEleve.choixProf != '')}invisible{else}visible{/if}"
        style="font-size:2em; color:#f00"
        id="led_{$matricule}"
        data-original-title="Choix de la cote"
        data-content="Veuillez sélectionner une cote finale parmi les options présentées à gauche"
        data-html="true"
        data-placement="top"></i>

    <span class="choixProf" id="textChoixProf_{$matricule}">
        {if isset($sitEleve.choixProf)}
            <strong>
                {if $sitEleve.attributProf == 'hook'}
                    [{$sitEleve.choixProf}]
                {elseif $sitEleve.attributProf == 'star'}
                    {$sitEleve.choixProf}*
                {elseif $sitEleve.attributProf == 'degre'}
                    {$sitEleve.choixProf}²
                {elseif $sitEleve.attributProf == 'externe'}
                    {$sitEleve.choixProf} <i class="fa fa-graduation-cap"></i>
                {else}
                    {$sitEleve.choixProf}
                {/if}
            </strong>
        {/if}
    </span>
    {* input caché pour contenir la valeur de la cote choisie par le prof et à enregistrer *}
    <input type="hidden" name="choixProf-matricule_{$matricule}" id='choixProf-matricule_{$matricule}' value="{$sitEleve.choixProf|default:''}">
    {* input caché pour contenir l'attribut de la cote choisie par le prof et à enregistrer *}
    <input type="hidden" name="attributProf-matricule_{$matricule}" id='attributProf-matricule_{$matricule}' value="{$sitEleve.attributProf|default:''}">
</td>

{* ------------------------------------------------------- *}
{* situation de délibé de l'élève -------------------------*}
{* Une fois dans un texte à l'écran -----------------------*}
{* Une fois dans un champ text caché (pour POST)-----------*}
{* ------------------------------------------------------- *}
<td style="text-align:center"{if isset($tableErreurs.$matricule['sitDelibe'])} class="erreurEncodage"{/if}>
    {* input caché pour contenir la valeur de la cote de délibé à enregistrer *}
    <input type="hidden" name="sitDelibe-matricule_{$matricule}" id="sitDelibe-matricule_{$matricule}" value="{$sitEleve.sitDelibe|default:''}">
    {* input caché pour contenir l'attribut de la cote de délibé à enregistrer *}
    <input type="hidden" name="attributDelibe-matricule_{$matricule}" id="attributDelibe-matricule_{$matricule}" value="{$sitEleve.attributDelibe|default:''}">

    <div class="input-group">
        {* baguette magique? -----------------------------------------*}
        <div class="input-group-btn">
        <button
            type="button"
            class="btn btn-primary magic pop"
            name="magic-eleve_{$matricule}"
            data-original-title="Baguette magique"
            data-content="Permet d'attribuer une cote arbitraire.<br>À n'utiliser que dans des cas extraordinaires avec l'aval du Conseil de Classe"
            data-container="body"
            data-placement="top"
            data-html="true"
            {if $blocage > 0} disabled="disabled"{/if}>
            <i class="fa fa-magic"></i>
        </button>
        </div>

        <div class="sitDelibe editable"
             id="editable_{$matricule}"
             data-html="true"
             data-original-title=''
             data-content=''>
            {if $sitEleve.attributDelibe == 'hook'}[{/if}
            {$sitEleve.sitDelibe}
            {if $sitEleve.attributDelibe == 'hook'}]{/if}
            {if $sitEleve.attributDelibe == 'magique'} <i class="fa fa-magic"></i>{/if}
            {if $sitEleve.attributDelibe == 'degre'}²{/if}
            {if $sitEleve.attributDelibe == 'star'}*{/if}
            {if $sitEleve.attributDelibe == 'externe'} <i class="fa fa-graduation-cap"></i>{/if}
        </div>

        {* balayette pour effacer la cote de délibé --------------------------*}
        <div class="input-group-btn">
        <button
            type="button"
            class="btn btn-default balayette"
            id="bal_{$matricule}"
            title="Effacer la cote de délibération"
            data-container="body"
            data-placement="top"
            {if $blocage > 0} disabled{/if}>
            <i class="fa fa-recycle"></i>
        </button>
        </div>

    </div>  <!-- input-group-btn -->
</td>

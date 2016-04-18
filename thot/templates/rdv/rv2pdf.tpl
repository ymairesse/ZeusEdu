<style type="text/Css">

.collapse
{
    border-collapse: collapse;
}

</style>
<page backtop="15mm" backbottom="7mm" backleft="20mm" backright="10mm">
    <page_header>
    <p>{$ECOLE}</p>
    </page_header>

<h3>Planning de rendez-vous de {$identite.prenom} {$identite.nom}</h3>

    <!-- Les RV fixées -->
    <h4>Liste des rendez-vous</h4>
    <table class="collapse" border="1" cellpadding="55" cellspacing="1" style="width:100%;">
        <tr>
            <th style="width:20%">Heure</th>
            <th style="width:40%">Nom</th>
            <th style="width:40%">e-mail</th>

        </tr>
        {foreach from=$listeRv key=date item=unJour}

        <tr>
            <th colspan="5"> {$unJour.jourSemaine} {$date}</th>
        </tr>
            {foreach from=$unJour.rv key=id item=unRv}
            <tr>
                <td>{$unRv.heure|date_format:"%H:%M"}</td>
                <td>{$unRv.prenom|default:'&nbsp;'} {$unRv.nom|default:'&nbsp;'}</td>
                <td>{if $unRv.email != ''}<a href="mailto:{$unRv.email}">{$unRv.email}</a>{else}&nbsp;{/if}</td>

            </tr>
            {/foreach}

        {/foreach}
    </table>

</page>

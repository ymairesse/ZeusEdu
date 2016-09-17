{if ($type=='classe') && ($noPage == 1)}
<h1 style="page-break-before:always; text-align:center; font-size: 120px; padding-top: 10em;">{$classe}</h1>
{/if}

<page backtop="7mm" backbottom="7mm" backleft="10mm" backright="10mm">
    <page_header>
        <h1 style="font-size: 12pt">{$detailsEleve.groupe} {$detailsEleve.nom} {$detailsEleve.prenom}</h1>
    </page_header>
    <page_footer>
        <div style="text-align:right; font-size: 10px;">
            {$detailsEleve.groupe} {$detailsEleve.nom} {$detailsEleve.prenom}
        </div>
    </page_footer>

    {assign var=sexe value=$detailsEleve.sexe}

    <p>Bien {if $sexe == 'F'}chère{else}cher{/if} {$detailsEleve.prenom}</p>

    <p><strong>Les informations qui figurent sur ce document sont extrêmement confidentielles. Elles ne peuvent, en aucun cas, être confiée à un-e autre élève.</strong></p>
    <br>
    <p>Elles permettent d'accéder:</p>
    <ul>
        <li>Aux ordinateurs de l'école</li>
        <li>À la plate-forme Thot (<a href="http://isnd.be/thot">http://isnd.be/thot</a>)</li>
        <li>À ton adresse mail (voir <a href="http://mail.isnd.be">http://mail.isnd.be</a> ou <a href="http://isnd.be/mail">http://isnd.be/mail</a>)</li>
    </ul>

    <h3>Ton nom {if $sexe == 'F'}d'utilisatrice{else}d'utilisateur{/if} pour l'informatique à l'ISND est:</h3>
    <p style="text-align:center;">
        <pre style="font-weight: bold">{$dataPwd.user}</pre>
    </p>
    <p>Il est formé de la <strong>première lettre de ton prénom</strong> suivie d'un maximum de <strong>7 lettres de ton nom de famille</strong>. On trouve ensuite <strong>4 chiffres</strong> qui sont ton matricule à l'école. Ces 4 chiffres figurent sur ta carte d'étudiant-e et dans ton journal de classe.</p>

    <h3>Ton mot de passe est</h3>
    <p style="text-align:center;">
        <pre style="font-weight: bold">{$dataPwd.passwd}</pre>
    </p>
    <p>Le mot de passe est formé d'une série de {$dataPwd.passwd|count_characters} lettres minuscules. C'est une succession de consonnes et de voyelles.</p>

    <h3>Ton adresse mail est</h3>
    <p style="text-align:center;">
        {assign var=mail value=$dataPwd.user|cat:'@'|cat:$dataPwd.mailDomain}
        <pre style="font-weight: bold">{$mail}</pre>
    </p>

    {if $dataPwd.passwd|count_characters == 6}
    <p>Dans ton cas, le mot de passe pour les mails est le même que celui qui figure plus haut auquel tu dois ajouter "<span style="font-size: 14pt">00</span>" (un double zéro) à la fin: <strong> {$dataPwd.passwd|cat:'00'}</strong>.</p>
    {/if}
    <hr>

    <p>Il est possible que tu aies besoin de ton nom {if $sexe == 'F'}d'utilisatrice{else}d'utilisateur{/if} et ton mot de passe pour une activité informatique dans n'importe quel cours, même si le professeur ne prévient pas. Tu devrais donc connaître ces informations par cœur à tout moment.
    <br> Tu pourrais éventuellement noter le mot de passe dans ton journal de classe, discrètement et à une page connue de toi seul-e.</p>
    <p>L'oubli de mot de passe gêne le déroulement du cours et sera considéré comme un "oubli de matériel scolaire".</p>
    <br>
    <p> Tu es responsable de la conservation de la confidentialité de ce document. <strong>Le fait de le laisser à l'abandon est une faute grave.</strong></p>
    <p>Si tu penses que ton mot de passe a été découvert par une autre personne, contacte d'urgence M.&nbsp;Lambert ou M.&nbsp;Mairesse.</p>

</page>

{if $type == 'classe'}
<div style="page-break-before:always"></div>
{/if}

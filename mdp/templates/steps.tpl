{* inspired by http://bootsnipp.com/lukepzak/snippets/eN4qy lic. MIT*}

<h2 id="titre" data-etape="{$etape|default:1}">Changement du mot de passe {$etape}/4</h2>
<div class="wizard">
    <div class="wizard-inner">
        <div class="connecting-line"></div>
        <ul class="nav nav-tabs" role="tablist">

            <li class="etape active" data-etape="1" role="presentation">
                <a href="#etape1" data-toggle="tab" aria-controls="etape1" role="tab" title="Étape 1">
                    <span class="round-tab">
                        <i class="fa fa-user"></i>
                    </span>
                </a>
            </li>

            <li class="etape disabled" data-etape="2" role="presentation">
                <a href="#etape2" data-toggle="tab" aria-controls="etape2" role="tab" title="Étape 2">
                    <span class="round-tab">
                        <i class="fa fa-envelope"></i>
                    </span>
                </a>
            </li>
            <li class="etape disabled" data-etape="3" role="presentation">
                <a href="#etape3" data-toggle="tab" aria-controls="etape3" role="tab" title="Étape 3">
                    <span class="round-tab">
                        <i class="fa fa-user-secret"></i>
                    </span>
                </a>
            </li>

            <li class="etape disabled" data-etape="4" role="presentation">
                <a href="#complete" data-toggle="tab" aria-controls="etape4" role="tab" title="Étape 4">
                    <span class="round-tab">
                        <i class="fa fa-thumbs-o-up"></i>
                    </span>
                </a>
            </li>
        </ul>
    </div>

    <div class="tab-content">
        <div class="tab-pane active" role="tabpanel" id="etape1" data-etape="1">
            <h3>Étape 1</h3>
            {if $etape == 1}
                {include file="$sousDoc.tpl"}
                <p class="pull-right"><a href="../index.php">Retour à la page d'accueil</a></p>
            {/if}
        </div>

        <div class="tab-pane" role="tabpanel" id="etape2" data-etape="2">
            <h3>Étape 2</h3>
            {if $etape == 2}
                {include file="$sousDoc.tpl"}
                <p class="pull-right"><a href="../index.php">Retour à la page d'accueil</a></p>
            {/if}
        </div>

        <div class="tab-pane" role="tabpanel" id="etape3" data-etape="3">
            <h3>Étape 3</h3>
            {if $etape == 3}
                {include file="$sousDoc.tpl"}
                <p class="pull-right"><a href="../index.php">Retour à la page d'accueil</a></p>
            {/if}
        </div>

        <div class="tab-pane" role="tabpanel" id="etape4" data-etape="4">
            <h3>Étape 4</h3>
            {if $etape == 4}
                {include file="$sousDoc.tpl"}
                    <p class="pull-right"><a href="../index.php">Retour à la page d'accueil</a></p>
            {/if}
        </div>
        <div class="clearfix"></div>
    </div>  <!-- tab-content -->

</div>


<script type="text/javascript">

$(document).ready(function () {

    var etape = $("#titre").data('etape');

    $(".etape").each(function(){
        var sousEtape = $(this).data('etape');
        if (sousEtape == etape)
            $(this).removeClass('disabled').addClass('active');
            else $(this).addClass('disabled').removeClass('active');
        })
    $(".tab-pane").each(function(){
        var sousEtape = $(this).data('etape');
        if (sousEtape == etape)
            $(this).removeClass('disabled').addClass('active');
            else $(this).addClass('disabled').removeClass('active');
        })


    //Wizard
    $('a[data-toggle="tab"]').on('show.bs.tab', function (e) {

        var $target = $(e.target);

        if ($target.parent().hasClass('disabled')) {
            return false;
        }
    });

    $(".next-step").click(function (e) {

        var $active = $('.wizard .nav-tabs li.active');
        $active.next().removeClass('disabled');
        nextTab($active);

    });

});

function nextTab(elem) {
    $(elem).next().find('a[data-toggle="tab"]').click();
}


</script>

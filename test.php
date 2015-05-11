<!DOCTYPE html>

<html>
<head>
    <title>testPage Title</title>
    <script type="text/javascript" src="js/jquery-1.10.2.min.js"></script>
 <script src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>    


<script type="text/javascript">
    jQuery.fn.single_double_click = function(single_click_callback, double_click_callback, timeout) {
        return this.each(function(){
            var clicks = 0;
            var self = this;
            jQuery(this).click(function(event){
                event.stopPropagation();
                clicks++;
                if (clicks == 1) {
                    setTimeout(function(){
                        if (clicks == 1) 
                            single_click_callback.call(self, event);
                            else 
                            double_click_callback.call(self, event);
                        clicks = 0;
                        },
                    timeout || 300);
                    }
                });
            });
        } 
</script>

<style type="text/css">
    button {height: 3em;
        font-weight: bold;
        font-size: 1.3em;
        width: 5em;
        }
        
    .double {
        background-color: #f77;
        text-align:center;
        }
    .gauche {
        background-color: #77f;
        text-align:left;
        }
    .droit {
        background-color: #ff0;
        text-align:right;
        }
        
    #zoneBoutons {
        width: 48em;
        text-align:center;
        min-height: 20em;
        background-color: #eee; 
    }
    
    #resultats span {
        width: 16em;
        display: inline-block;
        text-align:center;
    }
</style>
</head>

<body>
    <div id="zoneBoutons">
        <?php
        $nombre = 42;
        foreach (range(1,$nombre) as $n) {
        echo "<button></button>";
        }
        ?>
    </div>

<div id="resultats">
<span>Nombre d'erreurs <span id="compteur">0</span></span>
<span>Reste <span id="reste"><?php echo $nombre;?></span></span>
<span>Chrono <span id="timer">00 : 00 : 00</span></span>
</div>

<div class="drag">ddd</div>
<script type="text/javascript">
    
    $(document).ready(function (){

    // initialisation des boutons
    $("#zoneBoutons button").each(function(){
        var tirage = Math.floor((Math.random()*3)+1);
        switch (tirage) {
            case 1:
                $(this).attr('class', 'gauche');
                $(this).text('Gauche');
                break;
            case 2:
                $(this).attr('class', 'droit');
                $(this).text('Droit');
                break;
            case 3:
                $(this).attr('class', 'double');
                $(this).text('Double');
                break;
            }
        $(this).addClass('drag');
        })
    
    $(".drag").draggable();
    
    // fonction si erreur
    function faute (objet){
        var compteur = parseInt($("#compteur").text())+1;
        $("#compteur").text(compteur);
        }
    // fonction si ok
    function clickOK(objet){
        if (!(objet.hasClass('fini'))) {
            objet.addClass('fini');
            objet.fadeTo(0,0.3);
            var reste = parseInt($("#reste").text())-1;
            $("#reste").text(reste);
            if (reste == 41) 
                Start();
            if (reste == 0) 
                Stop();

            }
        }
    
    // traitement du double click, OK ou faute
    $("button.double").single_double_click(
        function () {
            if (!($(this).hasClass('fini'))) 
                faute($(this));
            },
        function () {
            clickOK($(this));
            },
        300
        )
    
    // click droit à mauvais escient
    $("button.double").contextmenu(function(e){
        e.preventDefault();
        if (!($(this).hasClass('fini'))) 
            faute($(this));
        e.stopPropagation();
        })

    $("button.gauche").contextmenu(function(e){
        e.preventDefault();
        if (!($(this).hasClass('fini'))) 
            faute($(this));
        e.stopPropagation();
        })        
    
    // click gauche à mauvais escient
    $("button.droit").click(function(e){
        e.preventDefault();
        if (!($(this).hasClass('fini'))) 
            faute($(this));
        e.stopPropagation();
        })
    
    // click gauche OK
    $("button.gauche").click(function(e){
        e.preventDefault();
        clickOK($(this));
        e.stopPropagation();
        })

    // click droit OK
    $("button.droit").contextmenu(function(e){
        e.preventDefault();
        clickOK($(this));
        e.stopPropagation();
        })
    
    // click hors boutons
    $("body").click(function(){
        faute($(this));
        })

 
    // chronomètre
    var demarre = false;
    
    $("#stop").hide();

    var startTime = 0;
    var start = 0;
    var end = 0;
    var diff = 0;
    // var reset = false;
    var timerID = 0;
 
    $("#start").click(function(e){
        e.preventDefault();
        Start();
        return false;
    });


    function chrono(){
        end = new Date();
        diff = end - start;
        diff = new Date(diff);

        var sec = diff.getSeconds();
        var min = diff.getMinutes();
        var hr = diff.getHours()-1;
 
        if (sec < 10){
            sec = "0" + sec;
            }
        if (min < 10){
            min = "0" + min;
            }
        if (hr < 10){
            hr = "0" + hr;
            }
        $("#timer").html(hr+" : "+min+" : "+sec);
    }
    
    function Start(){
        // $(".tog").toggle();
        start = new Date();
        timerID = setInterval(chrono, 100);
     }
     
    function Reset(){
        $("#timer").html("00 : 00 : 00");
        start = new Date();
        reset = true;
        }
        
    function Stop(){
        $(".tog").toggle();
        clearTimeout(timerID);
        }

 
    })
 
</script>
</body>

</html>

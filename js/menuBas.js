var timeout    = 500;
var closetimer = 0;
var leMenu = 0;

function menuBas_open(){
    menuBas_canceltimer();
    menuBas_close();
    leMenu = $(this).find("ul").css("visibility", "visible");
    }


function menuBas_close(){
    if (leMenu)
        leMenu.css('visibility', 'hidden')
    }

function menuBas_timer(){
    closetimer = window.setTimeout(menuBas_close, timeout);
    }

function menuBas_canceltimer(){
    if(closetimer){
        window.clearTimeout(closetimer);
        closetimer = null;
        }
    }

$(document).ready(function() {
    $('#menuBas > li').bind('mouseover', menuBas_open);
    $('#menuBas > li').bind('mouseout',  menuBas_timer)
    });

$(document).onclick = menuBas_close;

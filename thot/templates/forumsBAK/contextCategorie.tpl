<ul class="contextMenu" hidden>
  <li><a href="#"><i class="fa fa-times text-danger"></i> Supprimer cette catégorie</a></li>
  <li><a href="#"><i class="fa fa-edit text-info"></i> Renommer cette catégorie</a></li>
</ul>

<style media="screen">

    ul.contextMenu {
        list-style:none;
        margin:0;padding:0;
        position: absolute;
        color: #333;
        box-shadow: 0 12px 15px 0 rgba(0, 0, 0, 0.2);
    }

    ul.contextMenu * {
        transition:color .4s, background .4s;
    }

    ul.contextMenu li {
        min-width:150px;
        overflow: hidden;
        white-space: nowrap;
        padding: 12px 15px;
        background-color: #fff;
        border-bottom:1px solid #ecf0f1;
    }

    ul.contextMenu li a {
        color:#333;
        text-decoration:none;
    }

    ul.contextMenu li:hover {
        background-color: #ecf0f1;
    }

    ul.contextMenu li:first-child {
        border-radius: 5px 5px 0 0;
    }

    ul.contextMenu li:last-child {
    background:#ecf0f1;
    border-bottom:0;
    border-radius: 0 0 5px 5px
    }

    ul.contextMenu li:last-child a{ width:26%; }
    ul.contextMenu li:last-child:hover a{ color:#2c3e50 }
    ul.contextMenu li:last-child:hover a:hover { color:#2980b9 }

</style>

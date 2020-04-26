{foreach from=$stats key=likeLevel item=dataLike}

    <a href="javascript:void(0)"
       id="link_{$postId}"
        style="text-decoration: none"
        data-toggle="popover"
        data-postid="{$postId}"
        data-emoji="{$likeLevel}"
        title="<img src='js/fbLike/emojis/{$likeLevel}.svg' height='20px'> {ucfirst($likeLevel)} <span class='badge badge-danger pull-right'>{$dataLike|@count}</span>"
        data-html="true"
        data-placement="top"
        data-container="body"
        data-content="<ul class='list-unstyled fbLike emoji'><li>{$dataLike|implode:'</li><li>'}</li></ul>">

    <img src="js/fbLike/emojis/{$likeLevel}.svg" height="24px" alt="{$likeLevel}">

    </a>

 {/foreach}

<script>

    $(document).ajaxComplete(function () {

        $('[data-toggle="popover"]').popover( {
            trigger: 'hover'
        } );

    })

</script>

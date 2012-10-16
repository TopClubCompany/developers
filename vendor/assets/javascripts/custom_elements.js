
function reselect(select, addclass)
{

    addclass = typeof(addclass) != 'undefined' ? addclass : '';

    $(select).wrap('<div class="sel_wrap ' + addclass + '"/>');

    var sel_options = '';

    var selected_option = false;

    $(select).children('option').each(function() {

        if($(this).is(':selected')){

            selected_option = $(this).index();

        }
        sel_options = sel_options + '<div class="sel_option" value="' + $(this).val() + '">' + $(this).html() + '</div>';
    });
    var sel_imul = '<div class="sel_imul"><div class="sel_selected"><div class="selected-text">' + $(select).children('option').eq(selected_option).html() + '</div><div class="sel_arraw"></div></div><div class="sel_options">' + sel_options + '</div></div>';
    $(select).before(sel_imul);
}


function main()
{
    $('.sel_imul').live('click', function() {

        $('.sel_imul').removeClass('act');
        $(this).addClass('act');

        if ($(this).children('.sel_options').is(':visible')) {

            $('.sel_options').hide();

        }
        else {

            $('.sel_options').hide();
            $(this).children('.sel_options').show();

        }

    });

    $('.sel_option').live('click', function() {
        var tektext = $(this).html();
        $(this).parent('.sel_options').parent('.sel_imul').children('.sel_selected').children('.selected-text').html(tektext);

        $(this).parent('.sel_options').children('.sel_option').removeClass('sel_ed');
        $(this).addClass('sel_ed');

        var tekval = $(this).attr('value');
        tekval = typeof(tekval) != 'undefined' ? tekval : tektext;
        $(this).parent('.sel_options').parent('.sel_imul').parent('.sel_wrap').children('select').children('option').removeAttr('selected').each(function() {
            if ($(this).val() == tekval) {

                $(this).attr('selected', 'select');

            }
        });
    });

    var selenter = false;
    $('.sel_imul').live('mouseenter', function()
    {
        selenter = true;
    });

    $('.sel_imul').live('mouseleave', function()
    {
        selenter = false;
    });

    $(document).click(function()
    {
        if (!selenter) {

            $('.sel_options').hide();
            $('.sel_imul').removeClass('act');
        }
    });
}

$(document).ready(function(){
    reselect('#ourselect2', 'sec');
    main();
});



/**
* Created with JetBrains RubyMine.
* User: tolyamba
* Date: 23.11.12
* Time: 16:44
* To change this template use File | Settings | File Templates.
*/
$(document).ready(function(){
    $('#search_results #refine .more').click(function(){
        id = $(this).prev().attr('id');
        switch(id){
            case 'category':
                addCategory();
                break;
            case 'price':
                addPrice();
                break;
            case 'kitchen':
                addKitchen();
                break;
        }
        return false;
    });
});
function addCategory(){
    html = '';
    html+= '<label class="checkbox"><input type="checkbox">Restaurants</label>'
    html+= '<label class="checkbox"><input type="checkbox">Sushi</label>'
    html+= '<label class="checkbox"><input type="checkbox">Pubs & bars</label>'
    html+= '<label class="checkbox"><input type="checkbox">Pizza</label>'
    $('#category label:last').after(html);
}

function addPrice(){
    html = '';
    html+= '<label class="checkbox"><input type="checkbox">Cheap&nbsp;<b>$</b></label>'
    html+= '<label class="checkbox"><input type="checkbox">Medium&nbsp;<b>$$</b></label>'
    html+= '<label class="checkbox"><input type="checkbox">Reasonable&nbsp;<b>$$$</b></label>'
    html+= '<label class="checkbox"><input type="checkbox">Premium&nbsp;<b>$$$</b></label>'
    $('#price label:last').after(html);
}

function addKitchen(){
    html = '';
    html+= '<label class="checkbox"><input type="checkbox">European</label>'
    html+= '<label class="checkbox"><input type="checkbox">Mediterranian</label>'
    html+= '<label class="checkbox"><input type="checkbox">Ukrainian</label>'
    html+= '<label class="checkbox"><input type="checkbox">Caucasian</label>'
    $('#kitchen label:last').after(html);
}
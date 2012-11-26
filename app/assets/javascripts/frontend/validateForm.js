////validate email in order form
//function validateEmail(){
//    var email = $('#new_user #user_email');
//    email.keyup(function(event) {
//        $(this).tipsy({trigger: 'manual',gravity: 'w'});
//        if($(this).val() == ''){
//            $(this).tipsy('hide');
//        }
//        else{
//            if(/[а-я]+/i.test($(this).val())){
//                $(this).attr('original-title','Только латиница')
//                $(this).tipsy('show');
//            }else if(($(this).val()).length > 7){
//                $(this).attr('original-title','Введите корректный e-mail')
//                //original-title=Введите корректный e-mail
//                pattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,5}$/i
//                if(!pattern.test($(this).val())){
//                    $(this).tipsy('show');
//                }
//                else{
//                    $(this).tipsy('hide');
//                }
//            }
//            else{
//                $(this).tipsy('hide');
//            }
//        }
//    });
//    email.blur(function(){
//        $(this).tipsy({trigger: 'manual',gravity: 'w'});
//        $(this).attr('original-title','Введите корректный e-mail')
//        if($(this).val() == ''){
//            $(this).tipsy('hide');
//        }
//        else{
//            if(/[а-я]+/i.test($(this).val())){
//                $(this).attr('original-title','Только латиница')
//                $(this).tipsy('show');
//            }else if(($(this).val()).length > 0){
//                $(this).attr('original-title','Введите корректный e-mail')
//                //original-title=Введите корректный e-mail
//                /* /^[a-zA-Z0-9._-]+@[a-zA-Z0-9-]+\.[a-zA-Z.]{2,5}$/i */
//                pattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,5}$/i
//                if(!pattern.test($(this).val())){
//                    $(this).tipsy('show');
//                }
//                else{
//                    $(this).tipsy('hide');
//                }
//            }
//            else{
//                $(this).tipsy('hide');
//            }
//        }
//    });
//}
//function enter_phone(){
//    //event enter phone (only numbers)
//    var user_phone = $('#new_user #user_phone');
//    user_phone.keyup(function(event) {
//        $(this).tipsy({trigger: 'manual',gravity: 'w'});
//        // Allow: backspace, delete, tab, escape, and enter
//        if ( event.keyCode == 46 || event.keyCode == 8 || event.keyCode == 9 || event.keyCode == 27 || event.keyCode == 13 ||
//            // Allow: Ctrl+A
//            (event.keyCode == 65 && event.ctrlKey === true) ||
//            // Allow: home, end, left, right
//            (event.keyCode >= 35 && event.keyCode <= 39)) {
//            // let it happen, don't do anything
//            return;
//        }
//        else {
//            // Ensure that it is a number and stop the keypress
//            if (event.shiftKey || (event.keyCode < 48 || event.keyCode > 57) && (event.keyCode < 96 || event.keyCode > 105 )) {
//                //$('.order_phone_error').show()
//                $(this).tipsy('show');
//                //$('.order_phone_error').tooltip('show');
//                function hide (){
//                    //$('order_phone_error').fadeOut()
//                    $(this).tipsy('hide');
//                    //$('.order_phone_error').tooltip('hide');
//                }
//                setTimeout(hide, 1500)
//                event.preventDefault();
//            }
//            else{
//                //$('.order_phone_error').hide();
//                //$('.order_phone_error').tooltip('hide');
//                $(this).tipsy('hide');
//            }
//        }
//    });
//    user_phone.blur(function(){
//        $(this).tipsy({trigger: 'manual',gravity: 'w'});
//        $(this).tipsy('hide');
//    });
//}

//function validPass(){
//    var user_pass = $('#new_user #user_password');
//    user_pass.keyup(function(event) {
//        $(this).tipsy({trigger: 'manual',gravity: 'w'});
//        if($(this).val() == ''){
//            $(this).tipsy('hide');
//        }
//        else{
//            if(/[а-я]+/i.test($(this).val())){
//                $(this).attr('original-title','Только латиница')
//                $(this).tipsy('show');
//            }
//            else{
//                $(this).tipsy('hide');
//            }
//        }
//    });
//
//    user_pass.blur(function(){
//        $(this).tipsy({trigger: 'manual',gravity: 'w'});
//        $(this).attr('original-title','Только латиница')
//        if($(this).val() == ''){
//            $(this).tipsy('hide');
//        }
//        else{
//            if(/[а-я]+/i.test($(this).val())){
//                $(this).attr('original-title','Только латиница')
//                $(this).tipsy('show');
//            }
//            else{
//                $(this).tipsy('hide');
//            }
//        }
//    });
//}

//function validNameLastname(){
//    var user_first_name = $('#new_user #user_first_name');
//    user_first_name.keyup(function(event) {
//        $(this).tipsy({trigger: 'manual',gravity: 's'});
//        if($(this).val() == ''){
//            $(this).tipsy('hide');
//        }
//        else{
//            if(/[^а-яa-z0-9_-]+/i.test($(this).val())){
//                $(this).attr('original-title','Разрешается вводить латиницу, кириллицу, "-", "_"')
//                $(this).tipsy('show');
//            }
//            else{
//                $(this).tipsy('hide');
//            }
//        }
//    });
//
//    user_first_name.blur(function(){
//        $(this).tipsy({trigger: 'manual',gravity: 's'});
//        if($(this).val() == ''){
//            $(this).tipsy('hide');
//        }
//        else{
//            if(/[^а-яa-z0-9_-]+/i.test($(this).val())){
//                $(this).attr('original-title','Разрешается вводить латиницу, кириллицу, "-", "_"')
//                $(this).tipsy('show');
//            }
//            else{
//                $(this).tipsy('hide');
//            }
//        }
//    });
//
//    var user_last_name = $('#new_user #user_last_name');
//    user_last_name.keyup(function(event) {
//        $(this).tipsy({trigger: 'manual',gravity: 's'});
//        if(/[^а-яa-z0-9_-]+/i.test(user_last_name.val())){
//            $(this).attr('original-title','Разрешается вводить латиницу, кириллицу, "-", "_"')
//            $(this).tipsy('show');
//        }
//        else{
//            $(this).tipsy('hide');
//        }
//    });
//
//    user_last_name.blur(function(){
//        $(this).tipsy({trigger: 'manual',gravity: 's'});
//        if($(this).val() == ''){
//            $(this).tipsy('hide');
//        }
//        else{
//            if(/[^а-яa-z0-9_-]+/i.test($(this).val())){
//                $(this).attr('original-title','Разрешается вводить латиницу, кириллицу, "-", "_"')
//                $(this).tipsy('show');
//            }
//            else{
//                $(this).tipsy('hide');
//            }
//        }
//    });
//}

function checkNewUser(){
    user_pass = $('#new_user #user_password');
    user_email = $('#new_user #user_email');
    user_phone = $('#new_user #user_phone');
    user_first_name = $('#new_user #user_first_name');
    user_last_name = $('#new_user #user_last_name');
    patternEmail = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,5}$/i
    patternPhone = /^\+38\(0\d{2}\)\d{3}\-\d{2}\-\d{2}$/
    patternPass = /[^а-я]+/i
    patternNameLastname = /[а-яa-z0-9_-]+/i
    if(patternEmail.test(user_email.val()) &&  patternPhone.test(user_phone.val())  &&
        patternPass.test(user_pass.val()) &&
        patternNameLastname.test(user_first_name.val()) &&
        patternNameLastname.test(user_last_name.val())
        ){
        return true;
    }
    else{
        //check email
        if(user_email.val() == ''){
            user_email.attr('original-title','Заполните поле');
            user_email.tipsy('show');
        }  else if(!patternEmail.test(user_email.val())){
            user_email.attr('original-title','Введите корректный email');
            user_email.tipsy('show');
        }
        function hideEmail (){
            user_email.tipsy('hide');
        }
        setTimeout(hideEmail, 1500);

        //check phone
        if(!patternPhone.test(user_phone.val())){
            user_phone.attr('original-title','Введите корректный телефон');
            user_phone.tipsy('show');
        }
        else if(user_phone.val() == ''){
            user_phone.attr('original-title','Заполните поле');
            user_phone.tipsy('show');
        }
        function hidePhone (){
            user_phone.tipsy('hide');
        }
        setTimeout(hidePhone, 1500);

        //check pass
        if(!patternPass.test(user_pass.val())){
            user_pass.attr('original-title','Введите корректный пароль');
            user_pass.tipsy('show');
        }
        else if(user_pass.val().length < 5){
            user_pass.attr('original-title','Пароль должен содержать не меньше 5 символов');
            user_pass.tipsy('show');
        }
        else if(user_pass.val() == ''){
            user_pass.attr('original-title','Заполните поле');
            user_pass.tipsy('show');
        }
        function hidePass (){
            user_pass.tipsy('hide');
        }
        setTimeout(hidePass, 1500);

        //check first name
        if(!patternNameLastname.test(user_first_name.val())){
            user_first_name.attr('original-title','Введите корректое имя');
            user_first_name.tipsy('show');
        }
        else if(user_first_name.val().length < 2){
            user_first_name.attr('original-title','Слишком короткое имя');
            user_first_name.tipsy('show');
        }
        else if(user_first_name.val() == ''){
            user_first_name.attr('original-title','Заполните поле');
            user_first_name.tipsy('show');
        }
        function hideFirstName (){
            user_first_name.tipsy('hide');
        }
        setTimeout(hideFirstName, 1500);

        //check last name
        if(!patternNameLastname.test(user_last_name.val())){
            user_last_name.attr('original-title','Введите корректую фамилию');
            user_last_name.tipsy('show');
        }
        else if(user_last_name.val().length < 2){
            user_last_name.attr('original-title','Слишком короткая фамилия');
            user_last_name.tipsy('show');
        }
        else if(user_last_name.val() == ''){
            user_last_name.attr('original-title','Заполните поле');
            user_last_name.tipsy('show');
        }
        function hideLastName (){
            user_last_name.tipsy('hide');
        }
        setTimeout(hideLastName, 1500);
        return false;
    }
    return false;
}

$(document).ready(function(){
//    validateEmail();
//    enter_phone();
//    validPass();
//    validNameLastname();
    $('#new_user #user_phone').mask('+38(999)999-99-99');
    $('#sign_up_page #new_user').submit(function(){
        if(!checkNewUser()){
            return false;
        }else{
            return true;
        }
    });
});

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

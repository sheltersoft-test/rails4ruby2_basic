$(function(){
  //login form
  I18n.locale = document.documentElement.lang;

  //login form
  $('#login-form').formValidation({
    framework: 'bootstrap',
    fields: {
      user_email: {
        selector: "#user_email",
        validators: {
            notEmpty: {message: I18n.t("js.general.task.mandatory_field")}
        }
      },
      user_password: {
        selector: "#user_password",
        validators: {
            notEmpty: {message: I18n.t("js.general.task.mandatory_field")}
        }
      }
    }
  });  

  //forgot password form
  $('#forgotPass-form').formValidation({
    framework: 'bootstrap',
    fields: {
      user_email: {
        selector: "#user_email",
        validators: {
            notEmpty: {message: I18n.t("js.general.task.mandatory_field")}
        }
      }
    }
  });    

  //change password form
  $('#changePass-form').formValidation({
    framework: 'bootstrap',
    fields: {
      user_password: {
        selector: "#user_password",
        validators: {
            notEmpty: {message: I18n.t("js.general.task.mandatory_field")}
        }
      },
      user_password_confirmation: {
        selector: "#user_password_confirmation",
        validators: {
            notEmpty: {message: I18n.t("js.general.task.mandatory_field")}
        }
      }      
    }
  });
});

$("#flash_msg").delay(3000).fadeOut(500);

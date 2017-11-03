$(function(){

  I18n.locale = document.documentElement.lang;
  $.fn.datepicker.defaults.language = I18n.locale;

  // user form validation
  $('#executive-form, #director-form').formValidation({
    framework: 'bootstrap',
    fields: {
      user_first_name: {
        selector: "#user_first_name",
        validators: {
            notEmpty: {message: I18n.t("js.general.task.mandatory_field")}
        }
      },
      user_last_name: {
        selector: "#user_last_name",
        validators: {
            notEmpty: {message: I18n.t("js.general.task.mandatory_field")}
        }
      },
      user_email: {
        selector: "#user_email",
        validators: {
            notEmpty: {message: I18n.t("js.general.task.mandatory_field")}
        }
      }
    }
  });      

  //order_dbm_email_form
  $('#order_dbm_email_form').formValidation({
    framework: 'bootstrap',
    fields: {
      input_recipient_email: {
        selector: "#input_recipient_email",
        validators: {
            notEmpty: {message: I18n.t("js.general.task.mandatory_field")}
        }
      },
      subject: {
        selector: "#subject",
        validators: {
            notEmpty: {message: I18n.t("js.general.task.mandatory_field")}
        }
      },
      message: {
        selector: "#message",
        validators: {
            notEmpty: {message: I18n.t("js.general.task.mandatory_field")}
        }
      }      
    }
  });  

  // send feedback email form
  $('#send_feedback_email_form')
    .formValidation({
      framework: 'bootstrap',
      fields: {
        feedback_message: {
          selector: "#feedback_message",
          validators: {
              notEmpty: {message: I18n.t("js.general.task.mandatory_field")}
          }
        }      
      }
    }).on('success.form.fv', function(e) {
      // Prevent form submission
      e.preventDefault();

      // Some instances you can use are
      var $form = $(e.target),        // The form instance
          fv    = $(e.target).data('formValidation'); // FormValidation instance

      // Do whatever you want here ...
    });
});

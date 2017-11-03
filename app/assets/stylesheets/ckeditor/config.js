$(document).ready(function(){
	CKEDITOR.editorConfig = function(config) {
	  config.language = "en";
	  config.height = 250;
	  config.codeSnippet_theme = 'pojoaque';
	  config.uiColor = "#AADC6E";
    config.toolbar =  [{ name: 'document', items: ['Source', '-', 'Preview'] },
                       { name: 'basicstyles', items: ['Bold', 'Italic', 'Underline'] },
    								 ];
	  return true;
	};
});
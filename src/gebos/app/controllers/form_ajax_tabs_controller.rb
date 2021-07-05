# Esta clase tiene la funcionalidad básica para un controlador que
# use un formulario tipo AJAX con tabs
class FormAjaxTabsController < FormAjaxController

  layout 'form_ajax_tabs'
  
  skip_before_filter :set_charset, :only=>[:edit, :cancel_edit, :new, :save_new, :save_edit, :cancel_new, :list, :delete, :form_error, :errors_for, :error, :form_save_new]

end

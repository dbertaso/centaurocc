# Esta clase tiene la funcionalidad básica para un controlador que
# use un formulario tipo subTab
#
class FormTabTabsController < FormTabsController

  skip_before_filter :set_charset, :only=>[:edit, :cancel_edit, :save_new, :new, :save_edit, :cancel_new, :list, :delete, :form_error, :errors_for, :error, :form_save_new]

  layout 'form_tab_tabs'

end

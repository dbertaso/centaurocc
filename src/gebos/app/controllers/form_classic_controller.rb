# Esta clase tiene la funcionalidad básica para un controlador que
# use un formulario que no es AJAX
#
class FormClassicController < FormController

  helper :form_classic
  layout 'form_classic'

#antes estaba esto skip_before_filter :set_charset, :only=>[:form_error, :errors_for, :error]

  skip_before_filter :set_charset, :only=>[:edit, :cancel_edit, :new, :save_new, :save_edit, :cancel_new, :list, :delete, :form_error, :errors_for, :error, :form_save_new]

  protected

  #Funcionalidad para el método save_new de los controladores
  def form_save_new(entity, options={})
    value = options[:value]
    if value.nil?
      value = entity.save
    end
    if value
      identity_field = entity_field(entity, @form_identity_field)
      flash[:notice] = "#{@form_title_record} '#{identity_field}' #{I18n.t('Sistema.Body.Controladores.Mensaje.insercion')}"
      render :update do |page|
        new_options = {:action=>'view', :id=>entity.id }
        new_options.merge!(options[:params]) unless options[:params].nil?
        new_options.merge!({:popup=>params[:popup]}) unless params[:popup].nil?
        page.redirect_to new_options
      end
    else
      render :update do |page|
        page.form_error
        page.<< "window.scrollTo(0,0);"
      end
    end
  end

    #Funcionalidad para el método save_edit de los controladores
  def form_save_edit(entity, options={})
    value = options[:value]
    if value.nil?
      value = entity.update_attributes(params[@form_entity])
    end
    if value
      if @form_identity_field
        identity_field = entity_field(entity, @form_identity_field)
        flash[:notice] = "#{@form_title_record} '#{identity_field}' #{I18n.t('Sistema.Body.Controladores.Mensaje.modificacion')}"
      else
        flash[:notice] = "#{@form_title_record} #{I18n.t('Sistema.Body.Controladores.Mensaje.modificacion')}"
      end
      render :update do |page|
        new_options = {:action=>'index', :id=>entity.id }
        new_options.merge!(options[:params]) unless options[:params].nil?
        new_options.merge!({:popup=>params[:popup]}) unless params[:popup].nil?
        page.redirect_to new_options
      end
    else
      render :update do |page|
        page.form_error
        page.<< "window.scrollTo(0,0);"
      end
    end
  end

  def common
    super
    @form_search_expression = []
  end

end

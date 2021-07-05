# Esta clase tiene la funcionalidad básica para un controlador que
# use un formulario tipo subTab
#
class FormTabsController < FormController

  helper :form_classic
  layout 'form_classic'

  skip_before_filter :set_charset, :only=>[:edit, :cancel_edit, :save_new, :save_edit, :cancel_new, :list, :delete, :form_error, :errors_for, :error, :form_save_new]

  protected
    #Funcionalidad para el método save_new de los controladores
  def form_save_new(entity, options={})
    value = options[:value]
    if value.nil?
      value = entity.save
    end
    #logger.info entity.inspect
    #logger.info entity.errors.size

    if value
      identity_field = entity_field(entity, @form_identity_field)
      flash[:notice] = "#{@form_title_record} '#{identity_field}' #{I18n.t('Sistema.Body.Controladores.Mensaje.insercion')}"
      #logger.debug "PARAMETROS  22229932========> " << entity.inspect
      render :update do |page|
        new_options = {:action=>'edit', :id=>entity.id }
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

  def form_save_new_esp(entity, options={})
    value = options[:value]
    if value.nil?
      value = entity.save
    end
    #logger.info entity.inspect
    #logger.info entity.errors.size

    if value
      identity_field = entity_field(entity, @form_identity_field)
      flash[:notice] = "#{@form_title_record} '#{identity_field}' #{I18n.t('Sistema.Body.Controladores.Mensaje.insercion')}"
      render :update do |page|
        new_options = {:action=>'index'}
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
      identity_field = entity_field(entity, @form_identity_field)
      flash[:notice] = "#{@form_title_record} '#{identity_field}' #{I18n.t('Sistema.Body.Controladores.Mensaje.modificacion')}"
      render :update do |page|
        if !params[:controlador].nil?
          new_options = {:controlador => params[:controlador], :action=>'edit', :id=>entity.id }
        else
          new_options = {:action=>'edit', :id=>entity.id }
        end
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

# Esta clase tiene la funcionalidad básica para un controlador que
# use un formulario tipo AJAX
class FormAjaxController < FormController

  helper :form_ajax
  layout 'form_ajax'

  skip_before_filter :set_charset, :only=>[:edit, :cancel_edit, :new, :save_new, :save_edit, :cancel_new, :list, :delete, :form_error, :errors_for, :error, :form_save_new, :form_save_ajaxnew, :form_save_ajaxedit, :form_view, :form_cancel_view]

  protected
  #Funcionalidad para el método new de los controladores
  def form_new(entity)
    render :update do |page|
      page.form_new entity
    end
  end
  #Funcionalidad para el método cancel_new de los controladores
  def form_cancel_new
    render :update do |page|
      page.form_cancel_new
    end
  end

  #Funcionalidad para el método save new de los controladores
  def form_save_new(entity, options={})
    value = options[:value]
    if value.nil?
      value = entity.save
    end
    if value
      identity_field = entity_field(entity, @form_identity_field) unless @form_identity_field.nil?
      render :update do |page|
        if @form_identity_field.nil?
          page.form_save_new entity, @form_title_record
        else
          page.form_save_new entity, @form_title_record, identity_field
        end
      end
    else
      render :update do |page|
        page.form_error 'form_new'
        page.<< "varEnviado = false;"
      end
    end
  end


  #Funcionalidad para el método save new de los controladores
  def form_save_ajaxnew(entity, options={})
    value = options[:value]
    if value.nil?
      value = entity.save
    end
    logger.debug "form_save_ajaxnew ===> " << value.inspect
    if value
      identity_field = entity_field(entity, @form_identity_field) unless @form_identity_field.nil?

      controlador = params[:controller].split('/')
      nombre_controlador = "#{controlador[1].to_s}"
      logger.debug "CONTROLADOR ===> " << nombre_controlador
      id = params[:id].to_s
      render :update do |page|
        if @form_identity_field.nil?
          logger.debug "ENTRE EN EL IF"
          page.form_save_ajaxnew entity, @form_title_record, nombre_controlador.to_s, id
        else
          logger.debug "ENTRE EN EL ELSE #{nombre_controlador.to_s}"
          page.form_save_ajaxnew entity, @form_title_record, nombre_controlador.to_s, id, identity_field
        end
      end
    else
      logger.debug "ENTRE EN EL FALSE"
      render :update do |page|
        page.form_error 'form_new'
        page.<< "varEnviado = false;"
      end
    end
  end

  #Funcionalidad para el método edit de los controladores
  def form_edit(entity)
    render :update do |page|
      page.form_edit entity
    end
  end

  #Funcionalidad para el método save_edit de los controladores
  def form_save_edit(entity, options={})
    value = options[:value]
    if value.nil?
      value = entity.update_attributes(params[@form_entity])
    end
    if value
      identity_field = entity_field(entity, @form_identity_field) unless @form_identity_field.nil?
      render :update do |page|
        if @form_identity_field.nil?
          page.form_save_edit entity, @form_title_record
        else
          page.form_save_edit entity, @form_title_record, identity_field
        end
      end
    else
      render :update do |page|
        page.form_error "row_#{entity.id}"
        page.<< "varEnviado = false;"
      end
    end
  end

    #Funcionalidad para el método cancel_edit de los controladores
  def form_cancel_edit(entity)
    render :update do |page|
      page.form_cancel_edit entity
    end
  end

  #Funcionalidad para el método view de los controladores
  def form_view(entity)
    render :update do |page|
      page.form_view entity
    end
  end

  def form_cancel_view(entity)
    render :update do |page|
      page.form_cancel_view entity
    end
  end


  def common
    super
  end

end

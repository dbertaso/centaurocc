# Contiene las funcionalidades básicas para todos los controladores de todos los tipos de formularios
class FormController < ApplicationController

  skip_before_filter :set_charset, :only=>[:form_error, :errors_for, :error, :form_list, :form_list_view]

  before_filter :common

  protected
  #Funcionalidad para el método list de los controladores
  def form_list
    if request.xml_http_request?
      render :update do |page|
        page.form_list #ejecutando el form_list de la vista
      end
    end
  end

  #Funcionalidad para el método list_view de los controladores
  def form_list_view
    if request.xml_http_request?
      render :update do |page|
        page.form_list_view
      end
    end
  end

#Funcionalidad para el método delete de los controladores
  def form_delete(entity, value=nil) #entity es el modelo.
    if value.nil?
      value = entity.destroy #eliminar rubros
    end
    if value
      #controlador = params[:controller].split('/')
      #nombre_controlador = "#{controlador[1].to_s}"

      field = entity_field(entity, @form_identity_field) unless @form_identity_field.nil?
      render :update do |page|
        if @form_identity_field.nil?
          page.form_delete entity, @form_entity
        else
          page.form_delete entity, @form_title_record, field
        end
      end
    else
      render :update do |page|
        page.form_error
      end
    end
  end

#Funcionalidad para el método delete de los controladores
  def form_ajaxdelete(entity, value=nil) #entity es el modelo.
    if value.nil?
      id = entity.rubro_id
      value = entity.destroy #eliminar rubros
    end
    if value
      field = entity_field(entity, @form_identity_field) unless @form_identity_field.nil?
      render :update do |page|
        if @form_identity_field.nil?
          page.form_ajaxdelete entity, @form_entity
        else
          page.form_ajaxdelete entity, @form_title_record, field
        end
      end
    else
      render :update do |page|
        page.form_error
      end
    end
  end

#Funcionalidad para el método delete de los controladores con refresh en index
  def form_ajaxdelete_refresh(entity, value=nil) #entity es el modelo.
    if value.nil?
      id = entity.rubro_id
      value = entity.destroy #eliminar rubros
    end
    if value
      field = entity_field(entity, @form_identity_field) unless @form_identity_field.nil?
      render :update do |page|
        if @form_identity_field.nil?
          page.form_ajaxdelete_refresh entity, @form_entity ,nil, id
        else
          page.form_ajaxdelete_refresh entity, @form_title_record, field, id
        end
      end
    else
      render :update do |page|
        page.form_error
      end
    end
  end

  #Funcionalidad para el método expand de los controladores
  #Este método expande una fila de una tabla con AJAX
  def form_expand(entity)
    render :update do |page|
      page.form_expand entity
    end
  end

  #Funcionalidad para el método collapse de los controladores
  #Este método contrae una fila de una tabla con AJAX
  def form_collapse(entity)
    render :update do |page|
      page.form_collapse entity
    end
  end

  def common
    @records_by_page = 15
  end


  def entity_field(entity, field)
    fields = field.split('.')
    value = entity
    for field in fields
      value = value.send(field)
    end
    value
  end

end

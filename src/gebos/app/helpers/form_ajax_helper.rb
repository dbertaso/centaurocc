# Methods added to this helper will be available to all templates in the application.

include FormHelper
#Clase que contiene funciones que ayudan a crear los formularios tipo AJAX
module FormAjaxHelper


#Función que crea el título de una vista cuando se esta agregando un registro
  def form_title_new
    render :partial=>'/form/ajax/title_new'
  end

#Función que crea el título de una vista cuando se esta visualizando un registro
  def form_title_view(identity)
    render :partial=>'/form/ajax/title_view', :locals=>{:identity => identity}
  end

#Función que crea el título de una vista cuando se esta modificando un registro
  def form_title_edit(identity)
    render :partial=>'/form/ajax/title_edit', :locals=>{:identity => identity}
  end

#Función que crea el título de una vista cuando se estan listando los registros
  def form_title_list
    render :partial=>'/form/ajax/title_list'
  end

#Función que acomoda los elementos de la vista cuando se esta agregando un registro
  def form_new(entity)
    page.form_reset
    page.replace_html 'form_new', :partial => 'new'
    page.hide 'button_new'
    page.show 'form_new'
  end

#Función que acomoda los elementos de la vista cuando se esta cancelando un registro agregado
  def form_cancel_new
    page.form_reset
    page.show 'button_new'
    page.hide 'form_new'
  end

#Función que acomoda los elementos de la vista cuando se esta guardando un registro agregado

  def form_save_new(entity, title, identity = nil)

    message = identity.nil? ? "#{title} #{I18n.t('Sistema.Body.Vistas.Helpers.Mensajes.insercion')}" : "#{title} '#{identity}' #{I18n.t('Sistema.Body.Vistas.Helpers.Mensajes.insercion')}"
    page.hide 'error'
    page.hide 'form_new'
    page.insert_html :top, 'list_body' , :partial => 'row', :locals => { :even_odd => 0 }
    page.visual_effect :highlight, "row_#{entity.id}", :duration => 0.6
    page.show 'button_new'
    page.replace_html 'message', message
    page.show 'message'
    #page.redirect_to nombre_controlador

  end

#Función que acomoda los elementos de la vista cuando se esta guardando un registro agregado

  def form_save_ajaxnew(entity, title, nombre_controlador, valor_id, identity = nil)

    message = identity.nil? ? "#{title} #{I18n.t('Sistema.Body.Vistas.Helpers.Mensajes.insercion')}" : "#{title} '#{identity}' #{I18n.t('Sistema.Body.Vistas.Helpers.Mensajes.insercion')}"
    #page.alert "Message ======> #{valor_id.to_s}"
    page.hide 'error'
    page.hide 'form_new'
    page.insert_html :top, 'list_body' , :partial => 'row', :locals => { :even_odd => 0 }
    page.visual_effect :highlight, "row_#{entity.id}", :duration => 0.6
    page.show 'button_new'
    page.replace_html 'message', message
    page.show 'message'
    page.redirect_to :controller=>nombre_controlador, :action=>'index', :id=>valor_id

  end


  #Función que acomoda los elementos de la vista cuando se esta guardando un registro modificado
  def form_save_edit(entity, title, identity = nil)
    message = identity.nil? ?
      "#{title} #{I18n.t('Sistema.Body.Vistas.Helpers.Mensajes.modificacion')}" :
      "#{title} '#{identity}' #{I18n.t('Sistema.Body.Vistas.Helpers.Mensajes.modificacion')}"
    page.hide 'error'
    page.remove "row_#{entity.id}"
    page.insert_html :after, "row_#{entity.id}_edit", :partial => 'row', :locals=>{ :even_odd => 0 }
    page.remove "row_#{entity.id}_edit"
    page.show "row_#{entity.id}"
    page.visual_effect :highlight, "row_#{entity.id}", :duration => 0.6
    page.replace_html 'message', message
    page.show 'message'
  end

#Función que acomoda los elementos de la vista cuando se esta modificando un registro
  def form_edit(entity)
    page.form_reset
    page.hide "row_#{entity.id}"
    page.insert_html :after, "row_#{entity.id}", :partial => 'edit'
    page.show "row_#{entity.id}_edit"
  end

  #Función que acomoda los elementos de la vista cuando se esta cancelando un registro modificado
  def form_cancel_edit(entity)
    page.form_reset
    page.remove "row_#{entity.id}_edit"
    page.show "row_#{entity.id}"
  end

#Función que crea los botones de guardar y cancelar para los formularios
  def form_buttons_edit(params={})
    render :partial=>'/form/classic/buttons_edit', :locals=>{:params=>params}
  end

#Función que acomoda los elementos de la vista cuando se esta consultando un registro
  def form_view(entity)
    page.form_reset
    page.hide "row_#{entity.id}"
    page.insert_html :after, "row_#{entity.id}", :partial => 'view'
    page.show "row_#{entity.id}_view"
  end


  #Función que acomoda los elementos de la vista cuando se esta cancelando un registro de consulta
  def form_cancel_view(entity)
    page.form_reset
    page.remove "row_#{entity.id}_view"
    page.show "row_#{entity.id}"
  end

end

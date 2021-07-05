# Methods added to this helper will be available to all templates in the application.
#
#Clase que contiene funciones que ayudan a crear los formularios que no son de tipo AJAX
include FormHelper

module FormClassicHelper

#Función que crea el título de una vista cuando se esta agregando un registro
  def form_title_new
    render :partial=>'/form/classic/title_new'
  end
#Función que crea el título de una vista cuando se esta visualizando un registro    
  def form_title_view
    render :partial=>'/form/classic/title_view'
  end
#Función que crea el título de una vista cuando se esta modificando un registro    
  def form_title_edit(identity = nil)
    render :partial=>'/form/classic/title_edit', :locals=>{:identity => identity}
  end
#Función que crea el título de una vista cuando se esta visualizando un registro,
#y recibe el nombre de la tabla sobre la cual se agrega el registro 
  def form_title_view(identity)
    render :partial=>'/form/classic/title_view', :locals=>{:identity => identity}
  end

#Función que crea el título de una vista para las búsquedas
  def form_title_search
    render :partial=>'/form/classic/title_search'    
  end

#Función que crea los botones de guardar y cancelar para los formularios
  def form_buttons_edit(params={})
    render :partial=>'/form/classic/buttons_edit', :locals=>{:params=>params}
  end

#Función que crea los botones de enviar y cancelar para los formularios
  def form_buttons_cobranzas(params={})
    render :partial=>'/form/classic/buttons_cobranzas', :locals=>{:params=>params}
  end

end

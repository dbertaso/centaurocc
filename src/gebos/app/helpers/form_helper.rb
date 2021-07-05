# Methods added to this helper will be available to all templates in the application.
#
#Contiene métodos que ayuda a imprimir las vistas en la mayoria de los tipos de formularios
module FormHelper

#Función que acomoda los elementos de la vista cuando se listan registros
  def form_list
    #logger.debug "entro en helper form list"
    page.form_reset
    page.replace_html 'list', :partial => 'list'
  end

#Función que acomoda los elementos de la vista cuando visualiza un registro
  def form_list_view
    page.replace_html 'list', :partial => 'list_view'
  end

#Función que acomoda los elementos de la vista cuando se elimina un registro
  def form_delete(entity, title, identity = nil )
    message = identity.nil? ?
      "#{title} #{I18n.t('Sistema.Body.Vistas.Helpers.Mensajes.eliminacion')}" :
      "#{title} '#{identity}' #{I18n.t('Sistema.Body.Vistas.Helpers.Mensajes.eliminacion')}"
    page.hide 'error'
    page.remove "row_#{entity.id}"
    page.replace_html 'message', message
    page.show 'message'
    #page.redirect_to nombre_controlador
  end

#Función que acomoda los elementos de la vista cuando se elimina un registro
  def form_ajaxdelete(entity, title,  identity = nil)
    message = identity.nil? ?
      "#{title} #{I18n.t('Sistema.Body.Vistas.Helpers.Mensajes.eliminacion')}" :
      "#{title} '#{identity}' #{I18n.t('Sistema.Body.Vistas.Helpers.Mensajes.eliminacion')}"
    page.hide 'error'
    page.remove "row_#{entity.id}"
    page.replace_html 'message', message
    page.show 'message'
   end

#Función que acomoda los elementos de la vista cuando se elimina un registro con refresh al index
  def form_ajaxdelete_refresh(entity, title, identity=nil, id)
    message = identity.nil? ?
      "#{title} #{I18n.t('Sistema.Body.Vistas.Helpers.Mensajes.eliminacion')}" :
      "#{title} '#{identity}' #{I18n.t('Sistema.Body.Vistas.Helpers.Mensajes.eliminacion')}"
    page.hide 'error'
    page.remove "row_#{entity.id}"
    page.replace_html 'message', message
    page.show 'message'
    page.redirect_to :action=>'index', :id=>id
   end

  #Función que acomoda los elementos de la vista cuando se imprimen los errores
  def form_error(id = nil)
    if id
      id = 'error_'.concat(id)
    else
      id = 'error'
    end
    page.<< "varEnviado=false "
    page.replace_html id, :partial => 'error'
    page.show id
   #page.alert('cual es el error')
  end

#Función que acomoda los elementos de la vista cuando se expande una fila de una lista
  def form_expand(entity)

    page.form_reset
    page.hide "row_#{entity.id}"
    page.insert_html :after, "row_#{entity.id}", :partial => 'detail'
    page.visual_effect :highlight, "row_#{entity.id}_view", :duration => 0.6
  end

#Función que acomoda los elementos de la vista cuando se contrae la fila de una lista
  def form_collapse(entity)
    page.form_reset
    page.remove "row_#{entity.id}_view"
    page.show "row_#{entity.id}"
    page.visual_effect :highlight, "row_#{entity.id}", :duration => 0.6
  end

#Función que ayuda a reubicar los elementos de una vista a su forma por defecto
  def form_reset
    page.<< 'if ($(\'error\')) { Element.hide(\'error\'); }'
    page.<< 'if ($(\'message\')) { Element.hide(\'message\'); }'

  end

#Función que contiene el título de un formulario
  def form_title
    @form_title
  end

#Función que ayuda a crear la paginación de un formulario
  def form_pagination
    render :partial=>'/form/pagination', :locals=>{:list=>@list}
  end

#Función que imprime el mensaje de los registros que se estan listando
  def form_title_records_by_page
    title = '<b>'.html_safe << @list.length.to_s << '</b> '.html_safe << I18n.t('Sistema.Body.Vistas.Helpers.Mensajes.registros')
    title << ' ' << I18n.t('Sistema.Body.Vistas.General.de') << ' <b>'.html_safe << @total.to_s << '</b> '.html_safe
    if @form_search_expression && @form_search_expression.length > 0      
      title += I18n.t('Sistema.Body.Vistas.Helpers.Mensajes.para_la_expresion') + ": ".html_safe
      pass = 0
      for expression in @form_search_expression        
        if pass == (@form_search_expression.length-1)          
          if @form_search_expression.length==1
              title << " #{expression}".html_safe 
          else
              title=title[0,title.length-1]
              title << " #{I18n.t('Sistema.Body.Vistas.General.y')} #{expression}".html_safe
          end          
        else
          title << " #{expression},".html_safe           
        end
        pass+=1
      end
    end
    title    
  end

#Función que imprime el mensaje de la pagina actual donde se esta parado
  def form_title_page
    count = @list.total_entries - @list.offset
    params[:page].to_s=='' ? I18n.t('Sistema.Body.Vistas.Helpers.Mensajes.pagina') << ' 1' : I18n.t('Sistema.Body.Vistas.Helpers.Mensajes.pagina') << ' ' << params[:page].to_s
  end
  
  #funcion que me devuelve el nombre de la superclase del objeto que se está invocando
  def class_super_class    
    controller.class.superclass.to_s
  end

end

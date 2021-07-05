# encoding: utf-8

#
# autor: Luis Rojas
# clase: Maquinaria::GuiaMovilizacionMaquinariaController
# descripción: Migración a Rails 3
#

class Maquinaria::GuiaMovilizacionMaquinariaController < FormTabTabsController

skip_before_filter :set_charset, :only=>[:enviar, :destino_change]

  def index
    fill
    list
  end
  
  def printer
    @solicitud = Solicitud.find(params[:solicitud_id].to_i)
    @viewenviomaquinaria = ViewEnvioMaquinaria.find_by_solicitud_id(params[:solicitud_id])
    @viewalmacenmaquinaria = ViewAlmacenMaquinaria.find_by_guia_movilizacion_maquinaria_id(params[:guia_id])
    @guiam = GuiaMovilizacionMaquinaria.find(params[:guia_id])
    @datos_maquinaria = ViewDatosMaquinaria.find(:all, :conditions=> "guia_movilizacion_maquinaria_id = #{params[:guia_id]}")
    @catalogo = Catalogo.find(:first, :conditions => "id in (select catalogo_id from guia_catalogo where guia_movilizacion_maquinaria_id = #{@guiam.id})")
    @width_layout = '1135'
    render  :layout => 'form_reporte'
  end 
 
  def new
    fill
    @view_envio_maquinaria = ViewEnvioMaquinaria.find_by_solicitud_id(params[:solicitud_id])
    @guia_movilizacion_maquinaria = GuiaMovilizacionMaquinaria.new
    @maquinaria_list = ViewAlmacenMaquinaria.find(:all, :conditions=> "solicitud_id = #{params[:solicitud_id]}")
  end

  def save_new
    params[:guia_movilizacion_maquinaria][:estatus] = 'E'
    params[:guia_movilizacion_maquinaria][:fecha_emision] = format_fecha_inv(Time.now)
    params[:guia_movilizacion_maquinaria][:usuario_id] = session[:id]
    logger.debug "valor " << params[:tipo_documento][:tipo].to_s
    value = GuiaMovilizacionMaquinaria.validate_almacen(params[:tipo_documento][:tipo].to_s.split(','))    
    
    if value == true      
      errores = GuiaMovilizacionMaquinaria.create(params[:guia_movilizacion_maquinaria], params[:tipo_documento][:tipo])
      if errores.class.name == 'GuiaMovilizacionMaquinaria'
        guia_movilizacion = GuiaMovilizacionMaquinaria.find(errores.id)
        flash[:notice] = I18n.t('Sistema.Body.Vistas.GuiaMovilizacionMaquinaria.Mensajes.se_guardo_con_exito')
        render :update do |page|
          new_options = {:action=>'edit', :id=>guia_movilizacion.id, :solicitud_id=>guia_movilizacion.solicitud_id}
          page.redirect_to new_options
        end
      else
        render :update do |page|
          page.hide 'message'
          page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>".html_safe << errores.to_s.html_safe << "</UL></p>".html_safe
          page.show 'errorExplanation'
          page.<< "window.scrollTo(0,0);"
        end
      end
    else
      render :update do |page|
        page.hide 'message'
        page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>".html_safe << value << "</UL></p>".html_safe
        page.show 'errorExplanation'
        page.<< "window.scrollTo(0,0);"
      end
    end
  end

  def edit
    fill
    @guia_movilizacion_maquinaria = GuiaMovilizacionMaquinaria.find(params[:id])
    @maquinaria_list = GuiaCatalogo.find_by_sql("(select * from view_guia_catalogo_edit_v1 where solicitud_id = #{params[:solicitud_id]}
        union select * from view_guia_catalogo_edit_v2 where (estatus= 'E' OR conforme = false) and solicitud_id = #{params[:solicitud_id]} and guia_movilizacion_maquinaria_id = #{params[:id]})")
    @maquinaria_list.map { |item| if item.guia_movilizacion_maquinaria_id == @guia_movilizacion_maquinaria.id
        @li+=item.catalogo_id.to_s+',' 
      end}
    @tipo_documento[:tipo] = @li
  end
  
  def save_edit
    params[:guia_movilizacion_maquinaria][:estatus] = 'E'
    params[:guia_movilizacion_maquinaria][:fecha_emision] = format_fecha_inv(Time.now)
    params[:guia_movilizacion_maquinaria][:usuario_id] = session[:id]
    value = GuiaMovilizacionMaquinaria.validate_almacen(params[:tipo_documento][:tipo].to_s.split(','))
    if value == true
      errores = GuiaMovilizacionMaquinaria.update(params[:guia_movilizacion_maquinaria], params[:tipo_documento][:tipo], params[:id])
      if errores.class.name == 'GuiaMovilizacionMaquinaria'
        guia_movilizacion = GuiaMovilizacionMaquinaria.find(errores.id)
        flash[:notice] = I18n.t('Sistema.Body.Vistas.GuiaMovilizacionMaquinaria.Mensajes.se_actualizaron_con_exito')
        render :update do |page|
          new_options = {:action=>'edit', :id=>guia_movilizacion.id, :solicitud_id=>guia_movilizacion.solicitud_id}
          page.redirect_to new_options
        end
      else
        render :update do |page|
          page.hide 'message'
          page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>".html_safe << errores.to_s.html_safe << "</UL></p>".html_safe
          page.show 'errorExplanation'
          page.<< "window.scrollTo(0,0);"
        end
      end
    else
      render :update do |page|
        page.hide 'message'
        page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>".html_safe << value << "</UL></p>".html_safe
        page.show 'errorExplanation'
        page.<< "window.scrollTo(0,0);"
      end
    end
  end
  
  def delete
    @guia_movilizacion_maquinaria = GuiaMovilizacionMaquinaria.find(params[:id])
    errores = GuiaMovilizacionMaquinaria.delete(@guia_movilizacion_maquinaria.id)
    if errores.nil? || errores.to_s.empty?
      render :update do |page|
        page.remove "row_#{params[:id]}"
	      page.hide 'error'
        page.replace_html 'message', I18n.t('Sistema.Body.Vistas.GuiaMovilizacionMaquinaria.Mensajes.es_elimino_con_exito')
        page.show 'message'
      end
      #redirect_to :action => "index", :solicitud_id=>@guia_movilizacion_maquinaria.solicitud_id
    elsif errores.size > 0
      render :update do |page|
        page.hide 'message'
        page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>".html_safe << errores.to_s.html_safe << "</UL></p>".html_safe
        page.show 'errorExplanation'
        page.<< "window.scrollTo(0,0);"
      end
      return 
    end
  end
  
  def view
    fill
    @guia_movilizacion_maquinaria = GuiaMovilizacionMaquinaria.find(params[:id])
    @maquinaria_list = GuiaCatalogo.find_by_sql("select * from view_guia_catalogo_edit_v2 where guia_movilizacion_maquinaria_id = #{params[:id]}")
  end
  
  def view_maquinaria
    @catalogo = Catalogo.find(params[:catalogo_id])
  end
  
  def enviar
    errores_update = GuiaMovilizacionMaquinaria.enviar(params[:id])
    if errores_update == true
      render :update do |page|
        page.remove "row_#{params[:id]}"
        page.hide 'error'
        page.replace_html 'message', I18n.t('Sistema.Body.Vistas.General.se_envio_con_exito')
        page.show 'message'
        page.<< "document.getElementById('row_#{params[:id]}').style.display='none';"
      end
      #redirect_to :action => "index", :solicitud_id=>params[:solicitud_id]
      return

    else      
      render :update do |page|
        page.hide 'message'
        page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>".html_safe << errores_update.html_safe << "</UL></p>".html_safe
        page.show 'errorExplanation'
        page.<< "window.scrollTo(0,0);"
      end
    end
  end

  def destino_change
    @view_envio_maquinaria = ViewEnvioMaquinaria.find_by_solicitud_id(params[:solicitud_id])
    @guia_movilizacion_maquinaria = GuiaMovilizacionMaquinaria.new
    @silo = Silo.new
    if params[:opcion] == 'F'
      @guia_movilizacion_maquinaria.destino = 'F'
      @silo.nombre = (I18n.t('Sistema.Body.Vistas.General.estado')).downcase
    elsif params[:opcion] == 'O'
      @guia_movilizacion_maquinaria.destino = 'O'
    elsif params[:opcion] == 'U'
      @guia_movilizacion_maquinaria.destino = 'U'
    end
    render :update do |page|
      page.replace_html 'destino-maquinaria', :partial => 'destino'
    end
  end

  def list
    @condition = "solicitud_id = #{params[:solicitud_id]}"
    params['sort'] = "solicitud_id" unless params['sort']
    
    @list = ViewGuiaMovilizacion.search(@condition, params[:page], params['sort'])    
    @total=@list.count


    form_list
  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Vistas.GuiaMovilizacionMaquinaria.Header.title') 
    @form_title_record = I18n.t('Sistema.Body.Vistas.GuiaMovilizacionMaquinaria.Header.form_title') 
    @form_title_records = I18n.t('Sistema.Body.Vistas.GuiaMovilizacionMaquinaria.Header.form_title') 
    @form_entity = 'guia_movilizacion_maquinaria'
    @form_identity_field = 'id'
    @width_layout = '1000'
  end
  
  def fill
    @view_envio_maquinaria = ViewEnvioMaquinaria.find_by_solicitud_id(params[:solicitud_id])
    @municipio = Municipio.find(Oficina.find(session[:oficina]).municipio_id)
    @empresa_transporte_maquinaria_list = EmpresaTransporteMaquinaria.find(:all, :order=>'nombre')
    @li=''
    @tipo_documento = TipoDocumento.new
    if @empresa_transporte_maquinaria_list.length == 0
      @empresa_transporte_maquinaria_list = []
    end 
  end
end
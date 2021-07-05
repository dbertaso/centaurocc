# encoding: utf-8
#
# autor: Luis Rojas
# clase: Maquinaria::RecepcionMaquinariaController
# descripción: Migración a Rails 3
#
class Maquinaria::RecepcionMaquinariaController < FormTabTabsController
  
  skip_before_filter :set_charset, :only=>[:cerrar, :deshacer, :save_edit]
  
  def index
  end

  def list
    @condition = "estatus in ('T', 'R') and solicitud_id in (select id from solicitud where oficina_id = #{@usuario.oficina_id})"
    params['sort'] = "numero_guia" unless params['sort']
    
    unless params[:numero_orden].nil? || params[:numero_orden].to_s.empty?
      @condition << " AND numero_guia =  '#{params[:numero_orden].to_s}'"      
    end
    
    unless params[:fecha_llegada].to_s.empty? || params[:fecha_llegada].nil?
      @condition << " AND fecha_estimada = '#{params[:fecha_llegada].to_s}'"      
    end
    
    unless  params[:cedula_rif]=='' || params[:cedula_rif].nil?
      @condition << " AND cedula_rif = '#{params[:cedula_rif]}'"      
    end
    
    unless params[:productor].nil? || params[:productor].to_s.empty?
      @condition << " and lower(productor) like lower('%#{params[:productor]}%')"      
    end
    
    
    @list = ViewGuiaMovilizacion.search(@condition, params[:page], params['sort'])
    @total=@list.count

    form_list
  end
  
  def imprimir_recepcion
    @solicitud = Solicitud.find(params[:solicitud_id].to_i)
    @viewenviomaquinaria = ViewEnvioMaquinaria.find_by_solicitud_id(params[:solicitud_id])
    @viewalmacenmaquinaria = ViewAlmacenMaquinaria.find_by_guia_movilizacion_maquinaria_id(params[:guia_id])
    @guiam = GuiaMovilizacionMaquinaria.find(params[:guia_id])
    @datos_maquinaria = ViewDatosMaquinaria.find(:all, :conditions=> "guia_movilizacion_maquinaria_id = #{params[:guia_id]}")
    @datos_recepcion=RecepcionMaquinaria.find_by_guia_movilizacion_maquinaria_id(params[:guia_id])
    @width_layout = '1135'
    render  :layout => 'form_popup'
  end
  
  def edit
    @guia = GuiaMovilizacionMaquinaria.find(params[:guia_id])
    @solicitud = Solicitud.find(@guia.solicitud_id)
    @catalogo = Catalogo.find(:all, :conditions=> "id in (select catalogo_id from guia_catalogo where guia_movilizacion_maquinaria_id = #{@guia.id})")
    @recepcion_maquinaria = RecepcionMaquinaria.find(:first, :conditions=> "guia_movilizacion_maquinaria_id = #{@guia.id}")
    if @recepcion_maquinaria.class.name == "NilClass"
      @recepcion_maquinaria = RecepcionMaquinaria.new
    end
  end
  
  def cerrar
    guia_movilizacion_maquinaria = GuiaMovilizacionMaquinaria.find(params[:id])
    guia_movilizacion_maquinaria.estatus = 'R'
    guia_movilizacion_maquinaria.save!    
    flash[:notice] = I18n.t('Sistema.Body.Vistas.RecepcionMaquinaria.Mensajes.cerrado_exito_recepcion_maquinaria',:numero_guia=>guia_movilizacion_maquinaria.numero_guia) 
    render :update do |page|                        
      page.redirect_to :action=>'index'      
    end    
  end
  
  def deshacer
    guia_movilizacion_maquinaria = GuiaMovilizacionMaquinaria.find(params[:id])
    guia_movilizacion_maquinaria.estatus = 'T'
    guia_movilizacion_maquinaria.save!
    flash[:notice] = I18n.t('Sistema.Body.Vistas.RecepcionMaquinaria.Mensajes.abierto_exito_recepcion_maquinaria',:numero_guia=>guia_movilizacion_maquinaria.numero_guia)
    render :update do |page|      
      page.redirect_to :action=>'index'
    end
  end
  
  def save_edit
    guia_catalogo = GuiaCatalogo.find(:all, :conditions => "guia_movilizacion_maquinaria_id = #{params[:id]}")
    error = ""
    guia_catalogo.each {|c|
      unless params[:guia_catalogo].nil?
        if params[:guia_catalogo]["id_" + c.catalogo_id.to_s].nil?
          error = I18n.t('Sistema.Body.Vistas.RecepcionMaquinaria.Mensajes.debe_decidir_todas_maquinarias')
        end
      else
       error = I18n.t('Sistema.Body.Vistas.RecepcionMaquinaria.Mensajes.debe_decidir_todas_maquinarias')
      end
    }
    @recepcion_maquinaria = RecepcionMaquinaria.find(:first, :conditions=> "guia_movilizacion_maquinaria_id = #{params[:id]}")
    if @recepcion_maquinaria.class.name == "NilClass"
      @recepcion_maquinaria = RecepcionMaquinaria.new(params[:recepcion_maquinaria])
      succes = @recepcion_maquinaria.save_new(params[:id], params, session[:oficina], @usuario.id, error)
    else
      succes = @recepcion_maquinaria.save_edit(params, @usuario.id, error)
    end
    if succes == true
      flash[:notice] = I18n.t('Sistema.Body.Vistas.RecepcionMaquinaria.Mensajes.actualizado_exito_recepcion_maquinaria',:numero_guia=>@recepcion_maquinaria.guia_movilizacion_maquinaria.numero_guia)
      render :update do |page|        
        page.redirect_to :action=>'index'
      end
    else
      render :update do |page|
        page.form_error
      end
      return
    end
  end

  protected 
  def common
    super
    @form_title = I18n.t('Sistema.Body.Vistas.RecepcionMaquinaria.Header.form_title') 
    @form_title_record = I18n.t('Sistema.Body.Vistas.General.orden')
    @form_title_records = I18n.t('Sistema.Body.Vistas.General.orden')
    @form_entity = 'view_guia_movilizacion'
    @form_identity_field = 'id'
    @width_layout = '1000'
  end
end

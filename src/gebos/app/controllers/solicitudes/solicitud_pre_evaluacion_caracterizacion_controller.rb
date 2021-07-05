# encoding: utf-8

#
# autor: Luis Rojas
# clase: Solicitudes::SolicitudPreEvaluacionCaracterizacionController
# descripción: Migración a Rails 3
#
class Solicitudes::SolicitudPreEvaluacionCaracterizacionController < FormTabTabsController
  
  skip_before_filter :set_charset, :only=>[:save_suelos, :save_topografias, :save_fuentes_agua]
  
  def new
    @empresa = Empresa.find(params[:empresa_id])    
    @empresa_direccion = EmpresaDireccion.new 
    fill
  end
  
  def save_new
    @empresa = Empresa.find(params[:empresa_id])
    @empresa_direccion = EmpresaDireccion.new(params[:empresa_direccion])
    EmpresaDireccion.validate
    form_save_new @empresa_direccion, 
      :value=>@empresa.add_direccion(@empresa_direccion),
      :params=> { :id=>@empresa_direccion.id, :empresa_id => @empresa.id }
  end
  
  def edit
    @solicitud = Solicitud.find(params[:id])
    @unidad_produccion_caracterizacion = UnidadProduccionCaracterizacion.find(:first, :conditions=>['seguimiento_visita_id = ?',params[:seguimiento_visita_id]])
    if @unidad_produccion_caracterizacion.blank?
      @unidad_produccion_caracterizacion = UnidadProduccionCaracterizacion.new()
      @unidad_produccion_caracterizacion.solicitud_id = @solicitud.id
      @unidad_produccion_caracterizacion.unidad_produccion_id = @solicitud.unidad_produccion_id
      @unidad_produccion_caracterizacion.seguimiento_visita_id =  params[:seguimiento_visita_id]
      @unidad_produccion_caracterizacion.riego_actual = true
      @unidad_produccion_caracterizacion.requiere_riego = true
      @unidad_produccion_caracterizacion.posee_drenaje = true
      @unidad_produccion_caracterizacion.superficie_aprovechable = 0
      @unidad_produccion_caracterizacion.save
    end
   
   
    @mostrar = ''
    if @unidad_produccion_caracterizacion.riego_actual == false
      @mostrar = 'custom_limpiar_ocultar_div("riego_actual");'
    end
    if @unidad_produccion_caracterizacion.requiere_riego == false
      @mostrar =  @mostrar << 'custom_limpiar_ocultar_div("riego_propuesto");'
    end
    if @unidad_produccion_caracterizacion.posee_drenaje == false
      @mostrar =  @mostrar << 'custom_limpiar_ocultar_div("drenaje_actual");'
    end
       
    @unidad_produccion_caracterizacion.superficie_total = @solicitud.unidad_produccion.total_hectareas
    
    @tipo_fuente_agua = TipoFuenteAgua.find_by_sql("select id,nombre,descripcion,activo,case when id in (select tipo_fuente_agua_id from caracterizacion_fuente_agua where unidad_produccion_caracterizacion_id=#{@unidad_produccion_caracterizacion.id}) then 'checked' else '' end as marcado, case when id in (select tipo_fuente_agua_id from caracterizacion_fuente_agua where unidad_produccion_caracterizacion_id=#{@unidad_produccion_caracterizacion.id}) and upper(nombre) like '%OTRO%' then (select descripcion_otro from caracterizacion_fuente_agua where unidad_produccion_caracterizacion_id=#{@unidad_produccion_caracterizacion.id} and tipo_fuente_agua_id = tfa.id)  end as descripcion_otro from tipo_fuente_agua tfa order by nombre")
    @tipo_vialidad =      TipoVialidad.find_by_sql("select id,nombre,descripcion,activo,case when id in (select tipo_vialidad_id from caracterizacion_tipo_vialidad where unidad_produccion_caracterizacion_id=#{@unidad_produccion_caracterizacion.id}) then 'checked' else '' end as marcado, case when id in (select tipo_vialidad_id from caracterizacion_tipo_vialidad where unidad_produccion_caracterizacion_id=#{@unidad_produccion_caracterizacion.id}) and upper(nombre) like '%OTRO%' then (select descripcion_otro from caracterizacion_tipo_vialidad where unidad_produccion_caracterizacion_id=#{@unidad_produccion_caracterizacion.id} and tipo_vialidad_id = tv.id)  end as descripcion_otro from tipo_vialidad tv order by nombre")
    @tipo_suelo = TipoSuelo.find_by_sql("select ts.id,ts.nombre,ts.descripcion,ts.activo,cts.porcentaje, case when cts.id is not null then '' else 'readonly' end as habilitado, case when cts.id is not null then 'checked' end as marcado from tipo_suelo ts LEFT JOIN caracterizacion_tipo_suelo cts ON ts.id = cts.tipo_suelo_id and cts.unidad_produccion_caracterizacion_id=#{@unidad_produccion_caracterizacion.id} order by nombre")
    @tipo_topografia = TipoTopografia.find_by_sql("select tt.id,tt.nombre,tt.descripcion,tt.activo,ctt.porcentaje,case when ctt.id is not null then '' else 'readonly' end as habilitado,case when ctt.id is not null then 'checked' end as marcado,case when ctt.id is not null then descripcion_otro end as descripcion_otro from tipo_topografia tt LEFT JOIN caracterizacion_tipo_topografia ctt ON tt.id = ctt.tipo_topografia_id and ctt.unidad_produccion_caracterizacion_id=#{@unidad_produccion_caracterizacion.id} order by nombre")
    @tipo_riego_list = TipoRiego.find(:all, :conditions=>["activo = true"], :order=>'nombre')
    @tipo_drenaje_list = TipoDrenaje.find(:all, :conditions=>["activo = true"], :order=>'nombre')
  end
  
  def save_edit
    @solicitud = Solicitud.find(params[:id])
    @unidad_produccion_caracterizacion = UnidadProduccionCaracterizacion.find_by_seguimiento_visita_id(params[:seguimiento_visita_id])
    
    @unidad_produccion_caracterizacion.solicitud_id = @solicitud.id
    @unidad_produccion_caracterizacion.unidad_produccion_id = @solicitud.unidad_produccion_id
    @unidad_produccion_caracterizacion.seguimiento_visita_id =  params[:seguimiento_visita_id]
       
    validarAprovechable = false     
    validarAprovechable = @unidad_produccion_caracterizacion.actualizar(params)
       

    if validarAprovechable == true           
      flash[:notice] = "#{I18n.t('Sistema.Body.Vistas.General.la').capitalize} #{I18n.t('Sistema.Body.Vistas.General.informacion')} #{I18n.t('Sistema.Body.Modelos.General.se_actualizo_exito')}"
      render :update do |page|
        page.redirect_to :action=>'edit', :id=>@solicitud.id, :seguimiento_visita_id=>@unidad_produccion_caracterizacion.seguimiento_visita_id, :popup=>params[:popup]
        page.hide 'error'
        page.replace_html 'message', message
        page.show 'message'
      end
    else
      render :update do |page|
        page.<< "window.scrollTo(0,0);"                  
        page.form_error
      end
      return false
    end

  end

  def save_fuentes_agua
      
    @caracterizacion_fuente_agua = CaracterizacionFuenteAgua.find(:all, :conditions=>['unidad_produccion_caracterizacion_id = ? and tipo_fuente_agua_id = ?', params[:unidad_produccion_caracterizacion_id], params[:id]])
        
    if @caracterizacion_fuente_agua[0]  == nil
      @caracterizacion_fuente_agua = CaracterizacionFuenteAgua.new
      @caracterizacion_fuente_agua.tipo_fuente_agua_id = params[:id]
      @caracterizacion_fuente_agua.unidad_produccion_caracterizacion_id = params[:unidad_produccion_caracterizacion_id]
      if params[:actualizar] != nil
        @caracterizacion_fuente_agua.descripcion_otro =  params[:actualizar]
      end
      @caracterizacion_fuente_agua.save
      render :update do |page|
        message = "#{I18n.t('Sistema.Body.Vistas.General.la').capitalize} #{I18n.t('Sistema.Body.Vistas.General.fuente_agua').downcase} #{I18n.t('Sistema.Body.Vistas.Helpers.Mensajes.insercion')}"
        page.hide 'error'
        page.replace_html 'message', message
        page.show 'message'
      end
    else
      if params[:actualizar] != nil
        @caracterizacion_fuente_agua[0].descripcion_otro =  params[:actualizar]
        @caracterizacion_fuente_agua[0].save
      else
        @caracterizacion_fuente_agua[0].destroy
      end
      render :update do |page|
        message = "#{I18n.t('Sistema.Body.Vistas.General.la').capitalize} #{I18n.t('Sistema.Body.Vistas.General.fuente_agua').downcase} #{I18n.t('Sistema.Body.Vistas.Helpers.Mensajes.eliminacion')}"
        page.hide 'error'
        page.replace_html 'message', message
        page.show 'message'
      end
    end
    return false
  end

  def save_vialidad
     
    @caracterizacion_tipo_vialidad = CaracterizacionTipoVialidad.find(:all, :conditions=>['unidad_produccion_caracterizacion_id = ? and tipo_vialidad_id = ?', params[:unidad_produccion_caracterizacion_id], params[:id]])

    if @caracterizacion_tipo_vialidad[0]  == nil
      @caracterizacion_tipo_vialidad =  CaracterizacionTipoVialidad.new
      @caracterizacion_tipo_vialidad.tipo_vialidad_id = params[:id]
      @caracterizacion_tipo_vialidad.unidad_produccion_caracterizacion_id = params[:unidad_produccion_caracterizacion_id]
      if params[:actualizar] != nil
        @caracterizacion_tipo_vialidad.descripcion_otro =  params[:actualizar]
      end 
      @caracterizacion_tipo_vialidad.save
      render :update do |page|
        flash[:notice] = "#{I18n.t('Sistema.Body.Vistas.General.la').capitalize} #{I18n.t('Sistema.Body.Vistas.General.informacion')} #{I18n.t('Sistema.Body.Modelos.General.se_actualizo_exito')}"
        page.hide 'error'
        page.replace_html 'message', message
        page.show 'message'
      end
    else
      if params[:actualizar] != nil
        @caracterizacion_tipo_vialidad[0].descripcion_otro =  params[:actualizar]
        @caracterizacion_tipo_vialidad[0].save
      else
        @caracterizacion_tipo_vialidad[0].destroy
      end
      render :update do |page|
        flash[:notice] = "#{I18n.t('Sistema.Body.Vistas.General.la').capitalize} #{I18n.t('Sistema.Body.Vistas.General.informacion')} #{I18n.t('Sistema.Body.Modelos.General.se_actualizo_exito')}"
        page.hide 'error'
        page.replace_html 'message', message
        page.show 'message'
      end
    end
  end

  def save_suelos
     
    @caracterizacion_tipo_suelo = CaracterizacionTipoSuelo.find(:all, :conditions=>['unidad_produccion_caracterizacion_id = ? and tipo_suelo_id = ?', params[:unidad_produccion_caracterizacion_id], params[:id]])
    unless params[:porcentaje].to_f > 0
      params[:porcentaje] = 0
    else
      total_suelo = CaracterizacionTipoSuelo.sum(:porcentaje, :conditions=>['unidad_produccion_caracterizacion_id = ? and tipo_suelo_id <> ?', params[:unidad_produccion_caracterizacion_id], params[:id]])
      total = total_suelo + params[:porcentaje].to_f
      if total > 100
        @caracterizacion_tipo_suelo = CaracterizacionTipoSuelo.new
        @caracterizacion_tipo_suelo.errors.add(:id, 'El porcentaje no debe superar el 100%')
        render :update do |page|
          page.hide 'message'
          page << "document.getElementById('caracterizacion_tipo_suelo_porcentaje_#{params[:id]}').value = '';"
          page.form_error
        end
        return false
      end
    end    
    if @caracterizacion_tipo_suelo[0]  == nil
      @caracterizacion_tipo_suelo =  CaracterizacionTipoSuelo.new
      @caracterizacion_tipo_suelo.tipo_suelo_id = params[:id]
      @caracterizacion_tipo_suelo.unidad_produccion_caracterizacion_id = params[:unidad_produccion_caracterizacion_id]
      @caracterizacion_tipo_suelo.porcentaje = params[:porcentaje]
      
      if  @caracterizacion_tipo_suelo.save
        flash[:notice] = "#{I18n.t('Sistema.Body.Vistas.General.la').capitalize} #{I18n.t('Sistema.Body.Vistas.General.informacion')} #{I18n.t('Sistema.Body.Modelos.General.se_actualizo_exito')}"
        render :update do |page|
          #page.redirect_to :action=>'edit', :id=>@solicitud.id, :seguimiento_visita_id=>@unidad_produccion_caracterizacion.seguimiento_visita_id, :popup=>params[:popup]
          page.hide 'error'
          page.replace_html 'message', message
          page.show 'message'
        end
      else
        render :update do |page|
          page.form_error
        end
        return false
      end
    else
      @caracterizacion_tipo_suelo[0].porcentaje = params[:porcentaje]
      if  @caracterizacion_tipo_suelo[0].save
        flash[:notice] = "#{I18n.t('Sistema.Body.Vistas.General.la').capitalize} #{I18n.t('Sistema.Body.Vistas.General.informacion')} #{I18n.t('Sistema.Body.Modelos.General.se_actualizo_exito')}"
        render :update do |page|
          page.hide 'error'
          page.replace_html 'message', message
          page.show 'message'
        end
      else
        render :update do |page|
          page.form_error
        end
        return false
      end
    end
  end

  def save_topografias
     
    @caracterizacion_tipo_topografia = CaracterizacionTipoTopografia.find(:all, :conditions=>['unidad_produccion_caracterizacion_id = ? and tipo_topografia_id = ?', params[:unidad_produccion_caracterizacion_id], params[:id]])
       
    if @caracterizacion_tipo_topografia[0]  == nil
      @caracterizacion_tipo_topografia =  CaracterizacionTipoTopografia.new
      @caracterizacion_tipo_topografia.tipo_topografia_id = params[:id]
      @caracterizacion_tipo_topografia.unidad_produccion_caracterizacion_id = params[:unidad_produccion_caracterizacion_id]
      @caracterizacion_tipo_topografia.porcentaje = params[:porcentaje]
      if params[:actualizar] != nil
        @caracterizacion_tipo_topografia.descripcion_otro =  params[:actualizar]
      end
      success = @caracterizacion_tipo_topografia.validar_procentajes(params[:unidad_produccion_caracterizacion_id],params[:porcentaje],params[:id])
      if success == true
        if  @caracterizacion_tipo_topografia.save
          flash[:notice] = "#{I18n.t('Sistema.Body.Vistas.General.la').capitalize} #{I18n.t('Sistema.Body.Vistas.General.informacion')} #{I18n.t('Sistema.Body.Modelos.General.se_actualizo_exito')}"
          render :update do |page|
            #page.redirect_to :action=>'edit', :id=>@solicitud.id, :seguimiento_visita_id=>@unidad_produccion_caracterizacion.seguimiento_visita_id, :popup=>params[:popup]
            page.hide 'error'
            page.replace_html 'message', "#{I18n.t('Sistema.Body.Vistas.General.la').capitalize} #{I18n.t('Sistema.Body.Vistas.General.informacion')} #{I18n.t('Sistema.Body.Modelos.General.se_actualizo_exito')}".html_safe
            page.show 'message'
          end
        else
          render :update do |page|
            page.form_error
          end
          return false
        end
      else
        render :update do |page|
          page.alert I18n.t('Sistema.Body.Vistas.General.Verifique_suma_porcentajes_topografias')
        end
        return false
      end
            
    else
      if params[:accion] == 'eliminar'
        @caracterizacion_tipo_topografia[0].destroy
        flash[:notice] = "#{I18n.t('Sistema.Body.Vistas.General.la').capitalize} #{I18n.t('Sistema.Body.Vistas.General.informacion')} #{I18n.t('Sistema.Body.Modelos.General.se_actualizo_exito')}"
        render :update do |page|
          page.hide 'error'
          page.replace_html 'message', message
          page.show 'message'
        end
      else
        if params[:actualizar] != nil
          @caracterizacion_tipo_topografia[0].descripcion_otro =  params[:actualizar]
        end
        @caracterizacion_tipo_topografia[0].porcentaje = params[:porcentaje]
        success = @caracterizacion_tipo_topografia[0].validar_procentajes(params[:unidad_produccion_caracterizacion_id],params[:porcentaje],params[:id])
            
        if success == true
          if @caracterizacion_tipo_topografia[0].save
            flash[:notice] = "#{I18n.t('Sistema.Body.Vistas.General.la').capitalize} #{I18n.t('Sistema.Body.Vistas.General.informacion')} #{I18n.t('Sistema.Body.Modelos.General.se_actualizo_exito')}"
            render :update do |page|
              page.hide 'error'
              page.replace_html 'message', message
              page.show 'message'
            end
          else
            render :update do |page|
              page.form_error
            end
            return false
          end
        else
          render :update do |page|
            page.alert I18n.t('Sistema.Body.Vistas.General.Verifique_suma_porcentajes_topografias')
          end
          return false
        end
      end

    end
    return false
  end
           
  def delete
    @empresa = Empresa.find(params[:empresa_id])
    @empresa_direccion = EmpresaDireccion.find(params[:id])
    form_delete @empresa_direccion
  end

  def view_detail
    @empresa = Empresa.find(params[:empresa_id])
    @empresa_direccion = EmpresaDireccion.find(params[:id])
  end

  protected  
  def common
    super
    @form_title = "#{I18n.t('Sistema.Body.Vistas.General.registro')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.informe_recomendacion')}"
    @form_title_record = I18n.t('Sistema.Body.Vistas.General.informe_recomendacion')
    @form_title_records = I18n.t('Sistema.Body.Vistas.General.informe_recomendacion')
    @form_entity = 'unidad_produccion_caracterizacion'
    @form_identity_field = 'id'
    @width_layout = '955'
  end
end
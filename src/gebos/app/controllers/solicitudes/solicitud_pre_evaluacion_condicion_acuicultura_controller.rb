# encoding: utf-8

#
# autor: Luis Rojas
# clase: Solicitudes::SolicitudPreEvaluacionCondicionAcuiculturaController
# descripción: Migración a Rails 3
#
class Solicitudes::SolicitudPreEvaluacionCondicionAcuiculturaController < FormTabTabsController
  
  skip_before_filter :set_charset, :only=>[:save_vialidad, :save_fuentes_agua, :save_especies, :save_especies_solicitadas, :save_suelos, :save_topografias, :save_sistema_cultivo_actual]

  def index
    list
  end

  def list
    _list

    form_list

  end	
  
  def view
    list_view
  end
  
  def list_view
    _list
    form_list_view
  end
  
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

    if params[:seguimiento_visita_id].to_s == ''
      sol_id=UnidadProduccionCondicionAcuicultura.find(params[:id]).solicitud_id
      seguimiento_id=UnidadProduccionCondicionAcuicultura.find(params[:id]).seguimiento_visita_id
      @solicitud = Solicitud.find(sol_id)  
      @unidad_produccion_condicion_acuicultura = UnidadProduccionCondicionAcuicultura.find_by_seguimiento_visita_id(seguimiento_id)
    else    
      @solicitud = Solicitud.find(params[:id])
      @unidad_produccion_condicion_acuicultura = UnidadProduccionCondicionAcuicultura.find_by_seguimiento_visita_id(params[:seguimiento_visita_id])
    end


    if @unidad_produccion_condicion_acuicultura == nil
      @unidad_produccion_condicion_acuicultura = UnidadProduccionCondicionAcuicultura.new()
      @unidad_produccion_condicion_acuicultura.solicitud_id = @solicitud.id
      @unidad_produccion_condicion_acuicultura.unidad_produccion_id = @solicitud.unidad_produccion_id
      if params[:seguimiento_visita_id].to_s == ''
        @unidad_produccion_condicion_acuicultura.seguimiento_visita_id = seguimiento_id
      else
        @unidad_produccion_condicion_acuicultura.seguimiento_visita_id =  params[:seguimiento_visita_id]
      end
      @unidad_produccion_condicion_acuicultura.posee_drenaje = true
      @unidad_produccion_condicion_acuicultura.save
    end
    if @unidad_produccion_condicion_acuicultura.posee_drenaje == false
      @mostrar =  'custom_limpiar_ocultar_div("drenaje_actual");'
    end
    
    @tipo_fuente_agua = TipoFuenteAgua.find_by_sql("select id,nombre,descripcion,activo,case when id in (select tipo_fuente_agua_id from condiciones_fuente_agua where unidad_produccion_condicion_acuicultura_id=#{@unidad_produccion_condicion_acuicultura.id}) then 'checked' else '' end as marcado, case when id in (select tipo_fuente_agua_id from condiciones_fuente_agua where unidad_produccion_condicion_acuicultura_id=#{@unidad_produccion_condicion_acuicultura.id}) and upper(nombre) like '%OTRO%' then (select descripcion_otro from condiciones_fuente_agua where unidad_produccion_condicion_acuicultura_id=#{@unidad_produccion_condicion_acuicultura.id} and tipo_fuente_agua_id = tfa.id)  end as descripcion_otro from tipo_fuente_agua tfa order by nombre")
    @tipo_vialidad = TipoVialidad.find_by_sql("select id,nombre,descripcion,activo,case when id in (select tipo_vialidad_id from condiciones_tipo_vialidad where unidad_produccion_condicion_acuicultura_id=#{@unidad_produccion_condicion_acuicultura.id}) then 'checked' else '' end as marcado, case when id in (select tipo_vialidad_id from condiciones_tipo_vialidad where unidad_produccion_condicion_acuicultura_id=#{@unidad_produccion_condicion_acuicultura.id}) and upper(nombre) like '%OTRO%' then (select descripcion_otro from condiciones_tipo_vialidad where unidad_produccion_condicion_acuicultura_id=#{@unidad_produccion_condicion_acuicultura.id} and tipo_vialidad_id = tv.id)  end as descripcion_otro  from tipo_vialidad tv order by nombre")
    @tipo_suelo = TipoSuelo.find_by_sql("select ts.id,ts.nombre,ts.descripcion,ts.activo,cts.porcentaje, case when cts.id is not null then '' else 'readonly' end as habilitado, case when cts.id is not null then 'checked' end as marcado from tipo_suelo ts LEFT JOIN condiciones_tipo_suelo cts ON ts.id = cts.tipo_suelo_id and cts.unidad_produccion_condicion_acuicultura_id=#{@unidad_produccion_condicion_acuicultura.id} order by nombre")
    @tipo_topografia = TipoTopografia.find_by_sql("select tt.id,tt.nombre,tt.descripcion,tt.activo,ctt.porcentaje,case when ctt.id is not null then '' else 'readonly' end as habilitado,case when ctt.id is not null then 'checked' end as marcado, case when ctt.id is not null then descripcion_otro end as descripcion_otro  from tipo_topografia tt LEFT JOIN condiciones_tipo_topografia ctt ON tt.id = ctt.tipo_topografia_id and ctt.unidad_produccion_condicion_acuicultura_id=#{@unidad_produccion_condicion_acuicultura.id} order by nombre")
    @tipo_sistema_acuicultura_list = TipoSistemaAcuicultura.find(:all, :conditions=>["activo = true"], :order=>'nombre')
    @tipo_cultivo_acuicultura_list = TipoCultivoAcuicultura.find(:all, :conditions=>["activo = true"], :order=>'nombre')
    @tipo_drenaje_list = TipoDrenaje.find(:all, :conditions=>["activo = true"], :order=>'nombre')
    
    @tipo_especie_acuicultura = TipoEspecieAcuicultura.find_by_sql("select id,nombre,descripcion,activo, case when id in (select tipo_especie_acuicultura_id from condiciones_especies where   unidad_produccion_condicion_acuicultura_id=#{@unidad_produccion_condicion_acuicultura.id}) then 'checked' else '' end as marcado from tipo_especie_acuicultura order by nombre")
    @tipo_especie_solicitada_acuicultura = TipoEspecieAcuicultura.find_by_sql("select id,nombre,descripcion,activo, case when id in (select tipo_especie_acuicultura_id from condiciones_especies_solicitadas where   unidad_produccion_condicion_acuicultura_id=#{@unidad_produccion_condicion_acuicultura.id}) then 'checked' else '' end as marcado from tipo_especie_acuicultura order by nombre")
    @tipo_sistema_cultivo_actual = TipoSistemaAcuicultura.find_by_sql("select id,nombre,descripcion,activo, case when id in (select tipo_sistema_acuicultura_id from condiciones_sistema_cultivo_actual where   unidad_produccion_condicion_acuicultura_id=#{@unidad_produccion_condicion_acuicultura.id}) then 'checked' else '' end as marcado from tipo_sistema_acuicultura order by nombre")
    
  end
  
  def save_edit

    @solicitud = Solicitud.find(params[:id])

    if params[:seguimiento_visita_id].to_s == ''
      seguimiento_id=UnidadProduccionCondicionAcuicultura.find_by_solicitud_id(params[:id]).seguimiento_visita_id
      @unidad_produccion_condicion_acuicultura = UnidadProduccionCondicionAcuicultura.find_by_seguimiento_visita_id(seguimiento_id)
    else    

      @unidad_produccion_condicion_acuicultura = UnidadProduccionCondicionAcuicultura.find_by_seguimiento_visita_id(params[:seguimiento_visita_id])
    end


    #@unidad_produccion_condicion_acuicultura = UnidadProduccionCondicionAcuicultura.find_by_seguimiento_visita_id(params[:seguimiento_visita_id])  
    if @unidad_produccion_condicion_acuicultura == nil
      @unidad_produccion_condicion_acuicultura = UnidadProduccionCondicionAcuicultura.new(params[:unidad_produccion_condicion_acuicultura])
      @unidad_produccion_condicion_acuicultura.solicitud_id = @solicitud.id
      @unidad_produccion_condicion_acuicultura.unidad_produccion_id = @solicitud.unidad_produccion_id

      if params[:seguimiento_visita_id].to_s == ''
        @unidad_produccion_condicion_acuicultura.seguimiento_visita_id = seguimiento_id
      else
        @unidad_produccion_condicion_acuicultura.seguimiento_visita_id =  params[:seguimiento_visita_id]
      end

      #@unidad_produccion_condicion_acuicultura.seguimiento_visita_id =  params[:seguimiento_visita_id]
      if @unidad_produccion_condicion_acuicultura.posee_drenaje == false
        @unidad_produccion_condicion_acuicultura.tipo_drenaje_id = nil
        @unidad_produccion_condicion_acuicultura.superficie_drenaje = nil
        @unidad_produccion_condicion_acuicultura.condicion_drenaje = nil
      end
            
      @servicios_basicos.save
      render :update do |page|
        message = "#{I18n.t('Sistema.Body.Vistas.General.la').capitalize} #{I18n.t('Sistema.Body.Vistas.General.informacion')} #{I18n.t('Sistema.Body.Modelos.General.se_actualizo_exito')}"
        page.hide 'error'
        page.replace_html 'message', message
        page.show 'message'
      end
    else
      @unidad_produccion_condicion_acuicultura.solicitud_id = @solicitud.id
      @unidad_produccion_condicion_acuicultura.unidad_produccion_id = @solicitud.unidad_produccion_id

      if params[:seguimiento_visita_id].to_s == ''
        @unidad_produccion_condicion_acuicultura.seguimiento_visita_id = seguimiento_id
      else
        @unidad_produccion_condicion_acuicultura.seguimiento_visita_id =  params[:seguimiento_visita_id]
      end

      #@unidad_produccion_condicion_acuicultura.seguimiento_visita_id =  params[:seguimiento_visita_id]
      logger.info "mamarrua <<<<<" << params[:unidad_produccion_condicion_acuicultura].inspect
      form_save_edit @unidad_produccion_condicion_acuicultura    

    end

  end

  def save_fuentes_agua
    @condiciones_fuente_agua = CondicionesFuenteAgua.find(:all, :conditions=>['unidad_produccion_condicion_acuicultura_id = ? and tipo_fuente_agua_id = ?', params[:unidad_produccion_condicion_acuicultura_id], params[:id]])
        
    if @condiciones_fuente_agua[0]  == nil
      @condiciones_fuente_agua = CondicionesFuenteAgua.new
      @condiciones_fuente_agua.tipo_fuente_agua_id = params[:id]
      @condiciones_fuente_agua.unidad_produccion_condicion_acuicultura_id = params[:unidad_produccion_condicion_acuicultura_id]
      if params[:actualizar] != nil
        @condiciones_fuente_agua.descripcion_otro =  params[:actualizar]
      end
      @condiciones_fuente_agua.save
      render :update do |page|
        message = "#{I18n.t('Sistema.Body.Vistas.General.la').capitalize} #{I18n.t('Sistema.Body.Vistas.General.informacion')} #{I18n.t('Sistema.Body.Modelos.General.se_actualizo_exito')}"
        page.hide 'error'
        page.replace_html 'message', message
        page.show 'message'
      end
    else
      if params[:actualizar] != nil
        @condiciones_fuente_agua[0].descripcion_otro =  params[:actualizar]
        @condiciones_fuente_agua[0].save
      else
        @condiciones_fuente_agua[0].destroy
      end
      render :update do |page|
        message = "#{I18n.t('Sistema.Body.Vistas.General.la').capitalize} #{I18n.t('Sistema.Body.Vistas.General.informacion')} #{I18n.t('Sistema.Body.Modelos.General.se_actualizo_exito')}"
        page.hide 'error'
        page.replace_html 'message', message
        page.show 'message'
      end
    end
  end

  def save_especies
     
    @condiciones_especies = CondicionesEspecies.find(:all, :conditions=>['unidad_produccion_condicion_acuicultura_id = ? and tipo_especie_acuicultura_id = ?', params[:unidad_produccion_condicion_acuicultura_id], params[:id]])
       
    if @condiciones_especies[0]  == nil
      @condiciones_especies = CondicionesEspecies.new
      @condiciones_especies.tipo_especie_acuicultura_id = params[:id]
      @condiciones_especies.unidad_produccion_condicion_acuicultura_id = params[:unidad_produccion_condicion_acuicultura_id]
      @condiciones_especies.save
      render :update do |page|
        message = "#{I18n.t('Sistema.Body.Vistas.General.la').capitalize} #{I18n.t('Sistema.Body.Vistas.General.informacion')} #{I18n.t('Sistema.Body.Modelos.General.se_actualizo_exito')}"
        page.hide 'error'
        page.replace_html 'message', message
        page.show 'message'
      end
    else
      @condiciones_especies[0].destroy
      render :update do |page|
        message = "#{I18n.t('Sistema.Body.Vistas.General.la').capitalize} #{I18n.t('Sistema.Body.Vistas.General.informacion')} #{I18n.t('Sistema.Body.Modelos.General.se_actualizo_exito')}"
        page.hide 'error'
        page.replace_html 'message', message
        page.show 'message'
      end
    end
  end

  def save_especies_solicitadas

    @condiciones_especies_solicitadas = CondicionesEspeciesSolicitadas.find(:all, :conditions=>['unidad_produccion_condicion_acuicultura_id = ? and tipo_especie_acuicultura_id = ?', params[:unidad_produccion_condicion_acuicultura_id], params[:id]])

    if @condiciones_especies_solicitadas[0]  == nil
      @condiciones_especies_solicitadas = CondicionesEspeciesSolicitadas.new
      @condiciones_especies_solicitadas.tipo_especie_acuicultura_id = params[:id]
      @condiciones_especies_solicitadas.unidad_produccion_condicion_acuicultura_id = params[:unidad_produccion_condicion_acuicultura_id]
      @condiciones_especies_solicitadas.save
      render :update do |page|
        message = "#{I18n.t('Sistema.Body.Vistas.General.la').capitalize} #{I18n.t('Sistema.Body.Vistas.General.informacion')} #{I18n.t('Sistema.Body.Modelos.General.se_actualizo_exito')}"
        page.hide 'error'
        page.replace_html 'message', message
        page.show 'message'
      end
    else
      @condiciones_especies_solicitadas[0].destroy
      render :update do |page|
        message = "#{I18n.t('Sistema.Body.Vistas.General.la').capitalize} #{I18n.t('Sistema.Body.Vistas.General.informacion')} #{I18n.t('Sistema.Body.Modelos.General.se_actualizo_exito')}"
        page.hide 'error'
        page.replace_html 'message', message
        page.show 'message'
      end
    end
  end
    
  def save_vialidad
     
    @condiciones_tipo_vialidad = CondicionesTipoVialidad.find(:all, :conditions=>['unidad_produccion_condicion_acuicultura_id = ? and tipo_vialidad_id = ?', params[:unidad_produccion_condicion_acuicultura_id], params[:id]])
       
    if @condiciones_tipo_vialidad[0]  == nil
      @condiciones_tipo_vialidad =  CondicionesTipoVialidad.new
      @condiciones_tipo_vialidad.tipo_vialidad_id = params[:id]
      @condiciones_tipo_vialidad.unidad_produccion_condicion_acuicultura_id = params[:unidad_produccion_condicion_acuicultura_id]
      if params[:actualizar] != nil
        @caracterizacion_tipo_vialidad.descripcion_otro =  params[:actualizar]
      end
      @condiciones_tipo_vialidad.save
      render :update do |page|
        message = "#{I18n.t('Sistema.Body.Vistas.General.la').capitalize} #{I18n.t('Sistema.Body.Vistas.General.informacion')} #{I18n.t('Sistema.Body.Modelos.General.se_actualizo_exito')}"
        page.hide 'error'
        page.replace_html 'message', message
        page.show 'message'
      end
    else
      if params[:actualizar] != nil
        @condiciones_tipo_vialidad[0].descripcion_otro =  params[:actualizar]
        @condiciones_tipo_vialidad[0].save
      else
        @condiciones_tipo_vialidad[0].destroy
      end
      render :update do |page|
        message = "#{I18n.t('Sistema.Body.Vistas.General.la').capitalize} #{I18n.t('Sistema.Body.Vistas.General.informacion')} #{I18n.t('Sistema.Body.Modelos.General.se_actualizo_exito')}"
        page.hide 'error'
        page.replace_html 'message', message
        page.show 'message'
      end
    end
  end

  def save_suelos
     
    @condiciones_tipo_suelo = CondicionesTipoSuelo.find(:all, :conditions=>['unidad_produccion_condicion_acuicultura_id = ? and tipo_suelo_id = ?', params[:unidad_produccion_condicion_acuicultura_id], params[:id]])
       
    if @condiciones_tipo_suelo[0]  == nil
      @condiciones_tipo_suelo =  CondicionesTipoSuelo.new
      @condiciones_tipo_suelo.tipo_suelo_id = params[:id]
      @condiciones_tipo_suelo.unidad_produccion_condicion_acuicultura_id = params[:unidad_produccion_condicion_acuicultura_id]
       
      success = @condiciones_tipo_suelo.validar_suelo_procentajes(params[:unidad_produccion_condicion_acuicultura_id],params[:porcentaje],params[:id])
      if success == true
        @condiciones_tipo_suelo.porcentaje = params[:porcentaje]
        if @condiciones_tipo_suelo.save
          render :update do |page|
            message = "#{I18n.t('Sistema.Body.Vistas.General.la').capitalize} #{I18n.t('Sistema.Body.Vistas.General.informacion')} #{I18n.t('Sistema.Body.Modelos.General.se_actualizo_exito')}"
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
          page.alert I18n.t('Sistema.Body.Vistas.General.Verifique_suma_porcentajes_tipo_suelos')
        end
        return false
      end
    else
      if params[:accion] == 'eliminar'
        @condiciones_tipo_suelo[0].destroy
        render :update do |page|
          message = "#{I18n.t('Sistema.Body.Vistas.General.la').capitalize} #{I18n.t('Sistema.Body.Vistas.General.informacion')} #{I18n.t('Sistema.Body.Modelos.General.se_actualizo_exito')}"
          page.hide 'error'
          page.replace_html 'message', message
          page.show 'message'
        end
      else
        success = @condiciones_tipo_suelo[0].validar_suelo_procentajes(params[:unidad_produccion_condicion_acuicultura_id],params[:porcentaje],params[:id])
        if success == true
          @condiciones_tipo_suelo[0].porcentaje = params[:porcentaje]
          if @condiciones_tipo_suelo[0].save
            render :update do |page|
              message = "#{I18n.t('Sistema.Body.Vistas.General.la').capitalize} #{I18n.t('Sistema.Body.Vistas.General.informacion')} #{I18n.t('Sistema.Body.Modelos.General.se_actualizo_exito')}"
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
            page.alert I18n.t('Sistema.Body.Vistas.General.Verifique_suma_porcentajes_tipo_suelos')
          end
          return false
        end  
      end
        
    end
  end

  def save_topografias
     
    @condiciones_tipo_topografia = CondicionesTipoTopografia.find(:all, :conditions=>['unidad_produccion_condicion_acuicultura_id = ? and tipo_topografia_id = ?', params[:unidad_produccion_condicion_acuicultura_id], params[:id]])
       
    if @condiciones_tipo_topografia[0]  == nil
      @condiciones_tipo_topografia =  CondicionesTipoTopografia.new
      @condiciones_tipo_topografia.tipo_topografia_id = params[:id]
      @condiciones_tipo_topografia.unidad_produccion_condicion_acuicultura_id = params[:unidad_produccion_condicion_acuicultura_id]
      @condiciones_tipo_topografia.porcentaje = params[:porcentaje]
      if params[:actualizar] != nil
        @condiciones_tipo_topografia.descripcion_otro =  params[:actualizar]
      end
      success = @condiciones_tipo_topografia.validar_procentajes(params[:unidad_produccion_condicion_acuicultura_id],params[:porcentaje],params[:id])
      if success == true      
        if @condiciones_tipo_topografia.save
          render :update do |page|
            message = "#{I18n.t('Sistema.Body.Vistas.General.la').capitalize} #{I18n.t('Sistema.Body.Vistas.General.informacion')} #{I18n.t('Sistema.Body.Modelos.General.se_actualizo_exito')}"
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
      
    else
      
      if params[:accion] == 'eliminar'
        @condiciones_tipo_topografia[0].destroy
        flash[:notice] = "#{I18n.t('Sistema.Body.Vistas.General.la').capitalize} #{I18n.t('Sistema.Body.Vistas.General.informacion')} #{I18n.t('Sistema.Body.Modelos.General.se_actualizo_exito')}"
        render :update do |page|
          page.hide 'error'
          page.replace_html 'message', message
          page.show 'message'
        end
      else
        if params[:actualizar] != nil
          @condiciones_tipo_topografia[0].descripcion_otro =  params[:actualizar]
        end
        @condiciones_tipo_topografia[0].porcentaje = params[:porcentaje]
        success = @condiciones_tipo_topografia[0].validar_procentajes(params[:unidad_produccion_caracterizacion_id],params[:porcentaje],params[:id])
         
        if success == true
          if @condiciones_tipo_topografia[0].save
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
  end
  
  def save_sistema_cultivo_actual
    @condiciones_sistema_cultivo_actual = CondicionesSistemaCultivoActual.find(:all, :conditions=>['unidad_produccion_condicion_acuicultura_id = ? and tipo_sistema_acuicultura_id = ?', params[:unidad_produccion_condicion_acuicultura_id], params[:id]])

    if @condiciones_sistema_cultivo_actual[0]  == nil
      @condiciones_sistema_cultivo_actual = CondicionesSistemaCultivoActual.new
      @condiciones_sistema_cultivo_actual.tipo_sistema_acuicultura_id = params[:id]
      @condiciones_sistema_cultivo_actual.unidad_produccion_condicion_acuicultura_id = params[:unidad_produccion_condicion_acuicultura_id]
      @condiciones_sistema_cultivo_actual.save
      render :update do |page|
        message = "#{I18n.t('Sistema.Body.Vistas.General.la').capitalize} #{I18n.t('Sistema.Body.Vistas.General.informacion')} #{I18n.t('Sistema.Body.Modelos.General.se_actualizo_exito')}"
        page.hide 'error'
        page.replace_html 'message', message
        page.show 'message'
      end
    else
      logger.info "borrar"
      @condiciones_sistema_cultivo_actual[0].destroy
      render :update do |page|
        message = "#{I18n.t('Sistema.Body.Vistas.General.la').capitalize} #{I18n.t('Sistema.Body.Vistas.General.informacion')} #{I18n.t('Sistema.Body.Modelos.General.se_actualizo_exito')}"
        page.hide 'error'
        page.replace_html 'message', message
        page.show 'message'
      end
    end
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
    @form_entity = 'unidad_produccion_condicion_acuicultura'
    @form_identity_field = 'id'
    @width_layout = '955'
  end

  private
  def _list
    @empresa = Empresa.find(params[:empresa_id])
    conditions = ["empresa_direccion.empresa_id = ?", @empresa.id]
    @params['sort'] = "empresa_direccion.tipo" unless @params['sort']
    #@total = EmpresaDireccion.count(:conditions=>conditions, :include=>:ciudad)
    #@pages, @list = paginate(:empresa_direccion, :class_name => 'EmpresaDireccion',
      #:conditions => conditions,
      #:per_page => @records_by_page,
      #:include=>:ciudad,
      #:select=>'empresa_direccion.*',
      #:order_by => @params['sort'])
    @list = EmpresaDireccion.search(conditions, params[:page], params['sort'])
    @total=@list.count
      
  end
  
  def fill
  
  end

end

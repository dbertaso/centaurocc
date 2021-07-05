# encoding: utf-8

#
# autor: Luis Rojas
# clase: Visitas::VisitaInicialController
# descripción: Migración a Rails 3
#
class Visitas::VisitaInicialController < FormTabTabsController

  def index
    fill
    @solicitud = Solicitud.find(params[:id])
    @contador = SeguimientoVisita.count(:all, :conditions => ['solicitud_id = ? and motivo_visita_id = 1',@solicitud.id])
    unless @contador > 0
      @seguimiento_visita = SeguimientoVisita.new(:solicitud_id => @solicitud.id)
    else
      @seguimiento_visita = SeguimientoVisita.find(:first, :conditions => ['solicitud_id = ? and motivo_visita_id = 1', @solicitud.id])
    end
    @unidad_produccion = @seguimiento_visita.solicitud.unidad_produccion
  end

  def list

    @solicitud = Solicitud.find(params[:id])
    params['sort'] = "codigo_visita" unless params['sort']
    condition = "solicitud_id = #{params[:id]}"
    @list = SeguimientoVisita.search(condition, params[:page], params['sort'])
    @total=@list.count

    form_list

  end

  def new

    @solicitud = Solicitud.find(params[:solicitud_id])
    @contador = SeguimientoVisita.count(:all, :conditions => ['solicitud_id = ? and motivo_visita_id = 1', params[:solicitud_id]])

    if @contador < 1
      fill
      @seguimiento_visita = SeguimientoVisita.new(:solicitud_id => @solicitud.id)
      @unidad_produccion = @seguimiento_visita.Solicitud.UnidadProduccion
      form_new @seguimiento_visita
    else
        render :update do |page|
             page.alert 'No puede registrar mas de una visita incial'
        end
    end

  end

  def cancel_new
    form_cancel_new
  end

  def save_new
    @solicitud = params[:solicitud_id]
    @seguimiento_visita = SeguimientoVisita.new(params[:seguimiento_visita])
    @seguimiento_visita.solicitud_id = params[:solicitud_id]
    @seguimiento_visita.fecha_registro = Time.now.strftime("%Y-%m-%d")
    #creando el codigo de visita (ICV - <inicial_sector>-<anio_curso>-<codigo_tenico>-<cantidad_visitas>)
    #anterior inicial_sector = @seguimiento_visita.Solicitud.sector.nombre[0,1].upcase
    
    if @seguimiento_visita.solicitud.sub_sector.nemonico == "AC"
    inicial_sector = "AC"    
    else
    inicial_sector = @seguimiento_visita.solicitud.sub_sector.nemonico[0,1].upcase
    end
    anio_curso = Time.now.strftime("%Y")
    @tecnico = TecnicoCampo.find_by_cedula(@usuario.cedula)
    codigo_tecnico = @tecnico.codigo.to_s
    cantidad_visitas = @tecnico.cantidad_visitas + 1
    @tecnico.cantidad_visitas = @tecnico.cantidad_visitas + 1

    codigo_visita = "IR"
    codigo_visita += "-"
    codigo_visita += inicial_sector
    codigo_visita += "-"
    codigo_visita += anio_curso
    codigo_visita += "-"
    codigo_visita += codigo_tecnico
    codigo_visita += "-"
    codigo_visita += cantidad_visitas.to_s
    @seguimiento_visita.codigo_visita = codigo_visita


    @referencia = params[:unidad_produccion][:referencia]
    solicitud = Solicitud.find(@solicitud)
    direccion = params[:seguimiento_visita][:direccion_correcta].to_s
    success = true
    success &&= @seguimiento_visita.validar_referencia(@referencia, solicitud, direccion)
    @tecnico.save
    if success
      @seguimiento_visita.direccion_correcta = false
      if  @seguimiento_visita.save
        if  @tecnico.save
          flash[:notice] = "La información de la visita se agregó con éxito."
          render :update do |page|
            page.redirect_to :action=>'index', :id=>@seguimiento_visita.solicitud_id, :popup=>params[:popup]
          end
        else
          render :update do |page|
            page.form_error
            page.<< 'document.getElementById("button_save").disabled = "";'
          end
          return false
        end
      else
        render :update do |page|
          page.form_error
          page.<< 'document.getElementById("button_save").disabled = "";'
        end
        return false
      end
    else
      render :update do |page|
        page.form_error
        page.<< 'document.getElementById("button_save").disabled = "";'
      end
      return false
    end
  end

  def delete
    @seguimiento_visita = SeguimientoVisita.find(params[:id])
    form_delete @seguimiento_visita
  end

  def edit
    @seguimiento_visita = SeguimientoVisita.find(params[:id])
    fill
    @solicitud = Solicitud.find(@seguimiento_visita.solicitud_id)
    @contador = 1
    @unidad_produccion = @seguimiento_visita.solicitud.unidad_produccion
  end

  def save_edit
    @seguimiento_visita = SeguimientoVisita.find(params[:id])
    if  @seguimiento_visita.id != nil
      @referencia = params[:unidad_produccion][:referencia]
      solicitud = Solicitud.find(@seguimiento_visita.solicitud_id)
      direccion = params[:seguimiento_visita][:direccion_correcta].to_s
      success = true
      success &&= @seguimiento_visita.validar_referencia(@referencia,solicitud,direccion)
      if success

        if  @seguimiento_visita.update_attributes(params[:seguimiento_visita]) == true
          flash[:notice] = "La información de la visita se modificó con éxito."
          @eneguimiento_visita = SeguimientoVisita.find(params[:id])
          @seguimiento_visita.direccion_correcta = false
          @seguimiento_visita.save
          render :update do |page|
            page.redirect_to :action=>'edit', :id=>@seguimiento_visita.id, :popup=>params[:popup]
          end
        else
          render :update do |page|
            page.form_error
            page.<< 'document.getElementById("button_save").disabled = "";'
          end
          return false
        end
      else
        render :update do |page|
          page.form_error
          page.<< 'document.getElementById("button_save").disabled = "";'
        end
        return false
      end
    end
  end

  def cancel_edit
    @seguimiento_visita = SeguimientoVisita.find(params[:id])
    form_cancel_edit @seguimiento_visita
  end

  protected
  def common
    super
    @form_title = "#{I18n.t('Sistema.Body.Vistas.General.registro')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.informe_recomendacion')}"
    @form_title_record = I18n.t('Sistema.Body.Vistas.General.informe_recomendacion')
    @form_title_records = I18n.t('Sistema.Body.Vistas.General.informe_recomendacion')
    @form_entity = 'seguimiento_visita'
    @form_identity_field = 'codigo_visita'
    @width_layout = '955'
  end

  def fill
    @motivo_visita_list = MotivoVisita.find(:all, :conditions=>'id = 1', :order=>'id')
  end
end

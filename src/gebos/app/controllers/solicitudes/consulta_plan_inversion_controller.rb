# encoding: utf-8

#
# 
# clase: Solicitudes::ConsultaPlanInversionController
# descripción: Migración a Rails 3
#
class Solicitudes::ConsultaPlanInversionController < FormTabsController
  
  layout 'solicitudes/plan_inversion'
  
  def view
  
=begin
  
  Este método crea el plan de inversión si no existe y posteriormente lee este
  para poblar el grid y permitir las modificaciones pertinentes.
  
  Si existe simplemente llena el grid para permitir modificaciones.
=end
  
    #lectura del plan de inversión para verificar existencia
    
    logger.info "PARAMETROS ==========> " << params.inspect
    
    @solicitud = Solicitud.find(params[:id])
    unless @solicitud.sub_sector.nemonico == 'MA'
      @prestamo = Prestamo.find_by_solicitud_id(@solicitud.id)
      unidad_produccion = UnidadProduccion.find(@solicitud.unidad_produccion_id)
      @oficina_id = Oficina.find(session[:oficina]).id
      estado = Estado.find(unidad_produccion.estado_id)
      sector = Sector.find(@solicitud.rubro.sector_id)
      condicion = " estado_id = #{estado.id} and oficina_id = #{@oficina_id} and "
      condicion += "sector_id = #{@solicitud.sector_id} and sub_sector_id = #{@solicitud.sub_sector_id} "
      condicion += " and rubro_id = #{@solicitud.rubro_id} "

      condicion = " solicitud_id = #{@solicitud.id}"

      @plan_inversion = PlanInversion.find(:all,:conditions=>condicion,
                                                :order =>"estado_nombre,oficina_nombre,sector_nombre,sub_sector_nombre,rubro_nombre,partida_nombre,item_nombre,tipo_item",
                                                :include=>[:unidad_medida])


      @plan = @plan_inversion[0]


      if @solicitud.sub_sector.nemonico == 'VE'

        @caracterizacion = UnidadProduccionCaracterizacion.find_by_solicitud_id_and_unidad_produccion_id(@solicitud.id,@solicitud.unidad_produccion_id)

        if @caracterizacion.nil? && (@solicitud.numero_origen == 0 || @solicitud.numero_origen.nil?)

           #solicitud.erorrs_add_to_base(nil,"No existe estructura de costos para el rubro")
           @mensaje1 = "No existen los datos de la caracterización de la unidad de producción para el trámite #: #{@solicitud.numero}"
           render :template => "solicitudes/plan_inversion/error"
           return

        end

        #logger.info "CARACTERIZACION =========> " << @caracterizacion.inspect
      end
    else
      @prestamo = Prestamo.find_by_solicitud_id(@solicitud.id)
      @solicitud_maquinaria_inventario = SolicitudMaquinaria.find(:all, :conditions => "solicitud_id = #{@solicitud.id} and estatus = 'I'", :order => "tipo_maquinaria_id") 
      @solicitud_maquinaria_proforma = SolicitudMaquinaria.find(:all, :conditions => "solicitud_id = #{@solicitud.id} and estatus = 'P'", :order => "tipo_maquinaria_id")
      @width_layout = '1090'
    end

  end

  protected
  def common
    super
    @form_title = 'Plan de Inversión'
    @form_title_record = 'Plan de Inversión'
    @form_title_records = 'Plan de Inversión'
    @form_entity = 'plan_inversion'
    @form_identity_field = 'id'
    @width_layout = '1200'
  end
  
end

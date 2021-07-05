# encoding: utf-8
class SeguimientoVisita < ActiveRecord::Base

  self.table_name = 'seguimiento_visita'

  attr_accessible :id,
    :solicitud_id,
    :fecha_visita,
    :hora_visita,
    :motivo_visita_id,
    :cedula_persona_atencion,
    :nombre_persona_atencion,
    :apellido_persona_atencion,
    :telf1_persona_atencion,
    :telf2_persona_atencion,
    :telf3_persona_atencion,
    :vinculo_persona_atencion,
    :direccion_correcta,
    :observaciones,
    :codigo_visita,
    :cedula_nacionalidad_persona_atencion,
    :confirmada,
    :usuario_visita,
    :fecha_registro,
    :activo,
    :hora_visita_ampm,
    :fecha_visita_f,
    :hora_visita_f
  
  
  
  belongs_to :motivo_visita
  belongs_to :solicitud
  has_one :seguimiento_cultivo
  has_one :descripciones_especificas
  has_one :pastizales_potreros
  has_one :sanidad_animal
  has_many :encuesta_visita
  has_many :embarcacion
  has_one :desembolso
  has_one :orden_despacho
  has_one :decision_visita
  has_one :semovientes
  
  #INICIO VALIDATES
  validates :solicitud_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.Form.solicitud')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :motivo_visita_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Controladores.MotivoVisita.FormTitles.form_title')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :hora_visita_f, :length => { :in => 5..12, :allow_blank => false,
    :too_short => "#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Columnas.hora_visita')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Columnas.hora_visita')}  #{I18n.t('errors.messages.too_long.other')}"}
  
  validates :cedula_persona_atencion, :length => { :in => 6..8, :allow_blank => false,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.cedula')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.cedula')}  #{I18n.t('errors.messages.too_long.other')}"},
    :numericality =>{:numericality => true, :only_integer => true, :allow_blank => true, :message => "#{I18n.t('Sistema.Body.Vistas.General.cedula')} #{I18n.t('errors.messages.not_an_integer_decimal')}"}
  
  validates :nombre_persona_atencion, :length => { :in => 3..30, :allow_blank => false,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.nombre')}  #{I18n.t('errors.messages.too_long.other')}"}
  
  validates :apellido_persona_atencion, :length => { :in => 3..30, :allow_blank => false,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.apellido')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.apellido')}  #{I18n.t('errors.messages.too_long.other')}"}

  validates :vinculo_persona_atencion, :length => { :in => 1..60, :allow_blank => false,
    :too_short => "#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Columnas.vinculo_persona_atendio')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Columnas.vinculo_persona_atendio')}  #{I18n.t('errors.messages.too_long.other')}"}

  validates :codigo_visita, :uniqueness =>{:uniqueness => true, :message => "#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Columnas.codigo_visita')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"}
  
  #validates :telf1_persona_atencion, :length => { :in=>11..11, :allow_blank => false,
  # :too_short =>"#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Columnas.telf1')} #{I18n.t('errors.messages.too_short.other')}",
  # :too_long => "#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Columnas.telf1')}  #{I18n.t('errors.messages.too_long.other')}"}

  #validates :telf2_persona_atencion, :length => { :in=>11..11, :allow_blank => true,
  # :too_short =>"#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Columnas.telf2')} #{I18n.t('errors.messages.too_short.other')}",
  #:too_long => "#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Columnas.telf2')}  #{I18n.t('errors.messages.too_long.other')}"}

  #validates :telf3_persona_atencion, :length => { :in =>11..11, :allow_blank => true,
  #  :too_short =>"#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Columnas.telf3')} #{I18n.t('errors.messages.too_short.other')}",
  # :too_long => "#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Columnas.telf3')}  #{I18n.t('errors.messages.too_long.other')}"}
 
  
  #FIN VALIDATES

  validates :fecha_visita,
    :date => {:message =>"#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Columnas.fecha_visita')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalida')}",
    :before => Proc.new { 1.day.from_now.to_date }, :message => "#{I18n.t('Sistema.Body.Modelos.Errores.fecha_fin_no_posterior')}"}


  def semana_antes_visita(fecha_visita, fecha_comp)
    # Compara que la fecha de la visita no sea anterior a una semana (7 días)
    success = true
    unless fecha_visita.nil? || fecha_visita.empty?
      fecha_visita = (fecha_visita.to_s).split("/")
      fecha_visita = (fecha_visita[2]+"-"+fecha_visita[1]+"-"+fecha_visita[0])
      fecha_visita = fecha_visita.to_date
      fecha_comp = (fecha_comp - 7)

      logger.debug "comparación fecha_visita =====> " << fecha_visita.to_s
      logger.debug "comparación fecha_comp  =====> " <<  fecha_comp.to_s
      if (fecha_visita.to_date - fecha_comp.to_date) < 0
        errors.add(:seguimiento_visita, I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Errores.fecha_semana_antes_visita'))
        success = false
      end
    else
      errors.add(:seguimiento_visita,"#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Columnas.fecha_visita')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
      success = false
    end
    return success
  end  

  def fecha_visita_f=(fecha)
    self.fecha_visita = fecha
  end

  def fecha_visita_f
    format_fecha(self.fecha_visita)
  end

  def hora_visita_f=(time)
    self.hora_visita = time
  end

  def hora_visita_f
    format_hora(self.hora_visita)
  end

  def validar_referencia(referencia, solicitud, direccion)
    success = true
    unless direccion == 'false'
      if referencia.empty?
        errors.add(:seguimiento_visita, I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Errores.direcion_referencia_requerida'))
        success = false
      elsif referencia == solicitud.unidad_produccion.referencia
        errors.add(:seguimiento_visita, I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Errores.debe_modificar_direccion'))
        success = false
      elsif referencia.length < 25
        errors.add(:seguimiento_visita, I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Errores.direccion_demasiado_corta'))
        success = false
      else
        solicitud.unidad_produccion.referencia = referencia
        solicitud.unidad_produccion.save
        success = true
      end
    end
    return success
  end

  def validar_fecha_visita (params, solicitud)
    success = true
    logger.debug "parametros ===> " << params.inspect
    if params[:seguimiento_visita][:fecha_visita_f]==""
      errors.add(:seguimiento_visita, "#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Columnas.fecha_visita')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalida')}")
      success = false
    else
      seguimiento = SeguimientoVisita.find(:all, :conditions=>"solicitud_id = #{solicitud.id} and fecha_visita = '#{params[:seguimiento_visita][:fecha_visita_f]}' and activo=true")
      logger.debug "seguimiento ===> "<< seguimiento.inspect
      if seguimiento.length > 0
        errors.add(:seguimiento_visita,"#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Errores.visita_con_fecha_ya_realizada')} '#{params[:seguimiento_visita][:fecha_visita_f].to_s}'")
        success = false
      end
    end
    return success
  end
  
  
  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort,
      :select=>'*'
  end
  
  
  #calculo de la edad de una persona
  def edad(fecha_actual, fecha_nacimiento)
    anno_nacimiento = fecha_nacimiento.year
    anno_actual = fecha_actual.year
    edad = 0
    if fecha_actual.month > fecha_nacimiento.month
      edad = (anno_actual - anno_nacimiento)
    elsif fecha_actual.month == fecha_nacimiento.month
      if fecha_actual.day >= fecha_nacimiento.day
        edad = anno_actual - anno_nacimiento
      else
        edad = (anno_actual - anno_nacimiento) - 1
      end
    else
      edad = (anno_actual - anno_nacimiento) - 1
    end
    return edad
  end

  #determina la cantidad de solicitudes por un seguimiento_visita
  #solo mostrará las otras pestañas si se ha registrado la visita inicial
  
  def self.visita_solicitud(solicitud_id)
    return SeguimientoVisita.count(:conditions=>['solicitud_id = ? and motivo_visita_id = 1', solicitud_id])
  end

  def self.mostar_id(solicitud_id)
    visita = SeguimientoVisita.find(:first, :conditions=>['solicitud_id = ?', solicitud_id])
    unless visita.nil?
      return visita.id
    else
      return 0
    end
  end

  def self.confirmar(solicitud_id, ruta)
    solicitud = Solicitud.find(solicitud_id)
    visita = SeguimientoVisita.find(:all, :conditions => "solicitud_id = #{solicitud.id}")
    errores = ""
    if visita.length > 0
      visita = visita[0]
      if solicitud.sub_sector.nemonico == 'VE' || solicitud.sub_sector.nemonico == 'AN' || solicitud.sub_sector.nemonico == 'AC' || solicitud.sub_sector.nemonico == 'MA' || solicitud.sub_sector.nemonico == 'PE'
        unless solicitud.sub_sector.nemonico == "PE"
          count = ServiciosBasicos.count(:conditions => "solicitud_id = #{solicitud.id}")
          unless count > 0
            errores << "<li><b>#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Errores.Confirmar.servicios')}</b>#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Errores.Confirmar.debe_registrar_servicios')}<a href='#{ruta}/solicitudes/solicitud_pre_evaluacion_servicios/#{solicitud.id}/edit?seguimiento_visita_id=#{visita.id}'>#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Errores.Confirmar.ir_directamente')}</a></li>"
          end
          unless solicitud.sub_sector.nemonico == "AC"
            count = UnidadProduccionCaracterizacion.count(:conditions => "solicitud_id = #{solicitud.id}")
            unless count > 0
              errores << "<li><b>#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Errores.Confirmar.caracterizacion')}</b>#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Errores.Confirmar.debe_registrar_caracterizacion')}<a href='#{ruta}/solicitudes/solicitud_pre_evaluacion_caracterizacion/#{solicitud.id}/edit?seguimiento_visita_id=#{visita.id}'>#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Errores.Confirmar.ir_directamente')}</a></li>"
            end
          end
          count = UnidadProduccionColocacion.count(:conditions => "solicitud_id = #{solicitud.id}")
          unless count > 0
            errores << "<li><b>#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Errores.Confirmar.colocacion')}</b>#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Errores.Confirmar.registrar_colocacion')}<a href='#{ruta}/solicitudes/solicitud_pre_evaluacion_colocacion?seguimiento_visita_id=#{visita.id}&solicitud_id=#{solicitud.id}'>#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Errores.Confirmar.ir_directamente')}</a></li>"
          end
          count = EncuestaVisita.count(:conditions => "seguimiento_visita_id = #{visita.id} and (respuesta = true or respuesta = false)")
          unless count > 0
            errores << "<li><b>#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Errores.Confirmar.cuestionario')}</b>#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Errores.Confirmar.registrar_respuesta')}<a href='#{ruta}/visitas/encuesta?seguimiento_visita_id=#{visita.id.to_s}&solicitud_id=#{solicitud.id}'>#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Errores.Confirmar.ir_directamente')}</a></li>"
          end
        else
          count = Embarcacion.count(:conditions => "seguimiento_visita_id = #{visita.id}")
          unless count > 0
            errores << "<li><b>#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Errores.Confirmar.embarcacion')}</b>#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Errores.Confirmar.registrar_embarcacion')}<a href='#{ruta}/basico/embarcacion/index/#{visita.id.to_s}'>#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Errores.Confirmar.ir_directamente')}</a></li>"
          end
        end
        if solicitud.sub_sector.nemonico == "AN"
          count = UnidadProduccionInventarioAnimales.count(:conditions => "solicitud_id = #{solicitud.id}")
          unless count > 0
            errores << "<li><b>#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Errores.Confirmar.inventario')}</b>#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Errores.Confirmar.registrar_inventario')}<a href='#{ruta}/solicitudes/solicitud_pre_evaluacion_animales/#{solicitud.id}/edit?seguimiento_visita_id=#{visita.id}'>#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Errores.Confirmar.ir_directamente')}</a></li>"
          end
        end
        if solicitud.sub_sector.nemonico == "AC"
          count = UnidadProduccionCondicionAcuicultura.count(:conditions => "solicitud_id = #{solicitud.id}")
          unless count > 0
            errores << "<li><b>#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Errores.Confirmar.condiciones')}</b>#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Errores.Confirmar.registrar_condiciones')}<a href='#{ruta}/solicitudes/solicitud_pre_evaluacion_condicion_acuicultura/#{solicitud.id}/edit?seguimiento_visita_id=#{visita.id}'>#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Errores.Confirmar.ir_directamente')}</a></li>"
          end
        end
      end 
      if solicitud.decision_final.nil? || solicitud.justificacion.nil?
        errores << "<li><b>#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Errores.Confirmar.decision')}</b>#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Errores.Confirmar.registrar_decision')}<a href='#{ruta}/solicitudes/decision/edit?solicitud_id=#{solicitud.id}'>#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Errores.Confirmar.ir_directamente')}</a></li>"
      end
      if solicitud.decision_final == true
        unless solicitud.sub_sector.nemonico == "MA"
          plan = PlanInversion.sum(:monto_financiamiento, :conditions=>"solicitud_id = #{solicitud.id}")
          unless plan.nil?
            unless plan > 0
              errores << "<li><b>#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Errores.Confirmar.plan_inversion')}</b>#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Errores.Confirmar.registrar_plan_inversion')}<a href='#{ruta}/solicitudes/plan_inversion/#{solicitud.id}/edit'>#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Errores.Confirmar.ir_directamente')}</a></li>"
            # else
            #   total_prestamo = Prestamo.count(:conditions => ['solicitud_id = ?', solicitud.id])
            #   unless total_prestamo > 0
            #     errores << "<li><b>#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Errores.Confirmar.plan_inversion')}</b>#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Errores.Confirmar.registrar_plan_inversion')}<a href='#{ruta}/solicitudes/plan_inversion/#{solicitud.id}/edit'>#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Errores.Confirmar.ir_directamente')}</a></li>"
            #   else
            #     prestamo = Prestamo.sum(:monto_solicitado, :conditions => ['solicitud_id = ?', solicitud.id])
            #       unless prestamo > 0
            #       errores << "<li><b>#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Errores.Confirmar.plan_inversion')}</b>#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Errores.Confirmar.registrar_plan_inversion')}<a href='#{ruta}/solicitudes/plan_inversion/#{solicitud.id}/edit'>#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Errores.Confirmar.ir_directamente')}</a></li>"
            #     end
            #   end
            end
          else
            errores << "<li><b>#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Errores.Confirmar.plan_inversion')}</b>#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Errores.Confirmar.registrar_plan_inversion')}<a href='#{ruta}/solicitudes/plan_inversion/#{solicitud.id}/edit'>#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Errores.Confirmar.ir_directamente')}</a></li>"
          end
        else
          total = SolicitudMaquinaria.count(:conditions => ['solicitud_id = ?', solicitud.id])
          unless total > 0
            errores << "<li><b>#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Errores.Confirmar.plan_inversion')}</b>#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Errores.Confirmar.registrar_plan_inversion')}<a href='#{ruta}/solicitudes/plan_inversion/#{solicitud.id}/edit'>#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Errores.Confirmar.ir_directamente')}</a></li>"
          else
            total = SolicitudMaquinaria.count(:conditions => ['solicitud_id = ? and estatus is null', solicitud.id])
            if total > 0
              errores << "<li><b>#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Errores.Confirmar.plan_inversion')}</b>#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Errores.Confirmar.completar_plan_inversion')} <a href='#{ruta}/solicitudes/plan_inversion/edit/#{solicitud.id}'>Ir directamente</a></li>"
            else
              total = SolicitudMaquinaria.count(:conditions => ["solicitud_id = ? and estatus = 'P' and proforma_id is null", solicitud.id])
              if total > 0
                errores << "<li><b>#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Errores.Confirmar.plan_inversion')}</b>#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Errores.Confirmar.completar_proforma')} <a href='#{ruta}/solicitudes/plan_inversion/edit/#{solicitud.id}'>Ir directamente</a></li>"
              end
            end
          end
        end
      end
    else
      errores << "<li><b>#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Errores.Confirmar.visita')}</b>#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Errores.Confirmar.registrar_visita')}<a href='#{ruta}/visitas/visita_inicial?id=#{solicitud.id}'>#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Errores.Confirmar.ir_directamente')}</a></li>"
    end
    
    return errores
  end

  def self.pidan(solicitud, usuario)
    begin
      estatus_id = ""
      unless solicitud.prestamos[0].total_financiamiento_fm.nil? || solicitud.prestamos[0].total_financiamiento_fm.empty?
        unless solicitud.sub_sector.nemonico == "MA"
          total_financiamiento = solicitud.prestamos[0].total_financiamiento_fm
          total_financiamiento = total_financiamiento.gsub('.','').gsub(',','.')
        else
          total_proforma = SolicitudMaquinaria.count(:conditions => "estatus = 'P' and solicitud_id = #{solicitud.id}")
          unless total_proforma > 0
            estatus_id = "10033"
          else
            parametro = ParametroGeneral.find(1)
            total_maquinaria = solicitud.prestamos[0].monto_insumos
            sras_primer_ano = 0
            sras_anos_siguen = 0
            factor_mensual_primer_ano = parametro.porcentaje_sras_maquinaria_primer_anno / 1200
            factor_mensual_anos_siguen = parametro.porcentaje_sras_maquinaria_anno_subsiguientes / 1200
            if solicitud.prestamos[0].plazo <= 12
              sras_primer_ano = (total_maquinaria * factor_mensual_primer_ano) * 12
              sras_anos_siguen = 0.00
            end

            if solicitud.prestamos[0].plazo > 12
              sras_primer_ano = (total_maquinaria * factor_mensual_primer_ano) * 12
              sras_anos_siguen = (total_maquinaria * factor_mensual_anos_siguen) * (solicitud.prestamos[0].plazo - 12)
            end
            
            gastos = ProgramaTipoGasto.find_by_programa_id_and_tipo_gasto_id(solicitud.programa_id, 1)
            total_gasto = 0.00
            unless (gastos.nil?)        
              if gastos.porcentaje > 0
                monto = ((total_maquinaria)*(gastos.porcentaje/100))
              else
                monto = gastos.monto_fijo 
              end
              total_gasto = monto
            end           
            sras_total = sras_primer_ano + sras_anos_siguen
            total_financiamiento = total_maquinaria + sras_total + total_gasto
          end
        end
      else
        total_financiamiento = solicitud.monto_solicitado
      end
      p = PresupuestoPidan.find(:all, :conditions=>"programa_id = #{solicitud.programa_id} and estado_id = #{solicitud.unidad_produccion.ciudad.estado_id} and sub_rubro_id = #{solicitud.sub_rubro_id} and disponibilidad >= #{total_financiamiento.to_f}")
      transaction do
        
        if solicitud.sub_sector.nemonico == 'VE'
          if solicitud.actividad.ciclo_productivo.activo == false
            estatus_id = "10005"
          end
        end
        
        unless estatus_id.length > 0
          if p.length > 0
            pidan = p[0]
            pidan.compromiso = pidan.compromiso + total_financiamiento.to_f
            pidan.disponibilidad = pidan.disponibilidad - total_financiamiento.to_f
            success = pidan.save!
            estatus_id = "10033"
          else
            estatus_id = "10010"
          
          end     # ======> Fin if p.length > 0
        
        end       # ======> Fin unless estatus_id.length > 0
             
        estatus_id_inicial = solicitud.estatus_id
        fecha_evento = Time.now
        #@configuracion_avance = ConfiguracionAvance.find_by_estatus_origen_id(estatus_id_inicial)
        estatus_id_final = estatus_id
        solicitud.estatus_id = estatus_id
        solicitud.fecha_actual_estatus = format_fecha(fecha_evento)
        solicitud.save!
        # Crea un nuevo registro en la tabla control_solicitud
        ControlSolicitud.create(
          :solicitud_id=>solicitud.id,
          :estatus_id=>estatus_id_final,
          :usuario_id=>usuario.id,
          :fecha => fecha_evento,
          :estatus_origen_id => estatus_id_inicial,
          :accion => 'Avanzar'
        )
        return true
      
      end      # ======> Fin transaction do
    
    rescue Exception => e
      
      logger.debug "----------------------------------------------------"
      logger.error e.message
      return false
      
    end      # ======> Fin Begin
    
    
  end
  
end




# == Schema Information
#
# Table name: seguimiento_visita
#
#  id                                   :integer         not null, primary key
#  solicitud_id                         :integer         not null
#  fecha_visita                         :date
#  hora_visita                          :time
#  motivo_visita_id                     :integer
#  cedula_persona_atencion              :string(10)
#  nombre_persona_atencion              :string(30)
#  apellido_persona_atencion            :string(30)
#  telf1_persona_atencion               :string(12)
#  telf2_persona_atencion               :string(12)
#  telf3_persona_atencion               :string(12)
#  vinculo_persona_atencion             :string(60)
#  direccion_correcta                   :boolean         default(FALSE), not null
#  observaciones                        :text
#  codigo_visita                        :string(30)
#  cedula_nacionalidad_persona_atencion :string(1)       default("V"), not null
#  confirmada                           :boolean         default(FALSE), not null
#  usuario_visita                       :string(30)
#  fecha_registro                       :date
#  activo                               :boolean         default(TRUE), not null
#  hora_visita_ampm                     :string(2)
#


# encoding: utf-8

#
# autor: Luis Rojas
# clase: Solicitud
# descripcion: Migracion a Rails 3
#
class Solicitud < ActiveRecord::Base

  self.table_name = 'solicitud'

  attr_accessible :id,
                  :cliente_id,
                  :numero,
                  :programa_id,
                  :fecha_solicitud,
                  :fecha_registro,
                  :monto_solicitado,
                  :monto_aprobado,
                  :nombre_proyecto,
                  :objetivo_proyecto,
                  :justificacion,
                  :aporte_social,
                  :monto_propuesta_social,
                  :estatus,
                  :numero_comite_estadal,
                  :numero_comite_nacional,
                  :fecha_comite_estadal,
                  :fecha_comite_nacional,
                  :fecha_solicitud_desembolso,
                  :comentario_directorio,
                  :causa_rechazo_id,
                  :causa_diferimiento_id,
                  :parroquia_id,
                  :ciudad_id,
                  :municipio_id,
                  :estatus_directorio,
                  :intermediado,
                  :modalidad_financiamiento_id,
                  :origen_fondo_id,
                  :porcentaje_cooperativa,
                  :porcentaje_empresa,
                  :monto_cliente,
                  :liberada,
                  :causa_liberacion,
                  :aumento_capital,
                  :estatus_comite,
                  :estatus_modificacion,
                  :estatus_comite_temporal,
                  :causa_diferimiento_comite_id,
                  :migrado_d3,
                  :causa_rechazo_comite_id,
                  :codigo_d3,
                  :codigo_presupuesto_d3,
                  :descripcion_presupuesto_d3,
                  :tipo_comite,
                  :tir,
                  :van,
                  :tiempo_recuperacion,
                  :estatus_id,
                  :fecha_actual_estatus,
                  :fecha_firma_contrato,
                  :cuenta_matriz_id,
                  :numero_origen,
                  :banco_origen,
                  :transcriptor,
                  :fecha_aprobacion,
                  :fecha_liquidacion,
                  :ups_id,
                  :observacion,
                  :numero_grupo,
                  :numero_empresa,
                  :control,
                  :mision_id,
                  :analista_consejo,
                  :comite_id,
                  :decision_comite,
                  :comentario_comite,
                  :numero_acta_resumen_comite,
                  :estatus_desembolso_id,
                  :control_certificacion,
                  :control_disponibilidad,
                  :numero_acta_liquidacion,
                  :fecha_acta_liquidacion,
                  :region_id,
                  :certificado_presupuesto,
                  :monto_analista,
                  :scoring_aceptacion_id,
                  :monto_actuales,
                  :monto_proyecto,
                  :calificacion_cuantitativa,
                  :calificacion_cualitativa,
                  :calificacion_social,
                  :destino_credito,
                  :tipo_iniciativa_id,
                  :usuario_pre_evaluacion,
                  :partida_presupuestaria_id,
                  :consultoria,
                  :decision_final,
                  :confirmacion,
                  :avaluo_obra_civil,
                  :usuario_resguardo,
                  :reestructuracion_solicitud_id,
                  :monto_ampliacion,
                  :no_visto,
                  :oficina_id,
                  :unidad_produccion_id,
                  :sector_id,
                  :sub_sector_id,
                  :rubro_id,
                  :empresa_integrante_id,
                  :instancia_comite,
                  :decision_comite_estadal,
                  :decision_comite_nacional,
                  :comite_estadal_id,
                  :comentario_comite_estadal,
                  :comentario_comite_nacional,
                  :hectareas_recomendadas,
                  :semovientes_recomendados,
                  :folio_autenticacion,
                  :tomo_autenticacion,
                  :abogado_id,
                  :codigo_sras,
                  :enviado_suscripcion,
                  :ruta_contrato,
                  :ruta_acta_entrega,
                  :ruta_nota_autenticacion,
                  :fecha_nota_autenticacion,
                  :hectareas_solicitadas,
                  :semovientes_solicitados,
                  :por_inventario,
                  :fecha_a_entrega,
                  :conf_maquinaria,
                  :sub_rubro_id,
                  :actividad_id,
                  :moneda_id,
                  :prestamo,
                  :oficina

  belongs_to :sub_rubro
  belongs_to :actividad
  belongs_to :scoring_aceptacion
  belongs_to :comite
  belongs_to :estatus
  belongs_to :origen_fondo
  belongs_to :region
  belongs_to :unidad_produccion
  belongs_to :ciudad
  belongs_to :municipio
  belongs_to :parroquia
  belongs_to :causa_rechazo
  belongs_to :causa_diferimiento
  belongs_to :modalidad_financiamiento
  belongs_to :sector
  belongs_to :sub_sector
  belongs_to :rubro
  belongs_to :oficina
  belongs_to :moneda
  belongs_to :estado_comite, :class_name=>'Estado',  :foreign_key =>'estado_comite_id'
  belongs_to :causa_rechazo_comite, :class_name=>'CausaRechazo',  :foreign_key =>'causa_rechazo_comite_id'
  belongs_to :causa_diferimiento_comite, :class_name=>'CausaDiferimiento',  :foreign_key =>'causa_diferimiento_comite_id'
  belongs_to :causa_rechazo_comite, :class_name=>'CausaRechazo',  :foreign_key =>'causa_rechazo_consejo_id'
  belongs_to :causa_diferimiento_comite, :class_name=>'CausaDiferimiento',  :foreign_key =>'causa_diferimiento_consejo_id'
  belongs_to :cliente,
    :class_name => "Cliente",
    :foreign_key => "cliente_id"
  belongs_to :programa,
    :class_name => "Programa",
    :foreign_key => "programa_id"
  has_many :solicitud_maquinaria
  has_many :unidad_produccion_condicion_acuicultura
  has_many :unidad_produccion_inventario_animales
  has_many :unidad_produccion_infraestructura
  has_many :unidad_produccion_colocacion
  has_many :unidad_produccion_maquinaria
  has_many :linderos_coordenadas
  has_many :unidad_produccion_caracterizacion
  has_many :recaudos, :class_name=>'SolicitudRecaudo'
  has_many :prestamos, :class_name=>'Prestamo'
  has_many :garantias, :class_name=>'Garantia'
  has_many :condicionamientos, :class_name=>'Condicionamiento'
  has_many :gerencias, :class_name=>'Gerencia'
  has_many :resoluciones, :class_name => "SolicitudHistorico", :order=>"id"
  has_many :mercado_productos
  has_many :estructura_costo
  has_many :cronograma_desembolso
  has_many :unidad_negocio
  has_many :solicitud_producto
  has_many :control_asignacion
  belongs_to :partida_presupuestaria
  has_many :solicitud_aspectos_evaluar
  has_many :solicitud_obra_civil
  has_many :solicitud_recaudo_avaluo
  has_many :solicitud_tipo_garantia
  has_many :solicitud_insumos_internos
  has_many :solicitud_resguardo_imagen
  has_many :complemento_decision
  has_many :solicitud_rubro_solicitado
  has_many :solicitud_rubro_sugerido
  has_one :solicitud_certificacion_presupuestaria

  has_one :solicitud_contrato
  has_many :seguimiento_visita
  has_many :desvio_silo

  #  validates :destino_credito, :presence => {
  #    :if => Proc.new {|a| a.migrado_d3},
  #    :message => "#{I18n.t('Sistema.Body.Modelos.Solicitud.destino_credito')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :cliente, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.cliente')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :fecha_solicitud, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.Form.fecha')} #{I18n.t('Sistema.Body.Vistas.General.solicitud')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :programa, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.programa')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :sector, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.sector')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :sub_rubro, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.sub_rubro')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :actividad, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.actividad')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :origen_fondo, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.origen')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.fondo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :sub_sector, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.sub_sector')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :modalidad_financiamiento, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.modalidad')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.financiamiento')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :rubro, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.rubro')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :unidad_produccion_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.unidad_produccion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :objetivo_proyecto,
    :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.objetivo')} #{I18n.t('Sistema.Body.Vistas.General.del')} #{I18n.t('Sistema.Body.Vistas.General.proyecto')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => {:in => 3..400, :too_short => "#{I18n.t('Sistema.Body.Vistas.General.objetivo')} #{I18n.t('Sistema.Body.Vistas.General.del')} #{I18n.t('Sistema.Body.Vistas.General.proyecto')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long  => "#{I18n.t('Sistema.Body.Vistas.General.objetivo')} #{I18n.t('Sistema.Body.Vistas.General.del')} #{I18n.t('Sistema.Body.Vistas.General.proyecto')} #{I18n.t('errors.messages.too_long.other')}" }, :allow_nil => true
  
  validates :numero,
    :uniqueness => { :on=>:create,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.numero')} #{I18n.t('Sistema.Body.General.de')} #{I18n.t('Sistema.Body.Vistas.General.solicitud')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"}
  
  validates :hectareas_solicitadas,
    :numericality => {:numericality => true, :message => "#{I18n.t('Sistema.Body.Vistas.General.hectareas')} #{I18n.t('Sistema.Body.Vistas.General.solicitadas')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}", :allow_blank => true}

  validates :monto_aprobado,
    :numericality => {:if => Proc.new {|a| a.migrado_d3.nil? && !a.monto_aprobado.nil?}, :message => "#{I18n.t('Sistema.Body.Modelos.Prestamo.Columnas.monto_aprobado')} #{I18n.t('Sistema.Body.Modelos.Errores.monto_invalido')}" }

  validates :monto_actuales,
    :numericality => {:if => Proc.new {|a| a.migrado_d3 && !a.monto_actuales.nil?}, :message => "#{I18n.t('Sistema.Body.Modelos.Prestamo.Columnas.montos_actuales')} #{I18n.t('Sistema.Body.Modelos.Errores.monto_invalido')}" }

  validates :monto_proyecto,
    :numericality => {:if => Proc.new {|a| a.migrado_d3 && !a.monto_proyecto.nil?}, :message => "#{I18n.t('Sistema.Body.Modelos.Prestamo.Columnas.monto_proyecto')} #{I18n.t('Sistema.Body.Modelos.Errores.monto_invalido')}" }

  validates :calificacion_cuantitativa,
    :numericality => {:if => Proc.new {|a| a.migrado_d3 && !a.calificacion_cuantitativa.nil?}, :message => "#{I18n.t('Sistema.Body.Modelos.Prestamo.Columnas.calificacion_cuantitativa')} #{I18n.t('Sistema.Body.Modelos.Errores.monto_invalido')}" }

  validates :calificacion_cualitativa,
    :numericality => {:if => Proc.new {|a| a.migrado_d3 && !a.calificacion_cualitativa.nil?}, :message => "#{I18n.t('Sistema.Body.Modelos.Prestamo.Columnas.calificacion_cualitativa')} #{I18n.t('Sistema.Body.Modelos.Errores.monto_invalido')}" }

  validates :calificacion_social,
    :numericality => {:if => Proc.new {|a| a.migrado_d3 && !a.calificacion_social.nil?}, :message => "#{I18n.t('Sistema.Body.Modelos.Prestamo.Columnas.calificacion_social')} #{I18n.t('Sistema.Body.Modelos.Errores.monto_invalido')}" }

  validates :monto_solicitado,
    :numericality => {:if => Proc.new {|a| a.migrado_d3}, :message => "#{I18n.t('Sistema.Body.Modelos.Prestamo.Columnas.monto_solicitado')} #{I18n.t('Sistema.Body.Modelos.Errores.monto_invalido')}" }

  validates  :monto_aprobado,
    :presence => { :if => Proc.new {|a| a.migrado_d3.nil?},
    :message => I18n.t('Sistema.Body.Modelos.Errores.es_requerido'),
    :numericality => {:if => Proc.new {|a| a.migrado_d3.nil? && !a.monto_aprobado.nil?},
      :message => "#{I18n.t('Sistema.Body.Modelos.Prestamo.Columnas.monto_aprobado')} #{I18n.t('Sistema.Body.Modelos.Errores.monto_invalido')}" } }

  validates :monto_cliente,
    :numericality => {:if => Proc.new {|a| a.migrado_d3.nil? && !a.monto_cliente.nil?},
    :message => "#{I18n.t('Sistema.Body.Modelos.Prestamo.Columnas.monto_cliente')} #{I18n.t('Sistema.Body.Modelos.Errores.monto_invalido')}" }

#  validates :fecha_comite_estadal,
#    :date => {:message => I18n.t('Sistema.Body.Modelos.Errores.fecha_invalida'),
#    :before => Proc.new { 0.day.from_now.to_date }, :message => I18n.t('Sistema.Body.Modelos.Solicitud.Errores.fecha_mayor_que_la_actual')}
#
#  validates :fecha_comite_nacional,
#    :date => {:message => I18n.t('Sistema.Body.Modelos.Errores.fecha_invalida'),
#    :before => Proc.new { 0.day.from_now.to_date }, :message => I18n.t('Sistema.Body.Modelos.Solicitud.Errores.fecha_mayor_que_la_actual')}

  attr_accessor :usuario
  attr_accessor :ip_address
  attr_accessor :observaciones

  def save_viable(params)
    error = true
    if params[:decision_final].nil?
      self.errors.add(:solicitud, I18n.t('Sistema.Body.Modelos.Solicitud.Errores.decision_que_aplicara'))
      error = false
    end
    if params[:justificacion].nil? || params[:justificacion].empty?
      self.errors.add(:solicitud, I18n.t('Sistema.Body.Modelos.Solicitud.Errores.justificacion_tecnica_requerida'))
      error = false
    end
    unless error == true
      return false
    else
      self.decision_final = params[:decision_final]
      self.justificacion = params[:justificacion]
      if self.save
        return true
      else
        return false
      end
    end
  end

  def save_new
    begin
      transaction do
      
        ParametroGeneral.connection.execute("LOCK parametro_general in ACCESS EXCLUSIVE MODE;")
        parametro = ParametroGeneral.find(:first)
   
        if parametro.numero_solicitud_inicial_uea.nil?
          parametro.numero_solicitud_inicial_uea = 50000000
        end

        ultima_solicitud = parametro.numero_solicitud_inicial_uea + 1
        parametro.numero_solicitud_inicial_uea = ultima_solicitud
        parametro.save!
   
        self.numero = ultima_solicitud
        programa = Programa.find(self.programa_id)
        self.moneda_id = programa.moneda_id
        self.save!
        self.crear_recaudos()
        return true
      end
    rescue Exception => e
      return false
    end
  end
  
  #****************************************************************************
  # avanzar (14-04-2010)
  #****************************************************************************
  # Metodo que aplica el avance sobre una solicitud, según la configuracion de
  # avance establecida
  #
  # Params:
  #
  # Autor: Alex Belisario
  #
  #****************************************************************************

  def avanzar(user, session)
    logger.info "Solicitud.avanzar"
    begin
      success = true
      transaction do
        estatus_id_inicial = self.estatus_id
        fecha_evento = Time.now
        configuracion_avance = ConfiguracionAvance.find_by_estatus_origen_id(estatus_id_inicial)
        estatus_id_final = configuracion_avance.estatus_destino_id
        self.control = false
        self.estatus_id = estatus_id_final
        self.fecha_actual_estatus = fecha_evento.strftime("%Y/%m/%d")
        success &&= self.save
        raise Exception,  I18n.t('Sistema.Body.Modelos.Solicitud.Errores.error_al_guardar') unless success
        # Crea un nuevo registro en la tabla control_solicitud
        success &&= ControlSolicitud.create_new(self.id, estatus_id_final, user.id, 'Avanzar', estatus_id_inicial, '')
        raise Exception, I18n.t('Sistema.Body.Modelos.ControlSolicitud.Errores.error_al_guardar') unless success
        return success
      end
    rescue Exception => e
      return false
    end
  end

  #****************************************************************************
  # reversar (30-04-2010)
  #****************************************************************************
  # Metodo que aplica el reverso sobre una solicitud, según la configuracion de
  # reverso establecida
  #
  # Params:
  #
  # Autor: Alex Belisario
  #
  #****************************************************************************

  def reversar(user, session)
    begin
      success = true
      transaction do
        estatus_id_inicial = self.estatus_id
        fecha_evento = Time.now
        configuracion_reverso = ConfiguracionReverso.find_by_estatus_origen_id(estatus_id_inicial)
        estatus_id_final = configuracion_reverso.estatus_destino_id
        self.control = false
        self.estatus_id = estatus_id_final
        self.fecha_actual_estatus = fecha_evento.strftime("%Y/%m/%d")
        success &&= self.save
        raise Exception, I18n.t('Sistema.Body.Modelos.Solicitud.Errores.error_al_guardar') unless success
        # Crea un nuevo registro en la tabla control_solicitud
        success &&= ControlSolicitud.create_new(self.id, estatus_id_final, user.id, 'Avanzar', estatus_id_inicial, '')
        raise Exception, I18n.t('Sistema.Body.Modelos.ControlSolicitud.Errores.error_al_guardar') unless success
        return success
      end
    rescue Exception => e
      return false
    end
  end

  def get_arreglo_modalidad()
    tipo_proyecto = ModalidadFinanciamiento.find(:all)
    tipo_proyecto.collect! {|x| [x.nombre, x.id]}
    return tipo_proyecto
  end

  def get_arreglo_atributos()
    tipo_proyecto = AtributosProyecto.find(:all)
    tipo_proyecto.collect! {|x| [x.nombre, x.id]}
    return tipo_proyecto
  end

  def get_arreglo_scoring()
    tipo_proyecto = ScoringAceptacion.find(:all)
    tipo_proyecto.collect! {|x| [x.scoring, x.id]}
    return tipo_proyecto
  end

  def region_comite_id
    estado_comite.region_id unless estado_comite.nil?
  end

  def region_comite_id=(region_id)
  end

  def tramitando
    self.estatus == 'T' || self.estatus == 'I' || self.estatus == 'F' || self.estatus == 'Q'
  end

  def migracion
    if self.codigo_d3.nil?
      return false
    else
      return true
    end
  end

  def estatus_w
    estatus = Estatus.find(self.estatus_id)
    return estatus.nombre + sufijo_estatus_w
  end

  def sufijo_estatus_w
    resultado = ""
    resultado = "(Reestructuracion)" if self.causa_liberacion == "F"
    resultado = "(Ampliacion)" if self.causa_liberacion == "C"
    resultado = "(Refinanciamiento + Ampliacion)" if self.causa_liberacion == "E"
    resultado = "(Refinanciamiento)" if self.causa_liberacion == "D"
    resultado = "(Reestructuracion + Ampliacion)" if self.causa_liberacion == "G"
    resultado = "(Aprobado Condicionado)" if self.es_aprobado_condicionado_por_monto?
    resultado = " (#{self.nombre_estatus_antes_de_suspender})" if self.esta_suspendida?
    return resultado
  end

  def es_aprobado_condicionado_por_monto?
    resultado = false
    #if (self.monto_analista.to_f.to_s != self.monto_aprobado.to_f.to_s && (self.decision_comite == 'A' || self.decision_comite == 'C'))
    #  resultado = true
    #end
    #resultado = true if self.pre_aprobado
    return resultado
  end

  def monto_plan_inversion_ajustado_a_preaprobacion_instancias?
    resultado = false
    if (self.monto_aprobado.to_f.to_s == PrestamoRubro.sum('aporte_foncrei', :conditions => "prestamo_id IN (select id from prestamo where solicitud_id = #{self.id})").to_f.to_s)
      resultado = true
    end
    return resultado
  end

  def tiene_prestamo_reestructurado_con_deuda_consolidada?
    resultado = false
    resultado = true if Prestamo.find_by_solicitud_id(self.id, :conditions=>'consolidar_deuda = true')

    return resultado
  end

  def obtener_prestamo_origen_id
    total = Prestamo.find_by_solicitud_id(self.id, :conditions=>'tasa_inicial <> 0')
    return total.prestamo_origen_id
  end

  def monto_reestructurado_ampliacion
    if self.monto_ampliacion.nil?
      m_ampliacion = 0
    else
      m_ampliacion = self.monto_ampliacion
    end

    return format_fm(m_ampliacion)
  end

  def monto_reestructurado_saldo_insoluto
    total = Prestamo.find_by_solicitud_id(self.id, :conditions=>'tasa_inicial <> 0')
    if self.monto_ampliacion.nil?
      m_ampliacion = 0
    else
      m_ampliacion = self.monto_ampliacion
    end

    unless total.monto_solicitado.nil?
      return format_fm(total.monto_solicitado -  m_ampliacion)
    end
  end

  def monto_reestructurado_interes
    total = Prestamo.find_by_solicitud_id(self.id, :conditions=>'tasa_inicial = 0')
    return format_fm(total.monto_solicitado)
  end

  def monto_actuales_fm
    return format_fm(self.monto_actuales)
  end

  def monto_proyecto_fm
    return format_fm(self.monto_proyecto)
  end

  def van_fm
    return format_fm(self.van)
  end

  def tir_fm
    return format_fm(self.tir)
  end

  def calificacion_cuantitativa_fm
    return format_fm(self.calificacion_cuantitativa)
  end

  def calificacion_cualitativa_fm
    valor = format_fm(self.calificacion_cualitativa)
  end

  def calificacion_social_fm
    return format_fm(self.calificacion_social) 
  end

  def cantidad_modificaciones
    cantidad = PrestamoModificacion.count_by_sql("select count(id) from prestamo_modificacion where solicitud_id = #{self.id} and estatus = 'E'")
    if cantidad.nil?
      0
    else
      cantidad
    end
  end

  def aumento_capital_fm
    return format_fm(self.aumento_capital)
  end

  def porcentaje_cooperativa_f=(valor)
    self.porcentaje_cooperativa = format_valor(valor)
  end

  def porcentaje_cooperativa_f
    format_f(self.porcentaje_cooperativa)
    
  end

  def porcentaje_cooperativa_fm
    return format_fm(self.porcentaje_cooperativa)
  end

  def porcentaje_empresa_f=(valor)
    self.porcentaje_empresa = format_valor(valor)
  end

  def porcentaje_empresa_f
    format_f(self.porcentaje_empresa)
  end

  def porcentaje_empresa_fm
    return format_fm(self.porcentaje_empresa)
  end

  def estado_id
    ciudad.estado_id unless ciudad.nil?
  end

  def estado_id=(estado_id)
  end

  def rubros_total_aporte_propio
    monto = PrestamoRubro.sum('aporte_propio',  :conditions=>"prestamo_id in (select id from prestamo where solicitud_id= #{self.id})")
    if monto.nil?
      0
    else
      monto
    end
  end

  def rubros_total_aporte_propio_ejecutado
    monto = PrestamoRubro.sum('aporte_propio_ejecutado',  :conditions=>"prestamo_id in (select id from prestamo where solicitud_id= #{self.id})")
    if monto.nil?
      0
    else
      monto
    end
  end

  def rubros_total_aporte_propio_por_ejecutar
    monto = PrestamoRubro.sum('aporte_propio_por_ejecutar',  :conditions=>"prestamo_id in (select id from prestamo where solicitud_id= #{self.id})")
    if monto.nil?
      0
    else
      monto
    end
  end

  def rubros_total_aporte_propio_modificacion
    monto = PrestamoModificacionRubro.sum('aporte_propio',  :conditions=>"prestamo_modificacion_id in (select id from prestamo_modificacion where estatus = 'E' and prestamo_id in (select id from prestamo where solicitud_id= #{self.id}))")
    if monto.nil?
      0
    else
      monto
    end
  end

  def rubros_total_empresa_aporte_propio
    monto = PrestamoRubro.sum('aporte_propio',  :conditions=>"prestamo_id in (select id from prestamo where solicitud_id= #{self.id} and destinatario = 'E')")
    if monto.nil?
      0
    else
      monto
    end
  end

  def rubros_total_empresa_aporte_propio
    monto = PrestamoRubro.sum('aporte_propio',  :conditions=>"prestamo_id in (select id from prestamo where solicitud_id= #{self.id} and destinatario = 'E')")
    if monto.nil?
      0
    else
      monto
    end
  end

  def rubros_total_cooperativa_aporte_propio_ejecutado
    monto = PrestamoRubro.sum('aporte_propio_ejecutado',  :conditions=>"prestamo_id in (select id from prestamo where solicitud_id= #{self.id} and destinatario = 'C')")
    if monto.nil?
      0
    else
      monto
    end
  end

  def rubros_total_cooperativa_aporte_propio_por_ejecutar
    monto = PrestamoRubro.sum('aporte_propio_por_ejecutar',  :conditions=>"prestamo_id in (select id from prestamo where solicitud_id= #{self.id} and destinatario = 'C')")
    if monto.nil?
      0
    else
      monto
    end
  end

  def rubros_total_cooperativa_aporte_propio_modificacion
    monto = PrestamoModificacionRubro.sum('aporte_propio',  :conditions=>"prestamo_modificacion_id in (select id from prestamo_modificacion where estatus = 'E' and prestamo_id in (select id from prestamo where solicitud_id= #{self.id} and destinatario = 'C'))")
    if monto.nil?
      0
    else
      monto
    end
  end

  def rubros_total_empresa_aporte_propio_modificacion
    monto = PrestamoModificacionRubro.sum('aporte_propio',  :conditions=>"prestamo_modificacion_id in (select id from prestamo_modificacion where estatus = 'E' and prestamo_id in (select id from prestamo where solicitud_id= #{self.id} and destinatario = 'E'))")
    if monto.nil?
      0
    else
      monto
    end
  end

  def rubros_total_aporte_propio_fm
    return format_fm(self.rubros_total_aporte_propio)
  end

  def rubros_total_aporte_propio_ejecutado_fm
    return format_fm(self.rubros_total_aporte_propio_ejecutado)
  end

  def rubros_total_aporte_propio_por_ejecutar_fm
    return format_fm(self.rubros_total_aporte_propio_por_ejecutar)
  end

  def rubros_total_aporte_propio_modificacion_fm
    return format_fm(self.rubros_total_aporte_propio_modificacion)
  end

  def rubros_total_empresa_aporte_propio_fm
    return format_fm(self.rubros_total_empresa_aporte_propio)
  end

  def rubros_total_empresa_aporte_propio_ejecutado_fm
    format_fm(self.rubros_total_empresa_aporte_propio_ejecutado)
  end

  def rubros_total_empresa_aporte_propio_por_ejecutar_fm
    format_fm(self.rubros_total_empresa_aporte_propio_por_ejecutar)
  end

  def rubros_total_cooperativa_aporte_propio_fm
    format_fm(self.rubros_total_cooperativa_aporte_propio)
  end

  def rubros_total_cooperativa_aporte_propio_ejecutado_fm
    format_fm(self.rubros_total_cooperativa_aporte_propio_ejecutado)
  end

  def rubros_total_cooperativa_aporte_propio_por_ejecutar_fm
    format_fm(self.rubros_total_cooperativa_aporte_propio_por_ejecutar)
  end

  def rubros_total_cooperativa_aporte_propio_modificacion_fm
    format_fm(self.rubros_total_cooperativa_aporte_propio_modificacion)
  end

  def rubros_total_empresa_aporte_propio_modificacion_fm
  
    format_fm(self.rubros_total_empresa_aporte_propio_modificacion)
  end

  def rubros_total_aporte_foncrei
    monto = PrestamoRubro.sum('aporte_foncrei',  :conditions=>"prestamo_id in (select id from prestamo where solicitud_id= #{self.id})")
    if monto.nil?
      0
    else
      monto
    end
  end

  def rubros_total_aporte_foncrei_modificacion
    monto = PrestamoModificacionRubro.sum('aporte_foncrei',  :conditions=>"prestamo_modificacion_id in (select id from prestamo_modificacion where estatus = 'E' and prestamo_id in (select id from prestamo where solicitud_id= #{self.id}))")
    if monto.nil?
      0
    else
      monto
    end
  end

  def rubros_total_empresa_aporte_foncrei
    monto = PrestamoRubro.sum('aporte_foncrei',  :conditions=>"prestamo_id in (select id from prestamo where solicitud_id= #{self.id} and destinatario = 'E')")
    if monto.nil?
      0
    else
      monto
    end
  end

  def rubros_total_cooperativa_aporte_foncrei
    monto = PrestamoRubro.sum('aporte_foncrei',  :conditions=>"prestamo_id in (select id from prestamo where solicitud_id= #{self.id} and destinatario = 'C')")
    if monto.nil?
      0
    else
      monto
    end
  end

  def rubros_total_cooperativa_aporte_foncrei_modificacion
    monto = PrestamoModificacionRubro.sum('aporte_foncrei',  :conditions=>"prestamo_modificacion_id in (select id from prestamo_modificacion where estatus = 'E' and prestamo_id in (select id from prestamo where solicitud_id= #{self.id} and destinatario = 'C'))")
    if monto.nil?
      0
    else
      monto
    end
  end

  def rubros_total_empresa_aporte_foncrei_modificacion
    monto = PrestamoModificacionRubro.sum('aporte_foncrei',  :conditions=>"prestamo_modificacion_id in (select id from prestamo_modificacion where estatus = 'E' and prestamo_id in (select id from prestamo where solicitud_id= #{self.id} and destinatario = 'E'))")
    if monto.nil?
      0
    else
      monto
    end
  end

  def rubros_total_aporte_foncrei_fm
    format_fm(self.rubros_total_aporte_foncrei)
  end

  def rubros_total_aporte_foncrei_modificacion_fm
    format_fm(self.rubros_total_aporte_foncrei_modificacion)
  end

  def rubros_total_empresa_aporte_foncrei_fm
    format_fm(self.rubros_total_empresa_aporte_foncrei)
  end

  def rubros_total_cooperativa_aporte_foncrei_fm
    format_fm(self.rubros_total_cooperativa_aporte_foncrei).sub('.', ',')
  end

  def rubros_total_cooperativa_aporte_foncrei_modificacion_fm
    format_fm(self.rubros_total_cooperativa_aporte_foncrei_modificacion)
  end

  def rubros_total_empresa_aporte_foncrei_modificacion_fm
    format_fm(self.rubros_total_empresa_aporte_foncrei_modificacion)
  end

  def rubros_total_otras_fuentes
    monto = PrestamoRubro.sum('otras_fuentes',  :conditions=>"prestamo_id in (select id from prestamo where solicitud_id= #{self.id})")
    if monto.nil?
      0
    else
      monto
    end
  end

  def rubros_total_otras_fuentes_modificacion
    monto = PrestamoModificacionRubro.sum('otras_fuentes',  :conditions=>"prestamo_modificacion_id in (select id from prestamo_modificacion where estatus = 'E' and prestamo_id in (select id from prestamo where solicitud_id= #{self.id}))")
    if monto.nil?
      0
    else
      monto
    end
  end

  def rubros_total_empresa_otras_fuentes
    monto = PrestamoRubro.sum('otras_fuentes',  :conditions=>"prestamo_id in (select id from prestamo where solicitud_id= #{self.id} and destinatario = 'E')")
    if monto.nil?
      0
    else
      monto
    end
  end

  def rubros_total_cooperativa_otras_fuentes
    monto = PrestamoRubro.sum('otras_fuentes',  :conditions=>"prestamo_id in (select id from prestamo where solicitud_id= #{self.id} and destinatario = 'C')")
    if monto.nil?
      0
    else
      monto
    end
  end

  def rubros_total_cooperativa_otras_fuentes_modificacion
    monto = PrestamoModificacionRubro.sum('otras_fuentes',  :conditions=>"prestamo_modificacion_id in (select id from prestamo_modificacion where estatus = 'E' and prestamo_id in (select id from prestamo where solicitud_id= #{self.id} and destinatario = 'C'))")
    if monto.nil?
      0
    else
      monto
    end
  end

  def rubros_total_empresa_otras_fuentes_modificacion
    monto = PrestamoModificacionRubro.sum('otras_fuentes',  :conditions=>"prestamo_modificacion_id in (select id from prestamo_modificacion where estatus = 'E' and prestamo_id in (select id from prestamo where solicitud_id= #{self.id} and destinatario = 'E'))")
    if monto.nil?
      0
    else
      monto
    end
  end

  def rubros_total_otras_fuentes_fm
    format_fm(self.rubros_total_otras_fuentes)
  end

  def rubros_total_otras_fuentes_modificacion_fm
    format_fm(self.rubros_total_otras_fuentes_modificacion)
  end

  def rubros_total_empresa_otras_fuentes_fm
    format_fm(self.rubros_total_empresa_otras_fuentes)
  end

  def rubros_total_cooperativa_otras_fuentes_fm
    format_fm(self.rubros_total_cooperativa_otras_fuentes)
  end

  def rubros_total_cooperativa_otras_fuentes_modificacion_fm
    format_fm(self.rubros_total_cooperativa_otras_fuentes_modificacion)
  end

  def rubros_total_empresa_otras_fuentes_modificacion_fm
    format_fm(self.rubros_total_empresa_otras_fuentes_modificacion)
  end

  def rubros_total_empresa_valor_total
    monto = PrestamoRubro.sum('valor_total',  :conditions=>"prestamo_id in (select id from prestamo where solicitud_id= #{self.id} and destinatario = 'E')")
    if monto.nil?
      0
    else
      monto
    end
  end

  def rubros_total_cooperativa_valor_total
    monto = PrestamoRubro.sum('valor_total',  :conditions=>"prestamo_id in (select id from prestamo where solicitud_id= #{self.id} and destinatario = 'C')")
    if monto.nil?
      0
    else
      monto
    end
  end

  def rubros_total_cooperativa_valor_total_modificacion
    monto = PrestamoModificacionRubro.sum('valor_total',  :conditions=>"prestamo_modificacion_id in (select id from prestamo_modificacion where estatus = 'E' and prestamo_id in (select id from prestamo where solicitud_id= #{self.id} and destinatario = 'C'))")
    if monto.nil?
      0
    else
      monto
    end
  end

  def rubros_total_empresa_valor_total_modificacion
    monto = PrestamoModificacionRubro.sum('valor_total',  :conditions=>"prestamo_modificacion_id in (select id from prestamo_modificacion where estatus = 'E' and prestamo_id in (select id from prestamo where solicitud_id= #{self.id} and destinatario = 'E'))")
    if monto.nil?
      0
    else
      monto
    end
  end

  def rubros_total_valor_total
    monto = PrestamoRubro.sum('valor_total',  :conditions=>"prestamo_id in (select id from prestamo where solicitud_id= #{self.id})")
    if monto.nil?
      0
    else
      monto
    end
  end

  def rubros_total_valor_total_modificacion
    monto = PrestamoModificacionRubro.sum('valor_total',  :conditions=>"prestamo_modificacion_id in (select id from prestamo_modificacion where estatus = 'E' and prestamo_id in (select id from prestamo where solicitud_id= #{self.id}))")
    if monto.nil?
      0
    else
      monto
    end
  end

  def rubros_total_valor_total_fm
    format_fm(self.rubros_total_valor_total)
  end

  def rubros_total_valor_total_modificacion_fm
    format_fm(self.rubros_total_valor_total_modificacion)
  end

  def rubros_total_empresa_valor_total_fm
    format_fm(self.rubros_total_empresa_valor_total)
  end

  def rubros_total_cooperativa_valor_total_fm
    format_fm(self.rubros_total_cooperativa_valor_total)
  end

  def rubros_total_cooperativa_valor_total_modificacion_fm
    format_fm(self.rubros_total_cooperativa_valor_total_modificacion)
  end

  def rubros_total_empresa_valor_total_modificacion_fm  
    format_fm(self.rubros_total_empresa_valor_total_modificacion)
  end

  def add_prestamo(prestamo)
    if Prestamo.find_by_producto_id_and_solicitud_id(prestamo.producto.id, id);
      errors.add(:solicitud, I18n.t('Sistema.Body.Modelos.Solicitud.Errores.partida_ya_existe'))
      return false
    else
      prestamos << prestamo
    end
  end

  after_initialize :after_initialize
  
  def after_initialize
    if new_record?
      self.fecha_registro = Time.now unless self.fecha_registro
      self.fecha_solicitud = Time.now unless self.fecha_solicitud
      self.fecha_actual_estatus = Time.now unless self.fecha_actual_estatus
      self.monto_solicitado = 0 unless self.monto_solicitado
      self.monto_cliente = 0 unless self.monto_cliente
      self.monto_aprobado = 0 unless self.monto_aprobado
    #    self.estatus = 'T' unless self.estatus
      self.estatus_id = 10001 if self.estatus_id.nil?
      self.modalidad_financiamiento_id = 0 unless self.modalidad_financiamiento_id
    end
  end

  def monto_exigido_garantias
    self.monto_solicitado * self.programa.relacion_garantia
  end

  def monto_exigido_garantias_fm
    format_fm(self.monto_exigido_garantias)
  end

  def garantia_insuficiente
    self.monto_exigido_garantias > self.total_garantias
  end

  def tiene_condiciones_financiamiento?
    resultado = false
    registro = Prestamo.find_by_solicitud_id self.id, :conditions => "formula_id is null and plazo = 0"
    resultado = true if registro.nil?
    return resultado
  end

  def garantias_no_constituidas
    cantidad = 0
    cantidad = Garantia.count_by_sql("select count(*) from garantia where estatus = 'P' and solicitud_id = "+ self.id.to_s);
    return cantidad
  end

  def total_garantias
    total = Garantia.sum('monto_garantia', :conditions=>"solicitud_id=#{self.id}")
    total = total ? total : 0
  end

  def total_garantias_fm
    format_fm(self.total_garantias)
  end

  def porcentaje_garantias_cubiertas
    if total_garantias > 0 && monto_exigido_garantias > 0
      self.total_garantias/monto_exigido_garantias*100
    else
      0
    end
  end

  def porcentaje_garantias_cubiertas_fm
    format_fm(self.porcentaje_garantias_cubiertas)
  end

  def total_prestamos
    monto = Prestamo.sum('monto_solicitado', :conditions=>"solicitud_id=#{self.id}")
    if monto.nil?
      0
    else
      monto
    end
  end

  def diferencia_prestamos
    return self.monto_solicitado - total_prestamos
  end

  def diferencia_prestamos_fm
  
    format_fm(self.diferencia_prestamos)
  end

  def total_desembolsos
    monto = Desembolso.sum('monto', :conditions=>"prestamo_id in (SELECT id FROM prestamo WHERE solicitud_id = #{self.id})")
    if monto.nil?
      0
    else
      monto
    end
  end

  def instancia_de_aprobacion?
  
    estatus_id_final = 0
    origen_fondo = OrigenFondo.find(self.origen_fondo_id)

    if origen_fondo.banco_origen == 1
      estatus_id_final = InstanciaTipo.find(2).estatus_id
    end

    if origen_fondo.banco_origen == 2
      estatus_id_final = InstanciaTipo.find(1).estatus_id
    end

    estatus = Estatus.find(estatus_id_final) if estatus_id_final != 0

    if validar_analisis == 0
      return 0
    else
      return  estatus.id
    end

  end

  def validar_analisis()
    variable = 1

    if !ficha_resumen_llena?
      errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.ficha_resumen')}#{self.numero} #{I18n.t('Sistema.Body.Modelos.Errores.no_esta_completada')}")
      variable = 0
    end
    if  CondicionamientosNarrativaLibreSolicitud.find_by_solicitud_id(self.id).nil?
      errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.condicionamiento')}#{self.numero.to_s} #{I18n.t('Sistema.Body.Modelos.Errores.no_esta_completado')}")
      variable = 0
    end
    if PuntoCuenta.find_by_solicitud_id(self.id).nil?
      errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.punto_cuenta')}#{self.numero.to_s} #{I18n.t('Sistema.Body.Modelos.Errores.no_esta_completado')}")
      variable = 0
    end

    if !tiene_condiciones_financiamiento?
      errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.condiciones_financiamiento')}#{self.numero.to_s}#{I18n.t('Sistema.Body.Modelos.Errores.no_esta_completado')}")
      variable = 0
    end
    return variable
  end

  def validar(ruta)

    tipo_cliente = TipoCliente.find(:first, :conditions=>['id = (select tipo_cliente_id from cliente where id = ?)',self.cliente_id])
    if tipo_cliente.clasificacion == 'N'
      if self.cliente.persona.direcciones[0].nil?
        errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.beneficiario_natural')}#{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.debe_contener_una_ubicacion')} <a href='#{ruta}/clientes/cliente_persona_direccion?persona_id=#{self.cliente.persona.id}'>#{I18n.t('Sistema.Body.Modelos.Errores.ir_directamente')}</a>")
      end
      if self.cliente.persona.telefonos[0].nil?
        errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.beneficiario_natural')}#{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.debe_contener_un_numero_telefono')}<a href='#{ruta}/clientes/cliente_persona_telefono?persona_id=#{self.cliente.persona.id}'>#{I18n.t('Sistema.Body.Modelos.Errores.ir_directamente')}</a>")
      end
      if self.cliente.type.to_s == "ClientePersona"
        if self.sub_sector.nemonico == "VE"
          total = RegistroMercantil.count(:conditions=>"persona_id = #{self.cliente.persona_id} and tipo = 'T'")
          unless total > 0
            errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.beneficiario_natural')}#{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.debe_contener_un_registro_de_tierras')}<a href='#{ruta}/clientes/cliente_persona_registro?persona_id=#{self.cliente.persona.id}'>#{I18n.t('Sistema.Body.Modelos.Errores.ir_directamente')}</a>")
          end
        elsif self.sub_sector.nemonico == "AN"
          total = RegistroMercantil.count(:conditions=>"persona_id = #{self.cliente.persona_id} and tipo = 'T'")
          unless total > 0
            errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.beneficiario_natural')}#{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.debe_contener_un_registro_de_tierras')}<a href='#{ruta}/clientes/cliente_persona_registro?persona_id=#{self.cliente.persona.id}'>#{I18n.t('Sistema.Body.Modelos.Errores.ir_directamente')}</a>")
          end
          total = RegistroMercantil.count(:conditions=>"persona_id = #{self.cliente.persona_id} and tipo = 'H'")
          unless total > 0
            errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.beneficiario_natural')}#{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.debe_contener_un_registro_de_hierro')}<a href='#{ruta}/clientes/cliente_persona_registro?persona_id=#{self.cliente.persona.id}'>#{I18n.t('Sistema.Body.Modelos.Errores.ir_directamente')}</a>")
          end
        elsif self.sub_sector.nemonico == "AC"
          total = RegistroMercantil.count(:conditions=>"persona_id = #{self.cliente.persona_id} and tipo = 'T'")
          unless total > 0
            errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.beneficiario_natural')}#{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.beneficiario_natural_debe_contener_un_registro_de_tierras')}  <a href='#{ruta}/clientes/cliente_persona_registro?persona_id=#{self.cliente.persona.id.to_s}'>#{I18n.t('Sistema.Body.Modelos.Errores.ir_directamente')}</a>")
          end
        elsif self.sub_sector.nemonico == "PE"
          unless self.modalidad_financiamiento_id == 2
            total = RegistroMercantil.count(:conditions=>"persona_id = #{self.cliente.persona_id} and tipo = 'N'")
            unless total > 0
              errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.beneficiario_natural')}#{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.debe_contener_un_registro_naval')} <a href='#{ruta}/clientes/cliente_persona_registro?persona_id=#{self.cliente.persona.id}'>#{I18n.t('Sistema.Body.Modelos.Errores.ir_directamente')}</a>")
            end
          end
        end

      end
      #      if self.cliente.persona.PersonaEmail[0].nil?
      #        self.errors.add(nil, "#{I18n.t('Sistema.Body.Modelos.Errores.beneficiario_natural')}#{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.debe_contener_un_email')}<a href='#{ruta}/clientes/cliente_persona_email?persona_id=#{self.cliente.persona.id}'>I18n.t('Sistema.Body.Modelos.Errores.ir_directamente)</a>")
      #      end
    else
      if self.cliente.empresa.empresa_direccion[0].nil?
        self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.beneficiario_juridico')} #{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.debe_contener_una_ubicacion')} <a href='#{ruta}/clientes/cliente_empresa_direccion?empresa_id=#{self.cliente.empresa.id}'>#{I18n.t('Sistema.Body.Modelos.Errores.ir_directamente')}</a>")
      end
      if self.cliente.empresa.telefonos[0].nil?
        self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.beneficiario_juridico')} #{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.debe_contener_un_numero_telefono')} <a href='#{ruta}/clientes/cliente_empresa_telefono?empresa_id=#{self.cliente.empresa.id}'>#{I18n.t('Sistema.Body.Modelos.Errores.ir_directamente')}</a>")
      end
      #      if self.cliente.empresa.emails[0].nil?
      #        self.errors.add(nil, "#{I18n.t('Sistema.Body.Modelos.Errores.beneficiario_juridico')}#{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.debe_contener_un_email')} <a href='#{ruta}/clientes/cliente_empresa_email?empresa_id=#{self.cliente.empresa.id}'>#{I18n.t('Sistema.Body.Modelos.Errores.ir_directamente)</a>")
      #      end
      empresa_integrante = EmpresaIntegrante.find_by_sql("select e.id from empresa_integrante e join empresa_integrante_tipo t on e.id = t.empresa_integrante_id and t.tipo = 'R' where e.empresa_id = #{self.cliente.empresa.id}")
      if empresa_integrante[0].nil?
        self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.beneficiario_juridico')}#{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.debe_contener_representante_legal')} <a href='#{ruta}/clientes/cliente_empresa_integrante_persona?empresa_id=#{self.cliente.empresa.id}'>#{I18n.t('Sistema.Body.Modelos.Errores.ir_directamente')}</a>")
      else
        empresa_integrante = EmpresaIntegrante.find(:first, :conditions=>["id in (select empresa_integrante_id from empresa_integrante_tipo where tipo = 'R') and empresa_id = ?",self.cliente.empresa.id])
        if empresa_integrante.persona.direcciones[0].nil?
          self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.beneficiario_integrante_representante')}#{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.debe_contener_una_ubicacion')} <a href='#{ruta}/clientes/cliente_empresa_integrante_persona_direccion?empresa_integrante_tipo_id=#{empresa_integrante.tipos[0].id}&empresa_id=#{self.cliente.empresa.id}'>#{I18n.t('Sistema.Body.Modelos.Errores.ir_directamente')}</a>")
        end
        #        if empresa_integrante.persona.telefonos[0].nil?
        #          self.errors.add(nil, "#{I18n.t('Sistema.Body.Modelos.Errores.beneficiario_integrante_representante')}#{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.debe_contener_un_numero_telefono')} <a href='#{ruta}/clientes/cliente_empresa_integrante_persona_telefono?empresa_integrante_tipo_id=#{empresa_integrante.tipos[0].id}&empresa_id=#{self.cliente.empresa.id}'>#{I18n.t('Sistema.Body.Modelos.Errores.ir_directamente')}</a>")
        #        end
        #        if empresa_integrante.persona.PersonaEmail[0].nil?
        #          self.errors.add(nil, "#{I18n.t('Sistema.Body.Modelos.Errores.beneficiario_integrante_representante')}#{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.debe_contener_un_email')} <a href='#{ruta}/clientes/cliente_empresa_integrante_persona_email?empresa_integrante_tipo_id=#{empresa_integrante.tipos[0].id}&empresa_id=#{self.cliente.empresa.id}'>#{I18n.t('Sistema.Body.Modelos.Errores.ir_directamente')}</a>")
        #        end
      end
      empresa_contacto = EmpresaIntegrante.find_by_sql("select id from empresa_integrante where contacto = true and empresa_id = #{self.cliente.empresa.id}")
      if empresa_contacto[0].nil?
        self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.beneficiario_juridico')}#{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.debe_contener_persona_contacto')} <a href='#{ruta}/clientes/cliente_empresa_integrante_persona?empresa_id=#{self.cliente.empresa.id}'>#{I18n.t('Sistema.Body.Modelos.Errores.ir_directamente')}</a>")
      end
      empresa_total = EmpresaIntegrante.count(:conditions=>"empresa_id = #{self.cliente.empresa.id}")
      unless empresa_total > 4
        self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.beneficiario_juridico')}#{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.debe_contener_integrantes')} <a href='#{ruta}/clientes/cliente_empresa_integrante_persona?empresa_id=#{self.cliente.empresa.id}'>#{I18n.t('Sistema.Body.Modelos.Errores.ir_directamente')}</a>")
      end

      #empresa_junta = EmpresaIntegrante.find_by_sql("select e.id from empresa_integrante e join empresa_integrante_tipo t on e.id = t.empresa_integrante_id and t.tipo = 'J' where e.empresa_id = #{self.cliente.empresa.id}")
      #if empresa_junta[0].nil?
      #self.errors.add(nil, "#{I18n.t('Sistema.Body.Modelos.Errores.beneficiario_juridico')}#{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.debe_contener_integrante_junta_directiva')}<a href='#{ruta}/clientes/cliente_empresa_integrante_persona?empresa_id=#{self.cliente.empresa.id}'>#{I18n.t('Sistema.Body.Modelos.Errores.ir_directamente')}</a>")
      #end

      registro = RegistroMercantil.find_by_sql("select r.id from registro_mercantil r join empresa e on e.id = r.empresa_id and e.id = #{self.cliente.empresa.id} where r.tipo = 'M'")
      if registro[0].nil?
        self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.beneficiario_juridico')}#{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.debe_contener_registro_mercanil')} <a href='#{ruta}/clientes/cliente_empresa_registro?empresa_id=#{self.cliente.empresa.id}'>#{I18n.t('Sistema.Body.Modelos.Errores.ir_directamente')}</a>")
      end
      if self.cliente.unidad_produccion[0].nil?
        self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.beneficiario_juridico')}#{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.debe_contener_unidad_produccion')}. <a href='#{ruta}/clientes/cliente_empresa_unidad_produccion?empresa_id=#{self.cliente.empresa.id}'>#{I18n.t('Sistema.Body.Modelos.Errores.ir_directamente')}</a>")
      end
      if self.cliente.type.to_s == "ClienteEmpresa"
        if self.sub_sector.nemonico == "VE"
          total = RegistroMercantil.count(:conditions=>"empresa_id = #{self.cliente.empresa_id} and tipo = 'T'")
          unless total > 0
            self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.beneficiario_juridico')}#{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.beneficiario_natural_debe_contener_un_registro_de_tierras')} <a href='#{ruta}/clientes/cliente_empresa_registro?empresa_id=#{self.cliente.empresa.id}'>#{I18n.t('Sistema.Body.Modelos.Errores.ir_directamente')}</a>")
          end
        elsif self.sub_sector.nemonico == "AN"
          total = RegistroMercantil.count(:conditions=>"empresa_id = #{self.cliente.empresa_id} and tipo = 'T'")
          unless total > 0
            self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.beneficiario_juridico')}#{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.beneficiario_natural_debe_contener_un_registro_de_tierras')}  <a href='#{ruta}/clientes/cliente_empresa_registro?empresa_id=#{self.cliente.empresa.id}'>#{I18n.t('Sistema.Body.Modelos.Errores.ir_directamente')}</a>")
          end
          total = RegistroMercantil.count(:conditions=>"empresa_id = #{self.cliente.empresa_id} and tipo = 'H'")
          unless total > 0
            self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.beneficiario_juridico')}#{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.debe_contener_un_registro_de_hierro')} <a href='#{ruta}/clientes/cliente_empresa_registro?empresa_id=#{self.cliente.empresa.id}'>#{I18n.t('Sistema.Body.Modelos.Errores.ir_directamente')}</a>")
          end
        elsif self.sub_sector.nemonico == "AC"
          total = RegistroMercantil.count(:conditions=>"empresa_id = #{self.cliente.empresa_id} and tipo = 'T'")
          unless total > 0
            self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.beneficiario_juridico')}#{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.beneficiario_natural_debe_contener_un_registro_de_tierras')}  <a href='#{ruta}/clientes/cliente_empresa_registro?empresa_id=#{self.cliente.empresa.id}'>#{I18n.t('Sistema.Body.Modelos.Errores.ir_directamente')}</a>")
          end
        elsif self.sub_sector.nemonico == "PE"
          unless self.modalidad_financiamiento_id == 2
            total = RegistroMercantil.count(:conditions=>"empresa_id = #{self.cliente.empresa_id} and tipo = 'N'")
            unless total > 0
              self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.beneficiario_juridico')}#{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.beneficiario_natural_debe_contener_un_registro_naval')}<a href='#{ruta}/clientes/cliente_empresa_registro?empresa_id=#{self.cliente.empresa.id}'>#{I18n.t('Sistema.Body.Modelos.Errores.ir_directamente')}</a>")
            end
          end
        end
      end
    end
    if self.cliente.unidad_produccion[0].nil?
      self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.beneficiario_natural')}#{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.debe_contener_unidad_produccion')}<a href='#{ruta}/clientes/cliente_persona_unidad_produccion?persona_id=#{self.cliente.persona.id}'>=#{self.cliente.empresa.id}'>#{I18n.t('Sistema.Body.Modelos.Errores.ir_directamente')}</a>")
    end

    if self.objetivo_proyecto.nil? || self.objetivo_proyecto.empty?
      self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.tramite')}#{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.objetivo_proyecto_es_requerido')} <a href='#{ruta}/solicitudes/solicitud/edit/#{self.id}?controlador=solicitud'>=#{self.cliente.empresa.id}'>#{I18n.t('Sistema.Body.Modelos.Errores.ir_directamente')}</a>")
    end

    if self.unidad_produccion_id.nil?
      self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.tramite')}#{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.unidad_produccion_requerida')} <a href='#{ruta}/solicitudes/solicitud/edit/#{self.id}?controlador=solicitud'>=#{self.cliente.empresa.id}'>#{I18n.t('Sistema.Body.Modelos.Errores.ir_directamente')}</a>")
    end

    cantidad_recaudos = Recaudo.count(:conditions=>["obligatorio = true and id in (select recaudo_id from solicitud_recaudo where solicitud_id = #{self.id})"])
    cantidad_entregado = SolicitudRecaudo.count(:conditions=>["(entregado = true or tramite = true or no_aplica = true) and solicitud_id = #{self.id} and recaudo_id in (select id from recaudo where obligatorio = true and activo = true)"])
    cantidad_verificado = SolicitudRecaudo.count(:conditions=>["(revisado_consultoria = true) and solicitud_id = #{self.id} and recaudo_id in (select id from recaudo where obligatorio = true and activo = true)"])
    recaudos_solicitud = SolicitudRecaudo.count(:conditions=>["solicitud_id = #{self.id}"])
    unless recaudos_solicitud > 0
      self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.tramite')}#{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.debe_existir_recaudo')} <a href='#{ruta}/solicitudes/solicitud_recaudo?solicitud_id=#{self.id}'>#{I18n.t('Sistema.Body.Modelos.Errores.ir_directamente')}</a>")
    else
      unless cantidad_entregado >= cantidad_recaudos
        self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.tramite')}#{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.recaudos_no_completos')} <a href='#{ruta}/solicitudes/solicitud_recaudo?solicitud_id=#{self.id}'>#{I18n.t('Sistema.Body.Modelos.Errores.ir_directamente')}</a>")
      end
    end

    unless cantidad_verificado >= cantidad_entregado
      self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.tramite')}#{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.recaudos_no_verificados')} <a href='#{ruta}/solicitudes/solicitud_recaudo?solicitud_id=#{self.id}'>#{I18n.t('Sistema.Body.Modelos.Errores.ir_directamente')}</a>")
    end

    if errors.size > 0
      return false
    else
      return true
    end
  end

  #avanzar la solicitud a la bandeja del coordinador
  def avanzar_unidad_apoyo_consultoria(usuario,unidad)
    unless self.Estatus.const_id == 'ST0004'
      self.errors.add(:solicitud, I18n.t('Sistema.Body.Modelos.Solicitud.Errores.estatus_no_adecuado'))
    else
      if unidad == 1
        validacion = SolicitudRecaudo.validar_consultoria(self.id)
        unless validacion
          self.errors.add(:solicitud, I18n.t('Sistema.Body.Modelos.Solicitud.Errores.analisis_debe_ser_copletado'))
          return
        end
        self.consultoria = true
        mensaje = I18n.t('Sistema.Body.Modelos.Solicitud.Errores.analisis_legal_solicitud')
      elsif unidad == 2
        validacion = SolicitudAvaluo.validar_avaluo(self.id)
        unless validacion == true
          self.errors.add(:solicitud, validacion)
          return
        end
        self.avaluo = true
        mensaje = I18n.t('Sistema.Body.Modelos.Solicitud.Errores.revision_inspeccion_avaluos')
      elsif unidad == 3
        validacion = SolicitudResguardo.validar_resguardo(self.id)
        unless validacion == true
          self.errors.add(:solicitud, validacion)
          return
        end
        self.resguardo = true
        mensaje = I18n.t('Sistema.Body.Modelos.Solicitud.Errores.revision_resguardo_institucional')
      end
      self.save
      ControlSolicitud.create_new(self.id, self.estatus_id, usuario, I18n.t('Sistema.Body.General.avanzar'), self.estatus_id, mensaje)
      if self.resguardo == true && self.avaluo == true && self.consultoria == true
        estatus_origen_id = self.estatus_id
        configuracion_avance = ConfiguracionAvance.find_by_estatus_origen_id(self.estatus_id)
        self.estatus_id = configuracion_avance.estatus_destino_id
        self.fecha_actual_estatus = Time.now.strftime("%Y/%m/%d")
        self.save
        ControlSolicitud.create_new(self.id, self.estatus_id, usuario, I18n.('Sistema.Body.General.avanzar'), estatus_origen_id, '')
      end
    end
  end

  #avanzar la solicitud para unidades de apoyo
  def avanzar_pre_evaluacion(usuario)
    total = SolicitudAspectosEvaluar.count(:conditions=>['solicitud_id = ?',self.id])
    unless total > 0
      self.errors.add(:solicitud, I18n.t('Sistema.Body.Modelos.Solicitud.Errores.debe_asignar_aspecto_evaluar'))
      unless self.Estatus.const_id == 'ST0003'
        self.errors.add(:solicitud, I18n.t('Sistema.Body.Modelos.Solicitud.Errores.estatus_no_adecuado'))
      end
    else
      unless self.Estatus.const_id == 'ST0003'
        self.errors.add(:solicitud, I18n.t('Sistema.Body.Modelos.Solicitud.Errores.estatus_no_adecuado'))
      else
        estatus_id_inicial = self.estatus_id
        fecha_evento = Time.now
        configuracion_avance = ConfiguracionAvance.find_by_estatus_origen_id(estatus_id_inicial)
        estatus_id_final = configuracion_avance.estatus_destino_id
        self.estatus_id = estatus_id_final
        self.fecha_actual_estatus = fecha_evento.strftime("%Y/%m/%d")
        self.save
        ControlSolicitud.create_new(self.id, estatus_id_final, usuario, I18n.('Sistema.Body.General.avanzar'), estatus_id_inicial, '')
      end
    end
  end

  #avanzar la solicitud para unidades de apoyo
  def avanzar_evaluacion(usuario)
    unless self.Estatus.const_id == 'ST0028'
      self.errors.add(:solicitud, I18n.t('Sistema.Body.Modelos.Solicitud.Errores.estatus_no_adecuado'))
    else
      estatus_id_inicial = self.estatus_id
      fecha_evento = Time.now
      configuracion_avance = ConfiguracionAvance.find_by_estatus_origen_id(estatus_id_inicial)
      estatus_id_final = configuracion_avance.estatus_destino_id
      self.estatus_id = estatus_id_final
      self.fecha_actual_estatus = fecha_evento.strftime("%Y/%m/%d")
      self.save
      ControlSolicitud.create_new(self.id, estatus_id_final, usuario, I18n.('Sistema.Body.General.avanzar'), estatus_id_inicial, '')
    end
  end

  #Eliminar analista de pre-evaluacion de la solicitud
  def self.eliminar_analista_asignado(id)
    solicitud = Solicitud.find(id)
    solicitud.update_attribute(:usuario_pre_evaluacion, nil)
  end

  #Asignar/Re-asignar analista de la solicitud
  def update_asignar(control_asignacion)
    if control_asignacion[:usuario_id].nil? || control_asignacion[:usuario_id].empty?
      self.errors.add(:solicitud, I18n.t('Sistema.Body.Modelos.Errores.analista_asignar_es_requerido'))
      unless self.estatus_id == 10002
        if control_asignacion[:observacion].nil? || control_asignacion[:observacion].empty?
          self.errors.add(:solicitud, I18n.t('Sistema.Body.Modelos.Errores.observacion_es_requerido'))
        end
      end
      return false
    end
    unless self.estatus_id == 10002
      if control_asignacion[:observacion].nil? || control_asignacion[:observacion].empty?
        self.errors.add(:solicitud, I18n.t('Sistema.Body.Modelos.Errores.observacion_es_requerido'))
        return false
      end
    end

    if self.estatus_id == 10002
      asignar = true
    else
      asignar = false
    end

    control = ControlAsignacion.new(control_asignacion)
    control.solicitud_id = self.id
    control.fecha = Time.now
    control.asignacion = asignar
    control.unidad = 'C'
    control.save
    usuario = Usuario.find(control.usuario_id)
    self.usuario_pre_evaluacion = usuario.nombre_usuario
    self.save
    return true

  end

  def validada

    monto_total = total_prestamos
    if monto_total != self.monto_solicitado and self.codigo_d3 == nil
      self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.tramite')} #{I18n.('Sistema.Body.Modelos.Solicitud.Errores.monto_aprobado_no_coincide')}")
    end

    for prestamo in prestamos
      if prestamo.total_rubros != prestamo.monto_solicitado
        self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.tramite')} #{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.plan_inversion_no_coincide_partida')}#{prestamo.producto.partida.nombre}")
      end
      if prestamo.formula.nil?
        self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.tramite')} #{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.metodo_amortizacion_no_registrado')} #{prestamo.producto.partida.nombre}")
      end
      if prestamo.plazo.nil? || prestamo.plazo <= 0
        self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.tramite')} #{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.plazo_no_registrado')} #{prestamo.producto.partida.nombre}")
      end
    end

    if self.monto_cliente.nil? || self.monto_cliente == 0
      self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.tramite')} #{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.monto_solicitado_requerido')}")
    end

    if self.monto_solicitado.nil? || self.monto_solicitado == 0
      self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.tramite')} #{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.monto_aprobado_requerido')}")
    end

    if self.objetivo_proyecto.nil? || self.objetivo_proyecto.empty?
      self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.tramite')} #{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.destino_microcredito_requerido')}")
    end

    solicitud_recaudo = SolicitudRecaudo.find_by_sql("select * from solicitud_recaudo where solicitud_id = #{self.id} and entregado = true ")
    if !solicitud_recaudo
      self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.tramite')} #{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.registrar_recaudo_entregado')}")
    else
      solicitud_recaudo_entregados = SolicitudRecaudo.find_by_sql("select * from solicitud_recaudo where solicitud_id = #{self.id} and entregado = false and recaudo_id  in (select id from recaudo where obligatorio = true)")

      unless  solicitud_recaudo_entregados[0].nil?
        self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.tramite')} #{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.registrar_recaudos_obligatorios')}")
      end
    end

    if self.cliente.class.to_s == 'ClienteEmpresa'

      if self.CronogramaDesembolso.count()== 0
        self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.tramite')} #{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.debe_registrar_desembolso_en_cronograma')}")
      elsif self.CronogramaDesembolso.count()> 0
        monto_solicitud = self.monto_solicitado
        monto_cronograma = CronogramaDesembolso.sum(:monto, :conditions=>"solicitud_id=#{self.id}")
        if monto_cronograma != monto_solicitud
          self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.tramite')} #{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.sumatoria_cronograma_no_coincide')}")
        end
      end

      if self.cliente.empresa.numero_sunacop.nil? || self.cliente.empresa.numero_sunacop.empty?
        self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.tipo_cliente')} #{I18n.t('Sistema.Body.Modelos.Errores.tramite')} #{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.numero_sunacop_requerido')}")
      end

      if self.cliente.empresa.cant_socios_femeninos.nil?
        self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.tipo_cliente')} #{I18n.t('Sistema.Body.Modelos.Errores.tramite')} #{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.cantidad_socios_femeninos_requerido')}")
      end

      if self.cliente.empresa.cant_socios_masculinos.nil?
        self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.tipo_cliente')} #{I18n.t('Sistema.Body.Modelos.Errores.tramite')} #{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.cantidad_socios_masculinos_requerido')}")
      end

      if self.cliente.empresa.nombre_registro_mercantil.nil? || self.cliente.empresa.nombre_registro_mercantil.empty?
        self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.tipo_cliente')} #{I18n.t('Sistema.Body.Modelos.Errores.tramite')} #{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.nombre_registro_requerido')}")
      end

      if self.cliente.empresa.fecha_registro_mercantil.nil?
        self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.tipo_cliente')} #{I18n.t('Sistema.Body.Modelos.Errores.tramite')} #{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.fecha_registro_requerida')}")
      end

      if self.cliente.empresa.nro_registro_mercantil.nil? || self.cliente.empresa.nro_registro_mercantil.empty?
        self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.tipo_cliente')} #{I18n.t('Sistema.Body.Modelos.Errores.tramite')} #{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.numero_registro_requerido')}")
      end

      if self.cliente.empresa.nro_folio_inicial.nil? || self.cliente.empresa.nro_folio_inicial.empty?
        self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.tipo_cliente')} #{I18n.t('Sistema.Body.Modelos.Errores.tramite')} #{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.numero_folio_inicial_requerido')}")
      end

      if self.cliente.empresa.nro_folio_final.nil? || self.cliente.empresa.nro_folio_final.empty?
        self.errors.add(:solicitud, "{I18n.t('Sistema.Body.Modelos.Errores.tipo_cliente')} #{I18n.t('Sistema.Body.Modelos.Errores.tramite')} #{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.numero_folio_final_requerido')}")
      end

      if self.cliente.empresa.nro_tomo.nil? || self.cliente.empresa.nro_tomo.empty?
        self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.tipo_cliente')} #{I18n.t('Sistema.Body.Modelos.Errores.tramite')} #{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.numero_tomo_requerido')}")
      end

      if self.cliente.empresa.nro_protocolo.nil? || self.cliente.empresa.nro_protocolo.empty?
        self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.tipo_cliente')} #{I18n.t('Sistema.Body.Modelos.Errores.tramite')} #{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.numero_protocolo_requerido')}")
      end

      if self.cliente.empresa.nro_trimestre.nil? || self.cliente.empresa.nro_trimestre.empty?
        self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.tipo_cliente')}  #{I18n.t('Sistema.Body.Modelos.Errores.tramite')} #{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.numero_trimestre_requerido')}")
      end

      if self.cliente.empresa.anio_registro_mercantil.nil? || self.cliente.empresa.anio_registro_mercantil.empty?
        self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.tipo_cliente')} #{I18n.t('Sistema.Body.Modelos.Errores.tramite')} #{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.ano_registro_requerido')}")
      end

      if self.cliente.empresa.uso_calculadora == false &&
          self.cliente.empresa.uso_maquina_escribir == false &&
          self.cliente.empresa.uso_computadora == false &&
          self.cliente.empresa.uso_equipos_especiales == false &&
          self.cliente.empresa.uso_ninguno == false &&
          self.cliente.empresa.uso_ninguno == false &&
          self.cliente.empresa.uso_otro == false

        self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.tipo_cliente')} #{I18n.t('Sistema.Body.Modelos.Errores.tramite')} #{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.seleccionar_valor_incorporacion_tecnologica')}")
      end

      if self.cliente.empresa.direcciones.count()== 0
        self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.tipo_cliente')} #{I18n.t('Sistema.Body.Modelos.Errores.tramite')} #{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.debe_registrar_direccion')}")
      end

      if self.cliente.empresa.telefonos.count()== 0
        self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.tipo_cliente')} #{I18n.t('Sistema.Body.Modelos.Errores.tramite')} #{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.debe_registrar_numero_telefono')}")
      end

      integrante = EmpresaIntegrantePersona.find_by_sql("select * from empresa_integrante where empresa_id = #{self.cliente.empresa.id}  and id in (select empresa_integrante_id from empresa_integrante_tipo where tipo = 'R') limit 1").first
      if !integrante
        self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.tipo_cliente')} #{I18n.t('Sistema.Body.Modelos.Errores.tramite')} #{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.debe_registrar_representante_legal')}")
      else
        if integrante.persona.direcciones.count()==0
          self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.tipo_cliente')} #{I18n.t('Sistema.Body.Modelos.Errores.tramite')} #{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.representante_legal_debe_tener_direccion')}")
        end
        if integrante.persona.telefonos.count()==0
          self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.tipo_cliente')} #{I18n.t('Sistema.Body.Modelos.Errores.tramite')} #{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.representante_legal_debe_tener_telefono')}")
        end
      end

    else        # if self.cliente.class.to_s == 'ClienteEmpresa'

      if self.cliente.persona.GrupoFamiliar.count()== 0
        self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.tipo_cliente')} #{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.debe_registrar_grupo_familiar')}")
      end
      if self.cliente.persona.direcciones.count()== 0
        self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.tipo_cliente')} #{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.debe_registrar_direccion')}")
      end
      if self.cliente.persona.telefonos.count()== 0
        self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.tipo_cliente')} #{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.debe_registrar_numero_telefono')}")
      end
      if self.cliente.persona.PersonaEmail.count()== 0
        self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.tipo_cliente')} #{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.debe_registrar_email')}")
      end
      if self.cliente.persona.PuntoContacto.count()== 0
        self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.tipo_cliente')} #{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.debe_registrar_punto_contacto')}")
      end

    end     # fin if self.cliente.class.to_s == 'ClienteEmpresa'


    if errors.size > 0
      return false
    else
      return true
    end
  end

  def enviar_directorio(gerente)

    validada(gerente)

    self.numero_acta_directorio = nil
    self.numero_resolucion_directorio = nil
    self.fecha_acta_directorio = nil

    if errors.size > 0
      return false
    end

    if self.liberada == false
      self.estatus = 'I'
    else
      self.estatus_modificacion = 'I'
      #Diego Bertaso
      self.estatus = 'I'
    end

    self.save

  end

  def solicitar_pago
    self.estatus = 'P'
    self.fecha_solicitud_desembolso = Time.now
    self.save
  end

  def documentar
    if self.estatus == 'A' || self.estatus == 'C'
      self.estatus = 'D'
    elsif self.estatus == 'D'
      self.estatus = 'O'
    end
    self.save
  end

  def crear_recaudos()
    SolicitudRecaudo.destroy_all(["solicitud_id = ?", self.id])
    recaudos = Recaudo.find(:all, :conditions=>['activo = true and (tipo_cliente_id = ? or tipo_cliente_id = 1000) and (sector_id = ? or sector_id = 1000)', self.cliente.tipo_cliente_id, self.sector_id], :order =>'nombre')
    recaudos.each { |recaudo|
      solicitud_recaudo = SolicitudRecaudo.new
      solicitud_recaudo.entregado = false
      solicitud_recaudo.recaudo_id = recaudo.id
      solicitud_recaudo.solicitud_id = self.id
      solicitud_recaudo.save
    }
  end

  def evaluar_consejo(attributes)

    if attributes[:estatus].nil? ||
        attributes[:estatus].empty? ||
        self.estatus.nil? ||
        self.estatus.empty?

      self.errors.add(:solicitud, I18n.t('Sistema.Body.Modelos.Solicitud.Errores.debe_completar_informacion_evaluacion'))
      return false
    end

    if (attributes[:estatus] == 'A' ||
          attributes[:estatus] == 'C') &&
        (self.numero_resolucion_consejo.nil? ||
          self.numero_acta_consejo.nil? ||
          self.fecha_acta_consejo.nil? )

      self.errors.add(:solicitud, I18n.t('Sistema.Body.Modelos.Solicitud.Errores.debe_completar_informacion_presidencia'))
      return false
    end

    if self.fecha_acta_directorio
      if (attributes[:estatus] == 'A' ||
            attributes[:estatus] == 'C') &&
          (self.fecha_acta_consejo < self.fecha_acta_directorio)
        self.errors.add(:solicitud, I18n.t('Sistema.Body.Modelos.Solicitud.Errores.fecha_directorio_invalida'))
        return false
      end
    else
      if (attributes[:estatus] == 'A' ||
            attributes[:estatus] == 'C') &&
          (self.fecha_acta_consejo < self.fecha_acta_comite)
        self.errors.add(:solicitud, I18n.t('Sistema.Body.Modelos.Solicitud.Errores.fecha_comite_invalida'))
        return false
      end
    end

    solicitud_historico = SolicitudHistorico.new
    solicitud_historico.solicitud = self
    solicitud_historico.resolucion = self.numero_resolucion_consejo
    solicitud_historico.fecha = self.fecha_acta_consejo

    transaction do

      if !solicitud_historico.save
        self.errors.add_errors solicitud_historico.errors;
        return false
      end

      if self.liberada == false

        #return false unless self.update_attributes(attributes)

        if attributes[:estatus] == 'A' || attributes[:estatus] == 'C'
          self.estatus = 'D'
        else
          self.estatus = attributes[:estatus]
        end

        if  self.estatus == 'A' || self.estatus == 'C' && self.liberada == false

          for prestamo in self.prestamos
            prestamo.monto_aprobado = monto_solicitado
            return false unless prestamo.save
          end
        end

        self.save

        if self.estatus_consejo != 'F'
          registrar_acumulados
        end
      elsif self.liberada == true

        self.estatus_modificacion = 'A'
        #Diego Bertaso
        if attributes[:estatus] == 'A' || attributes[:estatus] == 'C'
          self.estatus = 'D'
        else
          self.estatus = attributes[:estatus]
        end
        self.liberada = false
        self.causa_liberacion = ''
        #fin Diego Bertaso
        self.save

      end

      #inicializacion del estatus de directorio para que aparezca en blanco cuando regrese a directorio
      if self.estatus_consejo == 'F'
        #ELIMINACION DE GERENCIA SI SE SELECCIONA DIFERIR -- MODIFICACION ALEX CIOFFI
        ids = Gerencia.find_by_sql("select id from gerencia where solicitud_id = #{self.id}")
        longitud = ids.length
        longitud = longitud - 1
        while longitud >= 0
          aux = ids[longitud].id
          gerencia_del = Gerencia.find(aux)
          gerencia_del.destroy
          longitud = longitud - 1
        end
        #FIN MODIFICACION ALEX CIOFFI
        self.estatus_directorio = 'N'
        self.estatus_consejo = nil
        self.estatus = 'F'
        self.numero_resolucion_comite = nil
        self.numero_acta_comite = nil
        self.fecha_acta_comite = nil
        self.numero_resolucion_directorio = nil
        self.numero_acta_directorio = nil
        self.fecha_acta_directorio = nil
        self.numero_resolucion_consejo = nil
        self.numero_acta_consejo = nil
        self.fecha_acta_consejo = nil
        self.estatus_comite = 'N'
        self.save
      end

      #fin de modificacion

      #ELIMINACION DE CONDICIONES SI SE SELECCIONA OTRA OPCION

      if self.estatus_consejo == 'A'

        ids = Condicionamiento.find_by_sql("select id from condicionamiento where solicitud_id = #{self.id}")
        longitud = ids.length
        longitud = longitud - 1

        while longitud >= 0
          aux = ids[longitud].id
          condicionamiento_del = Condicionamiento.find(aux)
          condicionamiento_del.destroy
          longitud = longitud - 1
        end

      end

      #fin de modificacion

      prestamo = Prestamo.find(:first, :conditions=>['solicitud_id = ?', self.id])
      parameters = { :p_id_solicitud => [solicitud_historico.id, "Integer"] } #, :p_id_prestamo => [prestamo.id, "long"]
      return false unless write_doc("resolucion_evaluar", parameters, "solicitudes", "resoluciones/" + solicitud_historico.id.to_s, "pdf" )

    end

    return true

  end

  def grabar_historico_resolucion

  end

  def before_update
  end
  
  after_update :after_update

  def after_update

    #Diego Bertaso
    #Se habilito este metodo que estaba comentado y se agrego que no actualizara
    #el archivo solicitud_evento cuando se modifica la solicitud sin cambiar su
    #estatus
    #

    if self.estatus != 'T'  #&& self.estatus != 'O' && self.estatus != 'P'

      if @usuario
        #
        # Modificaciones de Alex Cioffi necesarias para el diferimiento en comite
        if self.estatus_comite == 'F' || self.estatus_comite == 'R'
          if self.estatus == 'F'
            @observaciones = self.causa_diferimiento_comite.nombre
          elsif self.estatus == 'R'
            @observaciones = self.causa_rechazo_comite.nombre
          end
        elsif self.estatus_directorio == 'F' || self.estatus_directorio == 'R'
          if self.estatus == 'F'
            @observaciones = self.causa_diferimiento.nombre
          end
          if self.estatus == 'R'
            @observaciones = self.causa_rechazo.nombre
          end
        end
        # ---> Fin modificaciones Alex Cioffi
        ControlSolicitud.create_new(self.id, self.estatus_id, @usuario.id, I18n.t('Sistema.Body.General.avanzar'), self.estatus_id, '')

      end   #---> if @usuario

    end     #---> if self.estatus != 'T'

    # ---> Fin modificaciones
  end

  after_create :after_create
  
  def after_create
    ## TEWMPORAL MIENTRAS SE MIGRA

    if @usuario

      if self.estatus == 'F'
        @observaciones = self.causa_diferimiento.nombre
      end
      if self.estatus == 'R'
        @observaciones = self.causa_rechazo.nombre
      end
      ControlSolicitud.create_new(self.id, self.estatus_id, @usuario.id, I18n.t('Sistema.Body.General.avanzar'), self.estatus_id, '')
    end
    # FIN DE TEMPORAL MIENTRAS SE MIGRA
  end
  
  validate :validate

  def validate

    if self.estatus_id == 10001
      unless self.unidad_produccion.blank?
        unless self.oficina.blank?
          texto = I18n.t('Sistema.Body.Modelos.Errores.unidad_produccion')
          cliente = Cliente.find(self.cliente_id)
          if cliente.es_pescador == true
            if cliente.type.to_s == "ClienteEmpresa"
              texto = I18n.t('Sistema.Body.Modelos.Errores.comunidad_pesquera')
            else
              texto = I18n.t('Sistema.Body.Modelos.Errores.puerto_base')
            end
          end
          total = OficinaAreaInfluencia.count(:conditions => ['oficina_id = ? and parroquia_id = ?', self.oficina_id, self.unidad_produccion.parroquia_id])
          unless total > 0
            self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.estado_de')} #{texto} #{I18n.t('Sistema.Body.Modelos.Errores.area_influencia_oficina_receptora')}")
          end
        end
      end
      unless self.sub_sector_id.blank?
        sub_sector = SubSector.find(self.sub_sector_id)
        if sub_sector.nemonico == 'VE'
          if self.hectareas_solicitadas.blank?
            self.errors.add(:solicitud, I18n.t('Sistema.Body.Modelos.Solicitud.Errores.hectareas_requeridas'))
          else
            unless self.hectareas_solicitadas > 0
              self.errors.add(:solicitud, I18n.t('Sistema.Body.Modelos.Solicitud.Errores.hectareas_mayor_que_cero'))
            else
              unidad_produccion = UnidadProduccion.find(self.unidad_produccion_id)
              if self.hectareas_solicitadas > unidad_produccion.total_hectareas
                self.errors.add(:solicitud, I18n.t('Sistema.Body.Modelos.Solicitud.Errores.hectareas_mayor_que_unidad_produccion'))
              end
            end
          end
        elsif sub_sector.nemonico == 'AN'
          if self.semovientes_solicitados.nil?
            self.errors.add(:solicitud, I18n.t('Sistema.Body.Modelos.Solicitud.Errores.semovientes_es_requerido'))
          elsif self.semovientes_solicitados < 1
            self.errors.add(:solicitud, I18n.t('Sistema.Body.Modelos.Solicitud.Errores.semovientes_mayor_que_cero'))
          end
        end
      end
      if self.new_record?
        total = Solicitud.count(:conditions => "cliente_id = #{self.cliente_id} and actividad_id = #{self.actividad_id} and estatus_id not in (10070, 10100, 10110, 10024, 10080, 10035)")
        if total > 0
          if self.cliente.type.to_s == "ClientePersona"
            beneficiario = self.cliente.persona.nombre_corto
          else
            beneficiario = self.cliente.empresa.nombre
          end
          self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.el_beneficiario')}#{beneficiario}#{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.solicitud_en_ruta_credito')}")
        end
      end
      if self.sub_sector.nemonico == 'PE'
        unless self.cliente.es_pescador == true
          self.errors.add(:solcitud, "#{I18n.t('Sistema.Body.Modelos.Errores.el_beneficiario')} #{beneficiario} #{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.debe_ser_pescador')}")
        end
      else
        if self.cliente.es_pescador == true
          self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.el_beneficiario')} #{beneficiario} #{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.solo_tramite_pesca')}")
        end
      end
    end

    #if Solicitud.count(:conditions=>['cliente_id = ? ',self.cliente_id]) > 0
    #self.recredito = true
    #else
    #self.recredito = false
    #end

    #if self.monto_cliente < 1
    #self.errors.add(nil,"Monto Solicitado debe ser mayor a 0 2")
    #end


    #********************************************************************************************************************************************
    #AQUI COMIENZA BLOQUE DE VALIDACION CORRESPONDIENTE A ISNTANCIA DECISION
    #********************************************************************************************************************************************
    if self.migrado_d3.nil?
      if self.decision_comite.nil?
        self.errors.add(:solicitud, "Debe seleccionar la decision pertinente a este caso")
      end
      if self.numero_resolucion_comite.nil?
        self.errors.add(:solicitud, "Debe seleccionar la decision pertinente a este caso")
      end
      if !self.monto_aprobado.nil?
        if self.monto_aprobado <= 0
          #  self.errors.add(nil, "El Monto Aprobado debe ser mayor que cero")
        end
      end

      self.migrado_d3 = false
    end


    #********************************************************************************************************************************************
    #AQUI COMIENZA BLOQUE DE VALIDACION CORRESPONDIENTE A FICHA RESUMEN
    #********************************************************************************************************************************************
    if self.migrado_d3

      if !self.tir.nil?
        if self.tir < 1
          self.errors.add(:solicitud, "Tir debe ser mayor que cero")
        end
        if self.tir > 100
          self.errors.add(:solicitud,"Tir debe ser menor o igual a 100")
        end
      else
        #  self.errors.add(nil,"Tir es un campo requerido")
      end

      if !self.empleos_directo_generar.nil?
        if self.empleos_directo_generar < 0
          self.errors.add(:solicitud, "Cantidad de Empleos Directos a Generar debe ser positivo")
        end
      end

      if !self.empleos_indirecto_generar.nil?
        if self.empleos_indirecto_generar < 0
          self.errors.add(:solicitud, "Cantidad de Empleos Indirectos a Generar debe ser positivo")
        end
      end

      if !self.empleaos_mantener.nil?
        if self.empleaos_mantener < 0
          self.errors.add(:solicitud, "Cantidad de Empleos a Mantener debe ser positivo")
        end
      end

      if !self.empleos_directo_actual.nil?
        if self.empleos_directo_actual < 0
          self.errors.add(:solicitud, "Cantidad de Empleos Actuales Directos debe ser positivo")
        end
      end

      if !self.empleos_indirecto_actual.nil?
        if self.empleos_indirecto_actual < 0
          self.errors.add(:solicitud, "Cantidad de Empleos Actuales Indirectos debe ser positivo")
        end
      end

      if !self.unidades_actuales.nil?
        if self.unidades_actuales < 0
          self.errors.add(:solicitud, "Unidades Actuales debe ser positivo")
        end
      end

      if !self.unidades_proyecto.nil?
        if self.unidades_proyecto < 0
          self.errors.add(:solicitud, "Unidades Proyecto debe ser positivo")
        end
      end

      if !self.monto_actuales.nil?
        if self.monto_actuales < 0
          self.errors.add(:solicitud, "Monto Actuales debe ser positivo")
        end
      end

      if !self.monto_proyecto.nil?
        if self.monto_proyecto < 0
          self.errors.add(:solicitud, "Monto Proyecto debe ser positivo")
        end
      end

      if !self.van.nil?
        if self.van < 1
          self.errors.add(:solicitud, "Van debe ser mayor que cero")
        end
      else
        # self.errors.add(nil,"Van es un campo requerido")
      end

      if !self.calificacion_cuantitativa.nil?
        if self.calificacion_cuantitativa < 0
          self.errors.add(:solicitud, "Calificacion Cuantitativa debe ser positivo")
        end
      end

      if !self.calificacion_cualitativa.nil?
        if self.calificacion_cualitativa < 0
          self.errors.add(:solicitud, "Calificacion Cualitativa debe ser positivo")
        end
      end

      if !self.calificacion_social.nil?
        if self.calificacion_social < 0
          self.errors.add(:solicitud, "Calificacion Social debe ser positivo")
        end
      end

      if !self.monto_solicitado.nil?
        if self.monto_solicitado < 0
          self.errors.add(:solicitud, "Monto Recomendado del Credito debe ser mayor a 0")
        end

        if self.es_aprobado_condicionado_por_monto? && (self.monto_solicitado.to_f.to_s != self.monto_aprobado.to_f.to_s)
          self.errors.add(:solicitud, "Esta Solicitud es una solicitud Pre-Aprobada, con lo que el Monto Recomendado del Credito debe tener el valor que ya pre-aprobo el comite( BsF.#{self.monto_aprobado_f})")
        end

      else
        self.errors.add(:solicitud, "Monto Recomendado del Credito es un campo requerido")
      end

      if !self.atributo_expansion and !self.atributo_competitividad and !self.atributo_innovacion_tecnologica and !self.atributo_diversificacion and !self.atributo_transferencia_tecnologica and !self.atributo_desarrollo_tecnologico
        self.errors.add(:solicitud, "Debe haber por lo menos un Atributo del Proyecto seleccionado")
      end

      self.migrado_d3 = false

    end

    #********************************************************************************************************************************************
    #AQUI TERMINA BLOQUE DE VALIDACION CORRESPONDIENTE A FICHA RESUMEN
    #********************************************************************************************************************************************


    unless self.programa_id.nil? || self.programa_id.to_s.empty?
      producto = Producto.find(:first,:conditions=>"programa_id = #{self.programa_id}")
      if self.codigo_d3 == false
        unless self.monto_solicitado >= producto.monto_minimo && self.monto_solicitado <= producto.monto_maximo
          # self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Errores.monto_solicitado_debe_ser_mayor')} #{producto.monto_minimo_f} #{I18n.t('Sistema.Body.Modelos.Errores.menor_a')} #{producto.monto_maximo_f}")
        end

      end
    end

  end

  def fecha_solicitud_desembolso_f=(fecha)
    self.fecha_solicitud_desembolso = fecha
  end

  def fecha_solicitud_desembolso_f
    format_fecha(self.fecha_solicitud_desembolso)
  end

  def fecha_solicitud_f=(fecha)
    self.fecha_solicitud = fecha
  end

  def fecha_solicitud_f
    format_fecha(self.fecha_solicitud)
  end

  def fecha_registro_f=(fecha)
    self.fecha_registro = fecha
  end

  def fecha_registro_f
    format_fecha(self.fecha_registro)
  end

  def fecha_liquidacion_f=(fecha)
    self.fecha_liquidacion = fecha
  end

  def fecha_liquidacion_f
    format_fecha(self.fecha_liquidacion)
  end

  def fecha_propuesta_social_trabajadores_f=(fecha)
    self.fecha_propuesta_social_trabajadores = fecha
  end

  def fecha_propuesta_social_trabajadores_f
    format_fecha(self.fecha_propuesta_social_trabajadores)
  end

  def fecha_propuesta_social_comunidad_f=(fecha)
    self.fecha_propuesta_social_comunidad = fecha
  end

  def fecha_propuesta_social_comunidad_f
    format_fecha(self.fecha_propuesta_social_comunidad)
  end

  def fecha_propuesta_social_ambiente_f=(fecha)
    self.fecha_propuesta_social_ambiente = fecha
  end

  def fecha_propuesta_social_ambiente_f
    format_fecha(self.fecha_propuesta_social_ambiente)
  end

  def fecha_firma_contrato_f
    format_fecha(self.fecha_firma_contrato)
  end

  def fecha_aprobacion_f
    format_fecha(self.fecha_aprobacion)
  end

  def monto_solicitado_f=(valor)
    self.monto_solicitado = valor.sub(',', '.')
  end

  def monto_solicitado_f
    format_f(self.monto_solicitado)
  end

  #************************************************************************************************
  # Fecha: 10/07/2008
  # Metodos incluidos por Diego Bertaso para manejo de indicadores tir, van y tiempo_recuperacion
  #************************************************************************************************

  def tir_f
    format_f(self.tir)
  end

  def van_f
    format_f(self.van)
  end


  def monto_solicitado_fm
    format_fm(self.monto_solicitado)
  end

  def monto_aprobado_fm
    format_fm(self.monto_aprobado)
  end

  def monto_cliente_f=(valor)
    self.monto_cliente = format_valor(valor)
  end

  def monto_cliente_f
  
    format_f(self.monto_cliente)
  end

  def monto_cliente_fm
  
    format_fm(self.monto_cliente)
  end

  def monto_analista_fm
  
    format_fm(self.monto_analista)
  end

  def monto_aprobado_f=(valor)
    self.monto_aprobado = format_valor(valor)
  end

  def monto_aprobado_f
  
    format_fm(self.monto_aprobado)
  end

  def aporte_social_f=(valor)
    self.aporte_social = format_valor(valor)
  end

  def aporte_social_f
  
    format_f(self.aporte_social)
  end

  def aporte_social_fm
  
    format_fm(self.aporte_social)
  end

  def monto_propuesta_social_f=(valor)
    self.monto_propuesta_social = format_valor(valor)
  end

  def monto_propuesta_social_f
    format_f(self.monto_propuesta_social)
  end

  def monto_propuesta_social_fm
  
    format_fm(self.monto_propuesta_social)
  end

  def propuesta_utilidad_neta_f=(valor)
    self.propuesta_utilidad_neta = format_valor(valor)
  end

  def propuesta_utilidad_neta_f
    format_f(self.propuesta_utilidad_neta)
  end

  def propuesta_utilidad_neta_fm
  
    format_fm(self.propuesta_utilidad_neta)
  end

  def hectareas_recomendadas_f
  
    format_f(self.hectareas_recomendadas)
  end

  def hectareas_recomendadas_fm
  
    format_fm(self.hectareas_recomendadas)
  end

  def hectareas_solicitadas_fm
  
    format_fm(self.hectareas_solicitadas)
  end

  def semovientes_recomendados_f
    format_f(self.semovientes_recomendados)
  end

  def semovientes_recomendados_fm
  
    format_fm(self.semovientes_recomendados)
  end
  
  def fecha_acta_comite_f=(fecha)
    self.fecha_acta_comite = fecha
  end

  def fecha_acta_comite_f
    format_fecha(self.fecha_acta_comite)
  end

  def fecha_acta_entrega_f=(fecha)
    self.fecha_acta_entrega = fecha
  end

  def fecha_acta_entrega_f
  
    format_fecha(self.fecha_acta_entrega)
  end

  def fecha_acta_directorio_f=(fecha)
    self.fecha_acta_directorio = fecha
  end

  def fecha_acta_directorio_f
    format_fecha(self.fecha_acta_directorio)
  end

  def fecha_acta_consejo_f=(fecha)
    self.fecha_acta_consejo = fecha
  end

  def fecha_acta_consejo_f
    format_fecha(self.fecha_acta_consejo)
  end

  def maximo_plazo_de_prestamos
    plazo = 0
    prestamo = self.prestamos.find(:first,:order=>'plazo desc')
    plazo = prestamo.plazo unless !prestamo

    return plazo
  end

  def cantidad_fianzas_solidarias
    cantidad = 0
    cantidad = self.garantias.count_by_sql("select count(*) from garantia, tipo_garantia where garantia.tipo_garantia_id = tipo_garantia.id and tipo_garantia.fianza_solidaria = true and solicitud_id = "+ self.id.to_s)
    return cantidad
  end

  def tiene_equipamiento
    if self.prestamos.find_by_partida_id(5)
      true
    else
      false
    end
  end

  def tiene_capital_trabajo
    if self.prestamos.find_by_partida_id(2)
      true
    else
      false
    end
  end

  def cantidad_desembolsos
    return Desembolso.count_by_sql("select count(id) from desembolso where prestamo_id in (select id from prestamo where solicitud_id = #{self.id})")
  end

  def change_programa
    cantidad_programa = Prestamo.count(:conditions=>"solicitud_id = #{self.id}")
    if cantidad_programa.nil? || cantidad_programa == 0
      return true
    else
      return false
    end
  end

  def estatus_consejo_f
    case self.estatus_consejo
    when 'A'
      I18n.t('Sistema.Body.General.aprobar')
    when 'R'
      I18n.t('Sistema.Body.General.rechazar')
    when 'D'
      I18n.t('Sistema.Body.General.diferir')
    end
  end

  def decision_comite_f
    unless self.decision_comite.nil?
      case self.decision_comite
      when 'A'
        I18n.t('Sistema.Body.General.aprobado')
      when 'R'
        I18n.t('Sistema.Body.General.rechazado')
      when 'D'
        I18n.t('Sistema.Body.General.diferido')
      end
    end
  end

  def cuota_frances(monto, tasa, cuotas, periodo)
    if tasa>0

      tasa = ( tasa / (12 / periodo) ) / 100
      monto * ( ( tasa  * ( (1 + tasa)**cuotas ) ) / ( ( (1 + tasa)**cuotas ) - 1 ) )
    else
      monto / cuotas
    end
  end

  def ficha_resumen_llena?
    resultado = false
    if (!self.monto_analista.nil? and (self.atributo_expansion or self.atributo_competitividad or self.atributo_innovacion_tecnologica or self.atributo_diversificacion or self.atributo_transferencia_tecnologica or self.atributo_desarrollo_tecnologico) and !self.unidades_actuales.nil? and !self.unidades_proyecto.nil? and !self.scoring_aceptacion_id.nil? and !self.monto_actuales.nil? and !self.monto_proyecto.nil? and !self.calificacion_cuantitativa.nil? and !self.calificacion_cualitativa.nil? and !self.calificacion_social.nil? and !self.destino_credito.nil? and !self.tir.nil? and !self.van.nil? and !self.empleos_directo_generar.nil? and !self.empleos_indirecto_generar.nil? and !self.empleaos_mantener.nil?    and !self.empleos_directo_actual.nil? and !self.empleos_indirecto_actual.nil? )
      resultado = true
    end
    return resultado
  end

  def esta_certificada
    resultado = 0
    solicitud_certificacion = SolicitudCertificacionPresupuestaria.find_by_solicitud_id(self.id)
    if !solicitud_certificacion.nil?
      resultado = solicitud_certificacion.disponibilidad
    else
      resultado = 0
    end
    return resultado
  end

  def esta_esperando_por_certificacion?
    resultado = false
    if self.estatus_id == 10005
      resultado = true
    else
      resultado = false
    end
    return resultado
  end

  def esta_esperando_por_visado?
    resultado = false
    if self.estatus_id == 10006
      resultado = true
    else
      resultado = false
    end
    return resultado
  end

  def esta_certificada?
    resultado = false
    if self.estatus_id == 10026
      resultado = true
    else
      resultado = false
    end
    return resultado
  end

  def esta_visada?
    resultado = false
    if self.estatus_id == 10007
      resultado = true
    else
      resultado = false
    end
    return resultado
  end

  def esta_pre_visado
    resultado = 0

    if self.pre_visado == 1
      resultado = 1
    end

    if self.pre_visado == 2
      resultado = 2
    end
    return resultado
  end

  def apertura_instancia?
    if self.comite_id.nil?
      resultado = false
    else
      resultado = true
    end
    return resultado
  end

  def esta_aprobada?
    resultado = false
    resultado = true if ((self.decision_comite == 'A' || self.decision_comite == 'C') && !self.comite_id.nil?)
    return resultado
  end

  def esta_rechazado_diferido?
    resultado = false
    resultado = true if ((self.decision_comite == 'R' || self.decision_comite == 'D') && !self.comite_id.nil?)
    return resultado
  end
  def esta_no_visto?
    resultado = false
    resultado = true if ((self.decision_comite == 'P') && !self.comite_id.nil?)
    return resultado
  end

  def esta_asociada_al_comite?
    resultado = false
    resultado = true if !self.comite_id.nil?
    return resultado
  end

  def instancia_a_evalucion_del_credito_diferido
    self.visado = false
    sector_economico = 0
    if !self.comite_id.nil?
      @complemento_decision = ComplementoDecision.find_by_solicitud_id(self.id)

      if self.cliente.class.to_s =='ClienteEmpresa'
        sector_economico = self.cliente.empresa.sector_economico_id
      else
        sector_economico = self.cliente.persona.sector_economico_id
      end
      @comite_decision_historico = ComiteDecisionHistorico.new(:monto => self.monto_analista, :decision => self.decision_comite, :comite_id => self.comite_id, :solicitud_id => self.id, :sector_economico_id => sector_economico, :observaciones => @complemento_decision.notas)
      @comite_decision_historico.save
    end
  end


  def limpiar_decision

    complemento_decision_id = ComplementoDecision.find_by_solicitud_id(self.id).id if !ComplementoDecision.find_by_solicitud_id(self.id).nil?



    ComplementoDecisionCausaCondicionamiento.delete(ComplementoDecisionCausaCondicionamiento.find_by_complemento_decision_id(complemento_decision_id).id) if !ComplementoDecisionCausaCondicionamiento.find_by_complemento_decision_id(complemento_decision_id).nil?
    ComplementoDecision.delete(ComplementoDecision.find_by_solicitud_id(self.id).id) if !ComplementoDecision.find_by_solicitud_id(self.id).nil?



    self.decision_comite = nil
    self.numero_resolucion_comite = ""

  end

  def alerta_desde_instancia?

    resultado = false
    ultima_accion = ControlSolicitud.find_all_by_solicitud_id(self.id, :order =>'id DESC')
    ultima_accion = ultima_accion[0]

    if !ultima_accion.nil?
      if ultima_accion.accion == I18n.t('Sistema.Body.General.reversar') && (ultima_accion.estatus_origen_id.to_s == '10011' || ultima_accion.estatus_origen_id.to_s == '10008' || ultima_accion.estatus_origen_id.to_s == '10009' || ultima_accion.estatus_origen_id.to_s == '10010' || ultima_accion.estatus_origen_id.to_s == '10012' || ultima_accion.estatus_origen_id.to_s == '10027')
        resultado = true
      end
    end

    return resultado

  end

  def alerta_desde_visado?

    resultado = false
    ultima_accion = ControlSolicitud.find_all_by_solicitud_id(self.id, :order =>'id DESC')
    ultima_accion = ultima_accion[0]

    if !ultima_accion.nil?
      if ultima_accion.accion == I18n.t('Sistema.Body.General.reversar') && ultima_accion.estatus_origen_id.to_s == '10006'
        resultado = true
      end
    end

    return resultado

  end


  def alerta_desde_disponibilidad?

    resultado = false
    ultima_accion = ControlSolicitud.find_all_by_solicitud_id(self.id, :order =>'id DESC')
    ultima_accion = ultima_accion[0]

    if !ultima_accion.nil?
      if ultima_accion.accion == I18n.t('Sistema.Body.General.reversar') && ultima_accion.estatus_origen_id.to_s == '10005'
        resultado = true
      end
    end

    return resultado

  end

  def nombre_ultimo_estatus

    resultado = ""
    ultima_accion = ControlSolicitud.find_all_by_solicitud_id(self.id, :order =>'id DESC')
    ultima_accion = ultima_accion[0]

    resultado = Estatus.find(ultima_accion.estatus_origen_id).nombre if !ultima_accion.nil?
    return resultado

  end

  def devolver_instancias_a_evaluacion?
    resultado = false
    resultado = true if self.comite_id.nil?
  end


  #CODIGO NUEVO JAVIER CONTRERAS*********************SUSPENSION DE SOLICITUDES**************************************************

  def esta_suspendida?

    if self.estatus_id == 10029
      return true
    else
      return false
    end
    # solicitud_causa_renuncia = SolicitudCausaRenuncia.find_by_solicitud_id self.id

    #if solicitud_causa_renuncia.nil?
    #  return false
    #else
    #  return true
    #end
  end

  def reactivar
    solicitud_causa_renuncia = SolicitudCausaRenuncia.find_by_solicitud_id self.id
    self.estatus_id = solicitud_causa_renuncia.estatus_id
    self.save
    SolicitudCausaRenuncia.find_by_sql("delete from solicitud_causa_renuncia where solicitud_id = #{self.id}")
    return true
  end

  def suspender(paramms)
    solicitud_causa_renuncia = SolicitudCausaRenuncia.new(paramms)
    solicitud_causa_renuncia.save
    self.estatus_id = 10029
    self.save
  end

  def nombre_estatus_antes_de_suspender
    return  Estatus.find(SolicitudCausaRenuncia.find_by_solicitud_id(self.id).estatus_id).nombre


  end

  def esta_devuelta?

    if self.estatus_id == 10030
      return true
    else
      return false
    end

  end

  def devolver_al_cliente(paramms)
    solicitud_causa_devolucion_al_cliente = SolicitudCausaDevolucionCliente.new(paramms)
    solicitud_causa_devolucion_al_cliente.save
    self.estatus_id = 10030
    self.save
  end

  def nombre_estatus_antes_de_devolver
    return  Estatus.find(SolicitudCausaDevolucionCliente.find_by_solicitud_id(self.id).estatus_id).nombre
  end


  def asentar_traza_decision(tipo)
    sector_economico = 0
    if self.cliente.class.to_s =='ClienteEmpresa'
      sector_economico = self.cliente.empresa.sector_economico_id
    else
      sector_economico = self.cliente.persona.sector_economico_id
    end

    @complemento_decision = ComplementoDecision.find_by_solicitud_id(self.id)
    if tipo=='e'
      numero_comite = self.numero_comite_estadal
    else
      numero_comite=self.numero_comite_nacional
    end
    @comite = Comite.find_by_numero(numero_comite)
    @comite_decision_historico = ComiteDecisionHistorico.new(:monto => self.monto_aprobado, :decision => self.decision_comite, :comite_id => @comite.id, :solicitud_id => self.id, :sector_economico_id => sector_economico, :observaciones => @complemento_decision.notas)
    @comite_decision_historico.save
  end

  def asignar_numero_resolucion
    if (self.decision_comite == 'A' || self.decision_comite == 'C')
      self.numero_resolucion_comite = self.comite.proximo_numero_resolucion
    else
      self.numero_resolucion_comite = ""
    end
  end

  def deshacer_contrato user, session

    begin
      success = true
      estatus_id_inicial = estatus_id
      estatus_id_final = estatus_id_inicial - 1
      fecha_evento = Time.now
      self.estatus_id = estatus_id_final
      self.fecha_actual_estatus = format_fecha_inv(fecha_evento)
      unless self.solicitud_contrato.nil?
        SolicitudContrato.delete(solicitud_contrato.id)
        raise Exception, I18n.t('Sistema.Body.Modelos.SolicitudContrato.Errores.error_eliminacion_contrato') unless success
      end

      success &&= self.save!
      raise Exception, I18n.t('Sistema.Body.Modelos.Solicitud.Errores.actualizar_datos_solicitud') unless success
      # Crea un nuevo registro en la tabla control_solicitud
      success &&= ControlSolicitud.create_new(self.id, estatus_id_final, user.id, 'Deshacer', estatus_id_inicial, '')
      raise Exception, I18n.t('Sistema.Body.Modelos.Errores.guardar_registro_control') unless success
      return success

    rescue Exception => e

      return false
    end
  end

  def renunciar_contrato user, session, observaciones

    begin
      success = true
      estatus_id_inicial = estatus_id
      estatus_id_final = Estatus.find_by_const_id('ST0032').id
      fecha_evento = Time.now
      self.estatus_id = estatus_id_final
      self.fecha_actual_estatus = format_fecha_inv(fecha_evento)
      success &&= self.save!
      raise Exception, I18n.t('Sistema.Body.Modelos.Solicitud.Errores.actualizar_datos_solicitud') unless success
      # Crea un nuevo registro en la tabla control_solicitud
      success &&= ControlSolicitud.create_new(self.id, estatus_id_final, user.id, 'Deshacer', estatus_id_inicial, observaciones)
      raise Exception, I18n.t('Sistema.Body.Modelos.Errores.guardar_registro_control') unless success
      return success
    rescue Exception => e

      return false
    end
  end

  def nombre

    if self.cliente.class.to_s == 'ClienteEmpresa'
      self.cliente.empresa.nombre
    else
      self.cliente.persona.nombre_corto
    end

  end


  def avanzar_fideicomiso(user,solicitudes,condiciones)

    begin

      success = true

      monto_bancos = 0.00
      monto_insumos = 0.00
      monto_sras_total = 0.00
      monto_gasto_total = 0.00
      prestamo_total = 0.00
      idssolicitudes = ""
      cantsolicitudes = 0

      transaction do

        solicitudes.each do |solicitud|

          successDes = true
          successInsumos = true
          successDetalle = true
          successDetalleInsumos = true

          if idssolicitudes == ""
            idssolicitudes  = solicitud.id.to_s
          else
            idssolicitudes = idssolicitudes << ", " << solicitud.id.to_s
          end

          cantsolicitudes = cantsolicitudes +1

          #ACTUALIZACION DE LA SOLICITUD
          @solicitud = Solicitud.find(solicitud.id)
          estatus_id_inicial = @solicitud.estatus_id
          fecha_evento = Time.now

          @cuenta_bancaria = CuentaBancaria.find(:first, :conditions=>['activo = true and cliente_id = ?',@solicitud.cliente.id])

          if @cuenta_bancaria == nil
            modalidad = "C"
            cta_entidad_financiera_id = nil
            cta_tipo = nil
            cta_numero = nil
          else
            modalidad = "T"
            cta_entidad_financiera_id = @cuenta_bancaria.entidad_financiera_id
            cta_tipo = @cuenta_bancaria.tipo
            cta_numero = @cuenta_bancaria.numero
          end

          @prestamo = Prestamo.find_by_solicitud_id(@solicitud.id)
          @visita = SeguimientoVisita.find(:first, :conditions=>['solicitud_id = ?',@solicitud.id], :order=>'id desc')

          monto_bancos = monto_bancos + @prestamo.monto_banco.to_f
          monto_insumos = monto_insumos + @prestamo.monto_insumos.to_f
          monto_sras_total = monto_sras_total + @prestamo.monto_sras_total.to_f
          monto_gasto_total = monto_gasto_total + @prestamo.monto_gasto_total.to_f
          prestamo_total = prestamo_total + @prestamo.monto_solicitado.to_f + @prestamo.monto_sras_total.to_f + @prestamo.monto_gasto_total.to_f

          #-----------BORRANDO INFORMACION VIEJA DE DESEMBOLSOS Y ORDENES DE DESPACHO ---------------------
          @desembolsos_viejos = Desembolso.find(:all, :conditions=>['solicitud_id = ? and numero = 1',@solicitud.id])

          unless @desembolsos_viejos.nil?
            @desembolsos_viejos.each do |desembolsos_viejos|
              ActiveRecord::Base.connection.execute("delete from desembolso_detalle where desembolso_id = #{desembolsos_viejos.id}")
              ActiveRecord::Base.connection.execute("delete from desembolso where id = #{desembolsos_viejos.id}")
            end

          end

          despacho = OrdenDespacho.find_by_seguimiento_visita_id(@visita.id)

          unless despacho.nil?
            ActiveRecord::Base.connection.execute("delete from orden_despacho_detalle where orden_despacho_id = #{despacho.id}")
            ActiveRecord::Base.connection.execute("delete from orden_despacho where id = #{despacho.id}")
          end

          if @prestamo.monto_banco > 0 or @prestamo.monto_insumos > 0

            begin

              if @prestamo.monto_banco > 0

                #----------- CREANDO DESEMBOLSO ---------------------
                desembolso = Desembolso.new(
                  :solicitud_id =>@solicitud.id,
                  :prestamo_id=>@prestamo.id,
                  :usuario_id=>user.id,
                  :entidad_financiera_id=>cta_entidad_financiera_id,
                  :tipo_cuenta=>cta_tipo,
                  :numero_cuenta=>cta_numero,
                  :seguimiento_visita_id=>@visita.id,
                  :monto=>0,
                  :numero=>1,
                  :realizado=>false,
                  :confirmado=>true,
                  :modalidad=>modalidad )

                successDes = desembolso.save

                if successDes == false
                  self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Desembolso.Errores.no_puede_crearse_desembolso')} #{@solicitud.numero}")
                end

                #----------- BUSCANDO INTEMS PARA EL DETALLE DEL DESEMBOLSO ---------------------
                @plan_inversion = PlanInversion.find(:all, :conditions=>["solicitud_id = ? and numero_desembolso = 1 and tipo_item = 'B'",@solicitud.id])
                successDetalle = true
                total_banco = 0.00

                @plan_inversion.each do |plan_inversion|
                  total_banco = total_banco + plan_inversion.monto_financiamiento


                  #----------- CREANDO DETALLE DESEMBOLSO ---------------------
                  desembolso_detalle = DesembolsoDetalle.new(
                    :desembolso_id=>desembolso.id,
                    :plan_inversion_id=>plan_inversion.id,
                    :monto=> plan_inversion.monto_financiamiento
                  )
                  successDetalle = desembolso_detalle.save
                  if successDetalle == false
                    self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.DesembolsoDetalle.Errores.no_puede_crearse_detalle')} #{@solicitud.numero}")
                  end
                end      #=============> Fin @plan_inversion.each do

                desembolso.monto = total_banco

                if total_banco > 0
                  desembolso.save
                else
                  ActiveRecord::Base.connection.execute("delete from desembolso_detalle where desembolso_id = #{desembolso.id}")
                  desembolso.destroy()
                  self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Solicitud.Mensajes.error_desembolso')} #{self.numero}")
                  raise ActiveRecord::Rollback
                  return false
                end

              end       #====> Fin if @prestamo.monto_banco > 0

            rescue => detail
              logger.info "Se eliminó el desembolso por #{detail.mensaje.to_s}"
            end

            if @prestamo.monto_insumos > 0
              total_despachos = OrdenDespacho.count()
              if total_despachos == 0
                correlativo = 1
              else
                correlativo = total_despachos.to_i + 1
              end
              numero = @solicitud.numero.to_s<<'-'<<@prestamo.numero.to_s<<'-'<< Time.now.strftime('%Y')<<'-'<<'%04d' % correlativo

              unless @solicitud.sub_sector.nemonico == "MA"
                #----------- CREANDO ORDEN DE DESPACHO ---------------------
                orden_despacho = OrdenDespacho.new(
                  :solicitud_id =>@solicitud.id,
                  :prestamo_id=>@prestamo.id,
                  :usuario_id=>user.id,
                  :fecha_orden_despacho=>Time.now,
                  :seguimiento_visita_id=>@visita.id,
                  :estatus_id=>20000,
                  :monto=>0,
                  :numero=>numero,
                  :estado_id=>@solicitud.unidad_produccion.ciudad.estado_id,
                  :observacion=>''
                )
                successInsumos = orden_despacho.save
                if successInsumos == false
                  self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.OdenDespacho.Errores.no_puede_crearse_orden')} #{@solicitud.numero}")
                end


                #----------- BUSCANDO INTEMS PARA EL DETALLE DEL DESEMBOLSO ---------------------
                @plan_inversion = PlanInversion.find(:all, :conditions=>["solicitud_id = ? and numero_desembolso = 1 and tipo_item = 'I'",@solicitud.id])
                successDetalleInsumos = true
                total_insumos = 0.00
                @plan_inversion.each do |plan_inversion|
                  total_insumos = total_insumos + plan_inversion.monto_financiamiento
                  if @solicitud.sub_sector.nemonico=="VE"
                    cantidad = plan_inversion.cantidad * plan_inversion.cantidad_por_hectarea
                  else
                    cantidad = plan_inversion.cantidad
                  end

                  orden_despacho_detalle = OrdenDespachoDetalle.new(
                    :orden_despacho_id=>orden_despacho.id,
                    :plan_inversion_id=>plan_inversion.id,
                    :item_nombre=>plan_inversion.item_nombre,
                    :unidad_medida_id=>plan_inversion.unidad_medida_id,
                    :cantidad=>cantidad,
                    :costo_real=>plan_inversion.costo_real,
                    :monto_financiamiento=>plan_inversion.monto_financiamiento,
                    :monto_facturacion=>0,
                    :monto_recomendado=>0)

                  successDetalleInsumos = orden_despacho_detalle.save
                  if successDetalleInsumos == false
                    self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.OdenDespachoDetalle.Errores.no_puede_crearse_detalle')} #{@solicitud.numero}")
                  end

                end     #============> Fin @plan_inversion.each do

                orden_despacho.monto = total_insumos
                orden_despacho.save

            else
              @plan_inversion = PlanInversion.find(:all, :conditions=>["solicitud_id = ? and numero_desembolso = 1 and tipo_item = 'I'",@solicitud.id], :order => "casa_proveedora_id")
                  casa_proveedora_id = 0
                  total_insumos = 0.00
                  successDetalleInsumos = true
                  @plan_inversion.each {|plan|
                   unless casa_proveedora_id == plan.casa_proveedora_id
                      unless total_insumos == 0
                        total_insumos = 0.00
                      end
                      orden_despacho = OrdenDespacho.new(
                          :solicitud_id =>@solicitud.id,
                          :prestamo_id=>@prestamo.id,
                          :usuario_id=>user.id,
                          :fecha_orden_despacho=>Time.now,
                          :seguimiento_visita_id=>@visita.id,
                          :estatus_id=>20000,
                          :monto=>0,
                          :numero=>numero,
                          :estado_id=>@solicitud.unidad_produccion.ciudad.estado_id,
                          :casa_proveedora_id => plan.casa_proveedora_id,
                          :observacion=>''
                          )
                      successInsumos = orden_despacho.save
                      if successInsumos == false
                        errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.OdenDespacho.Errores.no_puede_crearse_orden')} #{@solicitud.numero}")
                      end
                      casa_proveedora_id = plan.casa_proveedora_id
                   end


                  #----------- BUSCANDO INTEMS PARA EL DETALLE DEL DESEMBOLSO ---------------------
#                  @plan_inversion = PlanInversion.find(:all, :conditions=>["solicitud_id = ? and numero_desembolso = 1 and tipo_item = 'I'",@solicitud.id])
                  
                    total_insumos = total_insumos + plan.monto_financiamiento
                    orden_despacho_detalle = OrdenDespachoDetalle.new(
                        :orden_despacho_id=>orden_despacho.id,
                        :plan_inversion_id=>plan.id,
                        :item_nombre=>plan.item_nombre,
                        :unidad_medida_id=>plan.unidad_medida_id,
                        :cantidad=>plan.cantidad,
                        :costo_real=>plan.costo_real,
                        :monto_financiamiento=>plan.monto_financiamiento,
                        :monto_facturacion=>0,
                        :monto_recomendado=>0)

                   successDetalleInsumos = orden_despacho_detalle.save
                    if successDetalleInsumos == false
                      errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.OdenDespachoDetalle.Errores.no_puede_crearse_detalle')} #{@solicitud.numero}")
                    end
                    
                    orden_despacho.monto = total_insumos
                    orden_despacho.save
                  }
              end
            end   #=================> Fin if @prestamo.monto_insumos > 0


            #BUSQUEDA DE NUEVO ESTATUS DEPENDIENDO SI TIENE INSUMOS O BANCOS
            if @prestamo.monto_insumos > 0
              configuracion_avance = ConfiguracionAvance.find(:first, :conditions=>['estatus_origen_id = ? and condicionado = false',estatus_id_inicial])
              configuracion_avance.estatus_destino_id = 10090
            end

            if @prestamo.monto_banco > 0
              if @cuenta_bancaria == nil
                configuracion_avance = ConfiguracionAvance.find(:first, :conditions=>['estatus_origen_id = ? and condicionado = true',estatus_id_inicial])
              end
              if @cuenta_bancaria != nil
                configuracion_avance = ConfiguracionAvance.find(:first, :conditions=>['estatus_origen_id = ? and condicionado = false',estatus_id_inicial])
              end
            end   #===================> Fin if @prestamo.monto_banco > 0
          end    #=====================> Fin if @prestamo.monto_banco > 0 or @prestamo.monto_insumos > 0

          #----------- GUARDANDO CAMBIOS EN LA SOLICITUD---------------------
          estatus_id_final = configuracion_avance.estatus_destino_id
          @solicitud.estatus_id = estatus_id_final
          @solicitud.fecha_actual_estatus = format_fecha_inv(fecha_evento)
          successSol = @solicitud.save
          if !successSol
            self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.General.Excepciones.error_guardando_solicitud')} #{@solicitud.numero}")
          end


          #----------- GUARDANDO AVANCE DE SOLICITUD ---------------------
          successControl = ControlSolicitud.create_new(@solicitud.id, estatus_id_final, user.id, 'Avanzar', estatus_id_inicial, '')
          if !successControl
            self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.Prestamo.Errores.registro_traza_seguimiento')} #{@solicitud.numero}")
          end

          if  successSol == false or successControl == false or successDes == false or successDetalle == false or successInsumos == false or successDetalleInsumos == false
            success = false
            return success
          else
            success = true
          end

        end     #=====>  Fin del solicitudes.each do

        #----------- GUARDANDO TRANSACCION DEL FIDEICOMISO ---------------------
        if condiciones[:estado_id].to_s == '' or
            condiciones[:estado_id].to_s == '0'

          estado_id = nil
        else
          estado_id = condiciones[:estado_id].to_s
        end

        if condiciones[:sector_id].to_s == '' or
            condiciones[:sector_id].to_s == '0'

          sector_id = nil
        else
          sector_id = condiciones[:sector_id].to_s
        end

        if condiciones[:sub_sector_id]
          sub_sector_id = condiciones[:sub_sector_id].to_s
        else
          sub_sector_id = nil
        end

        if condiciones[:rubro_id].to_s == '' or condiciones[:rubro_id].to_s == '0'
          rubro_id = condiciones[:rubro_id].to_s
        else
          rubro_id = nil
        end

        if condiciones[:sub_rubro_id]

          sub_rubro_id = condiciones[:sub_rubro_id].to_s
        else
          sub_rubro_id = nil
        end

        if condiciones[:actividad_id].to_s == '' or
            condiciones[:actividad_id].to_s == '0'

          actividad_id = condiciones[:actividad_id].to_s
        else
          actividad_id = nil
        end

        if monto_bancos > 0 or
            monto_insumos > 0

          transaccion_fideicomiso = TransaccionFideicomiso.new()
          transaccion_fideicomiso.usuario_id = user.id
          transaccion_fideicomiso.fecha = Time.now
          transaccion_fideicomiso.estado_id = estado_id
          transaccion_fideicomiso.sector_id = sector_id
          transaccion_fideicomiso.sub_sector_id = sub_sector_id
          transaccion_fideicomiso.rubro_id = rubro_id
          #transaccion_fideicomiso.sub_rubro_id = sub_rubro_id
          #transaccion_fideicomiso.actividad_id = actividad_id
          transaccion_fideicomiso.cantidad_solicitudes = cantsolicitudes
          transaccion_fideicomiso.monto_banco = monto_bancos
          transaccion_fideicomiso.monto_insumo = monto_insumos
          transaccion_fideicomiso.monto_sras = monto_sras_total
          transaccion_fideicomiso.monto_gastos_admin = monto_gasto_total
          transaccion_fideicomiso.monto_total = prestamo_total
          transaccion_fideicomiso.solicitud_id = idssolicitudes


          successFid = transaccion_fideicomiso.save

          if !successFid
            self.errors.add(:solicitud, "#{I18n.t('Sistema.Body.Modelos.TransaccionFideicomiso.Errores.no_se_puede_actualizar')}")

            error = false
            raise Exception, I18n.t('Sistema.Body.Modelos.TransaccionFideicomiso.Errores.no_se_puede_actualizar_traza')
            success = false
            return success
          end

        end     # fin if monto_bancos > 0 or monto_insumos > 0

        return success

      end       #=======> Fin del transaction do

    rescue Exception => e
      return e.message #false
    end
  end

  def self.search(search, page, orden)
    paginate :per_page=>@records_by_page, :page=>page, :conditions=>search, :order=>orden, :include => [:sub_rubro, :actividad, :scoring_aceptacion, :comite, :estatus, :origen_fondo, :region, :unidad_produccion, :ciudad, :municipio, :parroquia, :causa_rechazo, :causa_diferimiento, :modalidad_financiamiento, :sector, :sub_sector, :rubro, :oficina, :cliente, :programa, :partida_presupuestaria]
  end

  #search para solicitud en el caso que se quiera agregar a la busqueda selects o joins
  def self.search_especial(search, page, orden, select, joins)

    conditions=search
    logger.info "Select in Model =======> #{select}"
    logger.info "Conditions ===> " << conditions.to_s
    logger.info "Joins in Model =====> #{joins}"
    paginate  :per_page=>@records_by_page, 
              :page=>page, 
              :conditions=>conditions,
              :select=>select,
              :joins=>joins, 
              :order=>orden
  end

  def self.search_cambio_estatus(search, page, orden, select, joins)

    conditions=search

    logger.info "Conditions ===> " << conditions.to_s
    paginate :per_page=>@records_by_page, :page=>page, :conditions=>conditions,:select=>select,:joins=>joins, :order=>orden
  end
end

# == Schema Information
#
# Table name: solicitud
#
#  id                                            :integer         not null, primary key
#  cliente_id                                    :integer         not null
#  numero                                        :integer         not null
#  programa_id                                   :integer         not null
#  fecha_solicitud                               :date            not null
#  fecha_registro                                :date
#  monto_solicitado                              :float
#  monto_aprobado                                :float
#  nombre_proyecto                               :string(400)
#  objetivo_proyecto                             :string(400)
#  justificacion                                 :text
#  aporte_social                                 :float
#  monto_propuesta_social                        :float
#  estatus                                       :string(1)
#  numero_comite_estadal                         :string(20)
#  numero_comite_nacional                        :string(15)
#  fecha_comite_estadal                          :date
#  fecha_comite_nacional                         :date
#  fecha_solicitud_desembolso                    :date
#  comentario_directorio                         :string(400)
#  causa_rechazo_id                              :integer
#  causa_diferimiento_id                         :integer
#  parroquia_id                                  :integer
#  ciudad_id                                     :integer
#  municipio_id                                  :integer
#  estatus_directorio                            :string(1)
#  intermediado                                  :boolean         default(FALSE)
#  modalidad_financiamiento_id                   :integer         not null
#  origen_fondo_id                               :integer         not null
#  porcentaje_cooperativa                        :float
#  porcentaje_empresa                            :float
#  monto_cliente                                 :float
#  liberada                                      :boolean         default(FALSE)
#  causa_liberacion                              :string(1)
#  aumento_capital                               :float
#  estatus_comite                                :string(1)       default("N")
#  estatus_modificacion                          :string(1)       default("N")
#  estatus_comite_temporal                       :string(1)       default("N")
#  causa_diferimiento_comite_id                  :integer
#  migrado_d3                                    :boolean         default(FALSE)
#  causa_rechazo_comite_id                       :integer
#  codigo_d3                                     :string(10)
#  codigo_presupuesto_d3                         :string(2)       default("00")
#  descripcion_presupuesto_d3                    :string(100)     default("-")
#  tipo_comite                                   :string(1)       default("D")
#  tir                                           :decimal(16, 2)  default(0.0)
#  van                                           :decimal(16, 2)  default(0.0)
#  tiempo_recuperacion                           :integer         default(0)
#  estatus_id                                    :integer
#  fecha_actual_estatus                          :date
#  fecha_firma_contrato                          :date
#  cuenta_matriz_id                              :integer
#  numero_origen                                 :integer
#  banco_origen                                  :string(25)
#  transcriptor                                  :string(25)
#  fecha_aprobacion                              :date
#  fecha_liquidacion                             :date
#  ups_id                                        :integer
#  observacion                                   :string(250)
#  numero_grupo                                  :integer
#  numero_empresa                                :integer
#  control                                       :boolean         default(FALSE)
#  mision_id                                     :integer
#  analista_consejo                              :string(25)
#  comite_id                                     :integer
#  decision_comite                               :string(1)
#  comentario_comite                             :string(400)
#  numero_acta_resumen_comite                    :string(15)
#  estatus_desembolso_id                         :integer         default(1)
#  control_certificacion                         :boolean
#  control_disponibilidad                        :boolean
#  numero_acta_liquidacion                       :string(15)
#  fecha_acta_liquidacion                        :date
#  region_id                                     :integer
#  certificado_presupuesto                       :boolean         default(FALSE)
#  monto_analista                                :float
#  scoring_aceptacion_id                         :integer
#  monto_actuales                                :float
#  monto_proyecto                                :float
#  calificacion_cuantitativa                     :float
#  calificacion_cualitativa                      :float
#  calificacion_social                           :float
#  destino_credito                               :string(400)
#  tipo_iniciativa_id                            :integer
#  usuario_pre_evaluacion                        :string(30)
#  partida_presupuestaria_id                     :integer
#  consultoria                                   :boolean
#  decision_final                                :boolean
#  confirmacion                                  :boolean         default(FALSE)
#  avaluo_obra_civil                             :boolean         default(FALSE)
#  usuario_resguardo                             :string(30)
#  reestructuracion_solicitud_id                 :integer(8)
#  monto_ampliacion                              :decimal(16, 2)
#  no_visto                                      :boolean
#  oficina_id                                    :integer         default(1), not null
#  unidad_produccion_id                          :integer
#  sector_id                                     :integer         default(0), not null
#  sub_sector_id                                 :integer         default(0), not null
#  rubro_id                                      :integer         default(0), not null
#  empresa_integrante_id                         :integer
#  instancia_comite                              :boolean
#  decision_comite_estadal                       :string(1)
#  decision_comite_nacional                      :string(1)
#  comite_estadal_id                             :integer
#  comentario_comite_estadal                     :text
#  comentario_comite_nacional                    :text
#  hectareas_recomendadas                        :decimal(14, 3)  default(0.0), not null
#  semovientes_recomendados                      :decimal(14, 2)  default(0.0), not null
#  folio_autenticacion                           :integer
#  tomo_autenticacion                            :integer
#  abogado_id                                    :integer
#  codigo_sras                                   :integer(8)      default(0)
#  enviado_suscripcion                           :boolean         default(FALSE)
#  ruta_contrato                                 :text
#  ruta_acta_entrega                             :text
#  ruta_nota_autenticacion                       :text
#  fecha_nota_autenticacion                      :date
#  hectareas_solicitadas                         :float
#  semovientes_solicitados                       :integer
#  por_inventario                                :boolean         default(FALSE)
#  fecha_a_entrega                               :date
#  conf_maquinaria                               :boolean         default(FALSE)
#  sub_rubro_id                                  :integer
#  actividad_id                                  :integer
#  fecha_hora_revocatoria_anulacion              :datetime
#  usuario_responsable_revocatoria_anulacion     :integer
#  justificacion_revocatoria_anulacion           :text
#  fecha_aprobacion_oficio_revocatoria_anulacion :date
#  numero_oficio_revocatoria_anulacion           :string(20)
#  causa_revocatoria_anulacion                   :integer
#  referencia_revocatoria_liquidacion            :string(100)
#  fecha_pago_revocatoria_liquidacion            :date
#  moneda_id                                     :integer         default(1), not null
#


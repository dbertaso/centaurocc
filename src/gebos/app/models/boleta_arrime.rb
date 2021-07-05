# encoding: utf-8

class BoletaArrime < ActiveRecord::Base

  self.table_name = 'boleta_arrime'
  
  attr_accessible :id,
    :solicitud_id,
    :silo_id,
    :cliente_id,
    :rubro_id,
    :hora_registro,
    :placa_vehiculo,
    :letra_cedula_conductor,
    :cedula_conductor,
    :nombre_conductor,
    :numero_ticket,
    :guia_movilizacion,
    :numero_acta,
    :causa,
    :clase,
    :resultado,
    :tecnico_campo_id,
    :fecha_entrada,
    :fecha_salida,
    :valor_total_entrada,
    :valor_total_salida,
    :peso_neto,
    :peso_acondicionado,
    :confirmacion,
    :fecha_confirmacion,
    :peso_vehiculo,
    :peso_remolque,
    :peso_vehiculo_salida,
    :peso_remolque_salida,
    :usuario_id,
    :estatus,
    :fecha_decision,
    :nro_acta_rechazo,
    :causa_rechazo,
    :arrime_conjunto,
    :valor_arrime,
    :peso_acondicionado_liquidar,
    :detalle_precio_gaceta_id,
    :conjunto_verificado,
    :sub_rubro_id,
    :actividad_id,
    :ciclo_productivo_id,
    :hora_entrada_silo,
    :hora_entrada_peso,
    :hora_salida_peso,
    :peso_tara,
    :peso_bruto,
    :secos,
    :total_secos,
    :total_kg,
    :condicion_saco_id,
    :mojados,
    :total_mojados,
    :total_sacos,
    :peso_ajustado,
    :porcentaje_aplicado_seco,
    :porcentaje_aplicado_mojado,
    :acta_silo_id,
    :humedos,
    :total_humedos,
    :porcentaje_aplicado_humedo,
    :detalle_convenio_silo_id,
    :hora_registro_f, 
    :fecha_entrada_f, 
    :peso_vehiculo_f, 
    :peso_remolque_f, 
    :valor_total_entrada_f, 
    :fecha_salida_f, 
    :peso_vehiculo_salida_f, 
    :peso_remolque_salida_f, 
    :valor_total_salida_f, 
    :peso_neto_f, 
    :peso_acondicionado_f, 
    :peso_acondicionado_liquidar_f,
    :peso_ajustado_f,
    :total_kg_f,
    :total_mojados_f,
    :total_humedos_f,
    :total_secos_f,
    :valor_arrime_fm,
    :descuento_f,
    :kilogramo_f,
    :peso_tara_f,
    :peso_bruto_f,
    :hora_salida_peso_f,
    :hora_entrada_peso_f,
    :hora_entrada_silo_f
    
    
  #has_many :arrime_conjunto  
  belongs_to :solicitud
  belongs_to :silo
  belongs_to :rubro
  belongs_to :cliente
  belongs_to :actividad
  belongs_to :ciclo_productivo



  validates :silo_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.Form.silo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :cliente_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.cliente')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :ciclo_productivo_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.ActaSilo.Etiquetas.ciclo_productivo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :placa_vehiculo, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.TecnicoCampo.Etiquetas.placa_vehiculo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 6..10, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.TecnicoCampo.Etiquetas.placa_vehiculo')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.TecnicoCampo.Etiquetas.placa_vehiculo')} #{I18n.t('errors.messages.too_long.other')}"}

  validates :guia_movilizacion, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.guia_movilizacion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :uniqueness =>{:uniqueness => true, :message => "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.guia_movilizacion')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"}

  validates :nombre_conductor, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Vistas.General.conductor')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :fecha_entrada, :presence => { 
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.fecha_entrada')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :date => {:if=>:fecha_entrada?, :message => I18n.t('Sistema.Body.Modelos.Errores.fecha_invalida'),
    :before => Proc.new { 1.day.from_now.to_date }, :message => I18n.t('Sistema.Body.Modelos.BoletaArrime.Errores.fecha_entrada')}

  validates :fecha_salida, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.fecha_salida')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :date => {:if=>:fecha_salida?, :message => I18n.t('Sistema.Body.Modelos.Errores.fecha_invalida')}
  
  validates :hora_entrada_silo, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.hora_entrada_silo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :hora_entrada_peso, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.hora_entrada_peso')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :hora_salida_peso, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.hora_salida_peso')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :peso_vehiculo, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.peso_vehiculo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :peso_remolque, :presence => {:allow_nil=>true,
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.peso_remolque')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :peso_vehiculo_salida_f, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.peso_vehiculo')} #{I18n.t('Sistema.Body.Vistas.General.salida')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
 
  validates :peso_remolque_salida, :presence => {:allow_nil=>true,
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.peso_remolque')} #{I18n.t('Sistema.Body.Vistas.General.salida')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :peso_neto, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.peso_neto')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :resultado, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.resultado')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :peso_acondicionado, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.peso_acondicionado')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :numero_ticket, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.numero_ticket')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
    #:numericality =>{:numericality => true, :if=>:numero_ticket?, :only_integer=>true, :message => "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.numero_ticket')} #{I18n.t('errors.messages.not_a_number')}" }    

  validates :letra_cedula_conductor, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nacionalidad')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :cedula_conductor, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.cedula')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 6..10, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.cedula')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.cedula')}  #{I18n.t('errors.messages.too_long.other')}"},
    :numericality =>{:numericality => true, :if=>:cedula_conductor?, :only_integer=>true, :message => I18n.t('Sistema.Body.Modelos.Errores.cedula_sin_decimales') }

  validates :numero_acta, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.ActaSilo.Etiquetas.numero_acta')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :valor_total_entrada, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.valor_total_entrada')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :valor_total_salida, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.valor_total_salida')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}


  def largo_f=(valor)
    self.largo = format_valor(valor)
  end

  def largo_f
    format_f(self.largo)
  end

  def fecha_salida_f=(fecha)
    self.fecha_salida = fecha
  end

  def fecha_salida_f
    format_fecha(self.fecha_salida)
  end


  def fecha_entrada_f=(fecha)
    self.fecha_entrada = fecha
  end

  def fecha_entrada_f
    format_fecha(self.fecha_entrada)
  end

  def hora_registro_f=(time)
    self.hora_registro = time
  end

  def hora_registro_f
    format_hora(self.hora_registro)
  end
  
  def hora_entrada_silo_f=(time)
    self.hora_entrada_silo = time
  end

  def hora_entrada_silo_f
    format_hora_arrime(self.hora_entrada_silo)
  end
  
  def hora_entrada_peso_f=(time)
    self.hora_entrada_peso = time
  end

  def hora_entrada_peso_f
    format_hora_arrime(self.hora_entrada_peso)
  end
  
  def hora_salida_peso_f=(time)
    self.hora_salida_peso = time
  end

  def hora_salida_peso_f
    format_hora_arrime(self.hora_salida_peso)
  end


  def peso_vehiculo_f=(valor)
    self.peso_vehiculo = valor
  end
  def peso_vehiculo_f
    if self.peso_vehiculo == 0
      return '0.00'
    else
      valor = format_p(self.peso_vehiculo)
      #valor = sprintf('%01.2f', self.peso_vehiculo)
      #valor.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
      return valor
    end
  end
  def peso_vehiculo_salida_f=(valor)
    self.peso_vehiculo_salida = valor
  end
  def peso_vehiculo_salida_f
    if self.peso_vehiculo_salida == 0
      return '0.00'
    else
      valor = format_p(self.peso_vehiculo_salida)
      #valor = sprintf('%01.2f', self.peso_vehiculo_salida)
      #valor.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
      return valor
    end
  end

  def peso_remolque_f=(valor)
    self.peso_remolque = valor
  end
  def peso_remolque_f
    if self.peso_remolque == 0
      return '0.00'
    else
      valor = format_p(self.peso_remolque)
      #valor = sprintf('%01.2f', self.peso_remolque)
      #valor.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.") 
      return valor
    end
  end
  def peso_remolque_salida_f=(valor)
    self.peso_remolque_salida = valor
  end
  def peso_remolque_salida_f
    if self.peso_remolque_salida == 0
      return '0.00'
    else
      valor = format_p(self.peso_remolque_salida)
      #valor = sprintf('%01.2f', self.peso_remolque_salida)
      #valor.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.") 
      return valor
    end
  end

  def peso_neto_f=(valor)
    self.peso_neto = valor
  end
  def peso_neto_f
    if self.peso_neto == 0 || self.peso_neto.nil?
      return '0.00'
    else
      valor = format_p(self.peso_neto)
      #valor = sprintf('%01.2f', self.peso_neto)
      #valor.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
      return valor
    end
  end

  def peso_bruto_f=(valor)
    self.peso_bruto = valor
  end
  
  def peso_bruto_f
    if self.peso_bruto == 0 || self.peso_bruto.nil?
      return '0.00'
    else
      valor = format_p(self.peso_bruto)
      #valor = sprintf('%01.2f', self.peso_bruto)
      #valor.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
      return valor
    end
  end
  
  def peso_tara_f=(valor)
    self.peso_tara = valor
  end
  
  def peso_tara_f
    if self.peso_tara == 0 || self.peso_tara.nil?
      return '0.00'
    else
      valor = format_p(self.peso_tara)
      #valor = sprintf('%01.2f', self.peso_tara)
      #valor.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
      return valor
    end
  end
  
  def kilogramo_f=(valor)
    self.kilogramo = valor
  end
  
  def kilogramo_f
    if self.kilogramo == 0 || self.kilogramo.nil?
      return '0.00'
    else
      valor = format_p(self.kilogramo)
#      valor = sprintf('%01.2f', self.kilogramo)
#      valor.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
      return valor
    end
  end
  
  def descuento_f=(valor)
    self.descuento = valor
  end
  
  def descuento_f
    if self.descuento == 0 || self.descuento.nil?
      return '0.00'
    else
      valor = format_p(self.descuento)
#      valor = sprintf('%01.2f', self.descuento)
#      valor.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
      return valor
    end
  end


  def peso_acondicionado_f=(valor)
    self.peso_acondicionado = valor
  end
  def peso_acondicionado_f
    if self.peso_acondicionado == 0 || self.peso_acondicionado.nil?
      return '0.00'
    else
      valor = format_p(self.peso_acondicionado)
      #valor = sprintf('%01.2f', self.peso_acondicionado)
      #valor.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
    end
  end

  def peso_acondicionado_liquidar_f=(valor)
    self.peso_acondicionado_liquidar = valor
  end
  def peso_acondicionado_liquidar_f
    if self.peso_acondicionado_liquidar == 0 || self.peso_acondicionado_liquidar.nil?
      return '0.00'
    else
      valor = format_p(self.peso_acondicionado_liquidar)
      #valor = sprintf('%01.2f', self.peso_acondicionado_liquidar)
      #valor.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
      return valor
    end
  end

  def valor_total_entrada_f=(valor)
    self.valor_total_entrada = valor
  end
  def valor_total_entrada_f
    if self.valor_total_entrada == 0 || self.valor_total_entrada.nil?
      return '0.00'
    else
      valor = format_p(self.valor_total_entrada)
      #valor = sprintf('%01.2f', self.valor_total_entrada)
      #valor.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
      return valor
    end
  end


  def valor_arrime_fm
    if self.valor_arrime.nil?
      return '0.00'
    else
      valor = format_p(self.valor_arrime)
#      valor = sprintf('%01.2f', self.valor_arrime)
#      valor.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
      return valor
    end
  end

  def valor_total_salida_f=(valor)
    self.valor_total_salida = valor
  end
  def valor_total_salida_f
    if self.valor_total_salida == 0 || self.valor_total_salida.nil?
      return '0.00'
    else
      valor = format_p(self.valor_total_salida)
#      valor = sprintf('%01.2f', self.valor_total_salida)
#      valor.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
      return valor
    end
  end
  
  
  def total_secos_f=(valor)
    self.total_secos = valor
  end
  def total_secos_f
    if self.total_secos == 0 || self.total_secos.nil?
      return '0.00'
    else
      valor = format_p(self.total_secos)
#      valor = sprintf('%01.2f', self.total_secos)
#      valor.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
      return valor
    end
  end
  
  def total_humedos_f=(valor)
    self.total_humedos = valor
  end
  def total_humedos_f
    if self.total_humedos == 0 || self.total_humedos.nil?
      return '0.00'
    else
      valor = format_p(self.total_humedos)
#      valor = sprintf('%01.2f', self.total_humedos)
#      valor.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
      return valor
    end
  end
  
  def total_mojados_f=(valor)
    self.total_mojados = valor
  end
  def total_mojados_f
    if self.total_mojados == 0 || self.total_mojados.nil?
      return '0.00'
    else
      valor = format_p(self.total_mojados)
#      valor = sprintf('%01.2f', self.total_mojados)
#      valor.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
      return valor
    end
  end
  
  def total_kg_f=(valor)
    self.total_kg = valor
  end
  def total_kg_f
    if self.total_kg == 0 || self.total_kg.nil?
      return '0.00'
    else
      valor = format_p(self.total_kg)
#      valor = sprintf('%01.2f', self.total_kg)
#      valor.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
      return valor
    end
  end
  
  def peso_ajustado_f=(valor)
    self.peso_ajustado = valor
  end
  def peso_ajustado_f
    if self.peso_ajustado == 0 || self.peso_ajustado.nil?
      return '0.00'
    else
      valor = format_p(self.peso_ajustado)
#      valor = sprintf('%01.2f', self.peso_ajustado)
#      valor.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
      return valor
    end
  end

  validates :fecha_entrada, :if=>:fecha_entrada?,
    :date=>{:message => "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.fecha_entrada')} #{I18n.t('Sistema.Body.Modelos.Errores.fecha_invalida')}",
    :before => Proc.new { 1.day.from_now.to_date }, :before_message => I18n.t('Sistema.Body.Modelos.BoletaArrime.Errores.fecha_entrada')}
  
  validates :fecha_salida, :if=>:fecha_salida?,
    :date=>{:message => "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.fecha_salida')} #{I18n.t('Sistema.Body.Modelos.Errores.fecha_invalida')}"}

  before_save :antes_guardar
  #def before_save
  def antes_guardar
    if self.id.nil?
      numero_ticket = BoletaArrime.find_by_numero_ticket_and_silo_id(self.numero_ticket, self.silo_id)
      unless numero_ticket.nil?
        errors.add(:boleta_arrime,"#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.numero_ticket')} #{I18n.t('Sistema.Body.Modelos.BoletaArrime.Errores.ya_registrado')}")
        return false
      end
    end
    ### bloque de algodon
    rubro = Rubro.find(self.rubro_id)
    if rubro.nombre.downcase.match('algodon').to_s.length > 0
      actividad = Actividad.find(self.actividad_id)
      if actividad.nombre.downcase.match('semilla').to_s.length > 0 
        unless self.peso_neto >= self.peso_acondicionado
          errors.add(:boleta_arrime, I18n.t('Sistema.Body.Modelos.BoletaArrime.Errores.peso_ajustado_mayor_peso_neto'))
          return false
        end
      else
        unless self.peso_neto > self.peso_acondicionado
          errors.add(:boleta_arrime,  I18n.t('Sistema.Body.Modelos.BoletaArrime.Errores.peso_bruto_mayor_peso_neto'))
          return false
        end
      end
      unless self.peso_bruto > self.peso_neto
        errors.add(:boleta_arrime, I18n.t('Sistema.Body.Modelos.BoletaArrime.Errores.peso_sin_descuento_mayor_peso_bruto'))
        return false
      end
            
      if self.total_sacos.nil? || self.total_sacos.blank?
        errors.add(:boleta_arrime, "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.cantidad_total_sacos')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
      end
      if self.total_kg.nil? || self.total_kg.blank?
        errors.add(:boleta_arrime, "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.cantidad_total_kilogramos')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
      end
      if self.peso_neto.nil? || self.peso_neto.blank?
        errors.add(:boleta_arrime, "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.peso_bruto_ajustado')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
      end
      unless self.peso_neto.nil? || self.peso_neto.blank?
        if self.peso_neto > self.peso_bruto
          errors.add(:boleta_arrime, I18n.t('Sistema.Body.Modelos.BoletaArrime.Errores.peso_bruto_ajustado_menor_peso_sin_descuento'))
        end
      end
      if self.peso_acondicionado.nil? || self.peso_acondicionado.blank?
        errors.add(:boleta_arrime, "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.peso_neto')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
      end
    else
      unless self.peso_neto > self.peso_acondicionado
        errors.add(:boleta_arrime, I18n.t('Sistema.Body.Modelos.BoletaArrime.Errores.peso_neto_mayor_peso_acondicionado'))
      end
    end
    #### fin bloque algodon  
    
    ### Validaciones de hora
    if self.hora_registro.nil? || self.hora_registro.blank?
      errors.add(:boleta_arrime, I18n.t('Sistema.Body.Modelos.BoletaArrime.Errores.formato_hora_registro'))
      #return false
    end
    if (format_hora_arrime(self.hora_entrada_silo) == "12:00:00; AM")
      errors.add(:boleta_arrime, I18n.t('Sistema.Body.Modelos.BoletaArrime.Errores.formato_hora_entrada_silo'))
      #return false
    end 
    if format_hora_arrime(self.hora_entrada_peso) == "12:00:00; AM"
      errors.add(:boleta_arrime, I18n.t('Sistema.Body.Modelos.BoletaArrime.Errores.formato_hora_entrada_peso'))
      #return false
    end
    
    if format_hora_arrime(self.hora_salida_peso) == "12:00:00; AM"
      errors.add(:boleta_arrime, I18n.t('Sistema.Body.Modelos.BoletaArrime.Errores.formato_hora_salida_peso'))
      #return false
    end
    #### fin hora
   
    unless self.cedula_conductor.to_s.split('').length > 5
      errors.add(:boleta_arrime, I18n.t('Sistema.Body.Modelos.BoletaArrime.Errores.cedula_conductor_mayor_a_cinco'))
      return false
    end
    unless self.id.nil?
      numero_ticket = BoletaArrime.count(:conditions=>["silo_id = #{self.silo_id} and numero_ticket = '#{self.numero_ticket}' and id <> #{self.id}"])
      if numero_ticket > 0
        errors.add(:boleta_arrime, I18n.t('Sistema.Body.Modelos.BoletaArrime.Errores.ticket_ya_existe'))
        return false
      end
    end
    unless (self.fecha_salida.nil? and self.fecha_entrada.nil?)
      if self.fecha_salida < self.fecha_entrada
        errors.add(:boleta_arrime,I18n.t('Sistema.Body.Modelos.BoletaArrime.Errores.fecha_salida_menor_fecha_entrada'))
        return false
      end
    end
    
    unless self.id.nil?
      numero_ticket = BoletaArrime.count(:conditions=>["silo_id = #{self.silo_id} and numero_ticket = '#{self.numero_ticket}' and id <> #{self.id}"])
      if numero_ticket > 0
        errors.add(:boleta_arrime,"#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.numero_ticket')} #{I18n.t('Sistema.Body.Modelos.BoletaArrime.Errores.ya_registrado')}")
        return false
      end
    end

    #rubro = Rubro.find(self.rubro_id)
    if ((self.peso_acondicionado_liquidar.to_i) <= (self.peso_acondicionado.to_i)) and (rubro.nombre.downcase.match('arroz').to_s.length > 0)
      errors.add(:boleta_arrime, I18n.t('Sistema.Body.Modelos.BoletaArrime.Errores.peso_acondicionado_liquidar_mayor_peso_acondicionado'))
      return false
    end
    if ((self.peso_acondicionado_liquidar) > (self.peso_neto)) and (rubro.nombre.downcase.match('arroz').to_s.length > 0)
      errors.add(:boleta_arrime, I18n.t('Sistema.Body.Modelos.BoletaArrime.Errores.peso_acondicionado_liquidar_menor_peso_neto'))
      return false
    end

    if self.resultado == 'A'
      logger.info"XXXXXXXXXX********************* Valor Arrime" << self.valor_arrime.to_s
      unless self.valor_arrime.to_s > "0.00"
        errors.add(:boleta_arrime, "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.valor_arrime')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
        return false
      end
    end
    if (self.resultado == 'R' and self.nro_acta_rechazo.to_s.empty?)
      errors.add(:boleta_arrime, "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.nro_acta_rechazo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
      return false
    end
    if ((self.resultado == 'R') and (self.causa_rechazo.to_s.empty?))
      errors.add(:boleta_arrime, "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.causa_rechazo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
      return false
    end

    unless errors.blank?
      return false
    end

    placa_vehiculo = eliminar_acentos(self.placa_vehiculo)
    self.placa_vehiculo = placa_vehiculo.upcase
    nombre_conductor = eliminar_acentos(self.nombre_conductor)
    self.nombre_conductor = nombre_conductor.upcase
    guia_movilizacion = eliminar_acentos(self.guia_movilizacion)
    self.guia_movilizacion = guia_movilizacion.upcase

  end
  
  # transaccion de Diego
  def BoletaArrime.iniciar_transaccion(nombre_transaccion,usuario, monto)


    logger.info "NOMBRE TRANSACCION #{nombre_transaccion}"
    logger.info "USUARIO #{usuario}"
    
    
    fecha = Time.now.strftime('%Y-%m-%d %H:%M:%S')
    meta = MetaTransaccion.find_by_nombre(nombre_transaccion)
   
    transaccion = Transaccion.new
    
    if nombre_transaccion == 'p_dummy'
      transaccion.reversada = true
    end
    
    transaccion.prestamo_id = 0
    transaccion.meta_transaccion_id = meta.id
    transaccion.usuario_id = usuario
    transaccion.fecha = fecha
    transaccion.tipo = 'L'
    transaccion.descripcion = meta.descripcion
    transaccion.monto = monto
    transaccion.save
    
    if transaccion.errors.count > 0 
      @msg = transaccion.errors.full_message.to_s
      return @msg
    else
      @transaccion_id = transaccion.id
      return @transaccion_id
    end
  
  end
  # fin transaccion diego

  def self.create(parametros, rubro_id, actividad_id, sub_rubro_id, solicitud_id, cliente_id, laboratorio, parametros_laboratorio)
    begin
      boleta_arrime = BoletaArrime.new(parametros)
      boleta_arrime.solicitud_id = solicitud_id
      boleta_arrime.rubro_id = rubro_id
      boleta_arrime.sub_rubro_id = sub_rubro_id
      boleta_arrime.actividad_id = actividad_id
      boleta_arrime.cliente_id = cliente_id

      if laboratorio.nil?
        boleta_laboratorio = nil
      else
        laboratorio = laboratorio.constantize
        boleta_laboratorio = laboratorio.new(parametros_laboratorio)
      end

      transaction do
        boleta_arrime.save!
        unless boleta_laboratorio.nil?
          boleta_laboratorio.boleta_arrime_id = boleta_arrime.id
          boleta_laboratorio.save!
        end
        return boleta_arrime
      end
      
    rescue Exception => e
      logger.error e.message
      logger.error e.backtrace.join("\n")
      logger.info "XXXXX==========E======>>>>>>"<<e.inspect
      
      errores = ''
      boleta_arrime.errors.full_messages.each { |e|
        errores << "<li>" + e + "</li>"
      }
      unless boleta_laboratorio.nil?
        boleta_laboratorio.errors.full_messages.each{ |e|
          errores << "<li>" + e + "</li>"
        }
      end
      return errores
    end
  end


  def self.update(parametros, laboratorio, parametros_laboratorio, id)
    begin
      boleta = BoletaArrime.find(id)

      if laboratorio.nil?
        boleta_laboratorio = nil
      else
        laboratorio = laboratorio.constantize
        boleta_laboratorio = laboratorio.find_by_boleta_arrime_id(id)
      end

      transaction do
        value = boleta.update_attributes(parametros)
        if !value
          errores = ''
          boleta.errors.full_messages.each { |e|
            errores << "<li>" + e + "</li>"
          }
          return errores
        end
        unless boleta_laboratorio.nil?
          value_laboratorio = boleta_laboratorio.update_attributes(parametros_laboratorio)
          if value_laboratorio == false
            errores = ''
            boleta_laboratorio.full_messages.errors.each { |e|
              errores << "<li>" + e + "</li>"
            }
            return errores
          end
        end
      end
    rescue Exception => e
      logger.error e.message
      logger.error e.backtrace.join("\n")
    end
    return boleta
  end

  ## metodo de contabilizar de Diego
  def BoletaArrime.contabilizar(solicitud, monto, fecha,transaccion_id,tipo_transaccion)

    fuente_recursos_id = 0
    logger.info "Fecha cierre: =====> " << fecha.to_s
    
    cliente = Cliente.find(solicitud.cliente_id)
    cuenta = CuentaBancaria.find_by_cliente_id_and_activo(cliente.id,true)
    logger.info "***CUENTA*** =======> #{cuenta.inspect}"
    
    prestamo = Prestamo.find_by_solicitud_id(solicitud.id)
    logger.info "***ORIGEN*** =======> #{prestamo.banco_origen.to_s}"
    case prestamo.banco_origen
    when 'FONDAS'
      fuente_recursos_id = 1
    when 'AGROVENEZUELA'
      fuente_recursos_id = 2
    when 'FONDAFA'
      fuente_recursos_id = 3
    else
      fuente_recursos_id = 1
    end
    
    modalidad_pago = 'X'.to_s
    estatus = 'X'.to_s
    logger.info "Banco Origen ======> #{prestamo.banco_origen}"
    logger.info "fuente_recursos_id =======> #{fuente_recursos_id.to_s}"
    fechapre = fecha.split("/")
    logger.info "Fechapre =======> #{fechapre.to_s}"
    fechapro = Date.new(fechapre[0].to_i, fechapre[1].to_i, fechapre[2].to_i)
    tipo_transaccion = tipo_transaccion
    voucher = fecha.to_s + "-" + solicitud.numero.to_s
    entidad_financiera = 0
    anio = fechapro.strftime("%Y").to_i
    banco = "Pago en Cheque"
    banco = cuenta.entidad_financiera.nombre.to_s unless cuenta.nil?
    cliente = cliente.nombre.to_s
    numero_prestamo = prestamo.numero.to_s
    prestamo_id = prestamo.id.to_i
    factura_id = solicitud.id.to_i
    
    logger.info "Clase =====> #{self.class.to_s}"
    
    logger.info "factura_id =========> #{solicitud.id.to_s}"
    
    logger.info "Self ===============> #{self.inspect}"
    
    params = {:p_transaccion_contable_id=>22,
      :p_modalidad=>"X".to_s,
      :p_fuente_recursos_id=>fuente_recursos_id.to_i,
      :p_programa_id=> solicitud.programa_id.to_i,
      :p_estatus=>"X".to_s,
      :p_entidad_financiera_id=>entidad_financiera,
      :p_monto_pago=>monto,
      :p_monto_ingreso_intereses=>0.00,
      :p_monto_por_cobrar_intereses=>0.00,
      :p_remanente_por_aplicar=>0.00,
      :p_monto_capital_cuota=>0.00,
      :p_ingreso_mora=>0.00,
      :p_remanente_por_aplicar_inicial=>0.00,
      :p_monto_comision_intereses=>0.00,
      :p_interes_diferido=>0.00,
      :p_monto_gasto=>0.00,
      :p_monto_sras=>0.00,
      :p_monto_excedente=>0.00,
      :p_monto_desembolso=>0.00,
      :p_monto_boleta=>monto,
      :p_fecha_registro => fechapro.strftime("%Y-%m-%d").to_s,
      :p_fecha_comprobante => fechapro.strftime("%Y-%m-%d").to_s,
      :p_prestamo_id => prestamo_id,
      :p_factura_id => factura_id,
      :p_anio => anio,
      :p_voucher => voucher.to_s,
      :p_banco => banco.to_s,
      :p_nombre => cliente.to_s,
      :p_tipo_transaccion => tipo_transaccion.to_s,
      :p_prestamo => numero_prestamo.to_s,
      :p_reestructurado => prestamo.reestructurado.to_s,
      :p_transaccion_id => transaccion_id.to_i         
              
    }

    begin

      transaction do
        execute_sp('registro_contable',  params.values_at(:p_transaccion_contable_id,
            :p_modalidad,
            :p_fuente_recursos_id,
            :p_programa_id,
            :p_estatus,
            :p_entidad_financiera_id,
            :p_monto_pago,
            :p_monto_ingreso_intereses,
            :p_monto_por_cobrar_intereses,
            :p_remanente_por_aplicar,
            :p_monto_capital_cuota,
            :p_ingreso_mora,
            :p_remanente_por_aplicar_inicial,
            :p_monto_comision_intereses,
            :p_interes_diferido,
            :p_monto_gasto,
            :p_monto_sras,
            :p_monto_excedente,
            :p_monto_desembolso,
            :p_monto_boleta,
            :p_fecha_registro,
            :p_fecha_comprobante,
            :p_prestamo_id,
            :p_factura_id,
            :p_anio,
            :p_voucher,
            :p_banco,
            :p_nombre,
            :p_tipo_transaccion,
            :p_prestamo,
            :p_reestructurado,
            :p_transaccion_id))
        return true
      end

    end

  end

  ## Fin contabilizar de Diego
  
  def self.check(parametros, cliente_ci)
    unless parametros.arrime_conjunto == false || parametros.arrime_conjunto.nil?
      productor_ci = ArrimeConjunto.find_by_sql("select count(cedula_conjunto) as ci from view_arrime_conjunto where
                                                        boleta_arrime_id = #{parametros.id} and cedula_conjunto = '#{cliente_ci}'")
      cont_ci = productor_ci.map { |e| e.ci.to_s }
      total_acondicionado = ArrimeConjunto.find_by_sql("select sum(peso_condicionado) as total_peso_acondicionado from arrime_conjunto where boleta_arrime_id = #{parametros.id}")
      valor = total_acondicionado.map{|e| e.total_peso_acondicionado.to_f}
      unless valor[0].to_f == parametros.peso_acondicionado.to_f
        errores = ''
        errores << "<li> #{I18n.t('Sistema.Body.Modelos.BoletaArrime.Errores.verifique_total_peso_acondicionado')} </li>"
        return errores
      end
      unless cont_ci[0].to_i == 1
        errores = ''
        errores << "<li> #{I18n.t('Sistema.Body.Modelos.BoletaArrime.Errores.productor_debe_ser_registrado')} </li>"
        return errores
      end
    end
    return true
  end
  
  ## validacion para confirmar
  def self.check_confirmar(parametros, cliente_ci)
      
    unless parametros.arrime_conjunto == false || parametros.arrime_conjunto.nil?
      productor_ci = ArrimeConjunto.find_by_sql("select count(cedula_conjunto) as ci from view_arrime_conjunto where
                                                        boleta_arrime_id = #{parametros.id} and cedula_conjunto = '#{cliente_ci}'")
      cont_ci = productor_ci.map { |e| e.ci.to_s }
      total_acondicionado = ArrimeConjunto.find_by_sql("select sum(peso_condicionado) as total_peso_acondicionado from arrime_conjunto where boleta_arrime_id = #{parametros.id}")
      valor = total_acondicionado.map{|e| e.total_peso_acondicionado.to_f}
      unless valor[0].to_f == parametros.peso_acondicionado.to_f
        errores = ''
        errores << "<li> #{I18n.t('Sistema.Body.Modelos.BoletaArrime.Errores.verifique_datos_arrime_conjunto')} </li>"
        return errores
      end
      unless cont_ci[0].to_i == 1
        errores = ''
        errores << "<li> #{I18n.t('Sistema.Body.Modelos.BoletaArrime.Errores.verifique_datos_arrime_conjunto')} </li>"
        return errores
      end
    end
    return true
  end
  ## fin validacion


  #  def self.confirmacion(id, parametros)
  #    boleta = BoletaArrime.find(id)
  #    value = boleta.update_attributes(parametros)
  #    if !value
  #      errores = ''
  #      boleta.errors.full_messages.each { |e|
  #        errores << "<li>" + e + "</li>"
  #      }
  #      return errores
  #    end
  #    return true
  #  end

  def self.confirmacion(id, parametros)
  logger.info"XXXXXXX=================antes-solicitud=============>>>>"<<parametros.inspect
    begin
      transaction do
        boleta = BoletaArrime.find(id)
        logger.info "XXXXXXX=================antes-solicitud=============>>>>"<<boleta.inspect
        @transaccion_id = BoletaArrime.iniciar_transaccion('p_confirmacion_boleta',parametros["usuario_id"], boleta.valor_arrime)
        logger.info "Transacción==============================>>>>#{@transaccion_id.to_s}"

        unless boleta.nil?
          logger.info "Actualizando Boleta"
          value = boleta.update_attributes(parametros)
          if !value
            errores = ''
            boleta.errors.full_messages.each { |e|
              errores += "<li>" + e.to_s + "</li>"
            }
            return errores
          end
    logger.info"XXXXXXX=================antes-solicitud=============>>>>"<<boleta.inspect
          solicitud = Solicitud.find(boleta.solicitud_id)
          logger.info "Inicia proceso de contabilidad"
          result = BoletaArrime.contabilizar(solicitud, boleta.valor_arrime,parametros["fecha_confirmacion"],@transaccion_id,'Confirmación de Boleta de Arrime')
          BoletaArrime.iniciar_transaccion('p_dummy',parametros["usuario_id"], 0)
          return true
        else
          raise ActiveRecord::Rollback
        end
      end
    rescue Exception => e
      errores = "<li>" + e.message + "</li>"
      logger.info "errores---- =========> #{errores.to_s}"
      return false
    end
  end
  
  

  def BoletaArrime.instruccion_pago(boletas,usuario_id) 

    if boletas.empty?
      return 10000
    end

    id = ''
    begin

      transaction do

        boletas.each do |boleta|

          boleta_arrime = BoletaArrime.find(boleta.to_i)

          if boleta_arrime.nil?

            return 10100  # No existe boleta arrime
          end

          prestamo = Prestamo.find_by_solicitud_id(boleta_arrime.solicitud_id)

          if prestamo.nil?

            return 10200  #Prestamo no existe
          end


          prestamo.fecha_instruccion_pago = Time.now.strftime(I18n.t('time.formats.gebos_inverted'))

          prestamo.instruccion_pago = true
          prestamo.save

          prestamo.ejecutar_pago_arrime(usuario_id, boleta_arrime.id)

          id = id << boleta.to_s << ','

        end
      end

    end

    return 0, id
  end

  def eliminar_acentos(nombre)
    nombre = nombre.to_s
    nombre.downcase!
    nombre.gsub!(/[á|Á]/,'a')
    nombre.gsub!(/[é|É]/,'e')
    nombre.gsub!(/[í|Í]/,'i')
    nombre.gsub!(/[ó|Ó]/,'o')
    nombre.gsub!(/[ú|Ú]/,'u')
    return nombre
  end

  def self.delete(id)
    begin
      boleta = BoletaArrime.find(id)
      rubro = boleta.actividad.sub_rubro.rubro.nombre.to_s
      if rubro.downcase.match('arroz').to_s.length > 0
        laboratorio = BoletaLaboratorioArroz.find_by_boleta_arrime_id(id)
      elsif rubro.downcase.match('sorgo').to_s.length > 0
        laboratorio = BoletaLaboratorioSorgo.find_by_boleta_arrime_id(id)
      elsif rubro.downcase.match('maiz').to_s.length > 0
        laboratorio = BoletaLaboratorioMaiz.find_by_boleta_arrime_id(id) 
      elsif rubro.downcase.match('algodon').to_s.length > 0
        if boleta.actividad.nombre.downcase.match('semilla').to_s.length > 0
          laboratorio = nil
        else 
          laboratorio = BoletaLaboratorioAlgodon.find_by_boleta_arrime_id(id)
        end
      end
      
      unless boleta.arrime_conjunto == false || boleta.arrime_conjunto.nil?
        conjunto = ArrimeConjunto.find_by_boleta_arrime_id(boleta.id)
      else
        conjunto = nil
      end
      transaction do
        unless conjunto.nil?
          value = conjunto.destroy
          if !value
            errores = ''
            conjunto.errors.full_messages.each { |e|
              errores << "<li>" + e + "</li>"
            }
            return errores
          end
        end
        unless laboratorio.nil?
          value = laboratorio.destroy
          if !value
            errores = ''
            laboratorio.errors.full_messages.each { |e|
              errores << "<li>" + e + "</li>"
            }
            return errores
          end
        end
        boleta.destroy
        if !boleta
          errores = ''
          boleta.errors.full_messages.each { |e|
            errores << "<li>" + e + "</li>"
          }
          return errores
        else
          return true
        end
      end
    rescue=>detail
      unless laboratorio.nil?
        errores = ''
        laboratorio.errors.full_messages.each { |e|
          errores << "<li>" + e + "</li>"
        }
      end
      unless conjunto.nil?
        conjunto.errors.full_messages.each{ |e|
          errores << "<li>" + e + "</li>"
        }
      end
      unless boleta.nil?
        boleta.errors.full_messages.each{ |e|
          errores << "<li>" + e + "</li>"
        }
      end
      return errores
    end
  end


  
  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort,
      :select=>'boleta_arrime.*'
  end
  
  

end

# == Schema Information
#
# Table name: boleta_arrime
#
#  id                          :integer         not null, primary key
#  solicitud_id                :integer         not null
#  silo_id                     :integer         not null
#  cliente_id                  :integer         not null
#  rubro_id                    :integer         not null
#  hora_registro               :time
#  placa_vehiculo              :string(15)      not null
#  letra_cedula_conductor      :string(1)       not null
#  cedula_conductor            :integer         not null
#  nombre_conductor            :string(100)     not null
#  numero_ticket               :string(15)      not null
#  guia_movilizacion           :string(20)      not null
#  numero_acta                 :string(20)      not null
#  causa                       :text
#  clase                       :string(1)
#  resultado                   :string(30)
#  tecnico_campo_id            :integer
#  fecha_entrada               :date            not null
#  fecha_salida                :date            not null
#  valor_total_entrada         :decimal(16, 2)
#  valor_total_salida          :decimal(16, 2)
#  peso_neto                   :decimal(16, 2)
#  peso_acondicionado          :decimal(16, 2)
#  confirmacion                :boolean         default(FALSE), not null
#  fecha_confirmacion          :date
#  peso_vehiculo               :decimal(16, 2)  default(0.0)
#  peso_remolque               :decimal(16, 2)  default(0.0)
#  peso_vehiculo_salida        :decimal(16, 2)  default(0.0)
#  peso_remolque_salida        :decimal(16, 2)  default(0.0)
#  usuario_id                  :integer
#  estatus                     :string(1)
#  fecha_decision              :date
#  nro_acta_rechazo            :string(15)
#  causa_rechazo               :string(255)
#  arrime_conjunto             :boolean
#  valor_arrime                :decimal(16, 2)
#  peso_acondicionado_liquidar :decimal(16, 2)  default(0.0)
#  detalle_precio_gaceta_id    :integer
#  conjunto_verificado         :boolean         default(FALSE), not null
#  sub_rubro_id                :integer
#  actividad_id                :integer
#  ciclo_productivo_id         :integer
#  hora_entrada_silo           :time
#  hora_entrada_peso           :time
#  hora_salida_peso            :time
#  peso_tara                   :decimal(16, 2)  default(0.0)
#  peso_bruto                  :decimal(16, 2)  default(0.0)
#  secos                       :integer
#  total_secos                 :decimal(16, 2)  default(0.0)
#  total_kg                    :decimal(16, 2)  default(0.0)
#  condicion_saco_id           :integer
#  mojados                     :integer
#  total_mojados               :decimal(16, 2)  default(0.0)
#  total_sacos                 :integer
#  peso_ajustado               :decimal(16, 2)  default(0.0)
#  porcentaje_aplicado_seco    :decimal(16, 2)  default(0.0)
#  porcentaje_aplicado_mojado  :decimal(16, 2)  default(0.0)
#  acta_silo_id                :integer
#  humedos                     :integer
#  total_humedos               :decimal(16, 2)  default(0.0)
#  porcentaje_aplicado_humedo  :decimal(16, 2)  default(0.0)
#  detalle_convenio_silo_id    :integer
#


# encoding: utf-8
class OtroArrime < ActiveRecord::Base

  self.table_name = 'otro_arrime'
  
  attr_accessible   :id,
    :solicitud_id,
    :silo_id,
    :cliente_id,
    :actividad_id,
    :hora_registro,
    :placa_vehiculo,
    :letra_cedula_conductor,
    :cedula_conductor,
    :nombre_conductor,
    :numero_ticket,
    :guia_movilizacion,
    :observacion,
    :clase,
    :resultado,
    :fecha_entrada,
    :fecha_salida,
    :valor_total_entrada,
    :valor_total_salida,
    :peso_neto,
    :peso_acondicionado,
    :peso_vehiculo,
    :peso_remolque,
    :peso_vehiculo_salida,
    :peso_remolque_salida,
    :confirmacion,
    :fecha_confirmacion,
    :estatus,
    :monto_arrime,
    :usuario_id,
    :fecha_decision,
    :nro_acta_rechazo,
    :causa_rechazo,
    :fecha_entrada_f,
    :fecha_salida_f

  
  has_many :arrime_conjunto
  belongs_to :solicitud
  belongs_to :silo
  belongs_to :actividad
  belongs_to :cliente


  validates :silo_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.Form.silo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :cliente_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.cliente')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :placa_vehiculo, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.TecnicoCampo.Etiquetas.placa_vehiculo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 5..7, :allow_blank => false,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.TecnicoCampo.Etiquetas.placa_vehiculo')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.TecnicoCampo.Etiquetas.placa_vehiculo')}  #{I18n.t('errors.messages.too_long.other')}"}

  validates :guia_movilizacion, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.guia_movilizacion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :uniqueness =>{:uniqueness => true, :message => "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.guia_movilizacion')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"}
  
  validates :nombre_conductor, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Vistas.General.conductor')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 3..100, :allow_blank => false,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.nombre')}  #{I18n.t('errors.messages.too_long.other')}"}
  
  validates :fecha_entrada, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.fecha_entrada')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :date => {:message => I18n.t('Sistema.Body.Modelos.Errores.fecha_invalida'),
    :before => Proc.new { 0.day.from_now.to_date }, :message => I18n.t('Sistema.Body.Modelos.BoletaArrime.Errores.fecha_entrada')}

  validates :fecha_salida, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.fecha_salida')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :date => {:message => I18n.t('Sistema.Body.Modelos.Errores.fecha_invalida')}  

  validates :peso_vehiculo, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.peso_vehiculo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :peso_remolque, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.peso_remolque')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :peso_vehiculo_salida_f, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.peso_vehiculo')} #{I18n.t('Sistema.Body.Vistas.General.salida')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
 
  validates :peso_remolque_salida, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.peso_remolque')} #{I18n.t('Sistema.Body.Vistas.General.salida')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :peso_neto, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.peso_neto')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :resultado, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.resultado')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :peso_acondicionado, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.peso_acondicionado')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :letra_cedula_conductor, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nacionalidad')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :cedula_conductor, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.cedula')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :numericality =>{:numericality => true, :only_integer=>true, :message => I18n.t('Sistema.Body.Modelos.Errores.cedula_sin_decimales') }
  
  validates :valor_total_entrada, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.valor_total_entrada')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :valor_total_salida, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.valor_total_salida')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
 
  validates :peso_neto, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.peso_neto')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :numero_ticket, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.numero_ticket')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :numericality =>{:numericality => true, :only_integer=>true, :message => "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.numero_ticket')} #{I18n.t('errors.messages.not_a_number')}" }     

  

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

  def peso_vehiculo_f=(valor)
    self.peso_vehiculo = valor
  end
  def peso_vehiculo_f
    if self.peso_vehiculo == 0
      return '0.00'
    else
      valor = sprintf('%01.2f', self.peso_vehiculo)
      valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
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
      valor = sprintf('%01.2f', self.peso_vehiculo_salida)
      valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
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
      valor = sprintf('%01.2f', self.peso_remolque)
      valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
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
      valor = sprintf('%01.2f', self.peso_remolque_salida)
      valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
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
      valor = sprintf('%01.2f', self.peso_neto)
      valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
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
      valor = sprintf('%01.2f', self.peso_acondicionado)
      valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
      return valor
    end
  end
  def monto_arrime_f=(valor)
    self.monto_arrime = valor
  end
  def monto_arrime_f
    if self.monto_arrime == 0 || self.monto_arrime.nil?
      return '0.00'
    else
      valor = sprintf('%01.2f', self.monto_arrime)
      valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
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
      valor = sprintf('%01.2f', self.valor_total_entrada)
      valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
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
      valor = sprintf('%01.2f', self.valor_total_salida)
      valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
      return valor
    end
  end

  validates :fecha_entrada, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.fecha_entrada')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :date => {:message => I18n.t('Sistema.Body.Modelos.Errores.fecha_invalida'),
    :before => Proc.new { 0.day.from_now.to_date }, :message => I18n.t('Sistema.Body.Modelos.BoletaArrime.Errores.fecha_entrada')}

  validates :fecha_salida, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.fecha_salida')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :date => {:message => I18n.t('Sistema.Body.Modelos.Errores.fecha_invalida')}


  before_save :antes_guardar
  
  def antes_guardar
    if self.id.nil?
      numero_ticket = OtroArrime.find_by_numero_ticket_and_silo_id(self.numero_ticket, self.silo_id)
      unless numero_ticket.nil?
        errors.add(:otro_arrime, "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.numero_ticket')} #{I18n.t('Sistema.Body.Modelos.BoletaArrime.Errores.ya_registrado')}")
        return false
      end
    end
    unless self.peso_neto > self.peso_acondicionado
      errors.add(:otro_arrime, I18n.t('Sistema.Body.Modelos.BoletaArrime.Errores.peso_acondicionado_menor'))
      return false
    end
    unless self.id.nil?
      numero_ticket = OtroArrime.count(:conditions=>["silo_id = #{self.silo_id} and numero_ticket = '#{self.numero_ticket}' and id <> #{self.id}"])
      if numero_ticket > 0
        errors.add(:otro_arrime, "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.numero_ticket')} #{I18n.t('Sistema.Body.Modelos.BoletaArrime.Errores.ya_registrado')}")
        return false
      end
    end
    if self.fecha_salida < self.fecha_entrada
      errors.add(:otro_arrime, I18n.t('Sistema.Body.Modelos.BoletaArrime.Errores.fecha_salida_menor_fecha_entrada'))
      return false
    end
    if self.resultado == 'A'
      unless self.monto_arrime.to_f > 0
        errors.add(:otro_arrime, "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.monto_arrime')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
        return false
      end
    end
    if (self.resultado == 'R' and self.nro_acta_rechazo.to_s.empty?)
      errors.add(:otro_arrime, "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.nro_acta_rechazo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
      return false
    end
    if ((self.resultado == 'R') and (self.causa_rechazo.to_s.empty?))
      errors.add(:otro_arrime, "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Columnas.causa_rechazo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
      return false
    end
  end

  def self.confirmacion(id, parametros)

    boleta = OtroArrime.find(id)
    value = boleta.update_attributes(parametros)
    if !value
      errores = ''
      boleta.errors.full_messages.each { |e|
        errores << "<li>" + e + "</li>"
      }
      return errores
    end
    return true
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


  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort,
      :select=>'*'
  end

end


# == Schema Information
#
# Table name: otro_arrime
#
#  id                     :integer         not null, primary key
#  solicitud_id           :integer         not null
#  silo_id                :integer         not null
#  cliente_id             :integer         not null
#  actividad_id           :integer         not null
#  hora_registro          :time
#  placa_vehiculo         :string(15)      not null
#  letra_cedula_conductor :string(1)       not null
#  cedula_conductor       :integer         not null
#  nombre_conductor       :string(100)     not null
#  numero_ticket          :string(15)      not null
#  guia_movilizacion      :string(20)      not null
#  observacion            :text
#  clase                  :string(1)
#  resultado              :string(30)
#  fecha_entrada          :date            not null
#  fecha_salida           :date            not null
#  valor_total_entrada    :decimal(16, 2)
#  valor_total_salida     :decimal(16, 2)
#  peso_neto              :decimal(16, 2)
#  peso_acondicionado     :decimal(16, 2)
#  peso_vehiculo          :decimal(16, 2)  default(0.0)
#  peso_remolque          :decimal(16, 2)  default(0.0)
#  peso_vehiculo_salida   :decimal(16, 2)  default(0.0)
#  peso_remolque_salida   :decimal(16, 2)  default(0.0)
#  confirmacion           :boolean         default(FALSE), not null
#  fecha_confirmacion     :date
#  estatus                :string(1)
#  monto_arrime           :decimal(16, 2)
#  usuario_id             :integer
#  fecha_decision         :date
#  nro_acta_rechazo       :string(15)
#  causa_rechazo          :string(255)
#



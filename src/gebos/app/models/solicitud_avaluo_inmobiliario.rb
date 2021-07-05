# encodin: utf-8

class SolicitudAvaluoInmobiliario < ActiveRecord::Base

  self.table_name = 'solicitud_avaluo_inmobiliario'
  
  attr_accessible :id,
    :nombre_perito,
    :fecha_avaluo_inmobiliario,
    :valor_avaluo_inmobiliario,
    :clasificacion,
    :espacio,
    :ubicacion,
    :descripcion,
    :lindero_norte,
    :lindero_sur,
    :lindero_este,
    :lindero_oeste,
    :nombre_registro,
    :estado_id,
    :fecha_registro,
    :numero_registro,
    :tomo_registro,
    :protocolo_registro,
    :tipo_construccion,
    :espacio_construccion,
    :ubicacion_construccion,
    :nombre_registro_constrccion,
    :estado_constrccion_id,
    :fecha_registro_constrccion,
    :numero_registro_constrccion,
    :tomo_registro_constrccion,
    :protocolo_registro_constrccion,
    :sistema_construtivo,
    :solicitud_avaluo_id,
    :numero_sudeban_inmobiliario,
    :valor_avaluo_inmobiliario_f,
    :fecha_avaluo_inmobiliario_f,
    :fecha_registro_constrccion_f,
    :espacio_f,
    :clasificacion_w,
    :estado_w,
    :estado_constrccion_w,
    :fecha_registro_f
  
  belongs_to :solicitud_avaluo
   
  validates :solicitud_avaluo_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.SolicitudAvaluoMobiliario.Errores.solicitud_avaluo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :nombre_perito, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.SolicitudAvaluo.Errores.nombre_perito')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :fecha_avaluo_inmobiliario, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.SolicitudAvaluoMobiliario.Errores.fecha_avaluo_mobiliario')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :clasificacion, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.SolicitudAvaluoInmobiliario.Errores.clasificacion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}  

  validates :valor_avaluo_inmobiliario, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.SolicitudAvaluoMobiliario.Errores.valor_avaluo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :numericality =>{:numericality => true, :only_integer=>false, :allow_nil => true, :message => "#{I18n.t('Sistema.Body.Modelos.SolicitudAvaluoMobiliario.Errores.valor_avaluo')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}" }
  
  validates :fecha_avaluo_inmobiliario,
    :date => {:message => "#{I18n.t('Sistema.Body.Modelos.SolicitudAvaluoMobiliario.Errores.fecha_avaluo_formato')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalida')}",
    :before => Proc.new { 1.day.from_now.to_date }, :message => "#{I18n.t('Sistema.Body.Modelos.SolicitudAvaluoMobiliario.Errores.fecha_avaluo_formato')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_ser_posterior_fecha_actual')}"}

  validates :fecha_registro, :allow_blank =>true,
    :date => {:message => "#{I18n.t('Sistema.Body.Modelos.SolicitudAvaluoInmobiliario.Errores.terreno_fecha')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalida')}",
    :before => Proc.new { 1.day.from_now.to_date }, :message => "#{I18n.t('Sistema.Body.Modelos.SolicitudAvaluoInmobiliario.Errores.terreno_fecha')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_ser_posterior_fecha_actual')}"}

  validates :fecha_registro_constrccion, :allow_blank =>true,
    :date => {:message => "#{I18n.t('Sistema.Body.Modelos.SolicitudAvaluoInmobiliario.Errores.construccion_fecha')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalida')}",
    :before => Proc.new { 1.day.from_now.to_date }, :message => "#{I18n.t('Sistema.Body.Modelos.SolicitudAvaluoInmobiliario.Errores.construccion_fecha')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_ser_posterior_fecha_actual')}"}

  validates :espacio, :numericality =>{:numericality => true, :allow_blank=>true, 
    :message => "#{I18n.t('Sistema.Body.Modelos.SolicitudAvaluoInmobiliario.Errores.terreno_espacio')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}"}

  validates :espacio_construccion, :numericality =>{:numericality => true, :only_integer => false, :allow_blank=>true, 
    :message => "#{I18n.t('Sistema.Body.Modelos.SolicitudAvaluoInmobiliario.Errores.construccion_espacio')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}"}  

  validate :block_validate

  def block_validate
    unless self.valor_avaluo_inmobiliario.nil?
      if self.valor_avaluo_inmobiliario < 1
        errors.add(:solicitud_avaluo_inmobiliario, "#{I18n.t('Sistema.Body.Modelos.SolicitudAvaluoMobiliario.Errores.valor_avaluo')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_mayor_cero')}")
      end
    end
    if self.clasificacion == 'T'
      if (self.espacio.nil?)
        errors.add(:solicitud_avaluo_inmobiliario, "#{I18n.t('Sistema.Body.Modelos.SolicitudAvaluoInmobiliario.Errores.terreno_espacio')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_mayor_cero')}")
      else
        if self.espacio < 1
          errors.add(:solicitud_avaluo_inmobiliario, "#{I18n.t('Sistema.Body.Modelos.SolicitudAvaluoInmobiliario.Errores.terreno_espacio')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_mayor_cero')}")
        end
      end
    else
      if (self.clasificacion == 'C' and self.espacio.nil? and self.espacio_construccion.nil?)
        if (self.espacio.nil? or self.espacio < 1)
          errors.add(:solicitud_avaluo_inmobiliario, "#{I18n.t('Sistema.Body.Modelos.SolicitudAvaluoInmobiliario.Errores.terreno_espacio')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_mayor_cero')}")
        elsif (self.espacio_construccion.nil? or self.espacio_construccion < 1)
          errors.add(:solicitud_avaluo_inmobiliario, "#{I18n.t('Sistema.Body.Modelos.SolicitudAvaluoInmobiliario.Errores.construccion_espacio')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_mayor_cero')}")
        end
      else
        if self.espacio_construccion < 1
          errors.add(:solicitud_avaluo_inmobiliario, "#{I18n.t('Sistema.Body.Modelos.SolicitudAvaluoInmobiliario.Errores.construccion_espacio')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_mayor_cero')}")
        end
      end
    end
  end

  def valor_avaluo_inmobiliario_f=(valor)
    self.valor_avaluo_inmobiliario = format_valor(valor)
  end
  
  def valor_avaluo_inmobiliario_f
    format_f(self.valor_avaluo_inmobiliario)
  end

  def fecha_avaluo_inmobiliario_f=(fecha)
    self.fecha_avaluo_inmobiliario = fecha
  end

  def fecha_avaluo_inmobiliario_f
    format_fecha(self.fecha_avaluo_inmobiliario)
  end

  def fecha_registro_f=(fecha)
    self.fecha_registro = fecha
  end

  def fecha_registro_f
    format_fecha(self.fecha_registro)
  end

  def fecha_registro_constrccion_f=(fecha)
    self.fecha_registro_constrccion = fecha
  end

  def fecha_registro_constrccion_f
    format_fecha(self.fecha_registro_constrccion)
  end

  def espacio_f=(valor)
    self.espacio = format_valor(valor)
  end

  def espacio_f
    format_f(self.espacio)
  end

  def clasificacion_w
    if self.clasificacion == 'T'
      return 'Terreno'
    else
      return "Terreno/Construccion"
    end
  end

  def estado_w
    unless self.estado_id.blank?
      estado = Estado.find(self.estado_id)
      return estado.nombre
    end
  end

  def estado_constrccion_w
    unless self.estado_constrccion_id.blank?
      estado = Estado.find(self.estado_constrccion_id)
      return estado.nombre
    end
  end

end
# == Schema Information
#
# Table name: solicitud_avaluo_inmobiliario
#
#  id                             :integer         not null, primary key
#  nombre_perito                  :string(100)
#  fecha_avaluo_inmobiliario      :date
#  valor_avaluo_inmobiliario      :float
#  clasificacion                  :string(1)
#  espacio                        :float
#  ubicacion                      :string(500)
#  descripcion                    :string(500)
#  lindero_norte                  :string(100)
#  lindero_sur                    :string(100)
#  lindero_este                   :string(100)
#  lindero_oeste                  :string(100)
#  nombre_registro                :string(100)
#  estado_id                      :integer
#  fecha_registro                 :date
#  numero_registro                :string(20)
#  tomo_registro                  :string(10)
#  protocolo_registro             :string(10)
#  tipo_construccion              :string(500)
#  espacio_construccion           :integer
#  ubicacion_construccion         :string(500)
#  nombre_registro_constrccion    :string(100)
#  estado_constrccion_id          :integer
#  fecha_registro_constrccion     :date
#  numero_registro_constrccion    :string(20)
#  tomo_registro_constrccion      :string(10)
#  protocolo_registro_constrccion :string(10)
#  sistema_construtivo            :text
#  solicitud_avaluo_id            :integer         not null
#  numero_sudeban_inmobiliario    :string(20)
#


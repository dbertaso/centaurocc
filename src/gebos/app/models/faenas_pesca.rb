# encoding: utf-8
class FaenasPesca < ActiveRecord::Base

  self.table_name = 'faenas_pesca'
  
  attr_accessible :id, 
    :ganancia_por_unidad,
    :gasto_por_unidad,
    :destino_captura,
    :tiempo_expiracion,
    :tipo_especie_id,
    :seguimiento_visita_id,
    :embarcacion_id,
    :faenas_mensual,
    :captura_campana,
    :captura_estimada,
    :precio_x_kg,
    :gasto_por_unidad_f, 
    :ganancia_por_unidad_f

  belongs_to :embarcacion
  belongs_to :seguimiento_visita
  belongs_to :tipo_especie_acuicultura

  
  validates :destino_captura, :length => { :in => 1..160, :allow_blank => false,
    :too_short => "#{I18n.t('Sistema.Body.Modelos.FaenasPesca.Columnas.destino_captura')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Modelos.FaenasPesca.Columnas.destino_captura')}  #{I18n.t('errors.messages.too_long.other')}"}

  validates :tiempo_expiracion, :numericality =>{:numericality => true, :only_integer =>true, 
    :message => "#{I18n.t('Sistema.Body.Modelos.FaenasPesca.Columnas.tiempo_expiracion')} #{I18n.t('errors.messages.not_a_number')}"}

  validates :embarcacion_id, :presence => {:message => "#{I18n.t('Sistema.Body.Controladores.Embarcacion.FormTitles.form_title')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :tipo_especie_id, :presence =>{
    :message => "#{I18n.t('Sistema.Body.Modelos.FaenasPesca.Columnas.tipo_especie_id')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :ganancia_por_unidad, :numericality =>{:numericality => true, 
    :message => "#{I18n.t('Sistema.Body.Modelos.FaenasPesca.Columnas.ganancia_por_unidad')} #{I18n.t('errors.messages.not_a_number')}"}
 
  validates :gasto_por_unidad, :numericality =>{:numericality => true, 
    :message => "#{I18n.t('Sistema.Body.Modelos.FaenasPesca.Columnas.gasto_por_unidad')} #{I18n.t('errors.messages.not_a_number')}"}
  
  validates :precio_x_kg, :numericality =>{:numericality => true, 
    :message => "#{I18n.t('Sistema.Body.Modelos.FaenasPesca.Columnas.precio_x_kg')} #{I18n.t('errors.messages.not_a_number')}"}

  validates :captura_estimada, :numericality =>{:numericality => true, 
    :message => "#{I18n.t('Sistema.Body.Modelos.FaenasPesca.Columnas.captura_estimada')} #{I18n.t('errors.messages.not_a_number')}"}

  validates :captura_campana, :numericality =>{:numericality => true, 
    :message => "#{I18n.t('Sistema.Body.Modelos.FaenasPesca.Columnas.captura_campana')} #{I18n.t('errors.messages.not_a_number')}"}

  validates :faenas_mensual, :numericality =>{:numericality => true, 
    :message => "#{I18n.t('Sistema.Body.Modelos.FaenasPesca.Columnas.faenas_mensual')} #{I18n.t('errors.messages.not_a_number')}"}

  def precio_x_kg_f=(valor)
    self.precio_x_kg = format_valor(valor)
  end

  def precio_x_kg_f
    format_f(self.precio_x_kg)
  end

  def precio_x_kg_fm
    format_fm(self.precio_x_kg)
  end

  def ganancia_por_unidad_f=(valor)
    self.ganancia_por_unidad = format_valor(valor)
  end

  def ganancia_por_unidad_f
    format_f(self.ganancia_por_unidad)
  end

  def ganancia_por_unidad_fm
    format_fm(self.ganancia_por_unidad)
  end

  def gasto_por_unidad_f=(valor)
    self.gasto_por_unidad = format_valor(valor)
  end

  def gasto_por_unidad_f
    format_f(self.gasto_por_unidad)
  end

  def gasto_por_unidad_fm
    format_fm(self.gasto_por_unidad)
  end

  def captura_campana_f=(valor)
    self.captura_campana = format_valor(valor)
  end

  def captura_campana_f
    format_f(self.captura_campana)
  end

  def captura_campana_fm
    format_fm(self.captura_campana)
  end

  def captura_estimada_f=(valor)
    self.captura_estimada = format_valor(valor)
  end

  def captura_estimada_f
    format_f(self.captura_estimada)
  end

  def captura_estimada_fm
    format_fm(self.captura_estimada)
  end


  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort, :select=>'*'
  end


end




# == Schema Information
#
# Table name: faenas_pesca
#
#  id                    :integer         not null, primary key
#  ganancia_por_unidad   :float
#  gasto_por_unidad      :float
#  destino_captura       :string(160)     not null
#  tiempo_expiracion     :integer
#  tipo_especie_id       :integer
#  seguimiento_visita_id :integer
#  embarcacion_id        :integer
#  faenas_mensual        :integer
#  captura_campana       :float
#  captura_estimada      :float
#  precio_x_kg           :decimal(16, 2)
#


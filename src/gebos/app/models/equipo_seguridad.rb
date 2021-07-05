# encoding: UTF-8

#
# autor: Luis Rojas
# clase: EquipoSeguridad
# descripción: Migración a Rails 3
#
class EquipoSeguridad < ActiveRecord::Base

  self.table_name = 'equipo_seguridad'

  attr_accessible :id, 
    :modelo,
    :numero_serial,
    :cantidad,
    :ano,
    :seguimiento_visita_id,
    :embarcacion_id,
    :tipo_equipo_id,
    :potencia,
    :condicion,
    :descripcion,
    :es_propio,
    :con_gps  
 
  belongs_to :tipo_equipo_seguridad, :foreign_key => "tipo_equipo_id"
  belongs_to :embarcacion
  belongs_to :seguimiento_visita


  #validates :es_propio, :presence => {:message => "#{I18n.t('Sistema.Body.Modelos.EquipoSeguridad.Columnas.equipo_es_propio')}"}

  #validates :con_gps, :presence => {:message => "#{I18n.t('Sistema.Body.Modelos.EquipoSeguridad.Columnas.con_gps')}"}

  validates :modelo, :length => { :in => 1..160, :allow_blank => false,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.modelo')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.modelo')}  #{I18n.t('errors.messages.too_long.other')}"}

  validates :numero_serial, :length => { :in => 1..100, :allow_blank => false,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.numero')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.serial')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.numero')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.serial')} #{I18n.t('errors.messages.too_long.other')}"}

  validates :condicion, :length => { :in => 1..20, :allow_blank => false,
    :too_short => "#{I18n.t('Sistema.Body.Modelos.Embarcacion.Columnas.condicion')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Modelos.Embarcacion.Columnas.condicion')}  #{I18n.t('errors.messages.too_long.other')}"}

  validates :tipo_equipo_id, :presence => {:message => "#{I18n.t('Sistema.Body.Modelos.EquipoSeguridad.Columnas.tipo_equipo_seguridad')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :embarcacion_id, :presence => {:message => "#{I18n.t('Sistema.Body.Controladores.Embarcacion.FormTitles.form_title')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  
  validates :condicion, :length => { :in => 1..160, :allow_blank => false,
    :too_short => "#{I18n.t('Sistema.Body.General.descripcion')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.General.descripcion')}  #{I18n.t('errors.messages.too_long.other')}"}
 
  validates :cantidad, :numericality =>{:numericality => true, :only_integer =>true, 
    :message => "#{I18n.t('Sistema.Body.Modelos.EquipoSeguridad.Columnas.tipo_equipo_seguridad')} #{I18n.t('errors.messages.not_a_number')}"}

  validates :ano, :numericality =>{:numericality => true, :only_integer =>true, 
    :message => "#{I18n.t('Sistema.Body.Modelos.Motores.Columnas.ano')} #{I18n.t('errors.messages.not_a_number')}"}
  
  def potencia_f=(valor)
    self.potencia = format_valor(valor)
  end

  def potencia_f
    format_f(self.potencia)
  end

  def before_create
    retorno = true
    sereales = EquipoSeguridad.find_by_numero_serial(self.numero_serial)
    
    unless sereales.nil?
      if sereales.numero_serial!="***No-aplica***"
        errors.add(:equipo_seguridad, I18n.t('Sistema.Body.Modelos.Motores.Errores.serial_motor'))
        retorno = false
      end
    end   

    return retorno
  end

  def self.contar_tipos(tipo_id, visita_id)
    count = EquipoSeguridad.sum(:cantidad, :conditions=>['tipo_equipo_id = ? and seguimiento_visita_id = ?',tipo_id, visita_id])
    return count.to_s
  end
  
  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort, :select=>'*'
  end
  
end

# == Schema Information
#
# Table name: equipo_seguridad
#
#  id                    :integer         not null, primary key
#  modelo                :string(160)     not null
#  numero_serial         :string(100)     not null
#  cantidad              :integer
#  ano                   :integer
#  seguimiento_visita_id :integer
#  embarcacion_id        :integer
#  tipo_equipo_id        :integer
#  condicion             :string(20)
#  descripcion           :string(160)
#  es_propio             :boolean
#  con_gps               :boolean         default(FALSE)
#


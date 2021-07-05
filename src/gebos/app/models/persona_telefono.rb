# encoding: utf-8

#
# autor: Luis Rojas
# clase: PersonaTelefono
# descripción: Migración a Rails 3
#

class PersonaTelefono < ActiveRecord::Base

  self.table_name = 'persona_telefono'
  
  attr_accessible :id,
    :codigo,
    :numero,
    :tipo,
    :persona_id,
    :persona_direccion_id,
    :fax
  
  belongs_to :persona
  belongs_to :persona_direccion

  validates :tipo, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.tipo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  validates :codigo, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.codigo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  validates :numero, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.numero')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.telefono')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 7..7, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.numero')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.telefono')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.numero')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.telefono')} #{I18n.t('errors.messages.too_long.other')}"}

  # validates_numericality_of :codigo, :only_integer=>true,
  #    :message => " el número es inválido"

  #  validates_numericality_of :numero, :only_integer=>true,
  #    :message => "^Número de Teléfono el número es inválido"

  def after_initialize
    #    self.tipo = 'H' unless self.tipo
  end

  def tipo_nombre

    case self.tipo
    when 'H'
      'Habitacion'
    when 'O'
      'Oficina'
    when 'C'
      'Célular'
    when 'F'
      'Fax'
    when 'L'
      'Local'
    when 'T'
      'Otra'
    end

  end

  def to_s
    return "(#{self.codigo}) #{self.numero}"
  end

  validate :validate
  
  def validate
    unless self.tipo == 'C'
      cod = self.codigo.to_s.split('')
      dig = self.codigo.to_s[0,2]
      unless self.codigo.nil? || self.codigo.to_s.empty?
        unless dig == "02"
          errors.add(:persona_telefono, I18n.t('Sistema.Body.Modelos.Errores.codigo_area_no_valido'))
        end
      end
    else
      unless self.codigo == '0412' || self.codigo == '0416' || self.codigo == '0426' || self.codigo == '0414' || self.codigo == '0424'
        errors.add(:persona_telefono, I18n.t('Sistema.Body.Modelos.Errores.codigo_area_no_valido'))
      end
    end
  end

  def self.search(search, page, orden)    
    paginate :per_page=>@records_by_page, :page=>page, :conditions=>search, :order=>orden
  end

end

# == Schema Information
#
# Table name: persona_telefono
#
#  id                   :integer         not null, primary key
#  codigo               :string(4)       not null
#  numero               :string(15)      not null
#  tipo                 :string(1)       not null
#  persona_id           :integer         not null
#  persona_direccion_id :integer
#  fax                  :boolean         default(FALSE)
#


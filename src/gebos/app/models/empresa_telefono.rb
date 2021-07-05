# encoding: utf-8

#
# autor: Luis Rojas
# clase: EmpresaTelefono
# descripción: Migración a Rails 3
#

class EmpresaTelefono < ActiveRecord::Base
  
  self.table_name = 'empresa_telefono'
  
  attr_accessible :id, :numero, :tipo, :empresa_id, :empresa_direccion_id, :codigo, :fax

  belongs_to :empresa
  belongs_to :empresa_direccion
    
  validates :tipo, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.tipo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  validates :codigo, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.codigo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  validates :numero, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.numero')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.telefono')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 7..7, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.numero')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.telefono')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.numero')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.telefono')} #{I18n.t('errors.messages.too_long.other')}"},
    :uniqueness =>{:uniqueness => true, :allow_blank => true, :message => "#{I18n.t('Sistema.Body.Vistas.General.numero')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.telefono')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_registrado')}"}
  
  def self.search(search, page, orden)    
    paginate :per_page=>@records_by_page, :page=>page, :conditions=>search, :order=>orden
  end

  after_initialize :actualizar_tipo

  def actualizar_tipo    
    self.tipo = 'P' unless self.tipo
  end

  def tipo_nombre
    case self.tipo
    when 'P'
      "#{I18n.t('Sistema.Body.Vistas.General.sede')} #{I18n.t('Sistema.Body.Vistas.General.principal')}"
    when 'S'
      I18n.t('Sistema.Body.Vistas.General.sucursal')
    when 'L'
      I18n.t('Sistema.Body.Vistas.General.planta')
    when 'D'
      I18n.t('Sistema.Body.Vistas.Form.deposito')
    when 'O'
      I18n.t('Sistema.Body.Vistas.General.otra')
    end
  end

  def to_s
    return "(#{self.codigo}) #{self.numero}"
  end

  validate :validate
  
  def validate
    unless self.codigo.nil? || self.codigo.to_s.empty?
      cod = self.codigo.to_s.split('')
      dig = cod[0] + cod[1]
      unless dig.to_i == 02
        errors.add(:empresa_telefono, I18n.t('Sistema.Body.Modelos.Errores.codigo_area_no_valido'))
      end
    end
  end
     
end


# == Schema Information
#
# Table name: empresa_telefono
#
#  id                   :integer         not null, primary key
#  numero               :string(15)      not null
#  tipo                 :string(1)       not null
#  empresa_id           :integer         not null
#  empresa_direccion_id :integer
#  codigo               :string(4)       not null
#  fax                  :boolean         default(FALSE)
#


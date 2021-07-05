# encoding: utf-8

#
# autor: Luis Rojas
# clase: Perito
# descripción: Migración a Rails 3
#
class Perito < ActiveRecord::Base
  
  self.table_name = 'perito'
  
  attr_accessible :id, :cedula, :primer_nombre, :segundo_nombre,
    :primer_apellido, :segundo_apellido
  
  validates :primer_apellido, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.primer_nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio')}/, 
    :message => "#{I18n.t('Sistema.Body.Vistas.General.primer_nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}"}
  
  validates :primer_nombre, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.primer_apellido')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio')}/, 
    :message => "#{I18n.t('Sistema.Body.Vistas.General.primer_apellido')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}"}
  
  validates :cedula, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.cedula')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :uniqueness =>{:uniqueness => true, :message => "#{I18n.t('Sistema.Body.Vistas.General.cedula')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_registrado')}"}

  validates_length_of :primer_nombre, :within => 3..20, :allow_blank => true
  
  validates_length_of :segundo_nombre, :within => 3..20, :allow_blank => true

  validates_length_of :primer_apellido, :within => 3..20, :allow_blank => true

  validates_length_of :segundo_apellido, :within => 3..20, :allow_blank => true
  
  validates_numericality_of :cedula, :only_integer=>true, :allow_blank => true,
    :message => I18n.t('Sistema.Body.Modelos.Errores.cedula_sin_decimales')
  
  validate :validaciones
 
  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
             :conditions => search, :order => sort
  end

  def validaciones
    unless self.segundo_nombre.nil? || self.segundo_nombre.empty?
      a = self.segundo_nombre[/#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio')}/]
      if a.nil?
        errors.add(:segundo_nombre, "#{I18n.t('Sistema.Body.Vistas.General.segundo_nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}")
      end
    end
    unless self.segundo_apellido.nil? || self.segundo_apellido.empty?
      a = self.segundo_apellido[/^[a-zA-ZñÑáÁéÉíÍóÓúÚüÜÇ' ]+$/]
      if a.nil?
        errors.add(:segundo_apellido, "#{I18n.t('Sistema.Body.Vistas.General.segundo_apellido')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}")
      end
    end
  end

  def nombre_corto
    self.primer_nombre + ' ' + self.primer_apellido
  end

end

# == Schema Information
#
# Table name: perito
#
#  id               :integer         not null, primary key
#  cedula           :integer         not null
#  primer_nombre    :string(20)      not null
#  segundo_nombre   :string(20)
#  primer_apellido  :string(20)      not null
#  segundo_apellido :string(20)
#


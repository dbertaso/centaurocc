# encoding: utf-8
#
# autor: Diego Bertaso
# clase: Abogado
# descripción: Migración a Rails 3
# fecha: 2012-11-19
#

class Abogado < ActiveRecord::Base


  self.table_name = 'abogado'

  attr_accessible :id,
                  :nombre,
                  :impreabogado,
                  :cedula,
                  :oficina_id,
                  :telefono,
                  :activo

  belongs_to :oficina

  validates :nombre,
    :presence => { :message => I18n.t('Sistema.Body.Modelos.Errores.nombre_apellido_requerido')},
    :format =>{:with => /#{I18n.t('Sistema.Body.General.validar_nombre')}/, :allow_blank =>true, 
    :message => I18n.t('Sistema.Body.Modelos.Errores.nombre_apellido_invalido')}

  validates :impreabogado,
    :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.numero')} 
                                #{I18n.t('Sistema.Body.Vistas.General.de')} 
                                #{I18n.t('Sistema.Body.Vistas.Abogado.inpreabogado')} 
                                #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.solo_numeros')}/, :message => I18n.t('Sistema.Body.Modelos.Abogado.Errores.numero_impre_sin_decimales')}

  validates :oficina_id,
    :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.oficina')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerida')}"}

  validates :cedula, :numericality => {:only_integer=>true,
    :message => I18n.t('Sistema.Body.Modelos.Errores.cedula_sin_decimales')},
    :uniqueness => {:message => "#{I18n.t('Sistema.Body.Vistas.General.cedula')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"}

  validates :telefono, :numericality => {:only_integer=>true,
    :message => I18n.t('Sistema.Body.Modelos.Errores.telefono_sin_decimales')}
    
  validates_uniqueness_of :cedula,
  :message => I18n.t('Sistema.Body.Vistas.General.cedula') << " " << I18n.t('Sistema.Body.Modelos.Errores.ya_existe')


  validate :validate

  def validate
    if self.cedula.to_s.length < 6 || self.cedula.to_s.length > 8            
        errors.add(:abogado, "#{I18n.t('Sistema.Body.Vistas.General.cedula')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalida')}")      
    end
  end

  def self.search(search, page, sort)

    paginate :per_page => @records_by_page, :page => page,
             :conditions => search, :order => sort, :include => [:oficina]
  end


end


# == Schema Information
#
# Table name: abogado
#
#  id           :integer         not null, primary key
#  nombre       :string(100)
#  impreabogado :string(15)
#  cedula       :string(10)
#  oficina_id   :integer
#  telefono     :string(20)
#  activo       :boolean
#


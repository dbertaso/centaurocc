# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Moneda
# creado con Rails 3
#
class Moneda < ActiveRecord::Base

  self.table_name = 'moneda'

  attr_accessible :id,
                  :nombre,
                  :abreviatura,
                  :ruta_icono,
                  :activo
                  
  has_many :configurador

  validates :nombre,
    :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :format =>{:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.validar_nombre')}/, :allow_blank =>true, 
    :message => "#{I18n.t('Sistema.Body.Vistas.General.descripcion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalido')}"}

  validates :abreviatura,
    :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.abreviatura')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerida')}"}

  after_initialize :after_initialize
  before_destroy :before_destroy

  def after_initialize

    if new_record?
      self.activo = true
    end
  end    

  def before_destroy
    
    logger.info "Entro en Before Destroy"
    valid = true
    sol = Solicitud.find_by_moneda_id(self.id)

    if !sol.nil?
      errors.add(:moneda, I18n.t('Sistema.Body.Modelos.Moneda.Errores.no_puede_eliminarse_moneda_tramite'))
      valid = false
    end

    pro = Programa.find_by_moneda_id(self.id)
    if !pro.nil?
      errors.add(:moneda, I18n.t('Sistema.Body.Modelos.Moneda.Errores.no_puede_eliminarse_moneda_programa'))
      valid = false
    end

    valid
  end

  def self.search(search, page, orden)    

    conditions=search
    

    logger.info "Conditions ===> " << conditions.to_s
    paginate :per_page=>@records_by_page, :page=>page, :conditions=>conditions, :order=>orden
  end
end

# == Schema Information
#
# Table name: moneda
#
#  id          :integer         not null, primary key
#  nombre      :text            not null
#  abreviatura :string(5)       not null
#  ruta_icono  :text
#  activo      :boolean         default(TRUE), not null
#


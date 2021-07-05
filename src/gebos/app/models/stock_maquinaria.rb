# encoding: utf-8

#
# autor: Luis Rojas
# clase: StockMaquinaria
# descripción: Migración a Rails 3
#
class StockMaquinaria < ActiveRecord::Base
  
  self.table_name = 'stock_maquinaria'
  
  attr_accessible :id, :tipo_maquinaria_id, :clase_id, :marca_maquinaria_id, :modelo_id, :minimo, :maximo
  
  belongs_to :tipo_maquinaria
  belongs_to :clase
  belongs_to :marca_maquinaria
  belongs_to :modelo
  
  validates :tipo_maquinaria_id, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.rubro')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :clase_id, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.tipo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :marca_maquinaria_id, :presence => {:message => "#{I18n.t('Sistema.Body.Controladores.Marca.FormTitles.form_title_record')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :modelo_id, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.modelo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :minimo, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.existencia')} #{I18n.t('Sistema.Body.Vistas.General.minima')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :maximo, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.existencia')} #{I18n.t('Sistema.Body.Vistas.General.maxima')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates_numericality_of :minimo, :only_integer=>true,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.existencia')} #{I18n.t('Sistema.Body.Vistas.General.minima')} #{I18n.t('Sistema.Body.Modelos.Errores.numerico_sin_decimales')}"
  
  validates_numericality_of :maximo, :only_integer=>true,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.existencia')} #{I18n.t('Sistema.Body.Vistas.General.maxima')} #{I18n.t('Sistema.Body.Modelos.Errores.numerico_sin_decimales')}"
  
  validate :validaciones
  
  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
             :conditions => search, :order => sort, :include => [:tipo_maquinaria, :clase, :marca_maquinaria, :modelo]
  end
  
  def validaciones
    unless self.new_record?
      total = StockMaquinaria.count(:conditions => "id <> #{self.id} and tipo_maquinaria_id = #{self.tipo_maquinaria_id} and clase_id = #{self.clase_id} and marca_maquinaria_id = #{self.marca_maquinaria_id} and modelo_id = #{self.modelo_id}")
    else
      total = StockMaquinaria.count(:conditions => "tipo_maquinaria_id = #{self.tipo_maquinaria_id} and clase_id = #{self.clase_id} and marca_maquinaria_id = #{self.marca_maquinaria_id} and modelo_id = #{self.modelo_id}")
    end
    if total > 0
      errors.add(:tipo_maquinaria_id, I18n.t('Sistema.Body.Modelos.Stock_Maquinaria.Errores.combinación'))
    end
    
    unless self.minimo.nil? || self.minimo.to_s.empty?
      unless self.maximo.nil? || self.maximo.to_s.empty?
        unless self.minimo > 0
          errors.add(:minimo, "#{I18n.t('Sistema.Body.Vistas.General.existencia')} #{I18n.t('Sistema.Body.Vistas.General.minima')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_mayor_cero')}")
        else
          if self.minimo >= self.maximo
            errors.add(:maximo, "#{I18n.t('Sistema.Body.Vistas.General.existencia')} #{I18n.t('Sistema.Body.Vistas.General.maxima')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_mayor_cero')}")
          end
        end
      end
    end
  end
  
end
# == Schema Information
#
# Table name: stock_maquinaria
#
#  id                  :integer         not null, primary key
#  tipo_maquinaria_id  :integer         not null
#  clase_id            :integer         not null
#  marca_maquinaria_id :integer         not null
#  modelo_id           :integer         not null
#  minimo              :integer         not null
#  maximo              :integer         not null
#  indicador           :string(1)
#


# encoding: utf-8

#
# autor: Diego Bertaso
# clase: MarcaMaquinaria
# descripción: Migración a Rails 3
#

class MarcaMaquinaria < ActiveRecord::Base

  self.table_name = 'marca_maquinaria'
  
  attr_accessible :id,
                  :nombre,
                  :descripcion,
                  :activo
                
  has_many :catalogo
  has_many :stock_maquinaria
  has_many :solicitud_maquinaria
  
  validates_presence_of  :nombre,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"
    
  validates_presence_of  :descripcion,
    :message => "#{I18n.t('Sistema.Body.Vistas.Form.descripcion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}" 
    
  validates_uniqueness_of :nombre,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"
  
  validates_length_of :descripcion, :within => 0..250, :allow_nil => false,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.Form.descripcion')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.Form.descripcion')} #{I18n.t('errors.messages.too_long.other')}"
  
  validates_length_of :nombre, :within => 0..60, :allow_nil => false,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('errors.messages.too_long.other')}"
  
  def after_initialize
    self.activo = true if self.new_record?
  end
  
   
  def eliminar(id)
    begin
      catalogo = Catalogo.count(:conditions=>"marca_maquinaria_id = #{id}")
      if catalogo > 0
        errors.add(:marca_maquinaria, "#{I18n.t('Sistema.Body.Vistas.General.la').capitalize} #{I18n.t('Sistema.Body.Vistas.General.marca')} 
                                      #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.maquinaria')} 
                                      #{I18n.t('Sistema.Body.Modelos.Errores.usada_catalogo')}")
        return false
      else
        marca_maquinaria = MarcaMaquinaria.find(id)
        transaction do
          marca_maquinaria.destroy
          return true
        end
      end
    rescue
      errors.add(:marca_maquinaria, "#{I18n.t('Sistema.Body.Vistas.General.la').capitalize} #{I18n.t('Sistema.Body.Vistas.General.marca')} 
                                      #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.maquinaria')} 
                                      #{I18n.t('Sistema.Body.Modelos.Errores.usada')}")
      return false
    end
  end

  def self.search(search, page, sort)

    unless search.nil?
      paginate  :per_page => @records_by_page, :page => page,
                :conditions => search, :order => sort
    else
      paginate  :per_page => @records_by_page, :page => page,
                :order => sort

    end
    
  end  
  
end

# == Schema Information
#
# Table name: marca_maquinaria
#
#  id          :integer         not null, primary key
#  nombre      :string(100)     not null
#  descripcion :string(250)     not null
#  activo      :boolean         default(TRUE), not null
#


# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Ciudad
# descripción: Migración a Rails 3
#

class Ciudad < ActiveRecord::Base

  self.table_name = 'ciudad'
  
  attr_accessible :estado_id, :nombre
  
  belongs_to :estado
  has_many :registro_mercantil
  has_many :unidad_produccion
  has_many :agencia_bancaria
  has_many :almacen_maquinaria
  has_many :empresa_transporte_maquinaria
 
  
  validates_presence_of :nombre,
    :message => I18n.t('Sistema.Body.Vistas.General.nombre') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerido')
    
  validates_uniqueness_of :nombre, 
    :message => I18n.t('Sistema.Body.Vistas.General.nombre') << " " << I18n.t('Sistema.Body.Modelos.Errores.ya_existe'),
    :scope => [:estado_id]
  
    
  def self.find_by_nombre_and_estado_id(nombre, estado_id)
    self.find(:first, 
      :conditions => [ 'LOWER(nombre) = ? AND estado_id = ?',
      nombre.downcase, estado_id ])  
  end


def self.capitalizeText(text)

 #puts text
  
  arr = text.split
  
  contador = 0
  
  for _text in arr

    if contador != 0
      new_text = new_text + " " 
    end
    
    new_text = new_text + _text.capitalize if new_text
    new_text = _text.capitalize  if !new_text
    
    contador += 1
    
  end
  new_text
  
end



  def self.search(search, page, orden)    

    conditions=search  
  
    logger.info "Conditions ===> " << conditions.to_s
    paginate :per_page=>@records_by_page, :page=>page, :conditions=>conditions, :order=>orden
  end

end


# == Schema Information
#
# Table name: ciudad
#
#  id                :integer         not null, primary key
#  estado_id         :integer
#  nombre            :string(40)      not null
#  codigo_ine        :string(10)
#  estado_codigo_ine :string(10)
#


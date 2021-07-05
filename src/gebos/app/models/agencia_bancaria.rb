# encoding: utf-8

#
# autor: Diego Bertaso
# clase: AgenciaBancaria
# descripción: Migración a Rails 3
#

class AgenciaBancaria < ActiveRecord::Base

self.table_name = 'agencia_bancaria'
  
  attr_accessible :id,
                  :codigo,
                  :nombre,
                  :direccion,
                  :entidad_financiera_id,
                  :activo,
                  :estado_id,
                  :ciudad_id,
                  :municipio_id
                  
  belongs_to :entidad_financiera
  belongs_to :Estado
  belongs_to :Municipio
  belongs_to :Ciudad

  
  validates_presence_of :codigo, :nombre, :estado_id, :municipio_id, :ciudad_id,
    :message => " es requerido"
    
  validates_length_of :codigo, :within => 1..40, :allow_nil => false
      
  validates_length_of :nombre, :within => 1..100, :allow_nil => false
     
  validates_uniqueness_of :nombre, 
    :message => I18n.t('Sistema.Body.Modelos.Errores.ya_existe')

  validates_uniqueness_of :codigo, :scope => :entidad_financiera_id,
    :message => I18n.t('Sistema.Body.Modelos.Errores.ya_existe')
    
  def codigo_f=(codigo)
    self.codigo = codigo.upcase
  end
    
  def codigo_f
    self.codigo.upcase unless self.codigo.nil?
  end
  
  def nombre_f=(nombre)
    self.nombre = nombre.upcase
  end
    
  def nombre_f
    self.nombre.upcase unless self.nombre.nil?
  end
     
end

# == Schema Information
#
# Table name: agencia_bancaria
#
#  id                    :integer         not null, primary key
#  codigo                :string(40)
#  nombre                :string(100)
#  direccion             :string(250)
#  entidad_financiera_id :integer
#  activo                :boolean
#  estado_id             :integer
#  ciudad_id             :integer
#  municipio_id          :integer
#


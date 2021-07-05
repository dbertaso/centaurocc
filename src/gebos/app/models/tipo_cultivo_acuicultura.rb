# encoding: utf-8

#
# autor: Luis Rojas
# clase: TipoCultivoAcuicultura
# descripción: Migración a Rails 3
#
class TipoCultivoAcuicultura < ActiveRecord::Base
  
  self.table_name = 'tipo_cultivo_acuicultura'
  
  attr_accessible  :id, :nombre, :descripcion, :activo

  has_many :unidad_produccion_condicion_acuicultura
      
  validates_uniqueness_of :nombre, 
    :message => " ya existe este registro"


  validates_presence_of :nombre, :descripcion,
    :message => " es requerido"
  
  validates_length_of :nombre, :within => 1..150, :allow_nil => false,
    :too_short => " es demasiado corto (mínimo %d)",
    :too_long => "  es demasiado largo (máximo %d)"

  validates_length_of :descripcion, :within => 1..300, :allow_nil => false,
    :too_short => " es demasiado corto (mínimo %d)",
    :too_long => "  es demasiado largo (máximo %d)"
  
end


# == Schema Information
#
# Table name: tipo_cultivo_acuicultura
#
#  id          :integer         not null, primary key
#  nombre      :text            not null
#  descripcion :text            not null
#  activo      :boolean         default(TRUE), not null
#


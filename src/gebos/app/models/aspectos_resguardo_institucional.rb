# encoding: utf-8
class AspectosResguardoInstitucional < ActiveRecord::Base

  self.table_name = 'aspectos_resguardo_institucional'
  has_many :solicitud_aspectos_evaluar
      
  validates_uniqueness_of :nombre,
    :message => " ya existe este registro"


  validates_presence_of :nombre,
    :message => " es requerido"

end


# == Schema Information
#
# Table name: aspectos_resguardo_institucional
#
#  id     :integer         not null, primary key
#  nombre :string(100)
#


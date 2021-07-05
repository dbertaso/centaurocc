# encoding: utf-8
class TipoMaquinaria < ActiveRecord::Base
  
  self.table_name = 'tipo_maquinaria'
  
  attr_accessible :id, :nombre, :descripcion, :activo
  
  has_many :contrato_equipo_maquinaria
  has_many :clase
  has_many :SolicitudMaquinaria
  has_many :solicitud_maquinaria
  has_many :stock_maquinaria

end
# == Schema Information
#
# Table name: tipo_maquinaria
#
#  nombre      :string(100)     not null
#  descripcion :string(255)
#  activo      :boolean         not null
#  id          :integer         not null, primary key
#


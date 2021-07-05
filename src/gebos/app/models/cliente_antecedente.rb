# encoding: utf-8
#
# autor: Luis Rojas
# clase: Empresa
# descripción: Migración a Rails 3
#
class ClienteAntecedente < ActiveRecord::Base
  
  self.table_name = 'cliente_antecedente'
  attr_accessible :id, :cliente_id, :entidad_financiera_id, :fecha_aprobacion, :monto_aprobado, :estatus
  
  belongs_to :cliente
  belongs_to :entidad_financiera
     
end

# == Schema Information
#
# Table name: cliente_antecedente
#
#  id                    :integer         not null, primary key
#  cliente_id            :integer         not null
#  entidad_financiera_id :integer         not null
#  fecha_aprobacion      :date            not null
#  monto_aprobado        :float
#  estatus               :string(1)       default("V")
#


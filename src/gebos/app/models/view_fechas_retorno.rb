# encoding: utf-8
#
# autor: Luis Rojas
# clase: ViewFechasRetorno
# descripción: Migración a Rails 3
#
class ViewFechasRetorno < ActiveRecord::Base

	self.table_name = 'view_fechas_retorno'

  public

end

# == Schema Information
#
# Table name: view_fechas_retorno
#
#  prestamo_id          :integer
#  fecha_liquidacion    :date
#  fecha_fin_retorno    :date
#  fecha_inicio_retorno :date
#  sector_id            :integer
#  sub_sector_id        :integer
#  rubro_id             :integer
#  sub_rubro_id         :integer
#  sub_rubro_nombre     :string(100)
#  cantidad_integrantes :integer(8)
#  monto_aprobado       :decimal(16, 2)
#


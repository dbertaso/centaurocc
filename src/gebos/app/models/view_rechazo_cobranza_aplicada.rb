# encoding: utf-8

class ViewRechazoCobranzaAplicada < ActiveRecord::Base


  self.table_name = 'view_rechazo_cobranza_aplicada'

  attr_accessible :rechazo_cobranza_id,
    :fecha_rechazo,
	  :prestamo_numero,
	  :monto_pago,
	  :codigo_error,
	  :descripcion_error,
	  :archivo,
	  :numero_solicitud,
	  :cedula_rif,
	  :nombre_cliente,
	  :entidad_financiera,
	  :numero_cuenta,
	  :moneda




end


# == Schema Information
#
# Table name: view_rechazo_cobranza_aplicada
#
#  rechazo_cobranza_id :integer
#  fecha_rechazo       :date
#  prestamo_numero     :integer(8)
#  monto_pago          :float
#  codigo_error        :integer
#  descripcion_error   :string(255)
#  archivo             :string(100)
#  numero_solicitud    :integer
#  cedula_rif          :string
#  nombre_cliente      :string
#  entidad_financiera  :string(20)
#  numero_cuenta       :string(20)
#  moneda              :string(5)
#


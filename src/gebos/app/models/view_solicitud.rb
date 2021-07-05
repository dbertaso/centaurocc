# encoding: utf-8

#
# 
# clase: ViewSolicitud
# descripción: Migración a Rails 3
#

class ViewSolicitud < ActiveRecord::Base

  self.table_name = 'view_solicitud'
  
  attr_accessible :numero_solicitud,:numero_prestamo,:numero_grupo,:numero_empresa,:estado,:municipio,:parroquia,:ciudad,:monto_solicitud,:monto_solicitado,:monto_solicitado_letras,:monto_garantia,:monto_garantia_letras,:tipo_gasto,:identificador_cliente,:nombre_cliente,:plan,:plazo,:meses_muertos,:solicitud_id,:rubro,:porcentaje,:monto_fijo

end

# == Schema Information
#
# Table name: view_solicitud
#
#  numero_solicitud        :integer
#  numero_prestamo         :integer(8)
#  numero_grupo            :integer
#  numero_empresa          :integer
#  estado                  :string(40)
#  municipio               :string(40)
#  parroquia               :string(40)
#  ciudad                  :string(40)
#  monto_solicitud         :float
#  monto_solicitado        :text
#  monto_solicitado_letras :float
#  monto_garantia          :text
#  monto_garantia_letras   :float
#  tipo_gasto              :integer
#  identificador_cliente   :text
#  nombre_cliente          :text
#  plan                    :string(255)
#  plazo                   :integer(2)
#  meses_muertos           :integer(2)
#  solicitud_id            :integer
#  rubro                   :string(150)
#  porcentaje              :decimal(16, 2)
#  monto_fijo              :decimal(16, 2)
#


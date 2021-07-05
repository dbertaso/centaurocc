class HistoricoCambioCuenta < ActiveRecord::Base

  self.table_name = 'historico_cambio_cuenta'
  
  belongs_to :usuario
  belongs_to :persona
  belongs_to :empresa
  belongs_to :cuenta_bancaria
  belongs_to :entidad_financiera


  #validates_presence_of :observaciones, :message => " es requerido"

end

# == Schema Information
#
# Table name: historico_cambio_cuenta
#
#  id                                        :integer         not null, primary key
#  usuario_id                                :integer
#  persona_id                                :integer
#  empresa_id                                :integer
#  entidad_financiera_id_actual              :integer
#  entidad_financiera_id_ultima_modificacion :integer
#  tipo_cuenta_actual                        :string(1)
#  tipo_cuenta_ultima_modificacion           :string(1)
#  numero_cuenta_actual                      :string(20)
#  numero_cuenta_ultima_modificacion         :string(20)
#  fecha_modificacion_actual                 :datetime
#  fecha_ultima_modificacion                 :date
#  fecha_apertura                            :date
#  observaciones                             :text
#  cuenta_id                                 :integer
#  activo_actual                             :boolean
#  activo_ultima_modificacion                :boolean
#


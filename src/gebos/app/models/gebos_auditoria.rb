# encoding: utf-8

#
# autor: Diego Bertaso
# clase: GebosAuditoria
# descripción: Migración a Rails 3
#


class GebosAuditoria < ActiveRecord::Base

  self.table_name = 'gebos_auditoria'
  
  attr_accessible   :usuario_id,
                    :usuario_nombre,
                    :usuario_ip,
                    :controlador,
                    :accion,
                    :url,
                    :cantidad_parametros,
                    :parametros,
                    :creado_el
end

# == Schema Information
#
# Table name: gebos_auditoria
#
#  id                  :integer         not null, primary key
#  usuario_id          :integer         not null
#  usuario_nombre      :string(200)     not null
#  usuario_ip          :string(20)
#  controlador         :string(200)
#  accion              :string(200)
#  url                 :text
#  cantidad_parametros :string(255)
#  parametros          :text
#  creado_el           :datetime        default(2013-05-13 09:47:52 UTC)
#


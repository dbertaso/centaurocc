# encoding: utf-8

#
# 
# clase: ClienteEmpresa
# descripción: Migración a Rails 3
#

class ClienteEmpresa < Cliente

#  self.table_name = 'cliente_empresa'

  #attr_accessible :id,:tipo_cliente_id,:persona_id,:empresa_id,:type,:entidad_financiera_id,:tipo_cuenta,:numero_cuenta,:codigo_d3,:migrado_d3,:nro_expediente,:agencia_bancaria_id,:moroso,:reestructurado,:viable
  
#  belongs_to :empresa

#  validates_presence_of :entidad_financiera_id,
#    :agencia_bancaria_id,
#    :message => " es requerido",
#    :allow_nil => true
  
end


# == Schema Information
#
# Table name: cliente
#
#  id                    :integer         not null, primary key
#  tipo_cliente_id       :integer
#  persona_id            :integer
#  empresa_id            :integer
#  type                  :string(15)      not null
#  entidad_financiera_id :integer
#  tipo_cuenta           :string(1)       default("C")
#  numero_cuenta         :string(20)
#  codigo_d3             :string(10)
#  migrado_d3            :boolean         default(FALSE)
#  nro_expediente        :integer         default(0)
#  agencia_bancaria_id   :integer
#  moroso                :boolean         default(FALSE), not null
#  reestructurado        :boolean         default(FALSE), not null
#  viable                :boolean         default(TRUE), not null
#  es_pescador           :boolean         default(FALSE), not null
#  fecha_registro        :date
#


# encoding: utf-8
class TransaccionAccion < ActiveRecord::Base
  
  self.table_name = 'transaccion_accion'
  
  attr_accessible :id,
    :reverso,
    :transaccion_id,
    :tipo,
    :tabla,
    :tabla_id

  belongs_to :transaccion
  
  def tipo_w
    case self.tipo
    when 'A'
      'Agregado'
    when 'M'
      'Modificado'
    when 'E'
      'Eliminado'
    end    
  end
  
  def antes
    registros = connection.execute("select * from tr_" + self.tabla + " where tr_transaccion_accion_id = " + self.id.to_s + " and tr_momento = 'A'")
    return registros
  end
  def despues
    registros = connection.execute("select * from tr_" + self.tabla + " where tr_transaccion_accion_id = " + self.id.to_s + " and tr_momento = 'D'")
    return registros
  end
  
end


# == Schema Information
#
# Table name: transaccion_accion
#
#  id             :integer         not null, primary key
#  reverso        :boolean         default(FALSE)
#  transaccion_id :integer
#  tipo           :string(1)       default("A")
#  tabla          :string(100)     not null
#  tabla_id       :integer         not null
#


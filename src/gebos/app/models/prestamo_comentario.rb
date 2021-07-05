class PrestamoComentario < ActiveRecord::Base

  self.table_name = 'prestamo_comentario'

  attr_accessible :id,
                  :solicitud_id,
                  :partida_id,
                  :comentario

  belongs_to :prestamo
#


end

# == Schema Information
#
# Table name: prestamo_comentario
#
#  id               :integer         not null, primary key
#  comentario       :string(1000)
#  prestamo_id      :integer         not null
#  fecha_aplicacion :date            not null
#  usuario_id       :integer         not null
#


# encoding: utf-8
class AreaInfluenciaTecnico < ActiveRecord::Base

  self.table_name = 'area_influencia_tecnico'
  belongs_to :Tecnico_campo
  belongs_to :estado
  belongs_to :municipio
  belongs_to :parroquia
  
  validates_presence_of :estado_id,
    :message => ", es requerido" 
  validates_presence_of :municipio_id,
    :message => ", es requerido" 
  validates_presence_of :parroquia_id,
    :message => ", es requerido"


  def validate
    total = AreaInfluenciaTecnico.count(:conditions => ['parroquia_id = ? and tecnico_campo_id = ?', self.parroquia_id, self.tecnico_campo_id])
    if total > 0
      errors.add(nil, "La Parroquia ya fue seleccionada.")
    end
  end

  end


# == Schema Information
#
# Table name: area_influencia_tecnico
#
#  id               :integer         not null, primary key
#  estado_id        :integer         not null
#  municipio_id     :integer         not null
#  parroquia_id     :integer         not null
#  tecnico_campo_id :integer         not null
#


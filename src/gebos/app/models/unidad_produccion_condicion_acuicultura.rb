# encoding: utf-8
class UnidadProduccionCondicionAcuicultura < ActiveRecord::Base
  
  self.table_name = 'unidad_produccion_condicion_acuicultura'
  
  attr_accessible  :id,
                    :solicitud_id,
                    :unidad_produccion_id,
                    :seguimiento_visita_id,
                    :superficie_disponible,
                    :tipo_sistema_acuicultura_id,
                    :tipo_cultivo_acuicultura_id,
                    :observaciones,
                    :calidad_agua_ph,
                    :calidad_agua_temperatura,
                    :calidad_agua_od,
                    :vialidad_distancia,
                    :vialidad_condiciones,
                    :suelo_ph,
                    :porcentaje_vegetacion_baja,
                    :porcentaje_vegetacion_media,
                    :porcentaje_vegetacion_alta,
                    :condiciones_climaticas, 
                    :densidad_siembra, 
                    :rubros_animales, 
                    :posee_drenaje, 
                    :tipo_drenaje_id, 
                    :superficie_drenaje,
                    :condicion_drenaje

  belongs_to :Solicitud
  belongs_to :unidad_produccion
  belongs_to :seguimiento_visita
  has_many :tipo_especie_acuicultura
  has_many :CondicionesEspecies
  has_many :CondicionesTipoVialidad
  has_many :CondicionesTipoSuelo
  has_many :CondicionesTipoTopografia
  has_many :CondicionesFuenteAgua
  has_many :CondicionesSistemaCultivoActual
  belongs_to :tipo_drenaje
  belongs_to :tipo_cultivo_acuicultura
  belongs_to :tipo_sistema_acuicultura
  
  validates_numericality_of :superficie_disponible,
      :only_integer => false, :allow_nil => true,
      :message => " número inválido" 

  validates_numericality_of :densidad_siembra,
      :only_integer => false, :allow_nil => true,
      :message => " número inválido" 


  validates_numericality_of :calidad_agua_ph,
      :only_integer => false, :allow_nil => true,
      :message => " número inválido" 

  validates_numericality_of :superficie_drenaje,
      :only_integer => false, :allow_nil => true,
      :message => " número inválido"   

  validates_numericality_of :calidad_agua_temperatura,
      :only_integer => false, :allow_nil => true,
      :message => " número inválido" 

  validates_numericality_of :calidad_agua_od,
      :only_integer => false, :allow_nil => true,
      :message => " número inválido" 
      
  validates_numericality_of :vialidad_distancia,
      :only_integer => false, :allow_nil => true,
      :message => " número inválido" 
      
  validates_numericality_of :suelo_ph,
      :only_integer => false, :allow_nil => true,
      :message => " número inválido" 

  validates_numericality_of :porcentaje_vegetacion_baja,
      :only_integer => false, :allow_nil => true,
      :message => " número inválido" 
      
  validates_numericality_of :porcentaje_vegetacion_media,
      :only_integer => false, :allow_nil => true,
      :message => " número inválido" 

  validates_numericality_of :porcentaje_vegetacion_alta,
      :only_integer => false, :allow_nil => true,
      :message => " número inválido" 

  def vialidad_condicion_w
    if self.vialidad_condiciones == 'E'
      return 'Excelente'
    elsif self.vialidad_condiciones == 'B'
      return 'Bueno'
    elsif self.vialidad_condiciones == 'R'
      return 'Regular'
    elsif self.vialidad_condiciones == 'M'
      return 'Malo'
    end
  end

  def condicion_drenaje_w
    if self.condicion_drenaje == 'E'
      return 'Excelente'
    elsif self.condicion_drenaje == 'B'
      return 'Bueno'
    elsif self.condicion_drenaje == 'R'
      return 'Regular'
    elsif self.condicion_drenaje == 'M'
      return 'Malo'
    end
  end
end



# == Schema Information
#
# Table name: unidad_produccion_condicion_acuicultura
#
#  id                          :integer         not null, primary key
#  solicitud_id                :integer         not null
#  unidad_produccion_id        :integer         not null
#  seguimiento_visita_id       :integer
#  superficie_disponible       :float
#  tipo_sistema_acuicultura_id :integer
#  tipo_cultivo_acuicultura_id :integer
#  observaciones               :text
#  calidad_agua_ph             :float
#  calidad_agua_temperatura    :float
#  calidad_agua_od             :float
#  vialidad_distancia          :float
#  vialidad_condiciones        :text
#  suelo_ph                    :float
#  porcentaje_vegetacion_baja  :float
#  porcentaje_vegetacion_media :float
#  porcentaje_vegetacion_alta  :float
#  posee_drenaje               :boolean
#  tipo_drenaje_id             :integer
#  condicion_drenaje           :string(1)
#  superficie_drenaje          :float
#  condiciones_climaticas      :text
#  rubros_animales             :text
#  densidad_siembra            :float
#


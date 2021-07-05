# encoding: utf-8

#
# autor: 
# clase: ServiciosBasicos
# descripción: Migración a Rails 3
#

class ServiciosBasicos < ActiveRecord::Base
  
  
  self.table_name = 'servicios_basicos'
  
  attr_accessible :id,
				  :solicitud_id,
				  :unidad_produccion_id,
				  :seguimiento_visita_id,
				  :vivienda,
				  :electricidad,
				  :transporte_publico,
				  :telefono,
				  :gas,
				  :aguas_blancas,
				  :aguas_servidas,
				  :observaciones_vivienda,
				  :observaciones_electricidad,
				  :observaciones_transporte,
				  :observaciones_gas,
				  :observaciones_aguas_blancas,
				  :observaciones_aguas_servidas,
				  :observaciones_telefono1,
				  :observaciones_telefono2,
				  :observaciones_telefono3
  
  belongs_to :solicitud
  belongs_to :unidad_produccion
  belongs_to :seguimiento_visita
 
  def self.datos(solicitud_id)
    return ServiciosBasicos.find(:first, :conditions=>['solicitud_id = ?', solicitud_id])
  end

  before_save :before_save
  
  
  def before_save

      unless self.observaciones_telefono1.to_s.empty?
        res=self.observaciones_telefono1[/^[0-9]{3,4}-? ?[0-9]{6,7}$/]
        if res.to_s ==""
           errors.add(:servicios_basicos,"El formato de teléfono 1 NO es válido")
        end
      end


      unless self.observaciones_telefono2.to_s.empty?
        res2=self.observaciones_telefono2[/^[0-9]{3,4}-? ?[0-9]{6,7}$/]
        if res2.to_s ==""
           errors.add(:servicios_basicos,"El formato de teléfono 2 NO es válido")
            
        end
      end

      unless self.observaciones_telefono3.to_s.empty?
        res3=self.observaciones_telefono3[/^[0-9]{3,4}-? ?[0-9]{6,7}$/]
        if res3.to_s ==""
           errors.add(:servicios_basicos,"El formato de teléfono 3 NO es válido")
        end
      end

      return errors


  end 


  def validate

      
      unless self.observaciones_telefono1.to_s.empty?
        res=self.observaciones_telefono1[/^[0-9]{3,4}-? ?[0-9]{6,7}$/]
        if res.to_s ==""
           errors.add(:servicios_basicos,"El formato de teléfono 1 NO es válido")
        end
      end


      unless self.observaciones_telefono2.to_s.empty?
        res2=self.observaciones_telefono2[/^[0-9]{3,4}-? ?[0-9]{6,7}$/]
        if res2.to_s ==""
           errors.add(:servicios_basicos,"El formato de teléfono 2 NO es válido")
            
        end
      end

      unless self.observaciones_telefono3.to_s.empty?
        res3=self.observaciones_telefono3[/^[0-9]{3,4}-? ?[0-9]{6,7}$/]
        if res3.to_s ==""
           errors.add(:servicios_basicos,"El formato de teléfono 3 NO es válido")
        end
      end

      return errors

  end

end






# == Schema Information
#
# Table name: servicios_basicos
#
#  id                           :integer         not null, primary key
#  solicitud_id                 :integer         not null
#  unidad_produccion_id         :integer         not null
#  seguimiento_visita_id        :integer         not null
#  vivienda                     :boolean
#  electricidad                 :boolean
#  transporte_publico           :boolean
#  telefono                     :boolean
#  gas                          :boolean
#  aguas_blancas                :boolean
#  aguas_servidas               :boolean
#  observaciones_vivienda       :text
#  observaciones_electricidad   :text
#  observaciones_transporte     :text
#  observaciones_gas            :text
#  observaciones_aguas_blancas  :text
#  observaciones_aguas_servidas :text
#  observaciones_telefono1      :text
#  observaciones_telefono2      :text
#  observaciones_telefono3      :text
#


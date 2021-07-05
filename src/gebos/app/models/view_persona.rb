# encoding: utf-8

#
# 
# clase: ViewPersona
# descripción: Migración a Rails 3
#

class ViewPersona < ActiveRecord::Base

  self.table_name = 'view_persona'
  
  attr_accessible :solicitud_id,:cedula_persona,:nombre_persona,:estado_civil,:sexo_persona,:fecha_nacimiento,:rif_personal,:pasaporte,:ciudad_persona,:estado_persona,:municipio_persona,:parroquia_persona,:correspondencia
  
  
  
  def estado_civil_texto
  case self.sexo_persona
    when true
      case self.estado_civil
        when 'S'
          I18n.t('Sistema.Body.Vistas.General.soltero')
        when 'C'
          I18n.t('Sistema.Body.Vistas.General.casado')
        when 'V'
          I18n.t('Sistema.Body.Vistas.General.viudo')
        when 'D'
          I18n.t('Sistema.Body.Vistas.General.divorciado')
        when 'O'
          I18n.t('Sistema.Body.Vistas.General.concubino')
        when 'U'
          I18n.t('Sistema.Body.Vistas.General.unido')
        end

    when false
      case self.estado_civil
        when 'S'
          I18n.t('Sistema.Body.Vistas.General.soltera')
        when 'C'
          I18n.t('Sistema.Body.Vistas.General.casada')
        when 'V'
          I18n.t('Sistema.Body.Vistas.General.viuda')
        when 'D'
          I18n.t('Sistema.Body.Vistas.General.divorciada')
        when 'O'
          I18n.t('Sistema.Body.Vistas.General.concubina')
        when 'U'
          I18n.t('Sistema.Body.Vistas.General.unida')
        end
    end
  end
end

# == Schema Information
#
# Table name: view_persona
#
#  solicitud_id      :integer
#  cedula_persona    :text
#  nombre_persona    :text
#  estado_civil      :string(1)
#  sexo_persona      :boolean
#  fecha_nacimiento  :text
#  rif_personal      :string(12)
#  pasaporte         :string(20)
#  ciudad_persona    :string(40)
#  estado_persona    :string(40)
#  municipio_persona :string(40)
#  parroquia_persona :string(40)
#  correspondencia   :boolean
#


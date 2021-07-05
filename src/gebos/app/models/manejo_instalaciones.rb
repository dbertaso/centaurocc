# encoding: utf-8
class ManejoInstalaciones < ActiveRecord::Base

  self.table_name = 'manejo_instalaciones'
  
  attr_accessible :id,
    :seguimiento_visita_id,
    :tecnologia_convenio,
    :plan_vacunacion,
    :inseminacion_artificial,
    :descripcion_pajuela,
    :sala_ordenio,
    :tipo_ordenio,
    :calidad_ordenio,
    :refrescadero_leche,
    :calidad_refrescadero,
    :registro,
    :calidad_registro,
    :alimento_concentrado,
    :calidad_alimento_concentrado,
    :otro_tipo_suplementacion,
    :especificar_suplementacion,
    :calidad_suplementacion,
    :descripcion_observado
  
  def validar_manejo(instalaciones)
    success = true
    errores = 0
    if (instalaciones[:tecnologia_convenio].nil? || instalaciones[:tecnologia_convenio].empty? )
      errors.add(:manejo_instalaciones, "#{I18n.t('Sistema.Body.Modelos.ManejoInstalaciones.Columnas.tecnologia_convenio')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
      errores += 1
    end

    if (instalaciones[:plan_vacunacion].nil? || instalaciones[:plan_vacunacion].empty? )
      errors.add(:manejo_instalaciones,"#{I18n.t('Sistema.Body.Modelos.ManejoInstalaciones.Columnas.plan_vacunacion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
      errores += 1
    end

    if (instalaciones[:inseminacion_artificial].nil? || instalaciones[:inseminacion_artificial].empty? )
      errors.add(:manejo_instalaciones,"#{I18n.t('Sistema.Body.Modelos.ManejoInstalaciones.Columnas.inseminacion_artificial')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
      errores += 1
    end

    unless instalaciones[:inseminacion_artificial].to_s == "false"
      if (instalaciones[:descripcion_pajuela].nil? || instalaciones[:descripcion_pajuela].empty? )
        errors.add(:manejo_instalaciones,"#{I18n.t('Sistema.Body.Modelos.ManejoInstalaciones.Columnas.descripcion_pajuela')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
        errores += 1
      end
    else
      self.descripcion_pajuela = "" 
    end
    
    if (instalaciones[:sala_ordenio].nil? || instalaciones[:sala_ordenio].empty? )
      errors.add(:manejo_instalaciones,"#{I18n.t('Sistema.Body.Modelos.ManejoInstalaciones.Columnas.sala_ordenio')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
      errores += 1
    end

    if (instalaciones[:refrescadero_leche].nil? || instalaciones[:refrescadero_leche].empty? )
      errors.add(:manejo_instalaciones,"#{I18n.t('Sistema.Body.Modelos.ManejoInstalaciones.Columnas.refrescadero_leche')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
      errores += 1
    end

    unless instalaciones[:refrescadero_leche].to_s == "false"
      if (instalaciones[:calidad_refrescadero].nil? || instalaciones[:calidad_refrescadero].empty?)
        errors.add(:manejo_instalaciones,"#{I18n.t('Sistema.Body.Modelos.ManejoInstalaciones.Columnas.calidad_refrescadero')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
        errores += 1
      end
    else
      self.calidad_refrescadero = ""
    end

    if (instalaciones[:registro].nil? || instalaciones[:registro].empty? )
      errors.add(:manejo_instalaciones,"#{I18n.t('Sistema.Body.Modelos.ManejoInstalaciones.Columnas.registro_produccion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
      errores += 1
    end

    unless instalaciones[:registro].to_s == "false"
      if (instalaciones[:calidad_registro].nil?  || instalaciones[:calidad_registro].empty?)
        errors.add(:manejo_instalaciones,"#{I18n.t('Sistema.Body.Modelos.ManejoInstalaciones.Columnas.calidad_registro')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
        errores += 1
      end
    else
      self.calidad_registro = ""
    end

    if (instalaciones[:alimento_concentrado].nil? || instalaciones[:alimento_concentrado].empty? )
      errors.add(:manejo_instalaciones,"#{I18n.t('Sistema.Body.Modelos.ManejoInstalaciones.Columnas.alimento_concentrado')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
      errores += 1
    end

    unless instalaciones[:alimento_concentrado].to_s == "false"
      if (instalaciones[:calidad_alimento_concentrado].nil?  || instalaciones[:calidad_alimento_concentrado].empty?)
        errors.add(:manejo_instalaciones,"#{I18n.t('Sistema.Body.Modelos.ManejoInstalaciones.Columnas.calidad_alimento_concentrado')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
        errores += 1
      end
    else
      self.calidad_alimento_concentrado = ""
    end

    if (instalaciones[:otro_tipo_suplementacion].nil? || instalaciones[:otro_tipo_suplementacion].empty? )
      errors.add(:manejo_instalaciones,"#{I18n.t('Sistema.Body.Modelos.ManejoInstalaciones.Columnas.otro_tipo_suplementacion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
      errores += 1
    end


    unless instalaciones[:otro_tipo_suplementacion].to_s == "false"
      if (instalaciones[:especificar_suplementacion].nil?  || instalaciones[:especificar_suplementacion].empty?)
        errors.add(:manejo_instalaciones,"#{I18n.t('Sistema.Body.Modelos.ManejoInstalaciones.Columnas.especificar_suplementacion')}")
        errores += 1
      end
      if (instalaciones[:calidad_suplementacion].nil?  || instalaciones[:calidad_suplementacion].empty?)
        errors.add(:manejo_instalaciones,"#{I18n.t('Sistema.Body.Modelos.ManejoInstalaciones.Columnas.calidad_suplementacion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
        errores += 1
      end
    else
      self.especificar_suplementacion = ""
      self.calidad_suplementacion = ""
    end

    if (errores > 0)
      success = false
    end
    return success
  end


end


# == Schema Information
#
# Table name: manejo_instalaciones
#
#  id                           :integer         not null, primary key
#  seguimiento_visita_id        :integer         not null
#  tecnologia_convenio          :boolean         default(FALSE), not null
#  plan_vacunacion              :boolean         default(FALSE), not null
#  inseminacion_artificial      :boolean         default(FALSE), not null
#  descripcion_pajuela          :text
#  sala_ordenio                 :boolean         default(FALSE), not null
#  tipo_ordenio                 :string(2)
#  calidad_ordenio              :string(1)
#  refrescadero_leche           :boolean         default(FALSE), not null
#  calidad_refrescadero         :string(1)
#  registro                     :boolean         default(FALSE), not null
#  calidad_registro             :string(1)
#  alimento_concentrado         :boolean         default(FALSE), not null
#  calidad_alimento_concentrado :string(1)
#  otro_tipo_suplementacion     :boolean         default(FALSE), not null
#  especificar_suplementacion   :text
#  calidad_suplementacion       :string(1)
#  descripcion_observado        :text
#


# encoding: utf-8

#
# autor: 
# clase: UnidadNegocio
# descripción: Migración a Rails 3
#
class UnidadNegocio < ActiveRecord::Base
  
  self.table_name = 'unidad_negocio'
  
  attr_accessible :id,
                  :nombre,
                  :tenencia_unidad_produccion_id,
                  :propiedad_local,
                  :cuota_mensual,
                  :tiempo_unidad_negocio,
                  :superficie_total,
                  :tipo_explotacion_id,
                  :experiencia_id,
                  :formacion_id,
                  :porcentaje_ganancia_id,
                  :tamano_negocio,
                  :porcentaje_uso,
                  :actividad_economica_id,
                  :situacion,
                  :solicitud_id
  
  
  belongs_to :tenencia_unidad_produccion
  belongs_to :tipo_explotacion
  belongs_to :experiencia
  belongs_to :formacion
  belongs_to :porcentaje_ganancia
  belongs_to :actividad_economica
  belongs_to :solicitud

  validates :actividad_economica_id,
    :presence => {:message => "^ #{I18n.t('Sistema.Body.Vistas.General.sector_economico')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerida')}"}

  validates :situacion,
    :presence => {:message => "^ #{I18n.t('Sistema.Body.Vistas.General.situacion')} #{I18n.t('Sistema.Body.Modelos.Solicitud.Columnas.unidad_produccion')} / #{I18n.t('Sistema.Body.Vistas.General.negocio')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerida')}"}
  

  validates  :cuota_mensual, :numericality => {:only_integer => false,
    :message => "#{I18n.t('Sistema.Body.Modelos.Prestamo.Columnas.abono_cantidad_cuotas')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}", :allow_nil => true}
  
  validates_numericality_of :cuota_mensual,
    :only_integer => false, :allow_nil => true,
    :message => "^ #{I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.UnidadNegocio.cuota_mensual')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}"

  
  validates  :porcentaje_uso, :numericality => {:only_integer => true,
    :message => "#{I18n.t('Sistema.Body.Modelos.Prestamo.Columnas.abono_cantidad_cuotas')} #{I18n.t('Sistema.errors.messages_not_an_integer')}", :allow_nil => true}
  
  validates_numericality_of :porcentaje_uso,
    :only_integer => true, :allow_nil => true,
    :message => "^ #{I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.UnidadNegocio.porcentaje_capacidad_instalada')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}"

  validates  :tiempo_unidad_negocio, :numericality => {:only_integer => true,
    :message => "#{I18n.t('Sistema.Body.Modelos.Prestamo.Columnas.abono_cantidad_cuotas')} #{I18n.t('Sistema.errors.messages_not_an_integer')}", :allow_nil => true}
  
  
  validates_numericality_of :tiempo_unidad_negocio,
    :only_integer => true, :allow_nil => true,
    :message => "^ #{I18n.t('Sistema.Body.Vistas.General.tiempo')} #{I18n.t('Sistema.Body.Modelos.Solicitud.Columnas.unidad_produccion')} / #{I18n.t('Sistema.Body.Vistas.General.negocio')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}"

  validates  :superficie_total, :numericality => {:only_integer => false,
    :message => "#{I18n.t('Sistema.Body.Modelos.Prestamo.Columnas.abono_cantidad_cuotas')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}", :allow_nil => true}


  validates_numericality_of :superficie_total,
    :only_integer => false, :allow_nil => true,
    :message => "^ #{I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.UnidadNegocio.superficie_total')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}"

  validate :validate
  
  def validate
    if self.solicitud.cliente.type.to_s=='ClienteEmpresa'
      #if self.Solicitud.cliente.empresa.sector_economico.tipo_formulario == 2
        tipo_formulario = self.solicitud.cliente.empresa.sector_economico.tipo_formulario
      else
        tipo_formulario = self.solicitud.cliente.persona.sector_economico.tipo_formulario
      end
    #end

    if tipo_formulario == 2
      if self.propiedad_local.nil? || self.propiedad_local.empty?
        errors.add(:unidad_negocio, "#{I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.UnidadNegocio.propiedad_local')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
      else
        unless self.propiedad_local == 'Propio'
          if self.cuota_mensual.nil?
            errors.add(:unidad_negocio, "#{I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.UnidadNegocio.cuota_mensual')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
          end
        end
      end
      if self.tiempo_unidad_negocio.nil?
        errors.add(:unidad_negocio, "#{I18n.t('Sistema.Body.Vistas.General.tiempo')} #{I18n.t('Sistema.Body.Modelos.Solicitud.Columnas.unidad_produccion')} / #{I18n.t('Sistema.Body.Vistas.General.negocio')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
      elsif self.tiempo_unidad_negocio.to_i.to_s.length != self.tiempo_unidad_negocio.to_s.length
        errors.add(:unidad_negocio, "#{I18n.t('Sistema.Body.Vistas.General.tiempo')} #{I18n.t('Sistema.Body.Modelos.Solicitud.Columnas.unidad_produccion')} / #{I18n.t('Sistema.Body.Vistas.General.negocio')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}")
      elsif self.tiempo_unidad_negocio.to_i < 1
        errors.add(:unidad_negocio, "#{I18n.t('Sistema.Body.Vistas.General.tiempo')} #{I18n.t('Sistema.Body.Modelos.Solicitud.Columnas.unidad_produccion')} / #{I18n.t('Sistema.Body.Vistas.General.negocio')} #{I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.UnidadNegocio.numero_invalido_mayor_cero')}")
      end
    else
      if self.nombre.nil? || self.nombre.empty?
        errors.add(:unidad_negocio, "#{I18n.t('Sistema.Body.Vistas.Form.nombre')} #{I18n.t('Sistema.Body.Modelos.Solicitud.Columnas.unidad_produccion')} / #{I18n.t('Sistema.Body.Vistas.General.negocio')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
      end
      if self.tenencia_unidad_produccion.nil?
        errors.add(:unidad_negocio, "#{I18n.t('Sistema.Body.Controladores.TenenciaUnidadProduccion.FormTitles.form_title')} / #{I18n.t('Sistema.Body.Vistas.General.negocio')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
      end
      if self.superficie_total_f.nil?
        logger.info "entro en el error"
        errors.add(:unidad_negocio, "#{I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.UnidadNegocio.superficie_total')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
      end
      if self.tipo_explotacion.nil?
        errors.add(:unidad_negocio, "#{I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.UnidadNegocio.tipo_explotacion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
      end
    end
    unless self.porcentaje_uso.nil?
      if self.porcentaje_uso > 100
        errors.add(:unidad_negocio, "#{I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.UnidadNegocio.no_puede_ser_mayor_cien')}")
      elsif self.porcentaje_uso < 0
        errors.add(:unidad_negocio, "#{I18n.t('Sistema.Body.Modelos.Plantilla.Etiquetas.UnidadNegocio.no_puede_ser_menor_cero')}")
      end
    end
  end

  def cuota_mensual_f=(valor)
    self.cuota_mensual = fecha_f(valor)
  end

  def cuota_mensual_f
    format_fecha(self.cuota_mensual)    
  end

  def superficie_total_f=(valor)    
    self.superficie_total = fecha_f(valor)
  end

  def superficie_total_f
    format_fecha(self.superficie_total)    
  end

  def save_new(parametros, solicitud_id)
    self.solicitud_id = solicitud_id
    if self.solicitud.cliente.type.to_s == 'ClienteEmpresa'
      sector_economico_id = self.solicitud.cliente.empresa.sector_economico.tipo_formulario
    else
      sector_economico_id = self.solicitud.cliente.persona.sector_economico.tipo_formulario
    end
    if sector_economico_id == 2
      self.propiedad_local = parametros[:propiedad_local]
      self.cuota_mensual_f = parametros[:cuota_mensual_f]
      self.tamano_negocio = parametros[:tamano_negocio]
      self.porcentaje_uso = parametros[:porcentaje_uso]
      self.nombre = self.propiedad_local
    else
      self.nombre = parametros[:nombre]
      self.tenencia_unidad_produccion_id = parametros[:tenencia_unidad_produccion_id]
      self.superficie_total_f = parametros[:superficie_total_f]
      self.tipo_explotacion_id = parametros[:tipo_explotacion_id]
    end
    self.tiempo_unidad_negocio = parametros[:tiempo_unidad_negocio]
    self.experiencia_id = parametros[:experiencia_id]
    self.formacion_id = parametros[:formacion_id]
    self.porcentaje_ganancia_id = parametros[:porcentaje_ganancia_id]
    self.actividad_economica_id = parametros[:actividad_economica_id]
    self.situacion = parametros[:situacion]
    self.save
  end

end

# == Schema Information
#
# Table name: unidad_negocio
#
#  id                            :integer         not null, primary key
#  nombre                        :string(100)
#  tenencia_unidad_produccion_id :integer
#  propiedad_local               :string(50)
#  cuota_mensual                 :float
#  tiempo_unidad_negocio         :integer
#  superficie_total              :float
#  tipo_explotacion_id           :integer
#  experiencia_id                :integer
#  formacion_id                  :integer
#  porcentaje_ganancia_id        :integer
#  tamano_negocio                :string(100)
#  porcentaje_uso                :integer
#  actividad_economica_id        :integer
#  situacion                     :integer         not null
#  solicitud_id                  :integer         not null
#


# encoding: utf-8

#
# autor: Diego Bertaso
# clase: ControlAsignacion
# descripción: Migración a Rails 3


class ControlAsignacion < ActiveRecord::Base

  self.table_name = 'control_asignacion'

  attr_accessible :id,
                  :fecha,
                  :usuario_id,
                  :solicitud_id,
                  :observacion,
                  :asignacion,
                  :unidad

  belongs_to :usuario
  belongs_to :solicitud

  validate :valida_observacion

  validates_presence_of :solicitud_id,
    :message => I18n.t('Sistema.Body.Modelos.Errores.es_requerido')

  validates_presence_of :usuario_id,
    :message => I18n.t('Sistema.Body.Modelos.ControlAsignacion.Errores.es_requerido')

  #validates_length_of :observacion, :within => 0..500, :allow_nil => true

  def valida_observacion
    unless self.asignacion == true
      if self.observacion.nil? || self.observacion.empty?
        errors.add(:control_asignacion, I18n.t('Sistema.Body.Modelos.Errores.observaciones_es_requerido'))
      end
    end
  end

  def fecha_f
    self.fecha.strftime('%d/%m/%Y') unless self.fecha.nil?
  end

  def self.eliminar(id)
    solicitud = Solicitud.find(id)
    solicitud.update_attribute(:usuario_pre_evaluacion, nil)
    solicitud.save
  end

  def self.asignar_resguardo(parametros, solicitud_id, asignacion, unidad)
    control_asignacion = ControlAsignacion.new(parametros)
    control_asignacion.fecha = Time.now
    control_asignacion.solicitud_id = solicitud_id
    control_asignacion.asignacion = asignacion
    control_asignacion.unidad = unidad
    if control_asignacion.save
      usuario = Usuario.find(control_asignacion.usuario_id)
      solicitud = Solicitud.find(solicitud_id)
      solicitud.usuario_resguardo = usuario.nombre_usuario
      solicitud.save
      return true
    else
      errores = ''
      control_asignacion.errors.each { |e|
        errores << "<li>" + e[1] + "</li>"
      }
      return errores
    end
  end

  def self.dias_trancurridos(id)
    control = ControlAsignacion.find(:first, :conditions=>"solicitud_id = #{id}", :order=>' id desc')
    hoy = Time.now
    fecha = Time.parse(control.fecha.to_s)
    diferencia = (hoy - fecha).to_i
    return (((diferencia / 60) / 60) / 24).to_i
  end

  def self.asignacion(id)
    control = ControlAsignacion.find(:first, :conditions=>"solicitud_id = #{id}", :order=>' id desc')
    return control.fecha.strftime('%d/%m/%Y')
  end

end

# == Schema Information
#
# Table name: control_asignacion
#
#  id           :integer         not null, primary key
#  fecha        :date            not null
#  usuario_id   :integer         not null
#  solicitud_id :integer         not null
#  observacion  :string(500)
#  asignacion   :boolean
#  unidad       :string(1)
#


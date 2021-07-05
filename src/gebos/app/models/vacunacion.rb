# encoding: utf-8
class Vacunacion < ActiveRecord::Base

  self.table_name = 'vacunacion'
  
  attr_accessible :id, 
    :sanidad_animal_id,
    :vacuna_id,
    :fecha_colocacion,
    :fecha_colocacion_f
  
  belongs_to :sanidad_animal
  belongs_to :vacuna, :foreign_key => "vacuna_id"
  
  validates :sanidad_animal, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Columnas.sanidad_animal')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :fecha_colocacion,
    :date => {:message =>"#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Columnas.fecha_colocacion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalida')}",
    :before => Proc.new { 1.day.from_now.to_date }, :message => "#{I18n.t('Sistema.Body.Modelos.SeguimientoVisita.Columnas.fecha_colocacion')} I18n.t('Sistema.Body.Modelos.SeguimientoCultivo.Errores.fecha_no_posterior_fecha_actual')"}

  def fecha_colocacion_f=(fecha)
    self.fecha_colocacion = fecha
  end

  def fecha_colocacion_f
    format_fecha(self.fecha_colocacion)
  end
  
  
  def self.create_new(parametros, sanidad_animal_id)
    vacunacion = Vacunacion.new(parametros)
    logger.debug"XXXXX========Vacuna========>>>>"<<vacunacion.inspect
    vacunacion.sanidad_animal_id = sanidad_animal_id
    logger.debug"XXXXX========Vacuna========>>>>"<<vacunacion.inspect
    if vacunacion.save
      return true
    else
      errores = ''
      vacunacion.errors.full_messages.each do |error|
        errores << "<li>#{error}</li>"
      end
      return errores
    end
  end

  def self.delete(id)
    vacunacion = Vacunacion.find(id)
    vacunacion.destroy
    return true
  end
  
  

end


# == Schema Information
#
# Table name: vacunacion
#
#  id                :integer         not null, primary key
#  sanidad_animal_id :integer
#  vacuna_id         :integer
#  fecha_colocacion  :date
#


# encoding: utf-8
class MotivoVisita < ActiveRecord::Base

  self.table_name = 'motivo_visita'
  
  attr_accessible  :id,
    :nombre,
    :descripcion,
    :activo
                   
  
  validates :nombre, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.motivo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :format =>{:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio_numero_otro')}/, :allow_blank =>true, :message =>"#{I18n.t('Sistema.Body.Vistas.Form.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalido')}"},
    :uniqueness =>{:uniqueness => true, :message => "#{I18n.t('Sistema.Body.Vistas.MotivoVisita.Etiquetas.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"}

  validates :descripcion, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.Form.descripcion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates_length_of :nombre, :within => 3..40, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.Form.nombre')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.Form.nombre')}  #{I18n.t('errors.messages.too_long.other')}"
      
  validates_length_of :descripcion, :within => 3..300, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.General.descripcion')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => " #{I18n.t('Sistema.Body.General.descripcion')} #{I18n.t('errors.messages.too_long.other')}"
    
  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort
  end
  
  
  def eliminar(id)
    begin
      seguimiento_visita = SeguimientoVisita.count(:conditions=>"motivo_visita_id = #{self.id}")
      if (seguimiento_visita > 0 )
        errors.add(:motivo_visita, "#{I18n.t('Sistema.Body.Vistas.General.motivo')} #{I18n.t('Sistema.Body.Modelos.Errores.posee_registros_asociados')}")
        return false
      else
        motivo_visita = MotivoVisita.find(id)
        transaction do
          motivo_visita.destroy
          return true
        end
      end
    rescue
      errors.add(:motivo_visita, "#{I18n.t('Sistema.Body.Vistas.General.motivo')} #{I18n.t('Sistema.Body.Modelos.Errores.posee_registros_asociados')}")
      return false
    end
  end


end

# == Schema Information
#
# Table name: motivo_visita
#
#  id          :integer         not null, primary key
#  nombre      :string(100)     not null
#  descripcion :string(250)     not null
#  activo      :boolean         default(TRUE), not null
#


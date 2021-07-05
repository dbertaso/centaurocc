# encoding: utf-8
#
# autor: Luis Rojas
# clase: SectorEconomico
# descripción: Migración a Rails 3

class SectorEconomico < ActiveRecord::Base
  self.table_name = 'sector_economico'
  
  attr_accessible :id,
                  :descripcion,
                  :activo,
                  :tipo_formulario,
                  :codigo_d3 
  
  has_many :actividad_economica
  has_many :recaudo
  has_many :persona
  has_many :empresa
  has_many :sector_tipo
  has_many :regla_contable
  
  validates :descripcion, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.Form.descripcion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 3..255, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.Form.descripcion')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.Form.descripcion')} #{I18n.t('errors.messages.too_long.other')}"},
    :uniqueness =>{:uniqueness => true, :message => "#{I18n.t('Sistema.Body.Vistas.Form.descripcion')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_registrado')}", :allow_blank => true}

  def before_destroy()
    @sector_economico = SectorEconomico.find(self.id, :include=>:actividad_economica)
    @actividad_sector = @sector_economico.actividad_economica
    if @actividad_sector.size > 0
      errors.add nil, "El Sector no puede ser eliminado porque tiene registros asociados"
      return false
    end 
  end
  
end

# == Schema Information
#
# Table name: sector_economico
#
#  id              :integer         not null, primary key
#  descripcion     :string(250)     not null
#  activo          :boolean
#  tipo_formulario :integer
#  codigo_d3       :integer         default(0)
#


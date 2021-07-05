# encoding: utf-8

#
# autor: 
# clase: UnidadProduccionVocacionTierra
# descripción: Migración a Rails 3
#


class UnidadProduccionVocacionTierra < ActiveRecord::Base

  self.table_name = 'unidad_produccion_vocacion_tierra'
  
  attr_accessible :id,
                  :solicitud_id,
                  :unidad_produccion_id,
                  :vocacion_tierra_id,
                  :seguimiento_visita_id,
                  :descripcion_otro
  
  
  belongs_to :unidad_produccion
  belongs_to :vocacion_tierra
     
  validates :unidad_produccion_id, 
  :presence => { :message => I18n.t('Sistema.Body.Modelos.Solicitud.Columnas.unidad_produccion') <<" "<<I18n.t('Sistema.Body.Modelos.Errores.es_requerida')}
      
  validates :vocacion_tierra_id, 
  :presence => { :message => I18n.t('Sistema.Body.Controladores.VocacionTierra.FormTitles.form_title')<<" "<< I18n.t('Sistema.Body.Modelos.Errores.es_requerida') }
      

  def self.clonar_vocacion_tierra(unidad_produccion_id)
    unless UnidadProduccionVocacionTierra.count(:conditions=>['unidad_produccion_id = ?', unidad_produccion_id]) > 0
      if UnidadProduccion.count(:conditions=>['id = ?', unidad_produccion_id]) > 0
        vocacion_tierra = VocacionTierra.find(:all, :conditions=>['activo = true'], :order=>'nombre' )
        vocacion_tierra.each { |i|
          unidad_produccion_vocacion_tierra = UnidadProduccionVocacionTierra.new
          unidad_produccion_vocacion_tierra.unidad_produccion_id = unidad_produccion_id
          unidad_produccion_vocacion_tierra.vocacion_tierra_id = i.id
          #unidad_produccion_vocacion_tierra.entregado = false
          unidad_produccion_vocacion_tierra.save
        }
      end
    end
  end

end


# == Schema Information
#
# Table name: unidad_produccion_vocacion_tierra
#
#  id                    :integer         not null, primary key
#  solicitud_id          :integer
#  unidad_produccion_id  :integer         not null
#  vocacion_tierra_id    :integer         not null
#  seguimiento_visita_id :integer         not null
#  descripcion_otro      :text
#


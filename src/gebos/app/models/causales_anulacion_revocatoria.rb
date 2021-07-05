# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: CausalesAnulacionRevocatoria
# descripción: Migración a Rails 3
#

class CausalesAnulacionRevocatoria < ActiveRecord::Base

  self.table_name = 'causales_anulacion_revocatoria' 
  
  attr_accessible :id,
                  :anulacion,
                  :revocatoria_parcial,
                  :revocatoria_total,
                  :causa


  validates_presence_of :causa, 
    :message => "#{I18n.t('Sistema.Body.Vistas.Arrime.Etiquetas.causa')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerida')}"
    
  validates_length_of :causa, :within => 10..400, :allow_nil => false,
   :too_long => I18n.t('Sistema.Body.Vistas.Arrime.Etiquetas.causa') << " " << I18n.t('errors.messages.too_long.other'),
   :too_short => I18n.t('Sistema.Body.Vistas.Arrime.Etiquetas.causa') << " " << I18n.t('errors.messages.too_short.other')   
      
  validates_uniqueness_of :causa, 
    :message => "#{I18n.t('Sistema.Body.Vistas.Arrime.Etiquetas.causa')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"
  
  
  before_destroy :before_destroy    

  def before_destroy
    
    retorno = true
    #por terminar
    hay = Solicitud.find_by_causa_revocatoria_anulacion(self.id)    
    unless hay.nil?
      errors.add(:causales_anulacion_revocatoria,I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.no_puede_eliminar_causal')) 
      retorno = false
    end
    return retorno
    
  end
  
  validate :validate    

  def validate
    unless self.causa.nil?
      a = self.causa[/^[a-zA-ZñÑáÁéÉíÍóÓúÚüÜÇ,' ]+$/]
      if a.nil?
        errors.add(:causales_anulacion_revocatoria, I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.causa_permite_alfanumericos'))
      end
    end    
    if !self.anulacion && !self.revocatoria_parcial && !self.revocatoria_total
        errors.add(:causales_anulacion_revocatoria, I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Mensajes.causal_aplicada_tiene_seleccionar_opcion'))
    end
  
  end  
  

  def self.search(search, page, orden)    
    paginate :per_page=>@records_by_page, :page=>page, :conditions=>search, :order=>orden
  end
end

# == Schema Information
#
# Table name: causales_anulacion_revocatoria
#
#  id                  :integer         not null, primary key
#  anulacion           :boolean         default(FALSE)
#  revocatoria_parcial :boolean         default(FALSE)
#  revocatoria_total   :boolean         default(FALSE)
#  causa               :text
#


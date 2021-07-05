# encoding: utf-8
class OpcionAccion < ActiveRecord::Base

  self.table_name = 'opcion_accion'
  
  attr_accessible  :opcion_id,
                   :accion_id,
                   :autorizacion,
                   :autorizacion_tiempo_tipo,
                   :autorizacion_tiempo,
                   :autorizacion_extendida

  belongs_to :opcion
  belongs_to :accion

  validates_uniqueness_of :accion_id, :scope=>'opcion_id' 
  
  validates :opcion, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.OpcionAccion.Errores.accion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :accion, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.OpcionAccion.Errores.opcion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  
  def after_initialize    
    self.autorizacion = false unless self.autorizacion
  end
  
  def autorizacion_tiempo_w
    self.autorizacion_tiempo.to_s + ' ' + self.autorizacion_tiempo_tipo_w
  end
  
  def autorizacion_nombre
    self.opcion.nombre + ' - ' + self.accion.nombre
  end
  
  def autorizacion_tiempo_tipo_w
    case self.autorizacion_tiempo_tipo
    when 'M'
      I18n.t('Sistema.Body.Modelos.OpcionAccion.Errores.minutos')
    when 'H'
      I18n.t('Sistema.Body.Modelos.OpcionAccion.Errores.horas')
    when 'D'
      I18n.t('Sistema.Body.Modelos.OpcionAccion.Errores.dias')
    end
  end
  
   def self.search(search, page, sort, joins)
    paginate :per_page => @records_by_page, :page => page,
             :conditions => search, :order => sort,
#             :select=>'opcion_accion.*,accion.*,opcion.*',
             :joins=>joins
  end
  

end


# == Schema Information
#
# Table name: opcion_accion
#
#  id                       :integer         not null, primary key
#  opcion_id                :integer         not null
#  accion_id                :integer         not null
#  autorizacion             :boolean         default(FALSE)
#  autorizacion_tiempo_tipo :string(1)       default("D")
#  autorizacion_tiempo      :integer
#  autorizacion_extendida   :boolean         default(FALSE)
#


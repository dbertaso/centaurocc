# encoding: utf-8
class ProgramaTipoGarantia < ActiveRecord::Base

  self.table_name = 'programa_tipo_garantia'

  attr_accessible :id,
    :programa_id,
    :tipo_garantia_id,
    :relacion_garantia,
    :relacion_garantia_f

  belongs_to :programa
  belongs_to :tipo_garantia

  validates :programa,
    :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.programa')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :tipo_garantia,
    :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.tipo')} #{I18n.t('Sistema.Body.Vistas.General.garantia')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :relacion_garantia,
    :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.relacion')} #{I18n.t('Sistema.Body.Vistas.General.garantia')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  
  validates_uniqueness_of :tipo_garantia_id,
    :scope => [:programa_id],
    :message => "#{I18n.t('Sistema.Body.Vistas.General.tipo')} #{I18n.t('Sistema.Body.Vistas.General.garantia')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"

  def self.search(search, page, sort)
    joins = 'INNER JOIN tipo_garantia ON programa_tipo_garantia.tipo_garantia_id = tipo_garantia.id'
    unless search.nil?
      paginate  :per_page => @records_by_page, :page => page,
        :conditions => search, :order => sort, :joins=>joins
    else
      paginate  :per_page => @records_by_page, :page => page,
        :order => sort, :joins=>joins
    end
  end
  
#  def after_initialize
#    
#  end
  
  def relacion_garantia_f=(valor)
    self.relacion_garantia = format_valor(valor)
  end
  
  def relacion_garantia_f
    format_f(self.relacion_garantia)
  end
  
  def nombre_garantia
    
    tipo = eliminar_acentos(self.tipo_garantia.nombre.to_s)
    tipo = tipo.upcase
    logger.info"XXXXXXXXXXXX==================>>>>>>"<<tipo.inspect
    return tipo
  end
  
  def eliminar_acentos(tipo)
    tipo = tipo.to_s
    tipo.downcase!
    tipo.gsub!(/[á|Á]/,'a')
    tipo.gsub!(/[é|É]/,'e')
    tipo.gsub!(/[í|Í]/,'i')
    tipo.gsub!(/[ó|Ó]/,'o')
    tipo.gsub!(/[ú|Ú]/,'u')
    return tipo
  end
  
  
  def delete(id)
    begin
      tipo = ProgramaTipoGarantia.find(id)
      transaction do
        tipo.destroy
        return true
      end
    rescue
      errors.add(:programa_tipo_garantia, I18n.t('Sistema.Body.Modelos.Errores.item_utilizado'))
      return false
    end
  end
  
end

# == Schema Information
#
# Table name: programa_tipo_garantia
#
#  id                :integer         not null, primary key
#  programa_id       :integer         not null
#  tipo_garantia_id  :integer         not null
#  relacion_garantia :decimal(16, 2)  default(0.0)
#


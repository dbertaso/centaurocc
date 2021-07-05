# encoding: utf-8
class Vacuna < ActiveRecord::Base

  self.table_name = 'vacuna'
  
  attr_accessible  :id, :descripcion


validates :descripcion,
    :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates_length_of :descripcion, :within => 1..100, :allow_nil => false,
    :too_short =>"#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('errors.messages.too_long.other')}"

  validates_uniqueness_of :descripcion,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"


  
  before_save :mayu_descri
  
  def mayu_descri
    self.descripcion = mayuscula(self.descripcion)
  end

  def mayuscula(texto)
    unless texto.nil?
      texto  = texto.gsub('á', 'Á')
      texto  = texto.gsub('é', 'É')
      texto  = texto.gsub('í', 'Í')
      texto  = texto.gsub('ó', 'Ó')
      texto  = texto.gsub('ú', 'Ú')
      texto  = texto.upcase
    end
    return texto
  end


  def self.search(search, page, orden)    

    conditions=search
    
  
    logger.info "Conditions ===> " << conditions.to_s
    paginate :per_page=>@records_by_page, :page=>page, :conditions=>conditions, :order=>orden
  end

end


# == Schema Information
#
# Table name: vacuna
#
#  id          :integer         not null, primary key
#  descripcion :text
#


#encoding: utf-8
class TipoTopografia < ActiveRecord::Base
  
  self.table_name = 'tipo_topografia'
  
  attr_accessible :id,
    :nombre,
    :descripcion,
    :activo

  has_many :caracterizacion_tipo_topografia
  has_many :condiciones_tipo_topografia
  
  validates :nombre, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.Form.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :format =>{:with => /#{I18n.t('Sistema.Body.General.validar_nombre')}/, :allow_blank =>true, 
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}"},
    :length => { :in => 3..20, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.Form.nombre')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.Form.nombre')}  #{I18n.t('errors.messages.too_long.other')}"},
    :uniqueness =>{:uniqueness => true, :message => "#{I18n.t('Sistema.Body.Vistas.Form.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}" }
  
  validates :descripcion, :presence => {
    :message => "#{I18n.t('Sistema.Body.General.descripcion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
    
  validates_length_of :descripcion, :within => 3..40, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.General.descripcion')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.General.descripcion')}  #{I18n.t('errors.messages.too_long.other')}"

  def before_save
    self.nombre = mayuscula(self.nombre)
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

  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort
  end

end


# == Schema Information
#
# Table name: tipo_topografia
#
#  id          :integer         not null, primary key
#  nombre      :text            not null
#  descripcion :text            not null
#  activo      :boolean         default(TRUE)
#


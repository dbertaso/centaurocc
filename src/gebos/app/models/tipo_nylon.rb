# encoding: utf-8
class TipoNylon < ActiveRecord::Base
  
  self.table_name = 'tipo_nylon'
 
  attr_accessible  :id,
    :tipo,
    :descripcion,
    :activo

  belongs_to :arte_pesca
   
  validates :tipo, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.tipo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :format =>{:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio_numero_otro')}/, :allow_blank =>true, :message =>"#{I18n.t('Sistema.Body.Vistas.General.tipo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalido')}"},
    :length => { :in => 3..40, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.tipo')} es demasiado corto (mínimo %d)",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.tipo')}  es demasiado largo (máximo %d)"},
    :uniqueness =>{:uniqueness => true, :message => "#{I18n.t('Sistema.Body.Vistas.General.tipo')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"}

    
    
  
  validates :descripcion, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.Form.descripcion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
#  validates_length_of :tipo, :within => 3..40, :allow_blank => true,
#    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.tipo')} #{I18n.t('errors.messages.too_short.other')}",
#    :too_long => " #{I18n.t('Sistema.Body.Vistas.General.tipo')} #{I18n.t('errors.messages.too_long.other')}"
  
  validates_length_of :descripcion, :within => 3..300, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.General.descripcion')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => " #{I18n.t('Sistema.Body.General.descripcion')} #{I18n.t('errors.messages.too_long.other')}"

#  validates_uniqueness_of :tipo,
#    :message => "#{I18n.t('Sistema.Body.Vistas.General.tipo')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"
 
  
  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort
  end
  
  def before_save
    self.tipo = mayuscula(self.tipo)
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
  
end


# == Schema Information
#
# Table name: tipo_nylon
#
#  id          :integer         not null, primary key
#  tipo        :string(100)     not null
#  descripcion :string(250)     not null
#  activo      :boolean         default(TRUE), not null
#


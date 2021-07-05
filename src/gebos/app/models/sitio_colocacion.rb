# encoding: utf-8
class SitioColocacion < ActiveRecord::Base

  self.table_name = 'sitio_colocacion'
  
  attr_accessible :id,
    :sitio,
    :nombre,
    :activo
  
  belongs_to :equipo_seguridad
  has_many :unidad_produccion_colocacion


 
  validates :sitio, :presence=>{
    :message =>"#{I18n.t('Sistema.Body.Vistas.SitioColocacion.Etiquetas.sitio')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :format =>{:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio_numero_otro')}/, :allow_blank =>true, :message =>"#{I18n.t('Sistema.Body.Vistas.SitioColocacion.Etiquetas.sitio')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalido')}"},
    :uniqueness =>{:uniqueness => true, :message => "#{I18n.t('Sistema.Body.Vistas.SitioColocacion.Etiquetas.sitio')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"}
  
  validates :nombre, :presence=>{
    :message =>"#{I18n.t('Sistema.Body.Vistas.SitioColocacion.Etiquetas.sitio_colocacion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates_length_of :sitio, :within => 3..150, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.SitioColocacion.Etiquetas.sitio')} es demasiado corto (mínimo %{count})",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.SitioColocacion.Etiquetas.sitio')}  es demasiado largo (máximo %{count})"
  
  validates_length_of :nombre, :within => 3..40, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.SitioColocacion.Etiquetas.sitio_colocacion')} es demasiado corto (mínimo %{count})",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.SitioColocacion.Etiquetas.sitio_colocacion')}  es demasiado largo (máximo %{count})"

  def before_save
    self.sitio = mayuscula(self.sitio)
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
# Table name: sitio_colocacion
#
#  id     :integer         not null, primary key
#  sitio  :text            not null
#  nombre :text            not null
#  activo :boolean         default(TRUE)
#


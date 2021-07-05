# encoding: utf-8
class TipoPastoForraje < ActiveRecord::Base

  self.table_name = 'tipo_pasto_forraje'

  attr_accessible  :id,
                   :descripcion
  
  has_many :especie_variedad_pasto
  has_one :pastizales_potreros

  validates :descripcion, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.Form.descripcion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :format =>{:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio_numero_otro')}/, :allow_blank =>true, :message =>"#{I18n.t('Sistema.Body.Vistas.Form.descripcion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalido')}"},
    :length => { :in => 3..300, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.Form.descripcion')} es demasiado corto (mínimo %d)",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.Form.descripcion')}  es demasiado largo (máximo %d)"},
    :uniqueness =>{:uniqueness => true, :message => "#{I18n.t('Sistema.Body.Vistas.Form.descripcion')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"}

    
        
#  validates_length_of :descripcion, :within => 3..300, :allow_blank => true
#
#  validates_uniqueness_of :descripcion,
#    :message => "#{I18n.t('Sistema.Body.Vistas.Form.descripcion')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"

  def before_save
    self.descripcion = mayuscula(self.descripcion)
  end
  
  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort
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
# Table name: tipo_pasto_forraje
#
#  id          :integer         not null, primary key
#  descripcion :string(30)
#


# encoding: utf-8
class ArtePesca < ActiveRecord::Base

  self.table_name = 'arte_pesca'
  
  attr_accessible   :id, 
                    :es_propia,
                    :nombre_arte_pesca,
                    :cantidad,
                    :largo,
                    :ancho,
                    :alto,
                    :luz_maya,
                    :nro_anzuelo,
                    :cantidad_anzuelos,
                    :material_linea_madre,
                    :material,
                    :tipo_cordel,
                    :nro_cordel,
                    :tipo_nylon_id,
                    :seguimiento_visita_id,
                    :embarcacion_id,
                    :condicion,
                    :tipo_arte_pesca_id,
                    :largo_f,
                    :ancho_f,
                    :alto_f
                    
    
  belongs_to :tipo_arte_pesca
  belongs_to :tipo_nylon
  belongs_to :seguimiento_visita
  belongs_to :embarcacion

#  validates :es_propia, :inclusion =>{:in=>[true, false], 
#    :message => I18n.t('Sistema.Body.Modelos.Embarcacion.Errores.propia_si_no')}

  validates :embarcacion_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Controladores.Embarcacion.FormTitles.form_title')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :tipo_nylon_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Controladores.TipoNylon.FormTitles.form_title_record')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :tipo_arte_pesca_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Controladores.TipoArtePesca.FormTitles.form_title')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :cantidad, :numericality =>{:numericality => true, :only_integer =>true, 
    :message => "#{I18n.t('Sistema.Body.Vistas.General.cantidad')} #{I18n.t('errors.messages.not_a_number')}"},
    :inclusion =>{:in=>1..1000, :message => "#{I18n.t('Sistema.Body.Modelos.ArtePesca.Columnas.cantidad')} #{I18n.t('errors.messages.inclusion')}"}

  validates :luz_maya, :length => { :in => 1..160, :allow_blank => false,
    :too_short => "#{I18n.t('Sistema.Body.Modelos.ArtePesca.Columnas.luz_maya')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Modelos.ArtePesca.Columnas.luz_maya')}  #{I18n.t('errors.messages.too_long.other')}"}

  validates :nro_anzuelo, :numericality =>{:numericality => true, :only_integer =>true, 
    :message => "#{I18n.t('Sistema.Body.Modelos.ArtePesca.Columnas.nro_anzuelo')} #{I18n.t('errors.messages.not_an_integer_decimal')}"},
    :inclusion =>{:in=>0..1000, :message => "#{I18n.t('Sistema.Body.Modelos.ArtePesca.Columnas.nro_anzuelo')} #{I18n.t('errors.messages.inclusion')}"}
  
  validates :cantidad_anzuelos, :numericality =>{:numericality => true, :only_integer =>true, 
    :message => "#{I18n.t('Sistema.Body.Modelos.ArtePesca.Columnas.cantidad_anzuelos')} #{I18n.t('errors.messages.not_a_number')}"},
    :inclusion =>{:in=>1..1000, :message => "#{I18n.t('Sistema.Body.Modelos.ArtePesca.Columnas.cantidad_anzuelos')} #{I18n.t('errors.messages.inclusion')}"}

  validates :material_linea_madre, :length => { :in => 1..160, :allow_blank => false,
    :too_short => "#{I18n.t('Sistema.Body.Modelos.ArtePesca.Columnas.material_linea_madre')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Modelos.ArtePesca.Columnas.material_linea_madre')}  #{I18n.t('errors.messages.too_long.other')}"}

  validates :material, :length => { :in => 1..160, :allow_blank => false,
    :too_short => "#{I18n.t('Sistema.Body.Modelos.ArtePesca.Columnas.material')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Modelos.ArtePesca.Columnas.material')}  #{I18n.t('errors.messages.too_long.other')}"}

  validates :tipo_cordel, :length => { :in => 1..160, :allow_blank => false,
    :too_short => "#{I18n.t('Sistema.Body.Modelos.ArtePesca.Columnas.tipo_cordel')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Modelos.ArtePesca.Columnas.tipo_cordel')}  #{I18n.t('errors.messages.too_long.other')}"}

  validates :nro_cordel, :numericality =>{:numericality => true, :only_integer =>true, 
    :message => "#{I18n.t('Sistema.Body.Modelos.ArtePesca.Columnas.nro_cordel')} #{I18n.t('errors.messages.not_a_number')}"},
    :inclusion =>{:in=>1..1000, :message => "#{I18n.t('Sistema.Body.Modelos.ArtePesca.Columnas.nro_cordel')} #{I18n.t('errors.messages.inclusion')}"}

  validates :largo, :numericality =>{:numericality => true, :only_integer =>true, 
    :message => "#{I18n.t('Sistema.Body.Modelos.ArtePesca.Columnas.largo')} #{I18n.t('errors.messages.not_a_number')}"},
    :inclusion =>{:in=>1..1000, :message => "#{I18n.t('Sistema.Body.Modelos.ArtePesca.Columnas.largo')} #{I18n.t('errors.messages.inclusion')}"}

  validates :ancho, :numericality =>{:numericality => true, :only_integer =>true, 
    :message => "#{I18n.t('Sistema.Body.Modelos.ArtePesca.Columnas.ancho')} #{I18n.t('errors.messages.not_a_number')}"},
    :inclusion =>{:in=>1..1000, :message => "#{I18n.t('Sistema.Body.Modelos.ArtePesca.Columnas.ancho')} #{I18n.t('errors.messages.inclusion')}"}

  validates :alto, :numericality =>{:numericality => true, :only_integer =>true, 
    :message => "#{I18n.t('Sistema.Body.Modelos.ArtePesca.Columnas.alto')} #{I18n.t('errors.messages.not_a_number')}"},
    :inclusion =>{:in=>1..1000, :message => "#{I18n.t('Sistema.Body.Modelos.ArtePesca.Columnas.alto')} #{I18n.t('errors.messages.inclusion')}"}
 
  validates :condicion, :length => { :in => 1..20, :allow_blank => false,
    :too_short => "#{I18n.t('Sistema.Body.Modelos.Embarcacion.Columnas.condicion')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Modelos.Embarcacion.Columnas.condicion')}  #{I18n.t('errors.messages.too_long.other')}"}

  def largo_f=(valor)
    self.largo = format_valor(valor)
  end

  def largo_f
    format_f(self.largo)
  end

  def ancho_f=(valor)
    self.ancho = format_valor(valor)
  end

  def ancho_f
    format_f(self.ancho)
  end

  def alto_f=(valor)
    self.alto = format_valor(valor)
  end

  def alto_f
    format_f(self.alto)
  end

  
  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort, :select=>'*'
  end


end




# == Schema Information
#
# Table name: arte_pesca
#
#  id                    :integer         not null, primary key
#  es_propia             :boolean
#  nombre_arte_pesca     :string(160)
#  cantidad              :integer
#  largo                 :float
#  ancho                 :float
#  alto                  :float
#  luz_maya              :string(160)
#  nro_anzuelo           :integer
#  cantidad_anzuelos     :integer
#  material_linea_madre  :string(160)
#  material              :string(160)
#  tipo_cordel           :string(160)
#  nro_cordel            :integer
#  tipo_nylon_id         :integer
#  seguimiento_visita_id :integer
#  embarcacion_id        :integer
#  condicion             :string(20)
#  tipo_arte_pesca_id    :integer
#


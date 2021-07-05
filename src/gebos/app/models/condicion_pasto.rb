# encoding: utf-8

#
# autor: Luis Rojas
# clase: CondicionPasto
# descripción: Migración a Rails 3
#
class CondicionPasto < ActiveRecord::Base
  
  self.table_name = 'condicion_pasto'
  
  attr_accessible :id, :nombre, :descripcion, :activo
  
  validates :nombre, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :uniqueness =>{:uniqueness => true, :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_registrado')}"}
  
  validates :descripcion, :presence => {:message => "#{I18n.t('Sistema.Body.General.descripcion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
    
  validates_length_of :nombre, :within => 3..40, :allow_blank => true
    
  validates_length_of :descripcion, :within => 3..400, :allow_blank => true
   
  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
             :conditions => search, :order => sort
  end

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

end
# == Schema Information
#
# Table name: condicion_pasto
#
#  id          :integer         not null, primary key
#  nombre      :string(100)     not null
#  descripcion :string(255)
#  activo      :boolean         default(TRUE)
#


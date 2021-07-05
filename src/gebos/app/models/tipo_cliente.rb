# encoding: utf-8
#
# autor: Luis Rojas
# clase: TipoCliente
# descripción: Migración a Rails 3
#
class TipoCliente < ActiveRecord::Base

  self.table_name = 'tipo_cliente'

  attr_accessible :id, :nombre, :descripcion, :activo,
    :clasificacion, :codigo_d3

  has_many :recaudo
  has_many :cliente
  has_many :pre_chequeo
  has_many :programa_tipo_cliente
  has_one :tasa

  validates :nombre, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio_numero_puntuacion')}/, 
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}"},
    :uniqueness =>{:uniqueness => true, :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_registrado')}"}
  
  validates :descripcion, :presence => {:message => "#{I18n.t('Sistema.Body.General.descripcion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio_numero_puntuacion')}/, 
    :message => "#{I18n.t('Sistema.Body.General.descripcion')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}"}
    
  validates_length_of :nombre, :within => 3..40, :allow_blank => true
    
  validates_length_of :descripcion, :within => 3..300, :allow_blank => true
   
  def self.search(search, page, sort)

    unless search.nil?
      paginate  :per_page => @records_by_page, :page => page,
        :joins=>'INNER JOIN programa_tipo_cliente ON programa_tipo_cliente.tipo_cliente_id = tipo_cliente.id',
        :conditions => search, :order => sort
    end

  end
end

# == Schema Information
#
# Table name: tipo_cliente
#
#  id            :integer         not null, primary key
#  nombre        :string(40)      not null
#  descripcion   :string(300)
#  activo        :boolean         default(TRUE)
#  clasificacion :string(1)
#  codigo_d3     :integer
#


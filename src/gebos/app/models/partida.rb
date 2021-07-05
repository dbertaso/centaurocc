# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Partida
# descripción: Migración a Rails 3
#
class Partida < ActiveRecord::Base

  self.table_name = 'partida'

  attr_accessible :id,
                  :nombre,
                  :descripcion,
                  :financiamiento_integral,
                  :codigo_d3,
                  :rubro_id,
                  :codigo

  belongs_to :rubro
  belongs_to :sub_rubro
  belongs_to :actividad
  has_many :items, :class_name=>'Item'
  has_many :configurador

  validates :rubro_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.rubro')} #{I18n.t('Sistema.Body.Modelos.Errores.es requerido')}"} 

  validates :actividad_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.actividad')} #{I18n.t('Sistema.Body.Modelos.Errores.es requerido')}"}

  validates :codigo, 
              :presence => {
                :message => "#{I18n.t('Sistema.Body.Vistas.General.codigo')} #{I18n.t('Sistema.Body.Modelos.Errores.es requerido')}"},
              :uniqueness => {:scope => [:rubro_id, :sub_rubro_id, :actividad_id],
                :message => "#{I18n.t('Sistema.Body.Vistas.General.codigo')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"}
    
  validates :nombre, 
              :presence => {  
                :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es requerido')}"},
              :uniqueness => { :scope => [:rubro_id, :sub_rubro_id, :actividad_id],
                :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"},
              :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio')}/,
                :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}"}
    
                    
  validates :descripcion, :length =>  {
                :within => 2..300, :allow_nil => false,
                :too_long => "#{I18n.t('Sistema.Body.General.descripcion')} #{I18n.t('es.errors.message.too_long')}",
                :too_short => "#{I18n.t('Sistema.Body.General.descripcion')} #{I18n.t('es.errors.message.too_short')}"}

  def self.search(search, page, sort)

    paginate :per_page => @records_by_page, :page => page,
             :conditions => search, :order => sort, :include=> [:actividad]
  end


  def destino

    case self.destino_id

      when 1
        t('Sistema.Body.Modelos.Destino.banco')
      when 2
        t('Sistema.Body.Modelos.Destino.insumos')
      when 3
        t('Sistema.Body.Modelos.Destino.maquinaria')
      else
        t('Sistema.Body.Modelos.Destino.banco')
    end
  end

  def eliminar(id)
    begin

      item = Item.find_by_partida_id(id)

      if item.size > 0
        errors.add(:partida, "#{I18n.t('Sistema.Body.Vistas.General.partida')} #{I18n.t('Sistema.Body.Modelos.Errores.usado_item')}")
        return false
      end
      partida = Partida.find(id)
      transaction do
        partida.destroy
        return true
      end
      rescue
        errors.add(:partida, "#{I18n.t('Sistema.Body.Vistas.General.partida')} #{I18n.t('Sistema.Body.Modelos.Errores.usado')}")
        return false
    end
  end

end



# == Schema Information
#
# Table name: partida
#
#  id                      :integer         not null, primary key
#  nombre                  :string(100)     not null
#  descripcion             :string(300)     not null
#  financiamiento_integral :boolean         default(FALSE), not null
#  codigo_d3               :integer
#  rubro_id                :integer         default(0), not null
#  codigo                  :integer         default(0)
#  sub_rubro_id            :integer
#  actividad_id            :integer
#


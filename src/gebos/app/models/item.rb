# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Item
# descripción: Migración a Rails 3
#
class Item < ActiveRecord::Base

  self.table_name = 'item'

  attr_accessible :id,
                  :partida_id,
                  :nombre,
                  :descripcion,
                  :activo,
                  :codigo_d3,
                  :actividad_id,
                  :unidad_medida_id,
                  :numero_desembolso,
                  :codigo,
                  :tipo_item,
                  :cantidad_por_hectarea

  belongs_to :partida
  belongs_to :actividad
  belongs_to :unidad_medida
  has_many :configurador
  has_many :solicitud
  has_many :embarcacion
  
  after_initialize :after_initialize
  before_destroy :before_destroy
  
  validate :actividad_id,  
            :presence =>{
              :message => "#{I18n.t('Sistema.Body.Vistas.General.actividad')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerida')}"}

  validates :partida_id, 
              :presence =>{
                :message => "#{I18n.t('Sistema.Body.Vistas.General.partida')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requeria')}"}
    
  validates :codigo, 
              :presence =>{
                :message => "#{I18n.t('Sistema.Body.Vistas.General.codigo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
    
  validates :nombre, 
              :presence => {
                :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
    
  validates :unidad_medida, 
              :presence =>{
                :message => "#{I18n.t('Sistema.Body.Vistas.General.unidad_medida')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerida')}"}
    
  validates :numero_desembolso, 
              :presence => {
                :message => "#{I18n.t('Sistema.Body.Vistas.General.numero_desembolso')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
    
  validates :tipo_item, 
              :presence => { 
                :message => "#{I18n.t('Sistema.Body.Vistas.General.tipo')} #{ I18n.t('Sistema.Body.Vistas.General.item')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
    
  validates :codigo, 
              :numericality => {
                  :only_integer=> {
                    :message => "#{I18n.t('Sistema.Body.Vistas.General.codigo')} #{I18n.t('errors.messages.not_an_integer')}"}}

  validates :codigo, 
              :uniqueness => {:scope => [:actividad_id, :partida_id],
                              :message => "#{I18n.t('Sistema.Body.Vistas.General.codigo')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"}

  validates :nombre, 
              :uniqueness => {
                :scope => [:actividad_id, :partida_id], 
                  :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"},
              :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio')}/,
                :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}"}

  validates :descripcion, 
              :length => { :in => 0..255, :allow_blank => true,
              :too_short => "#{I18n.t('Sistema.Body.Vistas.General.descripcion')} #{I18n.t('errors.messages.too_short.other')}",
              :too_long => "#{I18n.t('Sistema.Body.Vistas.General.descripcion')}  #{I18n.t('errors.messages.too_long.other')}"}

  validates :numero_desembolso, 
              :uniqueness => {:scope => [:actividad_id, :partida_id, :id], 
                              :message => "#{I18n.t('Sistema.Body.Vistas.General.numero')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.desembolso')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"}

  validates :numero_desembolso, 
              :numericality => {:greater_than => 0, :only_integer=>true,
                                :message => "#{I18n.t('Sistema.Body.Vistas.General.numero')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.desembolso')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_mayor_cero')}"}
                    
  validates :cantidad_por_hectarea, 
              :numericality => {:greater_than => 0, 
              :message => "#{I18n.t('Sistema.Body.Vistas.General.cantidad')} #{I18n.t('Sistema.Body.Vistas.General.por')} #{I18n.t('Sistema.Body.Vistas.General.hectarea')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_mayor_cero')}"}


  def self.search(search, page, sort)

    paginate :per_page => @records_by_page, :page => page,
             :conditions => search, :order => sort, :include=> [:actividad]
  end

  def after_initialize
    if self.new_record?
      self.activo = true
    end
  end

  def eliminar(id)
    begin
      item = Item.find(id)
      transaction do
        item.destroy
        return true
      end
      rescue
        errors.add(:item, "#{I18n.t('Sistema.Body.Vistas.General.el')} #{ I18n.t('Sistema.Body.Vistas.General.item')} #{ I18n.t('Sistema.Body.Modelos.Errores.usado_configurador')}")
        return false
    end
  end

  def before_destroy

    retorno = true

    configurador = Configurador.find_by_item_id(self.id)

    unless configurador.nil?
      errors.add(nil, "El item esta siendo utilizado en Configuración, no puede ser eliminada")
      retorno = false
    end

    return retorno

  end

end



# == Schema Information
#
# Table name: item
#
#  id                    :integer         not null, primary key
#  partida_id            :integer         not null
#  nombre                :string(100)
#  descripcion           :string(255)
#  activo                :boolean
#  codigo_d3             :integer
#  actividad_id          :integer         not null
#  unidad_medida_id      :integer         not null
#  numero_desembolso     :integer         default(0), not null
#  codigo                :integer         default(0)
#  tipo_item             :string(1)
#  cantidad_por_hectarea :decimal(14, 2)  default(1.0), not null
#


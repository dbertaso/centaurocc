# encoding: utf-8

#
# autor: Diego Bertaso
# clase: ItemAtributo
# descripción: Migración a Rails 3
#

class ItemAtributo < ActiveRecord::Base

  self.table_name = 'item_atributo'

  attr_accessible :id,
                  :nombre,
                  :descripcion,
                  :activo,
                  :item_id,
                  :tipo,
                  :tabla_combo

  belongs_to :item

  validate :validate
  
  validates_presence_of :nombre,
    :message => "#{ I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"

  validates_presence_of :item,
    :message => "#{ I18n.t('Sistema.Body.Vistas.General.item')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"

  validates_presence_of :tipo,
    :message => "#{ I18n.t('Sistema.Body.Vistas.General.tipo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"
    
  validates_uniqueness_of :nombre, :scope=>'item_id',
    :message => "#{ I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"

  def validate
    unless self.nombre.nil? || self.nombre.empty?
      expr = /^[a-zA-ZñÑáÁéÉíÍóÓúÚüÜÇ' ]+$/
      a = expr.match(self.nombre)
      if a.nil?
        errors.add(:item_atributo, "#{ I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalido')}")
      end
    end
  end

  def self.search(search, page, sort)

    paginate :per_page => @records_by_page, :page => page,
             :conditions => search, :order => sort, :include=> [:item]
  end

  def tipo_w
    case self.tipo
      when '1'
        I18n.t('Sistema.Body.Modelos.ItemAtributo.Tipo.texto_100')
      when '5'
        I18n.t('Sistema.Body.Modelos.ItemAtributo.Tipo.texto_500')
      when 'I'
        I18n.t('Sistema.Body.Modelos.ItemAtributo.Tipo.numerico_entero')
      when 'F'
        I18n.t('Sistema.Body.Modelos.ItemAtributo.Tipo.numerico_decimales')
      when 'B'
        I18n.t('Sistema.Body.Modelos.ItemAtributo.Tipo.si_no')
      when 'D'
        I18n.t('Sistema.Body.Modelos.ItemAtributo.Tipo.fecha')
      when 'C'
        I18n.t('Sistema.Body.Modelos.ItemAtributo.Tipo.cuadro_lista')
    end

  end
end

# == Schema Information
#
# Table name: item_atributo
#
#  id          :integer         not null, primary key
#  nombre      :string(40)      not null
#  descripcion :string(300)
#  activo      :boolean         default(TRUE)
#  item_id     :integer         not null
#  tipo        :string(1)       default("1")
#  tabla_combo :string(100)
#


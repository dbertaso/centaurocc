# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Rubro
# descripción: Migración a Rails 3
#

class Rubro < ActiveRecord::Base

  self.table_name = 'rubro'

  attr_accessible  :id,
                  :nombre,
                  :descripcion,
                  :activo,
                  :codigo,
                  :sector_id,
                  :sub_sector_id

  belongs_to :sector
  belongs_to :sub_sector
  has_many :sub_rubro
  has_many :partida
  has_many :item
  has_many :cronograma_desembolso

  validate :validate

  validates :descripcion,
  :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.descripcion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :codigo,
  :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.codigo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :nombre,
  :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates_numericality_of :codigo, :only_integer=>true,
  :message => "#{I18n.t('Sistema.Body.Vistas.General.codigo')} #{I18n.t('errors.messages.not_an_integer')}"

  validates_uniqueness_of :codigo,
    :scope => [:sector_id, :sub_sector_id],
    :message => "#{I18n.t('Sistema.Body.Vistas.General.codigo')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"

  validates_uniqueness_of :nombre,
    :scope => [:sector_id, :sub_sector_id],
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"

   validates_length_of :descripcion, :within => 1..300, :allow_nil => false,
    :too_long => "#{I18n.t('Sistema.Body.General.descripcion')} #{I18n.t('es.errors.message.too_long')}",
    :too_short => "#{I18n.t('Sistema.Body.General.descripcion')} #{I18n.t('es.errors.message.too_short')}"

  def self.search(search, page, sort)

    unless search.nil?
      paginate  :per_page => @records_by_page, :page => page,
                :conditions => search, :order => sort
    else
      paginate  :per_page => @records_by_page, :page => page,
                :order => sort

    end

  end


  def validate
    unless self.nombre.nil? || self.nombre.empty?
      expr = /^[a-zA-ZñÑáÁéÉíÍóÓúÚüÜÇ' ]+$/
      a = expr.match(self.nombre)
      if a.nil?
        errors.add(nil, "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}")
      end
    end
  end

  def after_save
    RubroOficina.clonar(self.id)
  end

  def after_initialize
    self.activo = true if self.new_record?
  end

  def eliminar(id)
    begin
      sub_rubro = SubRubro.count(:conditions=>"rubro_id = #{self.id}")
        if sub_rubro > 0
          errors.add(nil, "#{I18n.t('Sistema.Body.General.el')} #{I18n.t('Sistema.Body.Vistas.General.rubro')} #{I18n.t('Sistema.Body.Modelos.Errores.usado_en_sub_rubro')}")
          return false
        else
          rubro = Rubro.find(id)
          transaction do
            rubro.destroy
            return true
          end
         end
        rescue
          errors.add(nil, "#{I18n.t('Sistema.Body.General.el')} #{I18n.t('Sistema.Body.Vistas.General.rubro')} #{I18n.t('Sistema.Body.Modelos.Errores.usado')}")
          return false
    end
  end

end

# == Schema Information
#
# Table name: rubro
#
#  id            :integer         not null, primary key
#  nombre        :string(100)     not null
#  descripcion   :string(255)
#  activo        :boolean         default(TRUE), not null
#  codigo        :integer         default(0)
#  sector_id     :integer         not null
#  sub_sector_id :integer         not null
#


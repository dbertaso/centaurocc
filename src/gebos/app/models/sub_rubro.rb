# encoding: utf-8

#
# autor: Diego Bertaso
# clase: SubRubro
# descripción: Migración a Rails 3
#
class SubRubro < ActiveRecord::Base

  self.table_name = 'sub_rubro'

  attr_accessible :id,
                  :nombre,
                  :descripcion,
                  :activo,
                  :codigo,
                  :rubro_id

  belongs_to :rubro

  has_many :partida
  has_many :actividad
  has_many :solicitud

  validate :validate
  
  validates :descripcion,
  :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.Form.descripcion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :codigo,
  :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.codigo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :nombre,
  :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates_numericality_of :codigo, :only_integer=>true,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.codigo')} #{I18n.t('es.errors.messages.not_an_integer')}"

  validates_uniqueness_of :codigo,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.codigo')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}",
    :scope => [:rubro_id]

  validates_uniqueness_of :nombre,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}",
    :scope => [:rubro_id]

   validates_length_of :descripcion, :within => 1..300, :allow_nil => false,
    :too_long => "#{I18n.t('Sistema.Body.General.descripcion')} #{I18n.t('es.errors.message.too_long')}",
    :too_short => "#{I18n.t('Sistema.Body.General.descripcion')} #{I18n.t('es.errors.message.too_short')}"

  def self.search(search, page, sort)

    paginate :per_page => @records_by_page, :page => page,
             :conditions => search, :order => sort

  end

  def validate
    unless self.nombre.nil? || self.nombre.empty?
      expr = /^[a-zA-ZñÑáÁéÉíÍóÓúÚüÜÇ' ]+$/
      a = expr.match(self.nombre)
      if a.nil?
        self.errors.add(nil, "#{I18n.t('Sistema.Main.Vistas.General.nombre')} #{I18n.t('Sistema.Main.Modelos.Errores.no_puede_tener')}")
      end
    end

  end


  def eliminar(id)
    begin
      actividad = Actividad.count(:conditions=>"sub_rubro_id = #{id}")
      if actividad > 0
        self.errors.add(nil, "#{I18n.t('Sistema.Body.General.el')} #{I18n.t('Sistema.Body.Vistas.General.sub_rubro')} #{I18n.t('Sistema.Body.Modelos.Errores.usado_actividad')}")
        return false
      else
        sub_rubro = SubRubro.find(id)
        transaction do
          sub_rubro.destroy
          return true
        end
      end
    rescue
      self.errors.add(nil,"#{I18n.t('Sistema.Body.General.el')} #{I18n.t('Sistema.Body.Vistas.General.sub_rubro')} #{I18n.t('Sistema.Body.Modelos.Errores.usado')}")
      return false
    end
  end

end

# == Schema Information
#
# Table name: sub_rubro
#
#  id          :integer         not null, primary key
#  nombre      :string(100)     not null
#  descripcion :string(255)
#  activo      :boolean         default(TRUE), not null
#  codigo      :integer         default(0)
#  rubro_id    :integer         not null
#


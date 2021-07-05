# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Rubro
# descripción: Migración a Rails 3
#
class SubSector < ActiveRecord::Base

    self.table_name = 'sub_sector'

    attr_accessible :id,
                    :sector_id,
                    :nombre,
                    :descripcion,
                    :activo,
                    :codigo,
                    :nemonico

    belongs_to :sector
    has_many :rubro
    has_many :configurador
    has_many :solicitud
    has_many :solicitud_rubro_solicitado
    has_many :condiciones_financiamiento
    has_many :solicitud_rubro_sugerido
    has_many :garantia_sector

    validates :sector,
    :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.sector')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

    validates :codigo,
    :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.codigo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

    validates :nombre,
    :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

    validates :nemonico,
    :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.nemonico')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

    validates_numericality_of :codigo, :only_integer=>true,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.codigo')} #{I18n.t('errors.messages.not_an_integer')}"

    validates_numericality_of :codigo, :greater_than=>0,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.codigo')} #{I18n.t('errors.messages.greater_than')}"

    validates_uniqueness_of :codigo,
    :scope=>'sector_id',
    :message=> "#{I18n.t('Sistema.Body.Vistas.General.codigo')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"

    validates_uniqueness_of :nombre,
    :message => "#{I18n.t('Sistema.Body.Vistas.Form.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"

    validates_length_of :descripcion, :within => 0..255, :allow_nil => false,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.descripcion')} #{I18n.t('errors.messages.too_short')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.descripcion')} #{I18n.t('errors.messages.too_long')}"

  def self.search(search, page, sort)

    paginate :per_page => @records_by_page, :page => page,
             :conditions => search, :order => sort, :include=>[:sector]

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

  def before_destroy

    retorno = true

    solicitud = Solicitud.find_by_sub_sector_id(self.id)

    unless solicitud.nil?
      errors.add(nil,"#{I18n.t('Sistema.Body.General.el')} #{I18n.t('Sistema.Body.Vistas.General.sub_sector')} #{I18n.t('Sistema.Body.Modelos.Errores.usado_tramite')}")
      retorno = false
    end

    rubro = Rubro.find_by_sub_sector_id(self.id)

    unless rubro.nil?
      errors.add(nil, "#{I18n.t('Sistema.Body.General.el')} #{I18n.t('Sistema.Body.Vistas.General.sub_sector')} #{I18n.t('Sistema.Body.Modelos.Errores.usado_rubro')}")
      retorno = false
    end

    configurador = Configurador.find_by_sub_sector_id(self.id)

    unless configurador.nil?
      errors.add(nil, "#{I18n.t('Sistema.Body.General.el')} #{I18n.t('Sistema.Body.Vistas.General.sub_sector')} #{I18n.t('Sistema.Body.Modelos.Errores.usado_configurador')}")
      retorno = false
    end

    condicion = CondicionesFinanciamiento.find_by_sub_sector_id(self.id)

    unless condicion.nil?
      errors.add(nil, "#{I18n.t('Sistema.Body.General.el')} #{I18n.t('Sistema.Body.Vistas.General.sub_sector')} #{I18n.t('Sistema.Body.Modelos.Errores.usado_condiciones')}")
      retorno = false
    end

    return retorno

  end
end



# == Schema Information
#
# Table name: sub_sector
#
#  id          :integer         not null, primary key
#  sector_id   :integer         not null
#  nombre      :string(100)     not null
#  descripcion :string(255)
#  activo      :boolean         default(TRUE), not null
#  codigo      :integer         default(0)
#  nemonico    :string(2)
#


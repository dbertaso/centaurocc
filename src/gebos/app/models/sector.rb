# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Sector
# descripción: Migración a Rails 3
#
class Sector < ActiveRecord::Base

  self.table_name = 'sector'

  attr_accessible :id,
                  :nombre,
                  :descripcion,
                  :activo,
                  :codigo

  has_many :configurador
  has_many :solicitud
  has_many :solicitud_rubro_solicitado
  has_many :condiciones_financiamiento
  has_many :recaudo  
  has_many :sub_sector
  has_many :sector_tecnico
  has_many :solicitud_rubro_sugerido
  has_many :rubro

  #validate :validate

  validates :codigo,
    :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.codigo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :nombre,
    :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :format => {:with => /#{I18n.t('Sistema.Body.General.validar_nombre')}/,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}"}

  validates_uniqueness_of :codigo,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.codigo')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"

  validates_uniqueness_of :nombre,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"

  validates_numericality_of :codigo, :only_integer=>true,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.codigo')} #{I18n.t('errors.messages.not_an_integer')}"

  validates_numericality_of :codigo, :greater_than=>0,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.codigo')} #{I18n.t('errors.messages.greater_than')}"

  validates_length_of :descripcion, :within => 0..255, :allow_nil => false,
    :too_long => "#{I18n.t('Sistema.Body.General.descripcion')} #{I18n.t('es.errors.message.too_long.other')}",
    :too_short => "#{I18n.t('Sistema.Body.General.descripcion')} #{I18n.t('es.errors.message.too_short.other')}"


=begin

  favor no descomentar porq ya se esta usando el format en el validate de nombre
  def validate
    unless self.nombre.nil? || self.nombre.empty?
      expr = /^[a-zA-ZñÑáÁéÉíÍóÓúÚüÜÇ' ]+$/
      a = expr.match(self.nombre)
      if a.nil?
        self.errors.add(:sector, "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Main.Modelos.Errores.no_puede_tener')}")
      end
    end

  end
=end

  def self.search(search, page, sort)

    paginate :per_page => @records_by_page, :page => page,
             :conditions => search, :order => sort

  end

  before_destroy :before_destroy

  def before_destroy

    retorno = true

    solicitud = Solicitud.find_by_sector_id(self.id)

    unless solicitud.nil?
      errors.add(:sector, "#{I18n.t('Sistema.Body.General.el')} #{I18n.t('Sistema.Body.Vistas.General.sector')} #{I18n.t('Sistema.Body.Modelos.Errores.usado_tramite')}")
      retorno = false
    end

    configurador = Configurador.find_by_sector_id(self.id)

    unless configurador.nil?
      errors.add(:sector, "#{I18n.t('Sistema.Body.General.el')} #{I18n.t('Sistema.Body.Vistas.General.sector')} #{I18n.t('Sistema.Body.Modelos.Errores.usado_configurador')}")
      retorno = false
    end

    condicion = CondicionesFinanciamiento.find_by_sector_id(self.id)

    unless condicion.nil?
      errors.add(:sector, "#{I18n.t('Sistema.Body.General.el')} #{I18n.t('Sistema.Body.Vistas.General.sector')} #{I18n.t('Sistema.Body.Modelos.Errores.usado_condiciones')}")
      retorno = false
    end

    sub_sector = SubSector.find_by_sector_id(self.id)

    unless sub_sector.nil?
      errors.add(:sector, "#{I18n.t('Sistema.Body.General.el')} #{I18n.t('Sistema.Body.Vistas.General.sector')} #{I18n.t('Sistema.Body.Modelos.Errores.usado_sub_sector')}")
      retorno = false
    end

    return retorno

  end

  def eliminar(id)
    begin
      sector = Sector.find(id)
      transaction do
        sector.destroy
        return true
      end
      rescue
        errors.add(:sector, "#{I18n.t('Sistema.Body.General.el')} #{I18n.t('Sistema.Body.Vistas.General.sector')} #{I18n.t('Sistema.Body.Modelos.Errores.usado')}")
        return false
    end
  end

end


# == Schema Information
#
# Table name: sector
#
#  id          :integer         not null, primary key
#  nombre      :string(100)     not null
#  descripcion :string(255)
#  activo      :boolean         default(TRUE), not null
#  codigo      :integer         default(0)
#


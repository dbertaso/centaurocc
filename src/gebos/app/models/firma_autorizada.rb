# encoding: utf-8

#
# autor: Diego Bertaso
# clase: FirmaAutorizada
# descripción: Migración a Rails 3
#


class FirmaAutorizada < ActiveRecord::Base

  self.table_name = 'firma_autorizada'

  attr_accessible :id,
                  :cargo_id,
                  :nombre,
                  :cedula
                  
  belongs_to :cargo

  validate :validate

  validates_presence_of :cargo_id,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.cargo')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"

  validates_presence_of :nombre,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.cargo')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"

  validates_length_of :cedula, :within => 0..10, :allow_nil => true,
    :too_long => "#{I18n.t('Sistema.Body.General.cedula')} #{I18n.t('es.errors.message.too_long.other')}",
    :too_short => "#{I18n.t('Sistema.Body.General.cedula')} #{I18n.t('es.errors.message.too_short.other')}"

  validates_length_of :nombre, :within => 1..120, :allow_nil => false,
    :too_long => "#{I18n.t('Sistema.Body.General.nombre')} #{I18n.t('es.errors.message.too_long.other')}",
    :too_short => "#{I18n.t('Sistema.Body.General.nombre')} #{I18n.t('es.errors.message.too_short.other')}"

  validates_uniqueness_of :cargo_id,
    :message => I18n.t('Sistema.Body.Modelos.FirmaAutorizada.Errores.firma_registrada')

  def self.search(search, page, sort)

    paginate :per_page => @records_by_page, :page => page,
             :conditions => search, :order => sort, :include=> [:cargo]
  end

  def self.detalle_firma const_id
        joins = 'left join cargo on firma_autorizada.cargo_id = cargo.id'
        return FirmaAutorizada.find(:first,
                                 :joins => joins,
                                 :conditions=>"cargo.const_id='#{const_id}'"
        )
  end

  def validate
    unless self.nombre.nil? || self.nombre.empty?
      expr = /^[a-zA-ZñÑáÁéÉíÍóÓúÚüÜÇ' ]+$/
      a = expr.match(self.nombre)
      if a.nil?
        errors.add(:firma_autorizada, "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}")
      end
    end
    unless self.cedula.nil? || self.cedula.to_s.empty?
      expr = /^[0-9VE-]+$/
      a = expr.match(self.cedula)
      if a.nil?
        errors.add(:firma_autorizada, "#{I18n.t('Sistema.Body.Vistas.General.cedula')} #{I18n.t('Sistema.Body.Modelos.Errores.solo_permite_numeros')}")
      end
    end
  end

end

# == Schema Information
#
# Table name: firma_autorizada
#
#  id       :integer         not null, primary key
#  cargo_id :integer
#  nombre   :string(120)
#  cedula   :string(10)
#


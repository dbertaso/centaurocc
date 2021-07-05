# encoding: utf-8

#
# autor: Diego Bertaso
# clase: PrecioGaceta
# descripción: Migración a Rails 3
#

class PrecioGaceta < ActiveRecord::Base

  self.table_name = 'precio_gaceta'

  attr_accessible :id,
                  :gaceta_oficial,
                  :status,
                  :usuario_id,
                  :fecha_vigencia,
                  :fecha_vigencia_f

  has_many :detalle_precio_gaceta

  validates_presence_of :fecha_vigencia,
    :message => "#{I18n.t('Sistema.Body.Vistas.Form.fecha')} #{I18n.t('Sistema.Body.Vistas.General.vigencia')} #{I18n.t('Sistema.Body.Modelos.Form.es_requerido')}"

  validates_presence_of :gaceta_oficial,
    :message => "#{I18n.t('Sistema.Body.Modelos.PrecioGaceta.Columnas.gaceta_oficial')} #{I18n.t('Sistema.Body.Modelos.Form.es_requerido')}"

  validates_uniqueness_of :gaceta_oficial,
    :message => "#{I18n.t('Sistema.Body.Modelos.PrecioGaceta.Columnas.gaceta_oficial')} #{I18n.t('Sistema.Body.Modelos.Form.ya_existe')}"

  validates_numericality_of :gaceta_oficial, :only_integer=>true, :allow_nil => true,
    :message => "#{I18n.t('Sistema.Body.Modelos.PrecioGaceta.Columnas.gaceta_oficial')} #{I18n.t('errors.messages.not_an_integer')}"

  validates :fecha_vigencia,
    :date => {:message => I18n.t('Sistema.Body.Modelos.Errores.fecha_invalida'),
              :before => Proc.new { 1.day.from_now.to_date }, :message => I18n.t('Sistema.Body.Modelos.Errores.fecha_fin_no_posterior')}

  def self.search(search, page, sort)

    paginate :per_page => @records_by_page, :page => page,
           :conditions => search, :order => sort

  end

  def fecha_vigencia_f=(fecha)
    self.fecha_vigencia = fecha
  end

  def fecha_vigencia_f
    self.fecha_vigencia.strftime("%d/%m/%Y") unless self.fecha_vigencia.nil?
  end

  def estatus

    unless self.status.nil?
      if self.status == 't'
        return I18n.t('Sistema.Body.Modelos.PrecioGaceta.Estatus.vigente')
      else
        return I18n.t('Sistema.Body.Modelos.PrecioGaceta.Estatus.vencida')
      end
    end

  end

  def before_save
    precio_gaceta = PrecioGaceta.count(:conditions=>["status = true"])
    unless precio_gaceta == 0
      errors.add(:precio_gaceta, I18n.t('Sistema.Body.Modelos.PrecioGaceta.Errores.gaceta_sin_cerrar'))
      return false
    end
  end

def eliminar(id)
    begin
      precio_gaceta = PrecioGaceta.find(id)
      transaction do
        precio_gaceta.destroy
        return true
      end
      rescue
        errors.add(:precio_gaceta, "#{I18n.t('Sistema.Body.Modelos.PrecioGaceta.Columnas.gaceta_oficial')} #{I18n.t('Sistema.Body.Modelos.Errores.usado')}")
        return false
    end
  end
end


# == Schema Information
#
# Table name: precio_gaceta
#
#  id             :integer         not null, primary key
#  gaceta_oficial :integer         not null
#  status         :boolean
#  usuario_id     :integer
#  fecha_vigencia :date
#


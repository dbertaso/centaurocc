# encoding: utf-8

#
# autor: Diego Bertaso
# clase: DetallePrecioGaceta
# descripción: Migración a Rails 3
#
class DetallePrecioGaceta < ActiveRecord::Base

  self.table_name = 'detalle_precio_gaceta'
  attr_accessible :id,
                  :precio_gaceta_id,
                  :actividad_id,
                  :tipo_clase,
                  :valor

  belongs_to :precio_gaceta
  belongs_to :actividad

  validates_presence_of :actividad_id,
  :message => "#{I18n.t('Sistema.Body.Vistas.General.Actividad')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"

  validates_presence_of :tipo_clase,
  :message => I18n.t('Sistema.Body.Modelos.DetallePrecioGaceta.Errores.tipo_clase_es_requerido')

  validates_presence_of :valor,
  :message => I18n.t('Sistema.Body.Modelos.DetallePrecioGaceta.Errores.valor_es_requerido')

  validates_numericality_of :valor, :only_integer=>false, :allow_nil => true,
  :message => I18n.t('Sistema.Body.Modelos.DetallePrecioGaceta.Errores.valor_debe_ser_numerico')
  
  validates :actividad_id, :uniqueness => { :scope => [:precio_gaceta_id, :tipo_clase],
    :message => I18n.t('Sistema.Body.Modelos.DetallePrecioGaceta.Errores.precio_registrado_actividad') }
    
  def self.search(search, page, sort)

    paginate :per_page => @records_by_page, :page => page,
           :conditions => search, :order => sort, :include=>[:precio_gaceta, :actividad]

  end

  def eliminar(id)
    begin
      detalle_precio_gaceta = DetallePrecioGaceta.find(id)
      transaction do
        detalle_precio_gaceta.destroy
        return true
      end
      rescue
        errors.add(:detalle_precio_gaceta, I18n.t('Sistema.Body.Modelos.DetallePrecioGaceta.Errores.precio_gaceta_usado'))
        return false
    end
  end

  def nombre_compuesto
    detalle_precio_gaceta = DetallePrecioGaceta.find_by_id(self.id)
    nombre = detalle_precio_gaceta.actividad.nombre + " Tipo " + detalle_precio_gaceta.tipo_clase
    return nombre
  end

  def tipo_clase_f
  
    unless self.tipo_clase.nil?
      case self.tipo_clase
        when 'A'
          'Tipo A'
        when 'B'
          'Tipo B'
        when 'C'
          'Tipo C'
      else
        'Sin Tipo'
      end
    end
  end

  def valor_f
    unless self.valor.nil?
      sprintf('%01.2f', self.valor).sub('.', ',') unless self.valor.nil?
    end
  end
  
end



# == Schema Information
#
# Table name: detalle_precio_gaceta
#
#  id               :integer         not null, primary key
#  precio_gaceta_id :integer         not null
#  actividad_id     :integer         not null
#  tipo_clase       :string(1)       not null
#  valor            :float           not null
#


# encoding: utf-8

#
# autor: Luis Rojas
# clase: Configurador
# descripción: Migración a Rails 3
#
class Configurador < ActiveRecord::Base

  self.table_name = 'configurador'
  
  attr_accessible :id, :estado_id, :oficina_id, :sector_id, :sub_sector_id, :rubro_id,
  :partida_id, :item_id, :unidad_medida_id, :costo_fijo, :costo_minimo,
  :costo_maximo, :numero_desembolso, :justificacion, :sub_rubro_id,
  :actividad_id, :moneda_id

  belongs_to :estado
  belongs_to :oficina
  belongs_to :sector
  belongs_to :sub_sector
  belongs_to :partida
  belongs_to :sub_rubro
  belongs_to :actividad
  belongs_to :rubro
  belongs_to :item
  belongs_to :moneda
  
  has_many :plan_inversion

  def save_new(item, tipo, fijo, minimo, maximo, parametros, oficina_id)
    moneda_id = ParametroGeneral.first.moneda_id
    oficina = Oficina.find(oficina_id)
    Configurador.delete_all(["oficina_id = ? and item_id = ? and moneda_id = ?", oficina_id, item.id, parametros[:moneda_id]])
    configurador = Configurador.new(parametros)
    configurador.item_id = item.id
    configurador.partida_id = item.partida_id
    configurador.oficina_id = oficina.id
    configurador.estado_id = oficina.estado_id
    configurador.unidad_medida_id = item.unidad_medida_id
    if tipo.to_i == 1
      configurador.costo_fijo = fijo
    else
      configurador.costo_minimo = minimo
      configurador.costo_maximo = maximo
    end
    if configurador.moneda_id == moneda_id
      configurador.tipo_item = item.tipo_item
    else
      configurador.tipo_item = 'B'
    end
    configurador.numero_desembolso = item.numero_desembolso
    configurador.save
  end

  def validar(item, tipo, fijo, minimo, maximo)
    msj = ""
    if tipo.to_i == 1
      if fijo.to_s.nil? || fijo.to_s.empty?
        msj << "<li>#{I18n.t('Sistema.Body.Modelos.Configurador.Errores.incluir_costo_fijo')}</li>"
      end
    else
      if minimo.to_s.nil? || minimo.to_s.empty?
        msj << "<li>#{I18n.t('Sistema.Body.Modelos.Configurador.Errores.incluir_costos')}</li>"
      elsif maximo.to_s.nil? || maximo.to_s.empty?
        msj << "<li>#{I18n.t('Sistema.Body.Modelos.Configurador.Errores.incluir_costos')}</li>"
      elsif minimo.to_f >= maximo.to_f
          msj << "<li>#{I18n.t('Sistema.Body.Modelos.Configurador.Errores.maximo_mayor_minimo')}</li>"
      end
    end
    if msj.length > 0
      return msj
    else
      return ''
    end
  end
  
  def self.cambiar_tipo
    configurador = Configurador.all
    configurador.each{|c|
      c.tipo_item = c.item.tipo_item
      c.save!
    }
  end

  def tipo_costo_w
    if self.costo_fijo > 0
      return 'Costo Fijo'
    elsif self.costo_maximo > 0
      return 'Costo Variable'
    end
  end

  def self.items(partida_id, oficina_id, moneda_id)
    return Configurador.find(:all, :conditions=>['partida_id = ? and oficina_id = ? and moneda_id = ?', partida_id, oficina_id, moneda_id])
  end

  def self.total_costo_minimo(actividad_id, oficina_id, moneda_id)
    total = Configurador.find_by_sql("select sum(costo_fijo) + sum(costo_minimo) as minimo from configurador where actividad_id = #{actividad_id} and oficina_id = #{oficina_id} and moneda_id = #{moneda_id}")
    return sprintf('%01.2f', total[0].minimo.to_f).sub('.', ',').to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
  end

  def self.total_costo_maximo(actividad_id, oficina_id, moneda_id)
    total = Configurador.find_by_sql("select sum(costo_fijo) + sum(costo_maximo) as maximo from configurador where actividad_id = #{actividad_id} and oficina_id = #{oficina_id} and moneda_id = #{moneda_id}")
    return sprintf('%01.2f', total[0].maximo.to_f).sub('.', ',').to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
  end
end

# == Schema Information
#
# Table name: configurador
#
#  id                :integer         not null, primary key
#  estado_id         :integer         not null
#  oficina_id        :integer         not null
#  sector_id         :integer         not null
#  sub_sector_id     :integer         not null
#  rubro_id          :integer         not null
#  partida_id        :integer         not null
#  item_id           :integer         not null
#  unidad_medida_id  :integer         not null
#  costo_fijo        :decimal(16, 2)  default(0.0), not null
#  costo_minimo      :decimal(16, 2)  default(0.0), not null
#  costo_maximo      :decimal(16, 2)  default(0.0), not null
#  numero_desembolso :integer         default(0), not null
#  justificacion     :text
#  sub_rubro_id      :integer
#  actividad_id      :integer
#  moneda_id         :integer
#  tipo_item         :string(1)
#


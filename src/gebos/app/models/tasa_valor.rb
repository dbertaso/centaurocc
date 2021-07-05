# encoding: utf-8

#
# autor: Diego Bertaso
# clase: TasaValor
# descripción: Migración a Rails 3
#
class TasaValor < ActiveRecord::Base

  self.table_name = 'tasa_valor'

  attr_accessible :id,
                  :tasa_id,
                  :fecha_actualizacion,
                  :fecha_resolucion_desde,
                  :fecha_resolucion_hasta,
                  :resolucion,
                  :valor,
                  :valor_f,
                  :fecha_actualizacion_f,
                  :fecha_resolucion_desde_f,
                  :fecha_resolucion_hasta_f
                  
  
  attr_accessor :tasa_valor_anterior

  validates :fecha_actualizacion,
    :presence => { :message => "#{I18n.t('Sistema.Body.Modelos.TasaValor.Columnas.fecha_actualizacion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :fecha_resolucion_desde,
    :presence => { :message => "#{I18n.t('Sistema.Body.Modelos.TasaValor.Columnas.fecha_resolucion_desde')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :resolucion,
    :presence => { :message => "#{I18n.t('Sistema.Body.Modelos.TasaValor.Columnas.resolucion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :valor,
    :presence => { :message => "#{I18n.t('Sistema.Body.Modelos.TasaValor.Columnas.valor')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :fecha_actualizacion,
    :date => {:message => "#{I18n.t('Sistema.Body.Modelos.TasaValor.Columnas.fecha_actualizacion')} #{I18n.t('Sistema.Body.Modelos.Errores.fecha_invalida')}"}

  validates :fecha_resolucion_desde,
    :date => {:message => "#{I18n.t('Sistema.Body.Modelos.Tasa.Columnas.fecha_resolucion_desde')} #{I18n.t('Sistema.Body.Modelos.Errores.fecha_invalida')}"}

  validates_numericality_of :valor,
    :message => "#{I18n.t('Sistema.Body.Modelos.Tasa.Columnas.fecha_resolucion_desde')} #{I18n.t('errors.messages.not_a_number')}"

  belongs_to :tasa

  before_create :before_create
  before_update :before_update
  after_create :after_create

  def self.search(search, page, sort)

    unless search.nil?
      paginate  :per_page => @records_by_page, :page => page,
                :conditions => search, :order => sort
    else
      paginate  :per_page => @records_by_page, :page => page,
                :order => sort

    end

  end

  def after_initialize
    self.fecha_actualizacion = Time.new
  end

  def valor_f=(valor)
    self.valor = valor.sub(',', '.')
  end

  def valor_f
    sprintf('%01.2f', self.valor).sub('.', ',') unless self.valor.nil?
  end

  def fecha_actualizacion_f=(fecha)
    self.fecha_actualizacion = fecha
  end

  def fecha_actualizacion_f
    self.fecha_actualizacion.strftime('%d/%m/%Y') unless self.fecha_actualizacion.nil?
  end

  def fecha_resolucion_desde_f=(fecha)
    self.fecha_resolucion_desde = fecha
  end

  def fecha_resolucion_desde_f
    self.fecha_resolucion_desde.strftime('%d/%m/%Y') unless self.fecha_resolucion_desde.nil?
  end

  def fecha_resolucion_hasta_f=(fecha)
    self.fecha_resolucion_hasta = fecha
  end

  def fecha_resolucion_hasta_f
    self.fecha_resolucion_hasta.strftime('%d/%m/%Y') unless self.fecha_resolucion_hasta.nil?
  end


  def before_create

    if self.fecha_resolucion_desde > Date.today
        errors.add(:tasa_valor, I18n.t('Sistema.Body.Modelos.TasaValor.Errores.error_fecha_resolucion'))
        return false
    end
    if self.valor <= 0
      errors.add(:tasa_valor, I18n.t('Sistema.Body.Modelos.TasaValor.Errores.valor_menor_cero'))
      return false
    end

    if self.valor > 100
      errors.add(:tasa_valor, I18n.t('Sistema.Body.Modelos.TasaValor.Errores.valor_mayor_cien'))
      return false
    end
    count = TasaValor.find(:all, :conditions=>"tasa_id = " + self.tasa.id.to_s).size
    if count > 0

      tasa_valor_anterior = TasaValor.find(:first, :conditions=>"tasa_id = "+self.tasa_id.to_s, :order=>"fecha_resolucion_desde desc");
      if tasa_valor_anterior.fecha_resolucion_desde > self.fecha_resolucion_desde
        errors.add(:tasa_valor, I18n.t('Sistema.Body.Modelos.TasaValor.Errores.fecha_resolucion_anterior'))
        return false
      end

      fecha_resolucion_hasta = self.fecha_resolucion_desde - 1
      tasa_valor_anterior.update_attributes(:fecha_resolucion_hasta=>fecha_resolucion_hasta)

    end

  end

  def before_update

 # TasaHistorico.delete_all(["tasa_valor_id = ?", self.id])

    if self.valor <= 0
      errors.add(:tasa_valor, I18n.t('Sistema.Body.Modelos.TasaValor.Errores.valor_menor_cero'))
      return false
    end

    if self.valor > 100
      errors.add(:tasa_valor, I18n.t('Sistema.Body.Modelos.TasaValor.Errores.valor_mayor_cien'))
      return false
    end

   programas = Programa.find(:all, :conditions=>"tasa_id ="+self.tasa.id.to_s+" and activo = true")
    if programas.size > 0
      for programa in programas
        porcentaje_tapp = round_2_decimal_ceil(self.valor*(programa.porcentaje_tasa_tapp/100))
        if programa.tipo_credito.id == 2
          tasa_foncrei = round_2_decimal_ceil(porcentaje_tapp*(programa.porcentaje_tasa_foncrei/100))
          tasa_intermediario = porcentaje_tapp-tasa_foncrei
        else
          tasa_foncrei = porcentaje_tapp
          tasa_intermediario = 0
        end
        tasa_cliente = tasa_foncrei+tasa_intermediario
        tasa_historico = TasaHistorico.new
        tasa_historico.programa_id=programa.id
        tasa_historico.tasa_valor_id=self.id
        tasa_historico.tasa_intermediario=tasa_intermediario
        tasa_historico.tasa_foncrei=tasa_foncrei
        tasa_historico.tasa_cliente=tasa_cliente
        tasa_historico.save
      end
    end

  end
  
  def round_2_decimal_ceil(valor)
    valor = valor * 100
    valor = valor.ceil
    valor = valor/100.0
    valor
  end
  def round_2_decimal(valor)
    valor = valor * 100
    valor = valor.to_i
    valor = valor/100.0
    valor
  end

  def after_create

    programas = Programa.find(:all, :conditions=>"tasa_id ="+self.tasa.id.to_s+" and activo = true")

    if programas.size > 0
      for programa in programas
        tasa_intermediario = 0
        porcentaje_tapp = 0

        porcentaje_tapp = round_2_decimal(self.valor*(programa.porcentaje_tasa_tapp/100)) if self.valor > 0

        if programa.tipo_credito.id == 2
          tasa_foncrei = 0
          tasa_foncrei = round_2_decimal(porcentaje_tapp*(programa.porcentaje_tasa_foncrei/100)) if self.valor > 0
          tasa_intermediario = porcentaje_tapp-tasa_foncrei
        else
          tasa_foncrei = porcentaje_tapp

          tasa_intermediario = 0
        end
        tasa_cliente = tasa_foncrei+tasa_intermediario

        tasa_historico = TasaHistorico.new
        tasa_historico.programa_id=programa.id
        tasa_historico.tasa_valor_id=self.id
        tasa_historico.tasa_intermediario=tasa_intermediario
        tasa_historico.tasa_foncrei=tasa_foncrei
        tasa_historico.tasa_cliente=tasa_cliente
        tasa_historico.save
      end
    end
  end
end

# == Schema Information
#
# Table name: tasa_valor
#
#  id                     :integer         not null, primary key
#  tasa_id                :integer         not null
#  fecha_actualizacion    :date            not null
#  fecha_resolucion_desde :date            not null
#  fecha_resolucion_hasta :date
#  resolucion             :string(15)      not null
#  valor                  :float
#


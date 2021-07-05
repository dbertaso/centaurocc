# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Cuota
# descripción: Migración a Rails 3
#

class Cuota

  attr_accessor :numero
  attr_accessor :numero_real
  attr_accessor :fecha
  attr_accessor :monto
  attr_accessor :tasa
  attr_accessor :interes
  attr_accessor :interes_acumulado
  attr_accessor :saldo
  attr_accessor :amortizado
  attr_accessor :amortizado_acumulado
  attr_accessor :interes_diferido
  attr_accessor :pago_total_cliente

  def fecha_f=(fecha)
    self.fecha = fecha
  end

  def fecha_f
    self.fecha.strftime('%d/%m/%Y') unless self.fecha.nil?
  end

  def monto_f=(valor)
    self.monto = valor.sub(',', '.')
  end

  def monto_f
    sprintf('%01.2f', self.monto).sub('.', ',') unless self.monto.nil?
  end

  def monto_fm
    unless self.monto.nil?
      valor = sprintf('%01.2f', self.monto).sub('.', ',')
      valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
    end
  end

  def tasa_f=(valor)
    self.tasa = valor.sub(',', '.')
  end

  def tasa_f
    sprintf('%01.2f', self.tasa).sub('.', ',') unless self.tasa.nil?
  end

  def interes_f=(valor)
    self.interes = valor.sub(',', '.')
  end

  def interes_f
    sprintf('%01.2f', self.interes).sub('.', ',') unless self.interes.nil?
  end

  def interes_fm
    unless self.interes.nil?
      valor = sprintf('%01.2f', self.interes).sub('.', ',')
      valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
    end
  end

  def interes_diferido_f=(valor)
    self.interes_diferido = valor.sub(',', '.')
  end

  def interes_diferido_f
    sprintf('%01.2f', self.interes_diferido).sub('.', ',') unless self.interes_diferido.nil?
  end

  def interes_diferido_fm
    unless self.interes_diferido.nil?
      valor = sprintf('%01.2f', self.interes_diferido).sub('.', ',')
      valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
    end
  end

  def pago_total_cliente_f=(valor)
    self.pago_total_cliente = valor.sub(',', '.')
  end

  def pago_total_cliente_f
    sprintf('%01.2f', self.pago_total_cliente).sub('.', ',') unless self.pago_total_cliente.nil?
  end

  def pago_total_cliente_fm
    unless self.pago_total_cliente.nil?
      valor = sprintf('%01.2f', self.pago_total_cliente).sub('.', ',')
      valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
    end
  end

  def interes_acumulado_f=(valor)
    self.interes_acumulado = valor.sub(',', '.')
  end

  def interes_acumulado_f
    sprintf('%01.2f', self.interes_acumulado).sub('.', ',') unless self.interes_acumulado.nil?
  end

  def interes_acumulado_fm
    unless self.interes_acumulado.nil?
      valor = sprintf('%01.2f', self.interes_acumulado).sub('.', ',')
      valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
    end
  end

  def saldo_f=(valor)
    self.saldo = valor.sub(',', '.')
  end

  def saldo_f
    sprintf('%01.2f', self.saldo).sub('.', ',') unless self.saldo.nil?
  end

  def saldo_fm
    unless self.saldo.nil?
      valor = sprintf('%01.2f', self.saldo).sub('.', ',')
      valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
    end
  end

  def amortizado_f=(valor)
    self.amortizado = valor.sub(',', '.')
  end

  def amortizado_f
    sprintf('%01.2f', self.amortizado).sub('.', ',') unless self.amortizado.nil?
  end

  def amortizado_fm
    unless self.amortizado.nil?
      valor = sprintf('%01.2f', self.amortizado).sub('.', ',')
      valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
    end
  end

  def remanente_por_aplicar_f
    sprintf('%01.2f', self. remanente_por_aplicar).sub('.', ',') unless self. remanente_por_aplicar.nil?
  end

  def  remanente_por_aplicar_fm
    unless self. remanente_por_aplicar.nil?
      valor = sprintf('%01.2f', self. remanente_por_aplicar).sub('.', ',')
      valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
    end
  end

  def amortizado_acumulado_f=(valor)
    self.amortizado_acumulado = valor.sub(',', '.')
  end

  def amortizado_acumulado_f
    sprintf('%01.2f', self.amortizado_acumulado).sub('.', ',') unless self.amortizado_acumulado.nil?
  end

  def amortizado_acumulado_fm
    unless self.amortizado_acumulado.nil?
      valor = sprintf('%01.2f', self.amortizado_acumulado).sub('.', ',')
      valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
    end
  end

end

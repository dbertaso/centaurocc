# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Calculadora
# descripción: Migración a Rails 3
#


class Calculadora < ActiveRecord::Base

  def self.columns() @columns ||= []; end

  def self.column(name, sql_type = nil, default = nil, null = true)
    columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
  end

  attr_accessible :metodo,
                  :fecha,
                  :plazo,
                  :periodo,
                  :monto,
                  :tasa,
                  :cuotas,
                  :_365,
                  :periodo_muerto,
                  :muerto_plazo,
                  :muerto_cuotas,
                  :periodo_gracia,
                  :gracia_plazo,
                  :gracia_periodo,
                  :gracia_tasa,
                  :gracia_cuotas,
                  :diferir_intereses,
                  :fecha_inicio,
                  :fecha_fin,
                  :dia_facturacion,
                  :evento,
                  :amortizado_inicial,
                  :interes_inicial,
                  :numero_cuota_inicial,
                  :tipo_cuota_inicial,
                  :total_gracia,
                  :cuota_diferido,
                  :fecha_f,
                  :tasa_f,
                  :gracia_tasa_f,
                  :monto_f

  # Datos Básicos
  column :metodo, :integer
  column :fecha, :date
  column :plazo, :integer
  column :periodo, :integer
  column :monto, :decimal, :precision=>16, :scale=>2
  column :tasa, :decimal, :precision=>5, :scale=>2
  column :cuotas
  column :_365, :integer

  # Período Muerto
  column :periodo_muerto, :integer
  column :muerto_plazo, :integer
  column :muerto_cuotas

  # Período de Gracia
  column :periodo_gracia, :integer
  column :gracia_plazo, :integer
  column :gracia_periodo, :integer
  column :gracia_tasa, :decimal, :precision=>5, :scale=>2
  column :gracia_cuotas
  column :diferir_intereses, :integer

  #Datos Derivados
  column :fecha_inicio, :date
  column :fecha_fin, :date
  column :dia_facturacion, :integer

  # Proyección
  column :evento
  column :amortizado_inicial, :decimal, :precision=>16, :scale=>2
  column :interes_inicial, :decimal, :precision=>16, :scale=>2
  column :numero_cuota_inicial, :integer
  column :tipo_cuota_inicial, :integer

  column :total_gracia, :decimal, :precision=>16, :scale=>2
  column :cuota_diferido, :decimal, :precision=>16, :scale=>2

  # Datos Básicos

  validate :validate
  
  validates :fecha,
    :date => {:message => "#{I18n.t('Sistema.Body.Vistas.Simulador.Etiquetas.fecha_liquidacion')} #{I18n.t('Sistema.Body.Modelos.Errores.fecha_invalida')}"}

  validates :plazo,    
            :numericality =>{:numericality => true, 
                             :only_integer => true, 
                             :message => "#{I18n.t('Sistema.Body.General.el')} #{I18n.t('Sistema.Body.Modelos.Errores.plazo_prestamo_invalido')}" }    

  validates :periodo,    
            :numericality =>{:numericality => true, 
                             :only_integer => true, 
                             :message => "#{I18n.t('Sistema.Body.General.la')} #{I18n.t('Sistema.Body.Modelos.Errores.periodicidad_prestamo_invalida')}" }    
  validates :monto,    
            :numericality =>{:numericality => true, 
                             :message => "#{I18n.t('Sistema.Body.General.el')} #{I18n.t('Sistema.Body.Vistas.General.monto')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_numerico')}" }    
  validates :tasa,    
            :numericality =>{:numericality => true, 
                             :message => "#{I18n.t('Sistema.Body.Vistas.General.tasa')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_numerico')}" }    

  # Período Gracia
  validates :gracia_plazo,    
            :numericality =>{:numericality => true, 
                             :only_integer => true,
                             :alow_nil=> true,
                             :message => "#{I18n.t('Sistema.Body.General.el')} #{I18n.t('Sistema.Body.Modelos.Errores.plazo_periodo_gracia_invalido')}" }    
  validates :gracia_periodo,    
            :numericality =>{:numericality => true, 
                             :only_integer => true,
                             :allow_nil => true,
                             :message => "#{I18n.t('Sistema.Body.General.la')} #{I18n.t('Sistema.Body.Modelos.Errores.periodicidad_periodo_gracia_invalido')}" }    
  validates :tasa,    
            :numericality =>{:numericality => true, 
                             :message => "#{I18n.t('Sistema.Body.General.la')} #{I18n.t('Sistema.Body.Modelos.Errores.tasa_periodo_gracia_invalida')}" }    

  def todas_cuotas
    self.muerto_cuotas + self.gracia_cuotas + self.cuotas
  end


  def after_initialize
    self._365 = self._365.to_i == 1
    # Datos Básicos
    self.fecha = Time.now unless self.fecha
    self.plazo = 0 unless self.plazo
    self.periodo = 0 unless self.periodo
    self.monto = 0 unless self.monto
    self.tasa = 0 unless self.tasa
    #self.cuotas = [] unless self.cuotas
    self.cuotas = []
    self.dia_facturacion = 0 unless self.dia_facturacion

    # Período Muerto
    self.muerto_plazo = 0 unless self.muerto_plazo
    #self.muerto_cuotas = []
    self.muerto_cuotas = []

    # Período de Gracia
    self.gracia_plazo = 0 unless self.gracia_plazo
    self.gracia_tasa = 0 unless self.gracia_tasa
    #self.gracia_cuotas = []
    self.gracia_cuotas = []
    self.gracia_periodo = 0 unless self.gracia_periodo

    # Proyección
    self.amortizado_inicial = 0 unless self.amortizado_inicial
    self.interes_inicial = 0 unless self.interes_inicial
    self.numero_cuota_inicial = 0 unless self.numero_cuota_inicial

    @cuota_numero = 1

  end

  def gracia_periodo_w
    _periodo(self.gracia_periodo)
  end

  def periodo_w
    _periodo(self.periodo)
  end

  def validate

    if self.gracia_plazo.to_i > self.plazo
      errors.add :calculadora, I18n.t('Sistema.Body.Modelos.Errores.plazo_gracia_no_mayor_plazo')
    end
    if self.monto.to_i <= 0
      errors.add :calculadora, "#{I18n.t('Sistema.Body.General.el')} #{I18n.t('Sistema.Body.Vistas.General.monto')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_mayor_cero')}"
    end
    if self.plazo.to_i <= 0
      errors.add :calculadora, "#{I18n.t('Sistema.Body.General.el')} #{I18n.t('Sistema.Body.Vistas.General.plazo')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_mayor_cero')}"
    end
    if (self.plazo.to_i % self.periodo.to_i) != 0
      errors.add :calculadora, I18n.t('Sistema.Body.Modelos.Errores.plazo_debe_ser_divisible_en_periodo')
    end
    if (self.periodo_muerto.to_i==1)
      if self.muerto_plazo.to_i <= 0
        errors.add :calculadora, "#{I18n.t('Sistema.Body.General.el')} #{I18n.t('Sistema.Body.Modelos.Errores.plazo_debe_ser_divisible_en_periodo')}"
      end
    end
    if (self.periodo_gracia.to_i==1)
      if self.gracia_plazo.to_i <= 0
        errors.add :calculadora, "#{I18n.t('Sistema.Body.General.el')} #{I18n.t('Sistema.Body.Modelos.Errores.plazo_debe_ser_divisible_en_periodo')}"
      end
      if self.gracia_plazo.to_i != 0 && self.gracia_periodo.to_i != 0 &&
         (self.gracia_plazo.to_i % self.gracia_periodo.to_i) != 0
        errors.add :calculadora, "#{I18n.t('Sistema.Body.General.el')} #{I18n.t('Sistema.Body.Modelos.Errores.plazo_gracia_debe_ser_divisible_en_periodo')}"
      end
    end
  end

  # Datos Básicos
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

  # Período Gracia
  def gracia_tasa_f=(valor)
    self.gracia_tasa = valor.sub(',', '.')
  end
  def gracia_tasa_f
    sprintf('%01.2f', self.gracia_tasa).sub('.', ',') unless self.gracia_tasa.nil?
  end

  def calcular

    if !@evento
      fecha = self.fecha
    else
      if self.fecha.day > self.dia_facturacion
        fecha = self.fecha.months_since(2)
      else
        fecha = self.fecha.next_month
      end
    end

    dia = fecha.day
    mes = fecha.month
    year = fecha.year
    if self.dia_facturacion == 0
      dia = dia > 16 && dia <= 28 ? 28 : 16
      self.dia_facturacion = dia
    else
      dia = self.dia_facturacion
    end
    @cuota_fecha = Time.gm(year, mes, dia, 0, 0, 0)
    self.fecha_inicio = @cuota_fecha

    if !self.tipo_cuota_inicial.nil?
      case self.tipo_cuota_inicial
      when 'M'
        if self.numero_cuota_inicial == self.muerto_plazo
          self.tipo_cuota_inicial='G'
          self.numero_cuota_inicial = 0
        end
      when 'G'
        if self.numero_cuota_inicial == self.gracia_plazo
          self.tipo_cuota_inicial='C'
          self.numero_cuota_inicial = 0
        end
      end
    end

    if self.tipo_cuota_inicial.nil? || (self.tipo_cuota_inicial != 'G' && self.tipo_cuota_inicial != 'C')
      calcular_muerto
    end
    if self.tipo_cuota_inicial.nil? || (self.tipo_cuota_inicial != 'C')
      calcular_gracia
    end
    calcular_prestamo

    #return @gracia_cuotas, @cuotas_muerto, @cuotas
  end

  private

  def calcular_muerto

    if self.muerto_plazo.to_i == 0
      return
    end

    numero_real = 0
    if !self.tipo_cuota_inicial.nil? && self.tipo_cuota_inicial=='M'
      self.muerto_plazo -= self.numero_cuota_inicial
      numero_real = self.numero_cuota_inicial
    end
    self.muerto_cuotas = []

    @cuota_numero = 0

    for i in 0...self.muerto_plazo.to_i

      cuota = Cuota.new
      numero_real += 1
      cuota.numero_real = numero_real
      @cuota_fecha = @cuota_fecha.next_month()

      cuota.numero = @cuota_numero
      cuota.fecha = @cuota_fecha
      cuota.monto = 0
      cuota.tasa = 0
      cuota.interes = 0
      cuota.interes_diferido = 0
      cuota.interes_acumulado = 0
      cuota.amortizado = 0
      cuota.amortizado_acumulado = 0
      cuota.pago_total_cliente = 0
      cuota.saldo = self.monto.to_f

      @cuota_numero += 1

      self.muerto_cuotas << cuota
    end

  end

  def calcular_gracia

    if self.gracia_plazo.to_i == 0
      return
    end

    numero_real = 0
    if !self.tipo_cuota_inicial.nil? && self.tipo_cuota_inicial == 'G'
      self.gracia_plazo -= self.numero_cuota_inicial
      numero_real = self.numero_cuota_inicial
    end

    if self.gracia_periodo.to_i > 0
      numero_cuotas = self.gracia_plazo.to_i / self.gracia_periodo.to_i
      periodicidad = 12 / self.gracia_periodo.to_i
    end

    interes = self.monto.to_f * ( (self.gracia_tasa.to_f / 100) / periodicidad )
    tasa = self.gracia_tasa.to_f / periodicidad

    self.total_gracia = 0.00
    self.cuota_diferido = 0.00

    @cuota_numero = 0
    numero_real = 0
    self.total_gracia = 0

    self.gracia_cuotas = []

    logger.info "Tipo de dato de gracia_cuotas =======> #{self.gracia_cuotas.class.to_s}"
    for i in 0...numero_cuotas

      cuota = Cuota.new
      numero_real += 1
      cuota.numero_real = numero_real
      @cuota_fecha = @cuota_fecha.months_since(self.gracia_periodo.to_i)

      cuota.numero = @cuota_numero
      cuota.fecha = @cuota_fecha

      puts "Diferir intereses =====> " << self.diferir_intereses.to_s
      if self.diferir_intereses.to_s == '1'
        cuota.monto = 0
      else
        cuota.monto = interes
      end

      cuota.tasa = tasa
      cuota.interes = interes
      cuota.interes_acumulado = 0
      cuota.amortizado = 0
      cuota.amortizado_acumulado = 0
      cuota.pago_total_cliente = 0
      cuota.interes_diferido = 0
      cuota.saldo = self.monto.to_f
      if self.diferir_intereses.to_s == '0'
        cuota.pago_total_cliente = cuota.amortizado + cuota.interes + cuota.interes_diferido
      end

      @cuota_numero += 1

      #puts "Tipo Objeto ==============> #{self.gracia_cuotas.type}"
      logger.info "cuota =====> #{cuota.inspect} <====> #{cuota.class.to_s}"
      logger.info "@Cuotas =====> #{@gracia_cuotas.inspect} <=====> #{@gracia_cuotas.class.to_s}"
      self.gracia_cuotas << cuota
      self.total_gracia += interes
    end

    if self.diferir_intereses.to_s == '1'
      self.cuota_diferido = self.total_gracia / (self.plazo.to_i / self.periodo.to_i)
    end

  end

  def calcular_prestamo

    numero_real = 0
    if !self.tipo_cuota_inicial.nil? && self.tipo_cuota_inicial=='C'
      self.plazo -= self.numero_cuota_inicial
      numero_real = self.numero_cuota_inicial
    end

    plazo_real = self.plazo.to_i - self.gracia_plazo.to_i

    numero_cuotas = plazo_real.to_i / self.periodo.to_i
    periodicidad = 12 / self.periodo.to_i

    tasa = self.tasa.to_f / periodicidad
    if (self.metodo.to_i==3)
      cuota_fija = (self.monto.to_f / (self.plazo.to_i / self.periodo.to_i))
    else
      monto_cuota = cuota_frances(self.monto.to_f, self.tasa.to_f, numero_cuotas, self.periodo.to_i)
    end

    saldo = self.monto.to_f

    interes_acumulado = interes_inicial
    amortizado_acumulado = amortizado_inicial
    # saldo = self.monto - amortizado_acumulado
    if tasa>0
      #tasa = tasa * 10000000000
      #tasa = tasa.to_i
      #tasa = tasa/10000000000.0
    end
    amortizado = 0;
    monto_cuota_365 = 0;
    fecha_365 = @cuota_fecha

    self.cuotas = []

    for i in 0...numero_cuotas
      interes = saldo * tasa / 100
      if self._365 && self.metodo.to_i==1

        fecha_365 = fecha_365.months_since(self.periodo.to_i)
        amortizado = monto_cuota - interes
        dias = (fecha_365 - fecha_365.months_since(-self.periodo.to_i)) / (24 * 3600)
        interes =  (self.tasa.to_f / 100) * (dias.to_f / 365)  * saldo
        monto_cuota_365 = amortizado + interes
      end

      if self.metodo.to_i==3
        if self._365
          fecha_365 = fecha_365.months_since(self.periodo.to_i)
          dias = (fecha_365 - fecha_365.months_since(-self.periodo.to_i)) / (24 * 3600)
          interes =  (self.tasa.to_f / 100) * (dias.to_f / 365)  * saldo
          monto_cuota_365 = cuota_fija + interes
        else
          monto_cuota = cuota_fija + interes
        end
      end

      cuota = Cuota.new
      cuota.monto =  self._365 ? monto_cuota_365 : monto_cuota
      cuota.tasa = tasa
      cuota.interes = interes
      cuota.amortizado = cuota.monto - cuota.interes
      # cuota.saldo = (cuota.monto < saldo) ? saldo - cuota.amortizado : 0
      cuota.saldo = saldo - cuota.amortizado
      cuota.interes_diferido = self.cuota_diferido
      cuota.pago_total_cliente = cuota.amortizado + cuota.interes + cuota.interes_diferido
      saldo = cuota.saldo

      self.cuotas << cuota
    end

    if (self.metodo.to_i==2)
      self.cuotas.reverse!
      saldo = self.monto.to_
    end

    @cuota_numero = 0

    for i in 0...numero_cuotas
      numero_real += 1
      cuota = self.cuotas[i]
      cuota.numero_real = numero_real
      @cuota_fecha = @cuota_fecha.months_since(self.periodo.to_i)

      cuota.numero = @cuota_numero
      cuota.fecha = @cuota_fecha

    # interes_acumulado += cuota.interes
      #cuota.interes_acumulado = interes_acumulado

      amortizado_acumulado += cuota.amortizado
      cuota.amortizado_acumulado = amortizado_acumulado

      if (self.metodo.to_i==2)
        cuota.saldo = (cuota.amortizado < saldo) ? saldo - cuota.amortizado : 0
        saldo = cuota.saldo
      end

      @cuota_numero += 1

    end
    interes_acumulado = 0
    for i in 0...numero_cuotas

      cuota = self.cuotas[i]

      cuota.amortizado = round_2_decimal(cuota.amortizado)
      cuota.interes =  round_2_decimal(cuota.interes)
      cuota.monto = round_2_decimal(cuota.monto)


     if cuota.monto != (cuota.interes + cuota.amortizado)
      cuota.interes = cuota.monto-cuota.amortizado
     end
     interes_acumulado += cuota.interes
     cuota.interes_acumulado = interes_acumulado
    end

    self.fecha_fin = @cuota_fecha
    @cuotas = @cuotas
  end

  def cuota_frances(monto, tasa, cuotas, periodo)
    if tasa>0
      tasa = ( tasa / (12 / periodo) ) / 100
      monto * ( ( tasa  * ( (1 + tasa)**cuotas ) ) / ( ( (1 + tasa)**cuotas ) - 1 ) )
    else
      monto / cuotas
    end
  end

  def _periodo(periodo)
    case periodo.to_i
    when 1
      I18n.t('Sistema.Body.General.Periodos.mensual')
    when 2
      I18n.t('Sistema.Body.General.Periodos.bimestral')
    when 3
      I18n.t('Sistema.Body.General.Periodos.trimestral')
    when 4
      I18n.t('Sistema.Body.General.Periodos.cuatrimestral')
    when 5
      I18n.t('Sistema.Body.General.Periodos.pentamestral')
    when 6
      I18n.t('Sistema.Body.General.Periodos.semestral')
    when 7
      I18n.t('Sistema.Body.General.Periodos.heptamestral')
    when 12
      I18n.t('Sistema.Body.General.Periodos.anual')
    end
  end

  def round_2_decimal(valor)
    valor = valor * 100
    valor = valor.round
    valor = valor/100.0
  end
end


# == Schema Information
#
# Table name: calculadoras
#
#  metodo               :integer
#  fecha                :date
#  plazo                :integer
#  periodo              :integer
#  monto                :decimal(, )     default(0.0)
#  tasa                 :decimal(, )     default(0.0)
#  cuotas               :
#  _365                 :integer
#  periodo_muerto       :integer
#  muerto_plazo         :integer
#  muerto_cuotas        :
#  periodo_gracia       :integer
#  gracia_plazo         :integer
#  gracia_periodo       :integer
#  gracia_tasa          :decimal(, )     default(0.0)
#  gracia_cuotas        :
#  diferir_intereses    :integer
#  fecha_inicio         :date
#  fecha_fin            :date
#  dia_facturacion      :integer
#  evento               :
#  amortizado_inicial   :decimal(, )     default(0.0)
#  interes_inicial      :decimal(, )     default(0.0)
#  numero_cuota_inicial :integer
#  tipo_cuota_inicial   :integer
#  total_gracia         :decimal(, )     default(0.0)
#  cuota_diferido       :decimal(, )     default(0.0)
#


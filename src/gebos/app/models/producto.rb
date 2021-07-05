# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Producto
# descripción: Migración a Rails 3
#
class Producto < ActiveRecord::Base

  self.table_name = 'producto'

  attr_accessible :id,
    :monto_maximo,
    :monto_minimo,
    :plazo_maximo,
    :plazo_minimo,
    :exonerar_intereses,
    :tasa_fija,
    :meses_fijos_sin_cambio_tasa,
    :forma_calculo_intereses,
    :base_calculo_intereses,
    :permitir_abonos,
    :abono_forma,
    :abono_porcentaje,
    :abono_cantidad_cuotas,
    :abono_monto_minimo,
    :abono_lapso_minimo,
    :abono_dias_vencimiento,
    :exonerar_intereses_mora,
    :base_cobro_mora,
    :meses_gracia_si,
    :meses_gracia,
    :diferir_intereses,
    :exonerar_intereses_diferidos,
    :meses_muertos_si,
    :meses_muertos,
    :gastos_fijos,
    :gastos_forma_cobro,
    :fiador_si,
    :garantia_si,
    :programa_id,
    :sector_id,
    :sub_sector_id,
    :sub_rubro_id,
    :actividad_id,
    :monto_minimo_f,
    :monto_maximo_f,
    :solicitud,
    :prestamo

  belongs_to :formula
  belongs_to :programa
  belongs_to :sector
  belongs_to :sub_sector


  has_and_belongs_to_many :formulas, :class_name=>'Formula', :join_table=>'producto_formula'
#  , :delete_sql =>
#    "DELETE FROM producto_formula WHERE id = #{self.id.to_s}"

  validate :validate

  validates_numericality_of :monto_maximo,
    :message => "#{I18n.t('Sistema.Body.Modelos.Producto.Columnas.monto_maximo')} #{I18n.t('errors.messages.not_a_number')}"

  validates_numericality_of :monto_minimo,
    :message => "#{I18n.t('Sistema.Body.Modelos.Producto.Columnas.monto_minimo')} #{I18n.t('errors.messages.not_a_number')}"

  validates_numericality_of :abono_porcentaje, :allow_nil => true,
    :message => "#{I18n.t('Sistema.Body.Modelos.Producto.Errores.abono_porcentaje_maximo')} #{I18n.t('errors.messages.not_a_number')}"

  validates_numericality_of :abono_monto_minimo, :allow_nil => true,
    :message => "#{I18n.t('Sistema.Body.Modelos.Producto.Errores.abono_monto_minimo')} #{I18n.t('errors.messages.not_a_number')}"

  validates_numericality_of :abono_cantidad_cuotas, :only_integer => true, :allow_nil => true,
    :message => "#{I18n.t('Sistema.Body.Modelos.Producto.Errores.abono_cantidad_cuotas')} #{I18n.t('errors.messages.not_a_number')}"

  validates_numericality_of :abono_lapso_minimo, :only_integer => true, :allow_nil => true,
    :message => "#{I18n.t('Sistema.Body.Modelos.Producto.Errores.abono_lapso_minimo')} #{I18n.t('errors.messages.not_a_number')}"

  validates_numericality_of :abono_dias_vencimiento, :only_integer => true, :allow_nil => true,
    :message => "#{I18n.t('Sistema.Body.Modelos.Producto.Errores.abono_dias_vencimiento')} #{I18n.t('errors.messages.not_a_number')}"

  validates_numericality_of :meses_gracia, :only_integer => true, :allow_nil => true,
    :message => "#{I18n.t('Sistema.Body.Modelos.Producto.Columnas.meses_gracia')} #{I18n.t('errors.messages.not_a_number')}"

  validates_numericality_of :meses_muertos, :only_integer => true, :allow_nil => true,
    :message => "#{I18n.t('Sistema.Body.Modelos.Producto.Columnas.meses_muertos')} #{I18n.t('errors.messages.not_a_number')}"

  validates_numericality_of :meses_fijos_sin_cambio_tasa, :only_integer => true, :allow_nil => true,
    :message => "#{I18n.t('Sistema.Body.Modelos.Producto.Columnas.meses_fijos_sin_cambio_tasa')} #{I18n.t('errors.messages.not_a_number')}"

  validates_numericality_of :plazo_maximo, :only_integer => true,
    :message =>  "#{I18n.t('Sistema.Body.Modelos.Producto.Columnas.plazo_maximo')} (#{I18n.t('Sistema.Body.Modelos.General.expresado_en_meses')}), #{I18n.t('errors.messages.not_a_number')}"

  validates_numericality_of :plazo_minimo, :only_integer => true,
    :message => "#{I18n.t('Sistema.Body.Modelos.Producto.Columnas.plazo_minimo')} (#{I18n.t('Sistema.Body.Modelos.General.expresado_en_meses')}), #{I18n.t('errors.messages.not_a_number')}"

  after_initialize :after_initialize, :on => :create

  def self.search(search, page, sort)

    unless search.nil?
      paginate  :per_page => @records_by_page, :page => page,
        :joins=>'INNER JOIN programa on programa.id = producto.programa_id INNER JOIN sector on sector.id = producto.sector_id INNER JOIN sub_sector on sub_sector.id = producto.sub_sector_id', 
        :conditions => search, :order => sort, 
        :select=>'producto.id, programa.id as programa_id, sector.nombre as nombre_sector, sector.descripcion as descripcion_sector, sub_sector.nombre as nombre_sub_sector, sub_sector.descripcion as descripcion_sub_sector' 
    else
      paginate  :per_page => @records_by_page, :page => page,
        :joins=>'INNER JOIN programa on programa.id = producto.programa_id INNER JOIN sector on sector.id = producto.sector_id INNER JOIN sub_sector on sub_sector.id = producto.sub_sector_id', 
        :order => sort, :select=>'producto.id, programa.id as programa_id, sector.nombre as nombre_sector, sector.descripcion as descripcion_sector, sub_sector.nombre as nombre_sub_sector, sub_sector.descripcion as descripcion_sub_sector'

    end

  end

  def monto_maximo_f=(valor)
    self.monto_maximo = valor.sub(',', '.')
  end

  def monto_maximo_f
    sprintf('%01.2f', self.monto_maximo).sub('.', ',') unless self.monto_maximo.nil?
  end
  def monto_maximo_fm
    unless self.monto_maximo.nil?
      valor = sprintf('%01.2f', self.monto_maximo).sub('.', ',')
      valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
    end
  end

  def monto_minimo_f=(valor)
    self.monto_minimo = valor.sub(',', '.')
  end

  def monto_minimo_f
    sprintf('%01.2f', self.monto_minimo).sub('.', ',') unless self.monto_minimo.nil?
  end
  def monto_minimo_fm
    unless self.monto_minimo.nil?
      valor = sprintf('%01.2f', self.monto_minimo).sub('.', ',')
      valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
    end
  end

  def abono_porcentaje_f=(valor)
    self.abono_porcentaje = valor.sub(',', '.')
  end

  def abono_porcentaje_f
    sprintf('%01.2f', self.abono_porcentaje).sub('.', ',') unless self.abono_porcentaje.nil?
  end

  def abono_monto_minimo_f=(valor)
    self.abono_monto_minimo = valor.sub(',', '.')
  end

  def abono_monto_minimo_f
    sprintf('%01.2f', self.abono_monto_minimo).sub('.', ',') unless self.abono_monto_minimo.nil?
  end
  def abono_monto_minimo_fm
    unless self.abono_monto_minimo.nil?
      valor = sprintf('%01.2f', self.abono_monto_minimo).sub('.', ',')
      valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
    end
  end

  def validate
    if self.monto_maximo.to_i < 0
      errors.add(:producto, "#{I18n.t('Sistema.Body.Modelos.Producto.Columnas.monto_maximo')} #{I18n.t('Sistema.Body.Modelos.Errores.deber_ser_mayor_cero')}")
    end
    if self.monto_minimo.to_i < 0
      errors.add(:producto, "#{I18n.t('Sistema.Body.Modelos.Producto.Columnas.monto_minimo')} #{I18n.t('Sistema.Body.Modelos.Errores.deber_ser_mayor_cero')}")
    end
    if self.plazo_maximo.to_i < 0
      errors.add(:producto, "#{I18n.t('Sistema.Body.Modelos.Producto.Columnas.plazo_maximo')} #{I18n.t('Sistema.Body.Modelos.Errores.deber_ser_mayor_cero')}")
    end
    if self.plazo_minimo.to_i < 0
      errors.add(:producto, "#{I18n.t('Sistema.Body.Modelos.Producto.Columnas.plazo_maximo')} #{I18n.t('Sistema.Body.Modelos.Errores.deber_ser_mayor_cero')}")
    end

    unless self.meses_fijos_sin_cambio_tasa.nil?
      if self.meses_fijos_sin_cambio_tasa.to_i < 0
        errors.add(:producto, "#{I18n.t('Sistema.Body.Modelos.Producto.Columnas.meses_fijos_sin_cambio_tasa')} #{I18n.t('Sistema.Body.Modelos.Errores.deber_ser_mayor_cero')}")
      end
    end

    unless self.abono_cantidad_cuotas.nil?
      if self.abono_cantidad_cuotas.to_i < 0
        errors.add(:producto, "#{I18n.t('Sistema.Body.Modelos.Producto.Columnas.abono_cantidad_cuotas')} #{I18n.t('Sistema.Body.Modelos.Errores.deber_ser_mayor_cero')}")
      end
    end

    unless self.meses_gracia_si.nil?
      if self.meses_gracia_si
        if self.meses_gracia.to_i < 0
          errors.add(:producto, "#{I18n.t('Sistema.Body.Modelos.Producto.Columnas.meses_gracia')} #{I18n.t('Sistema.Body.Modelos.Errores.deber_ser_mayor_cero')}")
        end
      end
    end

    unless self.meses_muertos_si.nil?
      if self.meses_muertos_si
        if self.meses_muertos.to_i < 0
          errors.add(:producto, "#{I18n.t('Sistema.Body.Modelos.Producto.Columnas.meses_muertos')} #{I18n.t('Sistema.Body.Modelos.Errores.deber_ser_mayor_cero')}")
        end
      end
    end

    unless self.monto_minimo.nil? && self.monto_maximo.nil?

      if self.monto_minimo>self.monto_maximo
        errors.add(:producto, I18n.t('Sistema.Body.Modelos.Producto.Columnas.monto_minimo_mayor'))
      end
    end

    unless self.plazo_minimo.nil? && self.monto_maximo.nil?
      if self.plazo_minimo>self.plazo_minimo
        errors.add(:producto, I18n.t('Sistema.Body.Modelos.Producto.Columnas.plazo_minimo_mayor'))
      end
    end
  end

  def after_initialize

    if new_record?
      self.base_calculo_intereses = 360 unless self.base_calculo_intereses
      self.monto_maximo = 0 unless self.monto_maximo
      self.monto_minimo = 0 unless self.monto_minimo
      self.plazo_maximo = 0 unless self.plazo_maximo
      self.plazo_minimo = 0 unless self.plazo_minimo
      self.abono_porcentaje = 0 unless self.abono_porcentaje
      self.abono_monto_minimo = 0 unless self.abono_monto_minimo
      self.abono_cantidad_cuotas = 0 unless self.abono_cantidad_cuotas
      self.abono_lapso_minimo = 0 unless self.abono_lapso_minimo
      self.abono_dias_vencimiento = 0 unless self.abono_dias_vencimiento
      self.meses_gracia = 0 unless self.meses_gracia
      self.meses_muertos = 0 unless self.meses_muertos
      self.meses_fijos_sin_cambio_tasa = 0 unless self.meses_fijos_sin_cambio_tasa
      self.forma_calculo_intereses = "V" unless self.forma_calculo_intereses
      self.base_cobro_mora = "C" unless self.base_cobro_mora
    end
  end

  def add_formula(formula)
    if formulas.find formula.id
      errors.add(:producto, I18n.t('Sistema.Body.Modelos.Producto.Columnas.condicion_financiamiento'))
      return false
    end
  rescue
    formulas << formula
  end

end



# == Schema Information
#
# Table name: producto
#
#  id                           :integer         not null, primary key
#  monto_maximo                 :float
#  monto_minimo                 :float
#  plazo_maximo                 :integer(2)
#  plazo_minimo                 :integer(2)
#  exonerar_intereses           :boolean
#  tasa_fija                    :boolean         default(FALSE)
#  meses_fijos_sin_cambio_tasa  :integer(2)
#  forma_calculo_intereses      :string(1)
#  base_calculo_intereses       :integer         default(360)
#  permitir_abonos              :boolean         default(FALSE)
#  abono_forma                  :string(1)       default("P")
#  abono_porcentaje             :float
#  abono_cantidad_cuotas        :integer(2)
#  abono_monto_minimo           :float
#  abono_lapso_minimo           :integer(2)
#  abono_dias_vencimiento       :integer(2)
#  exonerar_intereses_mora      :boolean         default(FALSE)
#  base_cobro_mora              :string(1)
#  meses_gracia_si              :boolean         default(FALSE)
#  meses_gracia                 :integer(2)
#  diferir_intereses            :boolean         default(FALSE)
#  exonerar_intereses_diferidos :boolean
#  meses_muertos_si             :boolean         default(FALSE)
#  meses_muertos                :integer(2)
#  gastos_fijos                 :float
#  gastos_forma_cobro           :string(1)
#  fiador_si                    :boolean         default(FALSE)
#  garantia_si                  :boolean         default(FALSE)
#  programa_id                  :integer         not null
#  sector_id                    :integer         not null
#  sub_sector_id                :integer         not null
#  sub_rubro_id                 :integer
#  actividad_id                 :integer
#


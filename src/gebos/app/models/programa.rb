# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Programa
# descripción: Migración a Rails 3
#

class Programa < ActiveRecord::Base

  validate :validate_block

  self.table_name = 'programa'

  attr_accessible :id, :nombre, :alias, :descripcion, :porcentaje_financiamiento, :intermediado, :porcentaje_riesgo_foncrei,
    :porcentaje_riesgo_intermediario, :porcentaje_tasa_foncrei, :porcentaje_tasa_intermediario,
    :frecuencia_pago_intermediario, :porcentaje_tasa_tapp, :activo, :tipo_credito_id, :tasa_id, :diferencial_maximo_tasa,:diferencial_minimo_tasa, :tasa_mora_id, :diferencial_maximo_tasa_mora, :diferencial_minimo_tasa_mora,
    :solo_aprueba_directorio, :cogestion, :codigo_d3, :codestpro_sigesp, :spg_cuenta_sigesp,
    :fecha_cierre, :solo_aprueba_comite, :aprueba_comite_directorio, :monto_max_presidencia, :convenio,
    :ultimo_desembolso, :tipo_diferimiento, :porcentaje_diferimiento, :vinculo_tasa,
    :financiamiento_integral, :tamano_credito, :partida_presupuestaria_id, :moneda_id


  belongs_to :moneda
  has_and_belongs_to_many :modalidades_financiamiento, :class_name=>'ModalidadFinanciamiento', :join_table=>'programa_modalidad_financiamiento'
  has_and_belongs_to_many :recaudos, :class_name=>'Recaudo', :join_table=>'programa_recaudo'
  has_and_belongs_to_many :tipos_cliente, :class_name=>'TipoCliente', :join_table=>'programa_tipo_cliente'
  has_and_belongs_to_many :misiones, :class_name=>'Mision', :join_table=>'programa_mision'
  #has_many :pre_chequeo


  belongs_to :tipo_credito,
    :class_name => "TipoCredito",
    :foreign_key => "tipo_credito_id"
  belongs_to :tasa,
    :class_name => "Tasa",
    :foreign_key => "tasa_id"
  belongs_to :tasa_mora,
    :class_name => "Tasa",
    :foreign_key => "tasa_mora_id"
  belongs_to :partida_presupuestaria,
    :class_name => "PartidaPresupuestaria",
    :foreign_key => "partida_presupuestaria_id"



  has_many :productos, :dependent => :destroy, :class_name=>"Producto"

  has_many :origenes_fondo, :dependent => :destroy, :class_name=>"ProgramaOrigenFondo"

  has_many :tipos_garantia, :dependent => :destroy, :class_name=>"ProgramaTipoGarantia"

  has_many :tipos_gasto, :dependent => :destroy, :class_name=>"ProgramaTipoGasto"

  #validate :validate

  validates :nombre,
    :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :moneda,
    :presence => {:message => "#{I18n.t('Sistema.Body.Modelos.Programa.Columnas.moneda')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :descripcion,
    :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.Form.descripcion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates_length_of :nombre, :within => 1..100, :allow_nil => false,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('errors.messages.too_long.other')}"

  validates_length_of :descripcion, :within => 1..300, :allow_nil => false,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.Form.descripcion')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.Form.descripcion')} #{I18n.t('errors.messages.too_long.other')}"

  validates_length_of :alias, :within => 1..100, :allow_nil => false,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.alias')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.alias')} #{I18n.t('errors.messages.too_long.other')}"

  validates_uniqueness_of :nombre,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"

#  validates_numericality_of :relacion_garantia,
#    :message => "#{I18n.t('Sistema.Body.Modelos.Programa.Columnas.relacion_garantia')} #{I18n.t('errors.messages.not_a_number')}"

  validates_numericality_of :porcentaje_financiamiento, :allow_nil => true,
    :message => "#{I18n.t('Sistema.Body.Modelos.Programa.Columnas.porcentaje_financiamiento')} #{I18n.t('errors.messages.not_a_number')}"

  validates_numericality_of :porcentaje_riesgo_foncrei, :allow_nil => true,
    :message => "#{I18n.t('Sistema.Body.Modelos.Programa.Columnas.porcentaje_riesgo_beneficiario')} #{I18n.t('errors.messages.not_a_number')}"

  validates_numericality_of :porcentaje_riesgo_intermediario, :allow_nil => true,
    :message => "#{I18n.t('Sistema.Body.Modelos.Programa.Columnas.porcentaje_riesgo_intermediario')} #{I18n.t('errors.messages.not_a_number')}"

  validates_numericality_of :porcentaje_tasa_foncrei, :allow_nil => true,
    :message => "#{I18n.t('Sistema.Body.Modelos.Programa.Columnas.porcentaje_tasa_foncrei')} #{I18n.t('errors.messages.not_a_number')}"

  validates_numericality_of :porcentaje_tasa_intermediario, :allow_nil => true,
    :message => "#{I18n.t('Sistema.Body.Modelos.Programa.Columnas.porcentaje_tasa_intermediario')} #{I18n.t('errors.messages.not_a_number')}"

  validates_numericality_of :porcentaje_tasa_tapp, :allow_nil => true,
    :message => "#{I18n.t('Sistema.Body.Modelos.Programa.Columnas.porcentaje_tasa_tapp')} #{I18n.t('errors.messages.not_a_number')}"

  validates_numericality_of :diferencial_maximo_tasa, :allow_nil => true,
    :message => "#{I18n.t('Sistema.Body.Modelos.Programa.Columnas.diferencial_maximo_tasa')} #{I18n.t('errors.messages.not_a_number')}"

  validates_numericality_of :diferencial_minimo_tasa, :allow_nil => true,
    :message => "#{I18n.t('Sistema.Body.Modelos.Programa.Columnas.diferencial_minimo_tasa')} #{I18n.t('errors.messages.not_a_number')}"

  validates_numericality_of :diferencial_maximo_tasa_mora, :allow_nil => true,
    :message => "#{I18n.t('Sistema.Body.Modelos.Programa.Columnas.diferencial_maximo_tasa_mora')} #{I18n.t('errors.messages.not_a_number')}"

  validates_numericality_of :diferencial_minimo_tasa_mora, :allow_nil => true,
    :message => "#{I18n.t('Sistema.Body.Modelos.Programa.Columnas.diferencial_minimo_tasa_mora')} #{I18n.t('errors.messages.not_a_number')}"

  validates_numericality_of :porcentaje_diferimiento, :allow_nil => true,
    :message => "#{I18n.t('Sistema.Body.Modelos.Programa.Columnas.porcentaje_diferimiento')} #{I18n.t('errors.messages.not_a_number')}"

  
  
  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort,
      :select=>'*'
  end

  after_initialize :after_initialize
  
#  def self.search(search, page, sort)
#
#    unless search.nil?
#      paginate  :per_page => @records_by_page, :page => page,
#        :conditions => search, :order => sort
#    else
#      paginate  :per_page => @records_by_page, :page => page,
#        :order => sort
#
#    end
#
#  end

  def frecuencia_pago_intermediario_w
    case self.frecuencia_pago_intermediario
    when 1
      I18n.t('Sistema.Body.General.Periodos.mensual')
    when 3
      I18n.t('Sistema.Body.General.Periodos.trimestral')
    when 6
      I18n.t('Sistema.Body.General.Periodos.semestral')
    when 12
      I18n.t('Sistema.Body.General.Periodos.anual')
    end
  end

  def porcentaje_diferimiento_f=(valor)
    self.porcentaje_diferimiento = valor.sub(',', '.')
  end

  def porcentaje_diferimiento_f
    sprintf('%01.2f', self.porcentaje_diferimiento).sub('.', ',') unless self.porcentaje_diferimiento.nil?
  end

#  def relacion_garantia_f=(valor)
#    self.relacion_garantia = valor.sub(',', '.')
#  end
#
#  def relacion_garantia_f
#    sprintf('%01.2f', self.relacion_garantia).sub('.', ',') unless self.relacion_garantia.nil?
#  end

  def porcentaje_financiamiento_f=(valor)
    self.porcentaje_financiamiento = valor.sub(',', '.')
  end

  def porcentaje_financiamiento_f
    sprintf('%01.2f', self.porcentaje_financiamiento).sub('.', ',') unless self.porcentaje_financiamiento.nil?
  end

  def porcentaje_riesgo_foncrei_f=(valor)
    self.porcentaje_riesgo_foncrei = valor.sub(',', '.')
  end
  def porcentaje_riesgo_foncrei_f
    sprintf('%01.2f', self.porcentaje_riesgo_foncrei).sub('.', ',') unless self.porcentaje_riesgo_foncrei.nil?
  end

  def porcentaje_riesgo_intermediario_f=(valor)
    self.porcentaje_riesgo_intermediario = valor.sub(',', '.')
  end

  def porcentaje_riesgo_intermediario_f
    sprintf('%01.2f', self.porcentaje_riesgo_intermediario).sub('.', ',') unless self.porcentaje_riesgo_intermediario.nil?
  end

  def porcentaje_tasa_foncrei_f=(valor)
    self.porcentaje_tasa_foncrei = valor.sub(',', '.')
  end

  def porcentaje_tasa_foncrei_f
    sprintf('%01.2f', self.porcentaje_tasa_foncrei).sub('.', ',') unless self.porcentaje_tasa_foncrei.nil?
  end


  def porcentaje_tasa_intermediario_f=(valor)
    self.porcentaje_tasa_intermediario = valor.sub(',', '.')
  end

  def porcentaje_tasa_intermediario_f
    sprintf('%01.2f', self.porcentaje_tasa_intermediario).sub('.', ',') unless self.porcentaje_tasa_intermediario.nil?
  end

  def porcentaje_tasa_tapp_f=(valor)
    self.porcentaje_tasa_tapp = valor.sub(',', '.')
  end

  def porcentaje_tasa_tapp_f
    sprintf('%01.2f', self.porcentaje_tasa_tapp).sub('.', ',') unless self.porcentaje_tasa_tapp.nil?
  end

  def diferencial_maximo_tasa_f=(valor)
    self.diferencial_maximo_tasa = valor.sub(',', '.')
  end

  def diferencial_maximo_tasa_f
    sprintf('%01.2f', self.diferencial_maximo_tasa).sub('.', ',') unless self.diferencial_maximo_tasa.nil?
  end

  def diferencial_minimo_tasa_f=(valor)
    self.diferencial_minimo_tasa = valor.sub(',', '.')
  end

  def diferencial_minimo_tasa_f
    sprintf('%01.2f', self.diferencial_minimo_tasa).sub('.', ',') unless self.diferencial_minimo_tasa.nil?
  end

  def diferencial_maximo_tasa_mora_f=(valor)
    self.diferencial_maximo_tasa_mora = valor.sub(',', '.')
  end

  def diferencial_maximo_tasa_mora_f
    sprintf('%01.2f', self.diferencial_maximo_tasa_mora).sub('.', ',') unless self.diferencial_maximo_tasa_mora.nil?
  end

  def diferencial_minimo_tasa_mora_f=(valor)
    self.diferencial_minimo_tasa_mora = valor.sub(',', '.')
  end

  def diferencial_minimo_tasa_mora_f
    sprintf('%01.2f', self.diferencial_minimo_tasa_mora).sub('.', ',') unless self.diferencial_minimo_tasa_mora.nil?
  end

  def monto_max_presidencia_f=(valor)
    self.monto_max_presidencia = valor.sub(',', '.')
  end

  def monto_max_presidencia_f
    sprintf('%01.2f', self.monto_max_presidencia).sub('.', ',') unless self.monto_max_presidencia.nil?
  end

  def fecha_ultimo_cierre_f
    self.fecha_cierre.strftime('%d/%m/%Y') unless self.fecha_cierre.nil?
  end

  def after_initialize
    logger.debug "paso por after initialize"
#    self.relacion_garantia = 0 unless self.relacion_garantia.nil?
    if new_record?
      self.porcentaje_tasa_tapp = 100 unless self.porcentaje_tasa_tapp.nil?
      self.porcentaje_riesgo_foncrei = 0 unless self.porcentaje_riesgo_foncrei.nil?
      self.porcentaje_riesgo_intermediario = 0 unless self.porcentaje_riesgo_intermediario.nil?
      self.porcentaje_tasa_foncrei = 0 unless self.porcentaje_tasa_foncrei.nil?
      self.porcentaje_tasa_intermediario = 0 unless self.porcentaje_tasa_intermediario.nil?
      self.porcentaje_financiamiento = 0 unless self.porcentaje_financiamiento.nil?
      self.porcentaje_diferimiento = 0 unless self.porcentaje_diferimiento.nil?
      self.diferencial_maximo_tasa = 0 unless self.diferencial_maximo_tasa.nil?
      self.diferencial_minimo_tasa = 0 unless self.diferencial_minimo_tasa.nil?
      self.diferencial_maximo_tasa_mora = 0 unless self.diferencial_maximo_tasa_mora.nil?
      self.diferencial_minimo_tasa_mora = 0 unless self.diferencial_minimo_tasa_mora.nil?
      self.tipo_credito_id = 1
      self.tasa_id = 0 unless self.tasa_id.nil?
      self.tasa_mora_id = 0 unless self.tasa_mora_id.nil?
      self.vinculo_tasa = false unless self.vinculo_tasa.nil?
    end
  end

  
  def validate_block

    if self.monto_max_presidencia_f.to_i < 0
      errors.add(:programa, I18n.t('Sistema.Body.Modelos.Programa.Errores.monto_maximo_junta'))
    end

    if self.porcentaje_riesgo_foncrei.to_i < 0
      errors.add(:programa, I18n.t('Sistema.Body.Modelos.Programa.Errores.porcentaje_riesgo_debe_estar'))
    end

    if self.porcentaje_riesgo_intermediario.to_i < 0
      errors.add(:programa,  I18n.t('Sistema.Body.Modelos.Programa.Errores.porcentaje_riesgo_intermediario_debe_estar'))
    end

    if self.porcentaje_tasa_foncrei.to_i < 0
      errors.add(:programa, I18n.t('Sistema.Body.Modelos.Programa.Errores.tasa_foncrei_debe_estar'))
    end

    if self.porcentaje_tasa_intermediario.to_i < 0
      errors.add(:programa, I18n.t('Sistema.Body.Modelos.Programa.Errores.porcentaje_intermediario_debe_estar'))
    end

    if self.porcentaje_financiamiento.to_i < 0
      errors.add(:programa, I18n.t('Sistema.Body.Modelos.Programa.Errores.porcentaje_financiamiento_debe_estar'))
    end

    if self.diferencial_maximo_tasa.to_i < 0
      errors.add(:programa, I18n.t('Sistema.Body.Modelos.Programa.Errores.diferencial_maximo_tasa'))
    end

    if self.diferencial_minimo_tasa.to_i < 0
      errors.add(:programa, I18n.t('Sistema.Body.Modelos.Programa.Errores.diferencial_minimo_tasa'))
    end

    if self.diferencial_maximo_tasa_mora.to_i < 0
      errors.add(:programa, I18n.t('Sistema.Body.Modelos.Programa.Errores.diferencial_maximo_mora'))
    end

    if self.diferencial_minimo_tasa_mora.to_i < 0
      errors.add(:programa, I18n.t('Sistema.Body.Modelos.Programa.Errores.diferencial_minimo_mora'))
    end

    unless self.diferencial_minimo_tasa_f.nil? && self.diferencial_maximo_tasa_f.nil?
      if self.diferencial_minimo_tasa_f > self.diferencial_maximo_tasa_f
        errors.add(:programa, I18n.t('Sistema.Body.Modelos.Programa.Errores.tasa_referencia_minima'))
      end
    end

    unless self.diferencial_minimo_tasa_mora_f.nil? && self.diferencial_maximo_tasa_mora_f.nil?
      if self.diferencial_minimo_tasa_mora_f > self.diferencial_maximo_tasa_mora_f
        errors.add(:programa, I18n.t('Sistema.Body.Modelos.Programa.Errores.tasa_mora_minima'))
      end
    end

    unless self.porcentaje_tasa_tapp.nil? && self.porcentaje_tasa_tapp.nil?
      if self.porcentaje_tasa_tapp.nil? ||  self.porcentaje_tasa_tapp < 0
        errors.add(:programa, I18n.t('Sistema.Body.Modelos.Programa.Errores.porcentaje_beneficiario_mayor_100'))
      end
    end

    tipo_credito = TipoCredito.find(2);
    if self.tipo_credito == tipo_credito
      parametro_general = ParametroGeneral.find(:first)
      if self.porcentaje_tasa_tapp < parametro_general.porcentaje_minimo_tapp
        errors.add(:programa, I18n.t('Sistema.Body.Modelos.Programa.Errores.porcentaje_tapp_menor'))
      end
      if self.porcentaje_tasa_tapp > parametro_general.porcentaje_maximo_tapp
        errors.add(:programa, I18n.t('Sistema.Body.Modelos.Programa.Errores.porcentaje_tapp_mayor'))
      end
    end

    unless self.porcentaje_riesgo_foncrei.nil? && self.porcentaje_riesgo_intermediario.nil?
      if self.porcentaje_riesgo_foncrei + self.porcentaje_riesgo_intermediario > 100
        errors.add(:programa, I18n.t('Sistema.Body.Modelos.Programa.Errores.porcentaje_riesgo_100'))
      end
    end

    unless self.porcentaje_tasa_foncrei.nil? && self.porcentaje_tasa_intermediario.nil?
      if self.porcentaje_tasa_foncrei + self.porcentaje_tasa_intermediario > 100
        errors.add(:programa, I18n.t('Sistema.Body.Modelos.Programa.Errores.porcentaje_tasa_mayor_100'))
      end
    end

    unless self.porcentaje_financiamiento.nil?
      if self.porcentaje_financiamiento > 100
        errors.add(:programa, "#{I18n.t('Sistema.Body.Modelos.Programa.Columnas.porcentaje_financiamiento')} #{I18n.t('errors.messages.greater_than')}")
      end
    end

  end

  def round_2_decimal(valor)
    valor = valor * 100
    valor = valor.to_i
    valor = valor/100.0
    valor
  end

  after_create :after_create
  
  def after_create

    tasa = self.tasa
    tasa_valor = TasaValor.find_by_tasa_id(tasa.id, :order=>"fecha_actualizacion desc");

    if tasa_valor
      tasa_intermediario = 0
      porcentaje_tapp = 0
      porcentaje_tapp = round_2_decimal(tasa_valor.valor*(self.porcentaje_tasa_tapp/100)) if tasa_valor.valor > 0

      if self.tipo_credito.id == 2
        tasa_foncrei = 0
        tasa_foncrei = round_2_decimal(porcentaje_tapp*(self.porcentaje_tasa_foncrei/100)) if tasa_valor.valor > 0
        tasa_intermediario = porcentaje_tapp-tasa_foncrei
      else
        tasa_foncrei = porcentaje_tapp
        tasa_intermediario = 0
      end
      tasa_cliente = tasa_foncrei+tasa_intermediario

      tasa_historico = TasaHistorico.new
      tasa_historico.programa_id=self.id
      tasa_historico.tasa_valor_id=tasa_valor.id
      tasa_historico.tasa_intermediario=tasa_intermediario
      tasa_historico.tasa_foncrei=tasa_foncrei
      tasa_historico.tasa_cliente=tasa_cliente
      tasa_historico.save
    else
      errors.add(:programa, I18n.t('Sistema.Body.Modelos.Programa.Errores.tasa_sin_valor'))
      return false
    end

  end

  def cuenta_presupuestaria

    self.partida_presupuestaria.cuenta_presupuestaria
  end

  before_save :before_save
  
  def before_save
    if self.porcentaje_riesgo_foncrei.nil?
      self.porcentaje_riesgo_foncrei = 0
    end
    if self.porcentaje_riesgo_intermediario.nil?
      self.porcentaje_riesgo_intermediario = 0
    end
    if self.porcentaje_tasa_foncrei.nil?
      self.porcentaje_tasa_foncrei = 0
    end
    if self.porcentaje_tasa_intermediario.nil?
      self.porcentaje_tasa_intermediario = 0
    end
    if self.porcentaje_financiamiento.nil?
      self.porcentaje_financiamiento = 0
    end

    if self.tasa_id.nil?
      self.tasa_id = 0
    end

    if self.tasa_mora_id.nil?
      self.tasa_mora_id = 0
    end

    if self.porcentaje_tasa_tapp.nil?
      self.porcentaje_tasa_tapp = 0
    end
    # if self.tipo_credito.id == 2 then
    #   self.intermediado = true
    # else
    #   self.intermediado = false
    # end
    if self.vinculo_tasa == 'R'
      self.tasa_id = 0
    end

  end

  def add_producto(producto)
    if Producto.find_by_programa_id_and_sector_id_and_sub_sector_id(id, producto.sector_id, producto.sub_sector_id);
      errors.add(:programa, I18n.t('Sistema.Body.Modelos.Programa.Errores.programa_tiene_sector_sub_sector'))
      return  false
    else
      productos << producto
    end
  end

  def add_modalidad_financiamiento(modalidad_financiamiento)
    if modalidades_financiamiento.find modalidad_financiamiento.id
      errors.add(:programa, I18n.t('Sistema.Body.Modelos.Programa.Errores.programa_tiene_modalidad_financiamiento'))
      return false
    end
  rescue
    modalidades_financiamiento << modalidad_financiamiento
  end

  def add_tipo_cliente(tipo_cliente)
    if tipos_cliente.find tipo_cliente.id
      errors.add(:programa, I18n.t('Sistema.Body.Modelos.Programa.Errores.programa_tiene_tipo_cliente'))
      return false
    end
  rescue
    tipos_cliente << tipo_cliente
  end

  def add_origen_fondo(origen_fondo)
    if origenes_fondo.find origen_fondo.id
      errors.add(:programa, I18n.t('Sistema.Body.Modelos.Programa.Errores.programa_tiene_origen_fondo'))
      return false
    end
  rescue
    origenes_fondo << origen_fondo
  end

  def add_recaudo(recaudo)
    if recaudos.find recaudo.id
      errors.add(:programa, I18n.t('Sistema.Body.Modelos.Programa.Errores.programa_tiene_recaudo'))
      return false
    end
  rescue
    recaudos << recaudo
  end

  def add_mision(mision)
    if misiones.find mision.id
      errors.add(:programa, I18n.t('Sistema.Body.Modelos.Programa.Errores.programa_tiene_mision'))
      return false
    end
  rescue
    misiones << mision
  end

  before_destroy :before_destroy
  
  def before_destroy()
    @solicitudes = Solicitud.find(:all, :conditions => ["programa_id = #{self.id}"])
    if @solicitudes.size > 0
      errors.add(:programa, I18n.t('Sistema.Body.Modelos.Programa.Errores.solicitudes_asociadas'))
      return false
    else
      @productos = Producto.find(:all, :conditions => ["programa_id = #{self.id}"])
      cantPrestamos = 0
      @productos.each do |producto|
        @prestamos = Prestamo.find(:all, :conditions => ["producto_id = #{producto[:id]}"])
        cantPrestamos = cantPrestamos + @prestamos.size
      end
      if cantPrestamos > 0
        errors.add(:programa, I18n.t('Sistema.Body.Modelos.Programa.Errores.prestamos_asociados'))
        return false
      end
    end
  end

  def descripcion_ultimo_desembolso_w

    case self.ultimo_desembolso

    when 0
      I18n.t('Sistema.Body.Modelos.Programa.Metodos.Mensajes.generacion_inmediata')
    when 1
      I18n.t('Sistema.Body.Modelos.Programa.Metodos.Mensajes.fecha_primer_desembolso')
    when 2
      I18n.t('Sistema.Body.Modelos.Programa.Metodos.Mensajes.fecha_ultimo_desemblso')
    when 3
      I18n.t('Sistema.Body.Modelos.Programa.Metodos.Mensajes.fin_desembolsos')

    end

  end

end


# == Schema Information
#
# Table name: programa
#
#  id                              :integer         not null, primary key
#  nombre                          :string(255)     not null
#  alias                           :string(255)     not null
#  descripcion                     :string(300)
#  porcentaje_financiamiento       :float
#  intermediado                    :boolean
#  porcentaje_riesgo_foncrei       :float
#  porcentaje_riesgo_intermediario :float
#  porcentaje_tasa_foncrei         :float
#  porcentaje_tasa_intermediario   :float
#  frecuencia_pago_intermediario   :integer(2)      default(1)
#  porcentaje_tasa_tapp            :float
#  activo                          :boolean         default(TRUE)
#  tipo_credito_id                 :integer         not null
#  tasa_id                         :integer         not null
#  diferencial_maximo_tasa         :float
#  diferencial_minimo_tasa         :float
#  tasa_mora_id                    :integer         not null
#  diferencial_maximo_tasa_mora    :float
#  diferencial_minimo_tasa_mora    :float
#  relacion_garantia               :float
#  solo_aprueba_directorio         :boolean         default(FALSE)
#  cogestion                       :boolean         default(FALSE)
#  codigo_d3                       :string(20)
#  codestpro_sigesp                :text
#  spg_cuenta_sigesp               :string(25)
#  fecha_cierre                    :date            default(Mon, 01 Jan 1900)
#  solo_aprueba_comite             :boolean         default(FALSE)
#  aprueba_comite_directorio       :boolean         default(FALSE)
#  monto_max_presidencia           :float
#  convenio                        :boolean
#  ultimo_desembolso               :integer         default(0)
#  tipo_diferimiento               :boolean         default(TRUE)
#  porcentaje_diferimiento         :decimal(5, 2)   default(0.0)
#  vinculo_tasa                    :string(1)       not null
#  financiamiento_integral         :boolean         default(FALSE), not null
#  tamano_credito                  :string(1)
#  partida_presupuestaria_id       :integer(8)
#  moneda_id                       :integer         default(0), not null
#


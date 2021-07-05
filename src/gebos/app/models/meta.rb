# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Meta
# descripción: Migración a Rails 3
#

class Meta < ActiveRecord::Base

  belongs_to :usuario
  
  validates_numericality_of :anio, :only_integer=>true,
    :message => " el número es inválido"
    
  validates_numericality_of :monto_liquidado,
    :message => " el número es inválido"
    
  validates_numericality_of :monto_liquidado_min,
    :message => " el número es inválido"
    
  validates_numericality_of :monto_liquidado_max,
    :message => " el número es inválido"
    
  validates_numericality_of :numero_solicitudes, :only_integer=>true,
    :message => " el número es inválido"
    
  validates_numericality_of :numero_solicitudes_min, :only_integer=>true,
    :message => " el número es inválido"
    
  validates_numericality_of :numero_solicitudes_max, :only_integer=>true,
    :message => " el número es inválido"
    
  validates_numericality_of :numero_empresas, :only_integer=>true,
    :message => " el número es inválido"
    
  validates_numericality_of :numero_empresas_min, :only_integer=>true,
    :message => " el número es inválido"
    
  validates_numericality_of :numero_empresas_max, :only_integer=>true,
    :message => " el número es inválido"
    
    
  def after_initialize
    
    self.anio = 0 unless self.anio
    self.monto_liquidado = 0 unless self.monto_liquidado
    self.monto_liquidado_min = 0 unless self.monto_liquidado_min
    self.monto_liquidado_max = 0 unless self.monto_liquidado_max
    self.numero_solicitudes = 0 unless self.numero_solicitudes
    self.numero_solicitudes_min = 0 unless self.numero_solicitudes_min
    self.numero_solicitudes_max = 0 unless self.numero_solicitudes_max
    self.numero_empresas = 0 unless self.numero_empresas
    self.numero_empresas_min = 0 unless self.numero_empresas_min
    self.numero_empresas_max = 0 unless self.numero_empresas_max
    
    
  end
  
  def save_all(tipo_agrupador, agrupadores)
  
    monto_liquidado_total = 0
    numero_solicitudes_total = 0
    numero_empresas_total = 0
    for agrupador in agrupadores
      monto_liquidado_total += agrupador[1][:monto_liquidado].to_f
      numero_solicitudes_total += agrupador[1][:numero_solicitudes].to_f
      numero_empresas_total += agrupador[1][:numero_empresas].to_f
    end
    
    if monto_liquidado_total > self.monto_liquidado
      self.errors.add 'Monto Liquidado',
        'La suma de los montos liquidados no puede exceder a la meta general'
    end
    
    if numero_solicitudes_total > self.numero_solicitudes
      self.errors.add 'Número Solicitudes',
        'La suma de los números de solicitudes no puede exceder a la meta general'
    end
    
    if numero_empresas_total > self.numero_empresas
      self.errors.add 'Número Empresas',
        'La suma de los números de empresas no puede exceder a la meta general'
    end
    
    unless self.errors.empty?
      return
    end
  
    case tipo_agrupador
      when 'P'
        actualizacion = Proc.new { |id, agrupador| _agrupador = MetaPrograma.find_by_id(id); _agrupador.update_attributes(agrupador) }
      when 'R'
        actualizacion = Proc.new { |id, agrupador| _agrupador = MetaRegion.find_by_id(id); _agrupador.update_attributes(agrupador) }
      when 'C'
        actualizacion = Proc.new { |id, agrupador| _agrupador = MetaTipoCredito.find_by_id(id); _agrupador.update_attributes(agrupador) }
      when 'I'
        actualizacion = Proc.new { |id, agrupador| _agrupador = MetaSectorIndustrial.find_by_id(id); _agrupador.update_attributes(agrupador) }
    end
    for agrupador in agrupadores
      actualizacion.call agrupador[0], agrupador[1]
    end
    
    return true
  end
  
  def self.anio_list
    list = []
    for anio in 2000..2040
      list.<< [anio.to_s, anio]
    end
    list
  end
  
  def self.mes_list
    [
      ['Enero', 1],
      ['Febrero', 2],
      ['Marzo', 3],
      ['Abril', 4],
      ['Mayo', 5],
      ['Junio', 6],
      ['Julio', 7],
      ['Agosto', 8],
      ['Septiembre', 9],
      ['Octubre', 10],
      ['Noviembre', 11],
      ['Diciembre', 12]
    ]
  end
  
  def self.agrupador_list
    [
      ['Seleccione...', ''],
      ['Programa', 'P'],
      ['Region', 'R'],    
      ['Tipo de Crédito', 'C'],
      ['Sector Industrial', 'I']
    ]
  end
  
  #nuevo agrupador para no tener conflictos con el modulo de metas, esto solo se va a usar para edad en mora e indicador_cartera
  def self.agrupador2_list
    [
      ['Seleccione...', ''],
      ['Región', 'RG'],
      ['Estado', 'E'],
      ['Sector', 'S'],    
      ['Sub Sector', 'SS'],
      ['Rubro', 'R'],    
      ['Sub Rubro', 'SR'],    
      ['Actividad', 'A']
    ]
  end





  def buscar_agrupadores(agrupador)
  
    valores = {:usuario_id=>self.usuario_id, :meta_id=>self.id, :fecha_actualizacion=>Date.today }
    agrupadores = []
    case agrupador
      when 'P'
        agrupadores = Programa.find(:all, :order=>'nombre', :conditions=>"activo=true")
        creacion = Proc.new { |id, meta_id| MetaPrograma.find_by_programa_id_and_meta_id(id, meta_id) ? MetaPrograma.find_by_programa_id_and_meta_id(id, meta_id) : MetaPrograma.create( valores.merge({:programa_id=>id}) ) }
      when 'R'
        agrupadores = Region.find(:all, :order=>'nombre')
        creacion = Proc.new { |id, meta_id| MetaRegion.find_by_region_id_and_meta_id(id, meta_id) ? MetaRegion.find_by_region_id_and_meta_id(id, meta_id) : MetaRegion.create( valores.merge({:region_id=>id}) ) }
      when 'C'
        agrupadores = TipoCredito.find(:all, :order=>'nombre')
        creacion = Proc.new { |id, meta_id| MetaTipoCredito.find_by_tipo_credito_id_and_meta_id(id, meta_id) ? MetaTipoCredito.find_by_tipo_credito_id_and_meta_id(id, meta_id) : MetaTipoCredito.create( valores.merge({:tipo_credito_id=>id}) ) }
      when 'I'
        agrupadores = SectorIndustrial.find(:all, :order=>'nombre')
        creacion = Proc.new { |id, meta_id| MetaSectorIndustrial.find_by_sector_industrial_id_and_meta_id(id, meta_id) ? MetaSectorIndustrial.find_by_sector_industrial_id_and_meta_id(id, meta_id) : MetaSectorIndustrial.create( valores.merge({:sector_industrial_id=>id}) ) }
    end
    
    _agrupadores = []
    for _agrupador in agrupadores
      _agrupadores.<< creacion.call(_agrupador.id, self.id)
    end
    
    return _agrupadores
    
  end
    
  def monto_liquidado_fm
    unless @monto_liquidado.nil?
      valor = sprintf('%01.2f', @monto_liquidado).sub('.', ',')
      valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
    end
  end
  
  def monto_liquidado_fm=(valor)
    @monto_liquidado = valor.sub(',', '.')
  end
  
  def monto_liquidado_min_fm
    unless @monto_liquidado_min.nil?
      valor = sprintf('%01.2f', @monto_liquidado_min).sub('.', ',')
      valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
    end
  end
  
  def monto_liquidado_min_fm=(valor)
    @monto_liquidado_min = valor.sub(',', '.')
  end

  def monto_liquidado_max_fm
    unless @monto_liquidado_max.nil?
      valor = sprintf('%01.2f', @monto_liquidado_max).sub('.', ',')
      valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
    end
  end
  
  def monto_liquidado_max_fm=(valor)
    @monto_liquidado_max = valor.sub(',', '.')
  end

end


# == Schema Information
#
# Table name: meta
#
#  id                     :integer         not null, primary key
#  fecha_actualizacion    :date            not null
#  anio                   :integer         not null
#  usuario_id             :integer         not null
#  monto_liquidado        :float
#  numero_solicitudes     :integer
#  numero_empresas        :integer
#  monto_liquidado_min    :float
#  monto_liquidado_max    :float
#  numero_solicitudes_min :integer
#  numero_solicitudes_max :integer
#  numero_empresas_min    :integer
#  numero_empresas_max    :integer
#


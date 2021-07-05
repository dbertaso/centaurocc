# encoding: utf-8
#
# autor: Luis Rojas
# clase: EmpresaDireccion
# descripción: Migración a Rails 3
#
class EmpresaDireccion < ActiveRecord::Base
  
  self.table_name = 'empresa_direccion'
  
  attr_accessible :id, :empresa_id, :ciudad_id, :municipio_id, :parroquia_id, :avenida,
    :edificio, :zona, :referencia, :codigo_postal, :tipo, :correspondencia, :activo, 
    :piso, :numero, :ubicacion_geografica, :tenencia, :tipo_inmueble, :espacio_aproximado_m2,
    :alquiler_mensual, :region_id, :eje_id, :unidad_negocio, :estado_id, :espacio_aproximado_m2_f

  belongs_to :empresa
  belongs_to :ciudad
  belongs_to :municipio
  belongs_to :parroquia

  has_many :telefonos, :dependent => :destroy, :class_name=>'EmpresaTelefono'

  validates :tipo, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.tipo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  validates :municipio_id, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.municipio')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  validates :ciudad_id, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.ciudad')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  validates :parroquia_id, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.parroquia')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :avenida, :length => { :in => 3..100, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.avenida_calle_callejon')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.avenida_calle_callejon')}  #{I18n.t('errors.messages.too_long.other')}"}

  validates :edificio, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.casa_edificio_otro')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 3..100, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.casa_edificio_otro')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.casa_edificio_otro')}  #{I18n.t('errors.messages.too_long.other')}"}

  validates :zona, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.urbanizacion_barrio_sector')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 3..100, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.urbanizacion_barrio_sector')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.urbanizacion_barrio_sector')}  #{I18n.t('errors.messages.too_long.other')}"}
  
  validates :referencia, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.punto')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.referencia')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 3..100, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.punto')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.referencia')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.punto')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.referencia')}  #{I18n.t('errors.messages.too_long.other')}"}
  
  validates :codigo_postal, :length => { :in => 1..8, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.codigo')} #{I18n.t('Sistema.Body.Vistas.General.postal')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.codigo')} #{I18n.t('Sistema.Body.Vistas.General.postal')}  #{I18n.t('errors.messages.too_long.other')}"}, 
    :numericality =>{:numericality => true, :only_integer => true, :allow_blank => true, :message => "#{I18n.t('Sistema.Body.Vistas.General.codigo')} #{I18n.t('Sistema.Body.Vistas.General.postal')} #{I18n.t('errors.messages.not_an_integer_decimal')}"}

  validates :alquiler_mensual, :numericality => {:numericality => true, :allow_blank => true, :message => "#{I18n.t('Sistema.Body.Vistas.General.alquiler')} #{I18n.t('Sistema.Body.General.mensual')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}"}

  validates :espacio_aproximado_m2, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.espacio')} #{I18n.t('Sistema.Body.Vistas.General.aprox')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :numericality => {:numericality => true, :allow_blank => true, :message => "#{I18n.t('Sistema.Body.Vistas.General.espacio')} #{I18n.t('Sistema.Body.Vistas.General.aprox')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}"}
  
  validates :tipo_inmueble, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.espacio')} #{I18n.t('Sistema.Body.Vistas.General.fisico')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :tipo_inmueble, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.tenencia')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :piso, :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio_numero')}/, 
    :message => "#{I18n.t('Sistema.Body.Vistas.General.piso')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}", :allow_blank => true}
  
  validates :numero, :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio_numero')}/, 
    :message => "#{I18n.t('Sistema.Body.Vistas.General.numero_apto_casa')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}", :allow_blank => true}
  
  validate :validate

  def validate
    if self.tenencia == 'A'
      if self.alquiler_mensual.nil?
        errors.add(nil, "#{I18n.t('Sistema.Body.Vistas.General.alquiler')} #{I18n.t('Sistema.Body.General.mensual')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
      elsif self.alquiler_mensual < 1
        errors.add(nil,"#{I18n.t('Sistema.Body.Vistas.General.alquiler')} #{I18n.t('Sistema.Body.General.mensual')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_mayor_cero')}")
      end
    end
  end
  
  def self.search(search, page, orden)    
    paginate :per_page=>@records_by_page, :page=>page, :conditions=>search, :order=>orden, :include=>[:ciudad]
  end

  after_initialize :actualizar_tipo
  
  def actualizar_tipo
    self.tipo = 'P' unless self.tipo
  end

  def tipo_nombre
    case self.tipo
      when 'P'
        "#{I18n.t('Sistema.Body.Vistas.General.sede')} #{I18n.t('Sistema.Body.Vistas.General.principal')}"
      when 'S'
        I18n.t('Sistema.Body.Vistas.General.sucursal')
      when 'L'
        I18n.t('Sistema.Body.Vistas.General.planta')
      when 'D'
        I18n.t('Sistema.Body.Vistas.Form.deposito')
      when 'O'
        I18n.t('Sistema.Body.Vistas.General.otra')
    end
  end

  def estado_id
    ciudad.estado_id unless ciudad.nil?
  end

  def estado_id=(estado_id)
  end

  def espacio_aproximado_m2_f=(valor)
    self.espacio_aproximado_m2 = valor.sub(',', '.')
  end

  def espacio_aproximado_m2_f
    sprintf('%01.2f', self.espacio_aproximado_m2).sub('.', ',') unless self.espacio_aproximado_m2.nil?
  end

  def after_save
    if self.correspondencia && self.activo
      EmpresaDireccion.update_all("correspondencia = false", "empresa_id = #{self.empresa_id} and id <> #{self.id}")
    end

  end

  def to_s
    str = ""
    str << "#{I18n.t('Sistema.Body.Vistas.General.avenida')}: " << self.avenida << ',' unless self.avenida.nil?
    str << "#{I18n.t('Sistema.Body.Vistas.General.casa_edificio_otro')}: " << self.edificio << ',' unless self.edificio.nil?
    str << "#{I18n.t('Sistema.Body.Vistas.General.piso')}: " << self.piso << ',' unless self.piso.nil?
    str << "#{I18n.t('Sistema.Body.Vistas.General.numero')}: " << self.numero << ',' unless self.numero.nil?
    str << "#{I18n.t('Sistema.Body.Vistas.General.parroquia')}: " << self.parroquia.nombre << ',' unless self.parroquia_id.nil?
    str << "#{I18n.t('Sistema.Body.Vistas.General.municipio')}: " << self.municipio.nombre << ',' unless self.municipio_id.nil?
    str << "#{I18n.t('Sistema.Body.Vistas.General.ciudad')}: " << self.ciudad.nombre << ', ' unless self.ciudad_id.nil?
    str << "#{I18n.t('Sistema.Body.Vistas.General.estado')}: " << self.ciudad.estado.nombre << ',' unless self.ciudad_id.nil?
    return str
  end

  def self.direccion(empresa_id)
    direccion = EmpresaDireccion.find(:first, :conditions=>["activo = true and empresa_id = ?", empresa_id], :order=> 'id' )
    str = ""
    str << "#{I18n.t('Sistema.Body.Vistas.General.avenida')}: " << direccion.avenida << ', ' unless direccion.avenida.nil? || direccion.avenida.empty?
    str << "#{I18n.t('Sistema.Body.Vistas.General.casa_edificio_otro')}: " << direccion.edificio << ', ' unless direccion.edificio.nil? || direccion.edificio.empty?
    str << "#{I18n.t('Sistema.Body.Vistas.General.piso')}: " << direccion.piso << ', ' unless direccion.piso.nil? || direccion.piso.to_s.empty?
    str << "#{I18n.t('Sistema.Body.Vistas.General.numero')}: " << direccion.numero << ', ' unless direccion.numero.nil? || direccion.numero.empty?
    return str[0, str.length - 2] << "."
  end

end


# == Schema Information
#
# Table name: empresa_direccion
#
#  id                    :integer         not null, primary key
#  empresa_id            :integer         not null
#  ciudad_id             :integer
#  municipio_id          :integer
#  parroquia_id          :integer
#  avenida               :string(300)     not null
#  edificio              :string(300)     not null
#  zona                  :string(300)     not null
#  referencia            :string(300)
#  codigo_postal         :string(8)       not null
#  tipo                  :string(1)       not null
#  correspondencia       :boolean
#  activo                :boolean         default(TRUE)
#  piso                  :string(3)
#  numero                :string(10)
#  ubicacion_geografica  :string(1)
#  tenencia              :string(1)
#  tipo_inmueble         :string(1)
#  espacio_aproximado_m2 :float
#  alquiler_mensual      :decimal(16, 2)
#  region_id             :integer
#  eje_id                :integer
#  unidad_negocio        :boolean
#


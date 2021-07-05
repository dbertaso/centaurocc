# encoding: utf-8

#
# autor: Luis Rojas
# clase: PersonaDireccion
# descripción: Migración a Rails 3
#

class PersonaDireccion < ActiveRecord::Base

  self.table_name = 'persona_direccion'
  
  attr_accessible :id, :persona_id, :ciudad_id, :municipio_id, :parroquia_id, :avenida,
				  :edificio, :zona, :referencia, :codigo_postal, :tipo, :correspondencia,
				  :activo, :tipo_vivienda, :piso, :numero, :localidad, :tenencia, 
          :ubicacion_geografica, :tipo_comunidad, :unidad_negocio, :region_id,
				  :comunidad_indigena_id, :estado_id

  has_many :telefonos, :dependent => :destroy, :class_name => 'PersonaTelefono'

  belongs_to :persona
  belongs_to :ciudad
  belongs_to :municipio
  belongs_to :parroquia

  validates :ciudad_id, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.ciudad')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  validates :municipio_id, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.municipio')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  validates :tipo, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.tipo')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.vivienda')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  validates :parroquia_id, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.parroquia')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  validates :edificio, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.casa_edificio_otro')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
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
  
  validates :referencia, :length => { :in => 3..100, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.referencia')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.referencia')}  #{I18n.t('errors.messages.too_long.other')}"}
  
  validates :codigo_postal, 
    :numericality =>{:numericality => true, :only_integer => true, :allow_blank => true, :message => "#{I18n.t('Sistema.Body.Vistas.General.codigo')} #{I18n.t('Sistema.Body.Vistas.General.postal')} #{I18n.t('errors.messages.not_an_integer_decimal')}"}
  
  validates :piso, :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio_numero')}/, 
    :message => "#{I18n.t('Sistema.Body.Vistas.General.piso')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}", :allow_blank => true}
  
  validates :numero, :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio_numero')}/, 
    :message => "#{I18n.t('Sistema.Body.Vistas.General.numero_apto_casa')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}", :allow_blank => true}
  
  validate :validate
  
  def validate
    if self.estado_id.blank?
      errors.add(:persona_direccion, "#{I18n.t('Sistema.Body.Vistas.General.estado')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
    end
  end

  def tipo_nombre
    case self.tipo
    when 'H'
      I18n.t('Sistema.Body.Vistas.General.vivienda')
    when 'O'
      I18n.t('Sistema.Body.Vistas.General.oficina')
    when 'T'
      I18n.t('Sistema.Body.Vistas.General.otra')
    when 'C'
      I18n.t('Sistema.Body.Vistas.General.casa')
    when 'R'
      "#{I18n.t('Sistema.Body.Vistas.General.vivienda')} #{I18n.t('Sistema.Body.Vistas.General.rustica')}"
    when 'A'
      I18n.t('Sistema.Body.Vistas.General.apartamento')
    when 'I'
      "#{I18n.t('Sistema.Body.Vistas.General.vivienda')} #{I18n.t('Sistema.Body.Vistas.General.indigena')}"
    when 'L'
      I18n.t('Sistema.Body.Vistas.General.local')
    end
  end

  def ubicacion_geografica_w
    case self.ubicacion_geografica
      when 'R'
        I18n.t('Sistema.Body.Vistas.General.rural')
      when 'U'
        I18n.t('Sistema.Body.Vistas.General.urbana')
    end
  end

  def tipo_comunidad_w
    case self.tipo_comunidad
      when 'I'
        I18n.t('Sistema.Body.Vistas.General.indigena')
      when 'A'
        I18n.t('Sistema.Body.Vistas.General.afrodescendiente')
      when 'O'
        I18n.t('Sistema.Body.Vistas.General.otro')
    end
  end

  def estado_id
    self.ciudad.estado_id unless self.ciudad_id.nil?
  end
  
  def estado_id=(estado_id)
  end

  def after_save
    if self.correspondencia && self.activo
      PersonaDireccion.update_all("correspondencia = false", "persona_id = #{self.persona_id} and id <> #{self.id}")
    end
  end

  def to_s
    str = ""
    str << "#{I18n.t('Sistema.Body.Vistas.General.avenida')}: " << self.avenida << ', ' unless self.avenida.nil?
    str << "#{I18n.t('Sistema.Body.Vistas.General.edificio_torre')}: " << self.edificio << ', ' unless self.edificio.nil?
    str << "#{I18n.t('Sistema.Body.Vistas.General.piso')}: " << self.piso << ', ' unless self.piso.nil?
    str << "#{I18n.t('Sistema.Body.Vistas.General.numero')}: " << self.numero << ', ' unless self.numero.nil?
    str << "#{I18n.t('Sistema.Body.Vistas.General.parroquia')} " << self.parroquia.nombre << ', ' unless self.parroquia_id.nil?
    str << "#{I18n.t('Sistema.Body.Vistas.General.municipio')} " << self.municipio.nombre << ', ' unless self.municipio_id.nil?
    str  << self.ciudad.nombre << ', ' unless self.ciudad_id.nil?
    str << "#{I18n.t('Sistema.Body.Vistas.General.estado')}: " << self.ciudad.estado.nombre  unless self.ciudad_id.nil?
    return str
  end

  def self.direccion(persona_id)
    direccion = PersonaDireccion.find(:first, :conditions=>["activo = true and persona_id = ?", persona_id], :order=> 'id' )
    str = ""
    str << "#{I18n.t('Sistema.Body.Vistas.General.avenida')}: " << direccion.avenida << ', ' unless direccion.avenida.nil? || direccion.avenida.empty?
    str << "#{I18n.t('Sistema.Body.Vistas.General.edificio_torre')}: " << direccion.edificio << ', ' unless direccion.edificio.nil? || direccion.edificio.empty?
    str << "#{I18n.t('Sistema.Body.Vistas.General.piso')}: " << direccion.piso << ', ' unless direccion.piso.nil? || direccion.piso.to_s.empty?
    str << "#{I18n.t('Sistema.Body.Vistas.General.numero')}: " << direccion.numero << ', ' unless direccion.numero.nil? || direccion.numero.empty?
    return str[0, str.length - 2] << "."
  end

  def self.search(search, page, orden)    
    conditions=search    
    paginate :per_page=>@records_by_page, :page=>page, :conditions=>conditions, :order=>orden,:include=>[:ciudad]
  end

end



# == Schema Information
#
# Table name: persona_direccion
#
#  id                    :integer         not null, primary key
#  persona_id            :integer         not null
#  ciudad_id             :integer
#  municipio_id          :integer
#  parroquia_id          :integer
#  avenida               :string(300)     not null
#  edificio              :string(300)     not null
#  zona                  :string(300)     not null
#  referencia            :string(300)
#  codigo_postal         :string(8)
#  tipo                  :string(1)       not null
#  correspondencia       :boolean         default(FALSE)
#  activo                :boolean         default(TRUE)
#  tipo_vivienda         :string(1)
#  piso                  :string(3)
#  numero                :string(10)
#  localidad             :string(1)
#  tenencia              :string(1)
#  ubicacion_geografica  :string(1)
#  tipo_comunidad        :string(1)
#  unidad_negocio        :boolean
#  region_id             :integer
#  comunidad_indigena_id :integer
#


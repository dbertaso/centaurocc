# encoding: utf-8
#
# autor: Luis Rojas
# clase: Persona
# descripción: Migración a Rails 3
#

class Persona < ActiveRecord::Base
  
  self.table_name = 'persona'
  
  attr_accessible :id, :cedula,:primer_nombre,:segundo_nombre,:primer_apellido,
    :segundo_apellido,:sexo,:estado_civil,:fecha_nacimiento,:venezolano,
    :profesion_id,:ocupacion,:rif_personal,:cedula_nacionalidad,:nacionalidad_id,
    :grupo,:pais,:lugar_nacimiento,:tiempo_profesion,:unidad_tiempo_profesion,
    :cantidad_total_hijos,:cantidad_hijos,:cantidad_hijas,:grado_instruccion_primaria,
    :grado_instruccion_secundaria,:grado_instruccion_medio,:grado_instruccion_universitario,
    :grado_instruccion_superior,:grado_instruccion_robinson1,:grado_instruccion_robinson2,
    :grado_instruccion_robinson3,:grado_instruccion_ribas,:grado_instruccion_sucre,
    :conyuge_cedula_nacionalidad,:conyuge_cedula,:conyuge_nombre_apellido,
    :conyuge_lugar_nacimiento,:conyuge_nacionalidad,:conyuge_profesion,
    :conyuge_oficio,:conyuge_trabaja,:conyuge_direccion_trabajo,:conyuge_telefono,
    :discapacidad,:discapacidad_detalle,:sector_economico_id,:actividad_economica_id,
    :rama_actividad_economica_id,:codigo_d3,:conyuge_celular,:prestamo_id,:pasaporte,
    :tipo_dependencia_laboral,:monto_salario, :monto_salario_f,:otros_ingresos,:conyuge_empresa,:pais_id,
    :nombre_organizacion,:grado_instruccion, :fecha_nacimiento_f, 
    :foto_confirmacion, :huella_confirmacion, :conyuge_cedula_f
  
  
  has_one :cliente_persona
  belongs_to :profesion
  belongs_to :pais
  belongs_to :nacionalidad
  belongs_to :sector_economico
  belongs_to :actividad_economica
  has_many :datos_socio_economico
  has_many :datos_formacion
  has_many :punto_contacto
  has_many :grupo_familiar
  has_many :grupo_integrante
  has_many :persona_email
  has_one :empresa_integrante, :class_name=>'EmpresaIntegrante'
  has_many :direcciones, :class_name=>'PersonaDireccion'
  has_many :telefonos, :class_name=>'PersonaTelefono'
  
  validates :cedula, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.nro')} #{I18n.t('Sistema.Body.Vistas.General.cedula')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :numericality => {:numericality => true, :message => "#{I18n.t('Sistema.Body.Vistas.General.nro')} #{I18n.t('Sistema.Body.Vistas.General.cedula')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}"},
    :uniqueness =>{:uniqueness => true, :message => "#{I18n.t('Sistema.Body.Vistas.General.nro')} #{I18n.t('Sistema.Body.Vistas.General.cedula')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_registrado')}"}
  
  validates :primer_nombre, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.primer_nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 3..20, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.primer_nombre')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.primer_nombre')}  #{I18n.t('errors.messages.too_long.other')}"},
    :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio')}/, :allow_blank => true,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.primer_nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}"}
    
  validates :primer_apellido, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.primer_apellido')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 3..20, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.primer_apellido')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.primer_apellido')}  #{I18n.t('errors.messages.too_long.other')}"},
    :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio')}/, :allow_blank => true, 
    :message => "#{I18n.t('Sistema.Body.Vistas.General.primer_apellido')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}"}

  validates :nacionalidad_id, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.nacionalidad')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :estado_civil, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.estado_civil')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :pais_id, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.pais')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :segundo_nombre, :length => { :in => 3..20, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.segundo_nombre')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.segundo_nombre')}  #{I18n.t('errors.messages.too_long.other')}"},
    :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio')}/, :allow_blank => true,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.segundo_nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}"}
  
  validates :segundo_apellido, :length => { :in => 3..20, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.segundo_apellido')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.segundo_apellido')}  #{I18n.t('errors.messages.too_long.other')}"},
    :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio')}/, :allow_blank => true,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.segundo_apellido')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}"}

  #  validates_numericality_of :cedula, :only_integer => true, :allow_blank => true,
  #    :message => "#{I18n.t('Sistema.Body.Vistas.General.cedula')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}",
  #    :if => :codigo_d3.nil?
  
  #  validates_numericality_of :conyuge_cedula, :only_integer => true, :allow_blank => true,
  #    :message => "#{I18n.t('Sistema.Body.Vistas.General.cedula')} #{I18n.t('Sistema.Body.Vistas.General.conyuge')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}",
  #    :if => :codigo_d3.nil?
  
  #  validates_numericality_of :cantidad_total_hijos, :only_integer => true, :allow_blank => true,
  #    :message => "#{I18n.t('Sistema.Body.Vistas.General.numero_hijos')} #{I18n.t('Sistema.Body.Vistas.General.conyuge')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}",
  #    :if => :codigo_d3.nil?
      
  #  validates_length_of :segundo_nombre, :within => 3..20, :allow_blank => true
  #  
  #  validates_length_of :segundo_apellido, :within => 3..20, :allow_blank => true,
  #    :if => :codigo_d3.nil?
  #
  #  validates_length_of :ocupacion, :within => 3..40, :allow_blank => true,
  #    :if => :codigo_d3:if .nil?
  
  validates :ocupacion, :length => { :in => 3..40, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.ocupacion')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.ocupacion')}  #{I18n.t('errors.messages.too_long.other')}"},
    :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio')}/, :allow_blank => true,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.ocupacion')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}"}

  validates :fecha_nacimiento, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.fecha_nacimiento')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :date => {:message => I18n.t('Sistema.Body.Modelos.Errores.fecha_invalida'), :allow_blank => true,
    :before => Proc.new { 0.day.from_now.to_date }, :message => "#{I18n.t('Sistema.Body.Vistas.General.fecha_nacimiento')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_ser_posterior_fecha_actual')}"}
  
  def self.search(search, page, sort)    
    paginate :per_page => @records_by_page, :page => page, :conditions => search, :order => sort
  end
  
  validate :validate
    
  def validate    
    #    unless self.tiempo_profesion.nil?
    #      unless self.unidad_tiempo_profesion.length > 0
    #        errors.add(:id, "Unidad del Tiempo de Profesión u Oficio es requerido")
    #      end
    #    else
    #      self.unidad_tiempo_profesion = ''
    #    end
    
    unless self.fecha_nacimiento.nil?
      edad = self.edad(Time.now, self.fecha_nacimiento)
      unless edad > 17
        errors.add(:id, "#{I18n.t('Sistema.Body.Modelos.Errores.el_beneficiario')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_mayor_edad')}")
      end
    end
    if self.estado_civil == "C" || self.estado_civil == "O"
      unless self.conyuge_telefono.nil? || self.conyuge_telefono.to_s.empty?
        if self.conyuge_telefono.to_s.sub('0','').length > self.conyuge_telefono.to_s.sub('0','').to_i.to_s.length
          errors.add(:id, "#{I18n.t('Sistema.Body.Vistas.General.nro')} #{I18n.t('Sistema.Body.Vistas.General.telefono')} #{I18n.t('Sistema.Body.Vistas.General.del')} #{I18n.t('Sistema.Body.Vistas.General.conyuge')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}")
        end
      else
        errors.add(:id, "#{I18n.t('Sistema.Body.Vistas.General.nro')} #{I18n.t('Sistema.Body.Vistas.General.telefono')} #{I18n.t('Sistema.Body.Vistas.General.del')} #{I18n.t('Sistema.Body.Vistas.General.conyuge')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
      end
      unless self.conyuge_celular.nil? || self.conyuge_celular.empty?
        if self.conyuge_celular.to_s.sub('0','').length > self.conyuge_celular.sub('0','').to_i.to_s.length
          errors.add(:id, "#{I18n.t('Sistema.Body.Vistas.General.nro')} #{I18n.t('Sistema.Body.Vistas.General.celular')} #{I18n.t('Sistema.Body.Vistas.General.del')} #{I18n.t('Sistema.Body.Vistas.General.conyuge')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}")
        end
      end
      unless self.conyuge_nombre_apellido.nil? || self.conyuge_nombre_apellido.empty?
        a = self.conyuge_nombre_apellido[/#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio')}/]
        if a.nil?
          errors.add(:id, "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Vistas.General.y')} #{I18n.t('Sistema.Body.Vistas.General.apellido')} #{I18n.t('Sistema.Body.Vistas.General.del')} #{I18n.t('Sistema.Body.Vistas.General.conyuge')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}")
        end
      else
        errors.add(:id, "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Vistas.General.y')} #{I18n.t('Sistema.Body.Vistas.General.apellido')} #{I18n.t('Sistema.Body.Vistas.General.del')} #{I18n.t('Sistema.Body.Vistas.General.conyuge')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
      end
      unless self.conyuge_cedula.to_i > 0
        errors.add(:id, "#{I18n.t('Sistema.Body.Vistas.General.nro')} #{I18n.t('Sistema.Body.Vistas.General.cedula')} #{I18n.t('Sistema.Body.Vistas.General.del')} #{I18n.t('Sistema.Body.Vistas.General.conyuge')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
      end
    end
  end
      
  def before_save
    self.primer_nombre = mayuscula(self.primer_nombre)
    self.segundo_nombre = mayuscula(self.segundo_nombre)
    self.primer_apellido = mayuscula(self.primer_apellido)
    self.segundo_apellido = mayuscula(self.segundo_apellido)
    self.lugar_nacimiento = mayuscula(self.lugar_nacimiento)
    self.pais = mayuscula(self.pais)
    self.ocupacion = mayuscula(self.ocupacion)
    self.conyuge_nombre_apellido = mayuscula(self.conyuge_nombre_apellido)
    self.conyuge_lugar_nacimiento = mayuscula(self.conyuge_lugar_nacimiento)
    self.conyuge_nacionalidad = mayuscula(self.conyuge_nacionalidad)
    self.conyuge_empresa = mayuscula(self.conyuge_empresa)
    self.conyuge_profesion = mayuscula(self.conyuge_profesion)
    self.conyuge_direccion_trabajo = mayuscula(self.conyuge_direccion_trabajo)
  end

  def edad(fecha_actual, fecha_nacimiento)
    anno_nacimiento = fecha_nacimiento.year
    anno_actual = fecha_actual.year
    edad = 0
    if fecha_actual.month > fecha_nacimiento.month
      edad = (anno_actual - anno_nacimiento)
    elsif fecha_actual.month == fecha_nacimiento.month
      if fecha_actual.day >= fecha_nacimiento.day
        edad = anno_actual - anno_nacimiento
      else
        edad = (anno_actual - anno_nacimiento) - 1
      end
    else
      edad = (anno_actual - anno_nacimiento) - 1
    end
    return edad
  end

  def mayuscula(texto)
    unless texto.nil?
      texto  = texto.gsub('á', 'Á')
      texto  = texto.gsub('é', 'É')
      texto  = texto.gsub('í', 'Í')
      texto  = texto.gsub('ó', 'Ó')
      texto  = texto.gsub('ú', 'Ú')
      texto  = texto.upcase
      texto.strip!
    end
    return texto
  end
    
  def sexo_w    
    case self.sexo
    when true
      I18n.t('Sistema.Body.Vistas.General.masculino')
    when false
      I18n.t('Sistema.Body.Vistas.General.femenino')
    end
  end
  
  def venezolano_w    
    nacionalidad = Nacionalidad.find(self.nacionalidad_id)
    case self.sexo
    when true
      nacionalidad.masculino
    when false
      nacionalidad.femenino
    end
  end
  
  def estado_civil_w    
    case self.sexo
    when true
      case self.estado_civil
      when 'S'
        I18n.t('Sistema.Body.Vistas.General.soltero')
      when 'C'
        I18n.t('Sistema.Body.Vistas.General.casado')
      when 'V'
        I18n.t('Sistema.Body.Vistas.General.viudo')
      when 'D'
        I18n.t('Sistema.Body.Vistas.General.divorciado')      
      when 'O'
        I18n.t('Sistema.Body.Vistas.General.concubino')
      when 'U'
        I18n.t('Sistema.Body.Vistas.General.unido')
      end

    when false
      case self.estado_civil
      when 'S'
        I18n.t('Sistema.Body.Vistas.General.soltera')
      when 'C'
        I18n.t('Sistema.Body.Vistas.General.casada')
      when 'V'
        I18n.t('Sistema.Body.Vistas.General.viuda')
      when 'D'
        I18n.t('Sistema.Body.Vistas.General.divorciada')      
      when 'O'
        I18n.t('Sistema.Body.Vistas.General.concubina')
      when 'U'
        I18n.t('Sistema.Body.Vistas.General.unida')
      end
    end
  end
  
  def conyuge_cedula_f=(conyuge_cedula)
    self.conyuge_cedula = conyuge_cedula.to_i
  end
  
  def conyuge_cedula_f
    self.conyuge_cedula unless self.conyuge_cedula.nil?
  end
      
  def fecha_nacimiento_f=(fecha)
    self.fecha_nacimiento = fecha
  end
  
  def fecha_nacimiento_f
    format_fecha(self.fecha_nacimiento)
  end

  def monto_salario_f=(valor)
    self.monto_salario = valor.sub(',', '.')
  end

  def monto_salario_f
    format_fm(self.monto_salario)
  end

  def otros_ingresos_f=(valor)
    self.otros_ingresos = valor.sub(',', '.')
  end

  def otros_ingresos_f
    format_fm(self.otros_ingresos)
  end
    
  def after_initialize
    self.estado_civil = 'S' unless self.estado_civil
  end

  def nombre_corto
    self.primer_nombre.to_s + ' ' + self.primer_apellido.to_s
  end

  def nombre_completo
    self.primer_apellido.to_s + ' ' + self.segundo_apellido.to_s + ' ' + self.primer_nombre.to_s + ' ' + self.segundo_nombre.to_s
  end
     
  def update_all(params_persona, params_cliente_persona)
    transaction do
      self.update_attributes(params_persona)
      self.cliente_persona.update_attributes(params_cliente_persona)
      if self.errors.count > 0 || self.cliente_persona.errors.count > 0
        raise ActiveRecord::Rollback
      else
        return true
      end
    end
  end
     
  def add_direccion(persona_direccion)     
    direcciones<<persona_direccion
  end
  #hacer que el integrante natural de una empresa sea un cliente para fondas
  #en 19/02/2014 se decidió eliminar la condión de que cada integrante de la empresa sea cliente en gebos. Paul Feo y Luis Rojas
  def save_new(tipo_cliente_id)
    transaction do
      self.save
      if tipo_cliente_id.blank?
        errors.add(:persona, "#{I18n.t('Sistema.Body.Vistas.General.tipo')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.General.beneficiario')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
      end
      if self.errors.count > 0
        raise ActiveRecord::Rollback
      end
#      cliente_persona = ClientePersona.new
#      cliente_persona.tipo_cliente_id = tipo_cliente_id
#      cliente_persona.type = "ClientePersona"
#      cliente_persona.persona_id = self.id
#      cliente_persona.tipo_cuenta = "C"
#      cliente_persona.fecha_registro = Time.now
#      cliente_persona.save
      return true
    end
  end
  
end


# == Schema Information
#
# Table name: persona
#
#  id                              :integer         not null, primary key
#  cedula                          :integer         not null
#  primer_nombre                   :string(20)      not null
#  segundo_nombre                  :string(20)
#  primer_apellido                 :string(20)      not null
#  segundo_apellido                :string(20)
#  sexo                            :boolean         default(TRUE)
#  estado_civil                    :string(1)
#  fecha_nacimiento                :date
#  venezolano                      :boolean         default(TRUE)
#  profesion_id                    :integer
#  ocupacion                       :string(40)
#  rif_personal                    :string(12)
#  cedula_nacionalidad             :string(1)
#  nacionalidad_id                 :integer
#  grupo                           :boolean         default(FALSE), not null
#  pais                            :string(50)
#  lugar_nacimiento                :string(100)
#  tiempo_profesion                :integer
#  unidad_tiempo_profesion         :string(10)
#  cantidad_total_hijos            :integer
#  cantidad_hijos                  :integer
#  cantidad_hijas                  :integer
#  grado_instruccion_primaria      :string(1)
#  grado_instruccion_secundaria    :string(1)
#  grado_instruccion_medio         :string(1)
#  grado_instruccion_universitario :string(1)
#  grado_instruccion_superior      :string(1)
#  grado_instruccion_robinson1     :string(1)
#  grado_instruccion_robinson2     :string(1)
#  grado_instruccion_robinson3     :string(1)
#  grado_instruccion_ribas         :string(1)
#  grado_instruccion_sucre         :string(1)
#  conyuge_cedula_nacionalidad     :string(1)
#  conyuge_cedula                  :string(8)
#  conyuge_nombre_apellido         :string(100)
#  conyuge_lugar_nacimiento        :string(50)
#  conyuge_nacionalidad            :string(50)
#  conyuge_profesion               :string(50)
#  conyuge_oficio                  :string(50)
#  conyuge_trabaja                 :boolean
#  conyuge_direccion_trabajo       :string(250)
#  conyuge_telefono                :string(16)
#  discapacidad                    :boolean
#  discapacidad_detalle            :string(100)
#  sector_economico_id             :integer
#  actividad_economica_id          :integer
#  rama_actividad_economica_id     :integer
#  codigo_d3                       :string(15)
#  conyuge_celular                 :string(25)
#  prestamo_id                     :integer
#  pasaporte                       :string(20)
#  tipo_dependencia_laboral        :string(50)
#  monto_salario                   :float
#  otros_ingresos                  :float
#  conyuge_empresa                 :string(100)
#  pais_id                         :integer
#  nombre_organizacion             :string(155)
#  grado_instruccion               :string(100)
#  foto_confirmacion               :boolean         default(FALSE)
#  huella_confirmacion             :boolean         default(FALSE)
#


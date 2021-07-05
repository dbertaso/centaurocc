# encoding: utf-8
class EmpleadoSilo < ActiveRecord::Base
  
  self.table_name = 'empleado_silo'
  
  attr_accessible :id,
    :silo_id,
    :letra_cedula,
    :cedula,
    :primer_nombre,
    :segundo_nombre,
    :primer_apellido,
    :segundo_apellido,
    :fecha_nacimiento,
    :edad,
    :estado_civil,
    :telefono_habitacion,
    :telefono_celular,
    :correo_electronico,
    :estado_id,
    :municipio_id,
    :parroquia_id,
    :direccion,
    :profesion_id,
    :cargo,
    :activo,
    :sexo,
    :fecha_nacimiento_f
  
  belongs_to :silo
  #    has_many :Configurador
  #    has_many :solicitud
  #    has_many :SolicitudRubroSolicitado
  #    has_many :CondicionesFinanciamiento
  #    has_many :SolicitudRubroSugerido


  validates :letra_cedula, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nacionalidad')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
 
  validates :cedula, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.cedula')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :numericality =>{:numericality => true, :message => I18n.t('Sistema.Body.Modelos.Errores.cedula_sin_decimales') },
    :uniqueness =>{:uniqueness => true, :message => I18n.t('Sistema.Body.Modelos.Usuario.Errores.cedula_ya_existe')}
  
  validates :primer_nombre, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.primer_nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 4..45, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.primer_nombre')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.primer_nombre')}  #{I18n.t('errors.messages.too_long.other')}"},
    :format =>{:with => /#{I18n.t('Sistema.Body.General.validar_nombre')}/, :allow_blank =>true, 
    :message => I18n.t('Sistema.Body.Modelos.Errores.primer_nombre_invalido')}
  
  validates :primer_apellido, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.primer_apellido')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 4..45, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.primer_apellido')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.primer_apellido')}  #{I18n.t('errors.messages.too_long.other')}"},
    :format =>{:with => /#{I18n.t('Sistema.Body.General.validar_nombre')}/, :allow_blank =>true, 
    :message => I18n.t('Sistema.Body.Modelos.Errores.primer_apellido_invalido')}
  
  validates :sexo, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.Errores.sexo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :edad, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.Errores.edad')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerida')}"},
    :numericality =>{:numericality => true, :message => I18n.t('Sistema.Body.Modelos.Errores.edad_invalida') }
 
  validates :estado_civil, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.TecnicoCampo.Errores.estado_civil')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :telefono_habitacion, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.TecnicoCampo.Errores.telefono_habitacion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :telefono_celular, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.TecnicoCampo.Errores.telefono_movil')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :correo_electronico, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.Errores.correo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 15..80, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Modelos.Errores.correo')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Modelos.Errores.correo')}  #{I18n.t('errors.messages.too_long.other')}"},
    :format =>{:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.validar_correo')}/, :allow_blank =>true, 
    :message => I18n.t('Sistema.Body.Modelos.Errores.email_invalido')},
    :uniqueness =>{:uniqueness => true, :message => "#{I18n.t('Sistema.Body.Modelos.Errores.correo')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_registrado')}"}
    
  validates :estado_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.estado')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :municipio_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.municipio')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :parroquia_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.parroquia')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :direccion, :presence => {
    :message => "#{I18n.t('Sistema.Body.General.direccion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 3..300, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.General.direccion')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.General.direccion')}  #{I18n.t('errors.messages.too_long.other')}"}

  validates :profesion_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.General.Controladores.Profesion.FormTitles.form_title_record')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :cargo, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.cargo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :fecha_nacimiento, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.fecha_nacimiento')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  
  ## CORREGIR VALIDACION DE FECHA VERIFICAR COMO ESTAN MANEJANDO LA FECHA LOS MUCHACHOS 
  #   validates_date :fecha_nacimiento,
  #    :before => Proc.new { 0.day.from_now.to_date }, :message => 'La fecha de nacimiento no puede ser posterior a la fecha actual'

  #PROBANDO VALIDADOR DE DIEGO DE FECHA
  validates :fecha_nacimiento,
    :date => {:message => I18n.t('Sistema.Body.Modelos.Errores.fecha_invalida'),
    :before => Proc.new { 1.day.from_now.to_date }, :message => I18n.t('Sistema.Body.Modelos.Errores.fecha_fin_no_posterior')}



  #  validates_numericality_of :cedula, :edad, :only_integer=>false,
  #    :message => "debe contener solo números"

  #  validates_uniqueness_of :cedula, :correo_electronico,
  #    :message => " ya existe"

  #  validates_length_of :primer_nombre,  :within => 4..45, :allow_nil => false,
  #    :too_short => " es demasiado corto ",
  #    :too_long => "  es demasiado largo (máximo %d)"

  #  validates_length_of :direccion, :within => 3..300, :allow_nil => false,
  #    :too_short => " es demasiado corto ",
  #    :too_long => "  es demasiado largo (máximo %d)"
  
  #  validates_length_of :correo_electronico, :primer_apellido, :within => 1..80, :allow_nil => false,
  #    :too_short => "^ Correo-e es demasiado corto (mínimo %d)",
  #    :too_long => "^ Correo -e es demasiado largo (máximo %d)"

  #  validates_as_email :correo_electronico, :message => '^ Correo-e inválido'

  def fecha_nacimiento_f=(fecha)
    self.fecha_nacimiento = fecha
  end

  def fecha_nacimiento_f
    self.fecha_nacimiento.strftime('%d/%m/%Y') unless self.fecha_nacimiento.nil?
  end

  before_save :before_save

  def before_save
    if self.id.nil?
      if self.cargo == 'S'
        supervisor = EmpleadoSilo.count(:conditions=>["silo_id = #{self.silo_id} and cargo = 'S'"])
        unless supervisor == 0
          errors.add(:empleado_silo,I18n.t('Sistema.Body.Modelos.EmpleadoSilo.Errores.posee_supervisor'))
          return false
        end
      end
    end
    unless self.id.nil?
      if self.cargo == 'S'
        supervisor = EmpleadoSilo.count(:conditions=>["silo_id = #{self.silo_id} and cargo = 'S' and id <> #{self.id}"])
        unless supervisor == 0
          errors.add(:empleado_silo,I18n.t('Sistema.Body.Modelos.EmpleadoSilo.Errores.posee_supervisor'))
          return false
        end
      end
    end
    self.primer_nombre = eliminar_acentos(self.primer_nombre)
    self.primer_nombre = mayuscula(self.primer_nombre) 
    self.segundo_nombre = eliminar_acentos(self.segundo_nombre)
    self.segundo_nombre = mayuscula(self.segundo_nombre)
    self.primer_apellido = eliminar_acentos(self.primer_apellido)
    self.primer_apellido = mayuscula(self.primer_apellido)
    self.segundo_apellido = eliminar_acentos(self.segundo_apellido)
    self.segundo_apellido = mayuscula(self.segundo_apellido)
  end

  def mayuscula(texto)
    unless texto.nil?
      texto  = texto.gsub('á', 'Á')
      texto  = texto.gsub('é', 'É')
      texto  = texto.gsub('í', 'Í')
      texto  = texto.gsub('ó', 'Ó')
      texto  = texto.gsub('ú', 'Ú')
      texto  = texto.upcase
    end
    return texto
  end

  def eliminar_acentos(nombre)
    nombre = nombre.to_s
    nombre.downcase!
    nombre.gsub!(/[á|Á]/,'a')
    nombre.gsub!(/[é|É]/,'e')
    nombre.gsub!(/[í|Í]/,'i')
    nombre.gsub!(/[ó|Ó]/,'o')
    nombre.gsub!(/[ú|Ú]/,'u')
    return nombre
  end

  def nombre
    empleado_silo = EmpleadoSilo.find_by_id(self.id)
    nombre = empleado_silo.primer_nombre + " " + empleado_silo.primer_apellido
    return nombre
  end
  
  #  def self.search(search, page, sort)
  #    paginate :per_page => @records_by_page, :page => page,
  #      :conditions => search, :order => sort
  #  end
  
  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort,
      :select=>'empleado_silo.*',
      :include=>['silo']
  end

end






# == Schema Information
#
# Table name: empleado_silo
#
#  id                  :integer         not null, primary key
#  silo_id             :integer         not null
#  letra_cedula        :string(1)       not null
#  cedula              :integer         not null
#  primer_nombre       :string(20)      not null
#  segundo_nombre      :string(20)
#  primer_apellido     :string(20)      not null
#  segundo_apellido    :string(20)
#  fecha_nacimiento    :date
#  edad                :integer
#  estado_civil        :string(1)
#  telefono_habitacion :string(12)
#  telefono_celular    :string(12)
#  correo_electronico  :string(50)
#  estado_id           :integer         not null
#  municipio_id        :integer         not null
#  parroquia_id        :integer         not null
#  direccion           :string(300)
#  profesion_id        :integer         not null
#  cargo               :string(1)
#  activo              :boolean         default(TRUE)
#  sexo                :string(1)
#


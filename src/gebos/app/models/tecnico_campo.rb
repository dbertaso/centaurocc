# encoding: utf-8
class TecnicoCampo < ActiveRecord::Base

  self.table_name = 'tecnico_campo'
  
  attr_accessible :id,
                  :letra_cedula,
                  :cedula,
                  :oficina_id,
                  :primer_nombre,
                  :segundo_nombre,
                  :primer_apellido,
                  :segundo_apellido,
                  :sexo,
                  :fecha_nacimiento,
                  :telefono_habitacion,
                  :telefono_celular,
                  :correo_electronico,
                  :estado_id,
                  :municipio_id,
                  :parroquia_id,
                  :direccion,
                  :estado_civil,
                  :posee_vehiculo,
                  :marca_vehiculo,
                  :modelo_vehiculo,
                  :ano_vehiculo,
                  :placa_vehiculo,
                  :profesion_id,
                  :activo,
                  :edad,
                  :codigo,
                  :cantidad_visitas,
                  :tipo_vehiculo,
                  :tipo_vehiculo_otro,
                  :carga_trabajo,
                  :fecha_nacimiento_f
  
  has_many :sector_tecnico
  has_many :area_influecia_tecnico
  belongs_to :estado
  belongs_to :municipio
  belongs_to :parroquia
  belongs_to :oficina
  belongs_to :profesion
  
  
  
  validates :cedula, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.cedula')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :numericality =>{:numericality => true, :message => I18n.t('Sistema.Body.Modelos.Errores.cedula_sin_decimales') },
    :uniqueness =>{:uniqueness => true, :message => I18n.t('Sistema.Body.Modelos.Usuario.Errores.cedula_ya_existe')}
  
  validates :estado_civil, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.TecnicoCampo.Errores.estado_civil')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :estado_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.estado')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :municipio_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.municipio')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :parroquia_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.parroquia')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :fecha_nacimiento, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.fecha_nacimiento')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :date => {:message => I18n.t('Sistema.Body.Modelos.Errores.fecha_invalida'),
    :before => Proc.new { 0.day.from_now.to_date }, :message => I18n.t('Sistema.Body.Modelos.Errores.fecha_fin_no_posterior')}
  
  validates :primer_nombre, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.primer_nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 3..20, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.primer_nombre')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.primer_nombre')}  #{I18n.t('errors.messages.too_long.other')}"},
    :format =>{:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.validar_nombre')}/, :allow_blank =>true, 
    :message => I18n.t('Sistema.Body.Modelos.Errores.primer_nombre_invalido')}
  
  validates :primer_apellido, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.primer_apellido')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 4..20, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.primer_apellido')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.primer_apellido')}  #{I18n.t('errors.messages.too_long.other')}"},
    :format =>{:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.validar_nombre')}/, :allow_blank =>true, 
    :message => I18n.t('Sistema.Body.Modelos.Errores.primer_apellido_invalido')}
  
  #SIN PRESENCIA
  validates :segundo_nombre, :length => { :in => 3..20, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.segundo_nombre')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.segundo_nombre')}  #{I18n.t('errors.messages.too_long.other')}"},
    :format =>{:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.validar_nombre')}/, :allow_blank =>true, 
    :message => I18n.t('Sistema.Body.Modelos.Errores.segundo_nombre_invalido')}
  
  validates :segundo_apellido, :length => { :in => 4..20, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.segundo_apellido')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.segundo_apellido')}  #{I18n.t('errors.messages.too_long.other')}"},
    :format =>{:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.validar_nombre')}/, :allow_blank =>true, 
    :message => I18n.t('Sistema.Body.Modelos.Errores.segundo_apellido_invalido')}
  
  validates :sexo, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.Errores.sexo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :telefono_habitacion, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.TecnicoCampo.Errores.telefono_habitacion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :numericality =>{:numericality => true, :message => I18n.t('Sistema.Body.Modelos.Errores.telefono_sin_decimales') }
  
  validates :telefono_celular, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.TecnicoCampo.Errores.telefono_movil')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :numericality =>{:numericality => true, :message => I18n.t('Sistema.Body.Modelos.Errores.telefono_sin_decimales') },
    :format =>{:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.validar_celular')}/, :allow_blank =>true, 
    :message => I18n.t('Sistema.Body.Modelos.Errores.telefono_movil_invalido')}
  
  validates :direccion, :presence => {
    :message => "#{I18n.t('Sistema.Body.General.direccion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 15..300, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.General.direccion')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.General.direccion')}  #{I18n.t('errors.messages.too_long.other')}"},
    :format =>{:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.validar_direccion')}/, :allow_blank =>true, 
    :message => I18n.t('Sistema.Body.Modelos.Errores.direccion_invalida')}
  
  validates :correo_electronico, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.Errores.correo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 15..50, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Modelos.Errores.correo')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Modelos.Errores.correo')}  #{I18n.t('errors.messages.too_long.other')}"},
    :format =>{:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.validar_correo')}/, :allow_blank =>true, 
    :message => I18n.t('Sistema.Body.Modelos.Errores.email_invalido')},
    :uniqueness =>{:uniqueness => true, :message => "#{I18n.t('Sistema.Body.Modelos.Errores.correo')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_registrado')}"}


  def fecha_nacimiento_f=(fecha)
    self.fecha_nacimiento = fecha
  end

  def fecha_nacimiento_f
    format_fecha(self.fecha_nacimiento)
  end

  def self.asignacion_tecnico_campo(oficina, solicitud)
    #asignamos automaticamente el caso al tecnico que tenga menos carga de tramites para esta oficina

    logger.debug "oficina = " << oficina.to_s << " solicitud = " << solicitud.to_s
	
   
    tecnico=TecnicoCampo.find(:first,:from=> "oficina ofi",:conditions => "ofi.id=#{oficina} ",:joins=>'JOIN tecnico_campo tecn ON tecn.oficina_id = ofi.id and tecn.activo=true JOIN usuario usu ON ofi.id = usu.oficina_id and usu.activo=true and usu.cedula_nacionalidad=tecn.letra_cedula and usu.cedula=tecn.cedula',:order=>'tecn.carga_trabajo asc,random()',:select=>'usu.id as usuario_id,usu.nombre_usuario as nombre_usuario, tecn.*')  
         
    unless tecnico.nil?
      #@usuario_select=Usuario.find(tecnico.usuario_id)
      @mi_solicitud=Solicitud.find(solicitud)
      @control_asignacion = ControlAsignacion.new
      @control_asignacion.usuario_id=tecnico.usuario_id 
      @control_asignacion.solicitud_id=solicitud 
      @control_asignacion.fecha=Time.now 
      if @mi_solicitud.estatus_id == 10002
        asignar = true
      else
        asignar = false
      end

      @control_asignacion.asignacion=asignar

      @control_asignacion.unidad='C'
      @control_asignacion.observacion='Asignación Automática'
      @control_asignacion.save

      @mi_solicitud.usuario_pre_evaluacion = tecnico.nombre_usuario
      @mi_solicitud.estatus_id=10003
      @mi_solicitud.save

      tecnico.carga_trabajo=tecnico.carga_trabajo + 1
      informacion_tecnico=tecnico.primer_nombre.to_s.strip.upcase+" "+tecnico.segundo_nombre.to_s.strip.upcase+" "+tecnico.primer_apellido.to_s.strip.upcase+" "+tecnico.segundo_apellido.to_s.strip.upcase+", cédula de identidad "+tecnico.letra_cedula.to_s+" "+tecnico.cedula.to_s
      informacion_tecnico="exitosamente"
      tecnico.save(:validate => false)
        
      return informacion_tecnico
    else
      #error no se encontro el tecnico de campo en la tabla de usuario
      return ""        
    end

  end


  after_save :actualizar_parametro
  
  def actualizar_parametro
    if self.codigo.nil? || self.codigo.to_s.empty?
      parametro_general = ParametroGeneral.find(:first)
      parametro_general.codigo_tecnico_campo = (parametro_general.codigo_tecnico_campo.to_i + 1)
      parametro_general.save
      self.codigo = (parametro_general.codigo_tecnico_campo.to_i + 1)
      self.save
    end
  end

  def complemento
    complemento = (self.primer_nombre + " " + self.primer_apellido)
    return complemento
  end


  before_save :actualiza_nombre
  
  def actualiza_nombre
    primer_nombre = eliminar_acentos(self.primer_nombre)
    self.primer_nombre = primer_nombre.upcase
    primer_apellido = eliminar_acentos(self.primer_apellido)
    self.primer_apellido = primer_apellido.upcase

    unless self.segundo_nombre.nil? || self.segundo_nombre.to_s.empty?
      segundo_nombre = eliminar_acentos(self.segundo_nombre)
      self.segundo_nombre = segundo_nombre.upcase
    end

    unless self.segundo_apellido.nil? || self.segundo_apellido.to_s.empty?
      segundo_apellido = eliminar_acentos(self.segundo_apellido)
      self.segundo_apellido = segundo_apellido.upcase
    end
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

  def eliminar(id)
    begin
      tecnico_campo = TecnicoCampo.find(id)
      transaction do
        tecnico_campo.destroy
        return true
      end
    rescue
      errors.add(:tecnico_campo, :message=> I18n.t('Sistema.Body.Modelos.TecnicoCampo.Errores.tecnico_utilizado'))
      return false
    end
  end
  
  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort
  end

end
 



# == Schema Information
#
# Table name: tecnico_campo
#
#  id                  :integer         not null, primary key
#  letra_cedula        :string(1)       not null
#  cedula              :integer         not null
#  oficina_id          :integer         not null
#  primer_nombre       :string(20)      not null
#  segundo_nombre      :string(20)
#  primer_apellido     :string(20)      not null
#  segundo_apellido    :string(20)
#  sexo                :boolean
#  fecha_nacimiento    :date
#  telefono_habitacion :string(12)
#  telefono_celular    :string(12)
#  correo_electronico  :string(50)
#  estado_id           :integer         not null
#  municipio_id        :integer         not null
#  parroquia_id        :integer         not null
#  direccion           :string(300)
#  estado_civil        :string(1)
#  posee_vehiculo      :boolean
#  marca_vehiculo      :string(20)
#  modelo_vehiculo     :string(20)
#  ano_vehiculo        :string(4)
#  placa_vehiculo      :string(10)
#  profesion_id        :integer         not null
#  activo              :boolean         default(TRUE)
#  edad                :integer
#  codigo              :integer
#  cantidad_visitas    :integer         default(0), not null
#  tipo_vehiculo       :string(30)
#  tipo_vehiculo_otro  :string(45)
#  carga_trabajo       :integer         default(0)
#


# encoding: utf-8
class Usuario < ActiveRecord::Base

  self.table_name = 'usuario'

  attr_accessible :id,
                  :nombre_usuario,
                  :primer_nombre,
                  :segundo_nombre,
                  :primer_apellido,
                  :segundo_apellido,
                  :super_usuario,
                  :oficina_id,
                  :clave,
                  :fecha_cambio_clave,
                  :activo,
                  :cedula_nacionalidad,
                  :cedula,
                  :tecnico_campo,
                  :password,
                  :lenguaje,
                  :empresa_sistema_id, :admin_empresa

  belongs_to :oficina
  has_and_belongs_to_many :roles, :class_name=>'Rol', :join_table=>'usuario_rol'
  has_many :control_asignacion
  has_many :recepcion_maquinaria
  has_many :proforma
  has_many :analista_cobranzas

  validates :nombre_usuario, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Vistas.Login.user')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 4..30, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Vistas.Login.user')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Vistas.Login.user')}  #{I18n.t('errors.messages.too_long.other')}"},
    :uniqueness =>{:message =>"#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Vistas.Login.user')} #{I18n.t('Sistema.Body.Modelos.Usuario.Errores.cedula_ya_existe')}"}
  
#  validates :oficina, 
#            :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.oficina')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

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
  
  validates :cedula, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.cedula')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :numericality =>{:numericality => true, :message => I18n.t('Sistema.Body.Modelos.Errores.cedula_sin_decimales') },
    :length => { :in => 6..20, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.cedula')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.cedula')}  #{I18n.t('errors.messages.too_long.other')}"},
    :uniqueness =>{:uniqueness => true, :message =>"#{I18n.t('Sistema.Body.Vistas.General.cedula')} #{I18n.t('Sistema.Body.Modelos.Usuario.Errores.cedula_ya_existe')}"}
  
  validates :clave, :length => { :in => 3..20, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.clave')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.clave')}  #{I18n.t('errors.messages.too_long.other')}"}
    
    
  validates :lenguaje, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.idioma')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates_confirmation_of :clave,
    :message => " #{I18n.t('Sistema.Body.Modelos.Usuario.Errores.confirmacion_invalida')}"

  validate :validate

  def validate
    unless self.admin_empresa == true
      unless self.super_usuario == true
        if self.oficina_id.blank?
          errors.add(:usuario, "#{I18n.t('Sistema.Body.Vistas.General.oficina')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
        end
        if self.empresa_sistema_id.blank?
          errors.add(:usuario, "#{I18n.t('Sistema.Body.General.empresa_sistema')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
        end
      end
    end
  end

  attr_accessor :clave_confirmation
  attr_accessor :clave_anterior
  attr_accessor :clave
#  attr_accessor :password_confirmation

  def add_rol(rol)
    if roles.find rol.id
      errors.add(:rol, "#{I18n.t('Sistema.Body.Modelos.Rol.Errores.rol_ya_asignado')}")
      false
    end
  rescue
    roles<<rol
  end

  def add_oficina(oficina)
    if oficinas.find_by_oficina_id oficina.id
      errors.add(:oficina, I18n.t('Sistema.Body.Vistas.Login.usuario_ya_tiene_oficina'))
      false
    else
      oficinas<<UsuarioOficina.new(:oficina_id=>oficina.id, :usuario_id=>id, :predeterminada=>false)
    end
  end

  def try_to_login
    clave = Digest::MD5.new.hexdigest(self.clave)
    self.clave = clave
    Usuario.login(self.nombre_usuario, self.clave)
  end

  def self.login(nombre_usuario, clave)
    if nombre_usuario == 'admin'
      find(:first, :conditions => ["\"nombre_usuario\" = ? and \"password\" = ?", nombre_usuario, clave])
    else
      find(:first, :conditions => ["\"nombre_usuario\" = ? and \"password\" = ? and \"activo\"= ?", nombre_usuario, clave, true])
    end
  end

  def self.usuario_asigando(nombre_usuario)
    u = Usuario.count(:conditions=>['nombre_usuario = ?', nombre_usuario])
    if u > 0
      usuario = Usuario.find(:first, :conditions=>['nombre_usuario = ?', nombre_usuario])
      return usuario.nombre_corto
    else
      return ''
    end
  end

  def nombre_corto
    self.primer_nombre + ' ' + self.primer_apellido
  end
  
  def self.search(search, page, sort, joins)
    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort,
      :select=>'usuario.*',
      :joins=>joins
  end
  

end




# == Schema Information
#
# Table name: usuario
#
#  id                  :integer         not null, primary key
#  nombre_usuario      :string(30)      not null
#  primer_nombre       :string(20)      not null
#  segundo_nombre      :string(20)
#  primer_apellido     :string(20)      not null
#  segundo_apellido    :string(20)
#  super_usuario       :boolean         default(FALSE)
#  oficina_id          :integer
#  fecha_cambio_clave  :date
#  activo              :boolean         default(TRUE)
#  cedula_nacionalidad :string(1)       default("V"), not null
#  cedula              :integer
#  tecnico_campo       :boolean         default(FALSE), not null
#  password            :
#  lenguaje            :string(2)       default("es"), not null
#  empresa_sistema_id  :integer
#  admin_empresa       :boolean         default(FALSE)
#


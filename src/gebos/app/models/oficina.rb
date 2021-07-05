# encoding: utf-8
class Oficina < ActiveRecord::Base

  self.table_name = 'oficina'

  attr_accessible :id,
    :nombre,
    :municipio_id,
    :ciudad_id,
    :cedula_nacionalidad,
    :cedula_supervisor,
    :primer_nombre_supervisor,
    :segundo_nombre_supervisor,
    :primer_apellido_supervisor,
    :segundo_apellido_supervisor,
    :cedula_nacionalidad_jefe_brigada,
    :folio_autenticacion,
    :tomo_autenticacion,
    :cedula_jefe_brigada,
    :primer_nombre_jefe_brigada,
    :segundo_nombre_jefe_brigada,
    :primer_apellido_jefe_brigada,
    :segundo_apellido_jefe_brigada,
    :estado_id

  belongs_to :municipio
  belongs_to :ciudad
  has_many :configurador
  has_many :solicitud
  has_many :tecnico_campo
  has_many :abogado
  has_many :oficina_area_influencia
  has_many :view_envio_maquinaria
  has_many :departamentos,  :class_name=>'OficinaDepartamento'
  
  #LISTOS
  validates :nombre, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.Form.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :format =>{:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio_numero_otro')}/, :allow_blank =>true, :message =>"#{I18n.t('Sistema.Body.Vistas.Form.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalido')}"},
    :uniqueness =>{:uniqueness => true, :message => "#{I18n.t('Sistema.Body.Vistas.Form.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"} 
  
  validates :municipio, :presence => {
    :message => I18n.t('Sistema.Body.Modelos.Errores.municipio_requerido')}
  
  validates :ciudad, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.ciudad')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :cedula_nacionalidad, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nacionalidad')} #{I18n.t('Sistema.Body.Vistas.General.cedula')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :cedula_supervisor, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.cedula')} #{I18n.t('Sistema.Body.Vistas.General.supervisor')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :uniqueness =>{:uniqueness => true, :message => I18n.t('Sistema.Body.Modelos.Usuario.Errores.cedula_ya_existe')}

  validates :cedula_jefe_brigada, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.cedula')} #{I18n.t('Sistema.Body.Vistas.General.jefe_brigada')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :uniqueness =>{:uniqueness => true, :message => I18n.t('Sistema.Body.Modelos.Usuario.Errores.cedula_ya_existe')}
  
  validates :cedula_nacionalidad_jefe_brigada, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nacionalidad')} #{I18n.t('Sistema.Body.Vistas.General.jefe_brigada')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :primer_nombre_supervisor, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.primer_nombre')} #{I18n.t('Sistema.Body.Vistas.General.supervisor')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :format =>{:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio')}/, :allow_blank =>true, :message =>"#{I18n.t('Sistema.Body.Vistas.General.primer_nombre')} #{I18n.t('Sistema.Body.Vistas.General.supervisor')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalido')}"}
  
  validates :segundo_nombre_supervisor, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.segundo_nombre')} #{I18n.t('Sistema.Body.Vistas.General.supervisor')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :format =>{:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio')}/, :allow_blank =>true, :message =>"#{I18n.t('Sistema.Body.Vistas.General.segundo_nombre')} #{I18n.t('Sistema.Body.Vistas.General.supervisor')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalido')}"}
  
  validates :primer_apellido_supervisor, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.primer_apellido')} #{I18n.t('Sistema.Body.Vistas.General.supervisor')}  #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :format =>{:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio')}/, :allow_blank =>true, :message =>"#{I18n.t('Sistema.Body.Vistas.General.primer_apellido')} #{I18n.t('Sistema.Body.Vistas.General.supervisor')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalido')}"}
  
  validates :segundo_apellido_supervisor, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.segundo_apellido')} #{I18n.t('Sistema.Body.Vistas.General.supervisor')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :format =>{:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio')}/, :allow_blank =>true, :message =>"#{I18n.t('Sistema.Body.Vistas.General.segundo_apellido')} #{I18n.t('Sistema.Body.Vistas.General.supervisor')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalido')}"}
  
  validates :primer_nombre_jefe_brigada, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.primer_nombre')} #{I18n.t('Sistema.Body.Vistas.General.jefe_brigada')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :format =>{:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio')}/, :allow_blank =>true, :message =>"#{I18n.t('Sistema.Body.Vistas.General.primer_nombre')} #{I18n.t('Sistema.Body.Vistas.General.jefe_brigada')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalido')}"}
  
  validates :segundo_nombre_jefe_brigada, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.segundo_nombre')} #{I18n.t('Sistema.Body.Vistas.General.jefe_brigada')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :format =>{:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio')}/, :allow_blank =>true, :message =>"#{I18n.t('Sistema.Body.Vistas.General.segundo_nombre')} #{I18n.t('Sistema.Body.Vistas.General.jefe_brigada')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalido')}"}
  
  validates :primer_apellido_jefe_brigada, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.primer_apellido')} #{I18n.t('Sistema.Body.Vistas.General.jefe_brigada')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :format =>{:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio')}/, :allow_blank =>true, :message =>"#{I18n.t('Sistema.Body.Vistas.General.primer_apellido')} #{I18n.t('Sistema.Body.Vistas.General.jefe_brigada')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalido')}"}
  
  validates :segundo_apellido_jefe_brigada, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.segundo_apellido')} #{I18n.t('Sistema.Body.Vistas.General.jefe_brigada')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :format =>{:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio')}/, :allow_blank =>true, :message =>"#{I18n.t('Sistema.Body.Vistas.General.segundo_apellido')} #{I18n.t('Sistema.Body.Vistas.General.segundo_apellido')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalido')}"}
  
  validates :tomo_autenticacion, :presence => {
    :message => I18n.t('Sistema.Body.Modelos.Solicitud.Errores.numero_tomo_requerido')}
  
  validates :folio_autenticacion, :presence => {
    :message => I18n.t('Sistema.Body.Modelos.Oficina.Errores.folio_autenticacion')}
  
  #  validates_uniqueness_of :nombre,
  #    :message => "#{I18n.t('Sistema.Body.Vistas.Form.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"
  #  
  validates_length_of :nombre, :within => 3..20, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.Form.nombre')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => " #{I18n.t('Sistema.Body.Vistas.Form.nombre')} #{I18n.t('errors.messages.too_long.other')}"
  
  validates_length_of :primer_nombre_supervisor, :within => 3..20, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.primer_nombre')} #{I18n.t('Sistema.Body.Vistas.General.supervisor')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.primer_nombre')} #{I18n.t('Sistema.Body.Vistas.General.supervisor')} #{I18n.t('errors.messages.too_long.other')}"
  
  validates_length_of :segundo_nombre_supervisor, :within => 3..20, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.segundo_nombre')} #{I18n.t('Sistema.Body.Vistas.General.supervisor')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.segundo_nombre')} #{I18n.t('Sistema.Body.Vistas.General.supervisor')} #{I18n.t('errors.messages.too_long.other')}"
  
  validates_length_of :primer_apellido_supervisor, :within => 3..20, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.primer_apellido')} #{I18n.t('Sistema.Body.Vistas.General.supervisor')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.primer_apellido')} #{I18n.t('Sistema.Body.Vistas.General.supervisor')} #{I18n.t('errors.messages.too_long.other')}"
  
  validates_length_of :segundo_apellido_supervisor, :within => 3..20, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.segundo_apellido')} #{I18n.t('Sistema.Body.Vistas.General.supervisor')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.segundo_apellido')} #{I18n.t('Sistema.Body.Vistas.General.supervisor')} #{I18n.t('errors.messages.too_long.other')}"

  validates_length_of :primer_nombre_jefe_brigada, :within => 3..20, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.primer_nombre')} #{I18n.t('Sistema.Body.Vistas.General.jefe_brigada')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.primer_nombre')} #{I18n.t('Sistema.Body.Vistas.General.jefe_brigada')} #{I18n.t('errors.messages.too_long.other')}"
  
  validates_length_of :segundo_nombre_jefe_brigada, :within => 3..20, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.segundo_nombre')} #{I18n.t('Sistema.Body.Vistas.General.jefe_brigada')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.segundo_nombre')} #{I18n.t('Sistema.Body.Vistas.General.jefe_brigada')} #{I18n.t('errors.messages.too_long.other')}"
  
  validates_length_of :primer_apellido_jefe_brigada, :within => 3..20, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.primer_apellido')} #{I18n.t('Sistema.Body.Vistas.General.jefe_brigada')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.primer_apellido')} #{I18n.t('Sistema.Body.Vistas.General.jefe_brigada')} #{I18n.t('errors.messages.too_long.other')}"
  
  validates_length_of :segundo_apellido_jefe_brigada, :within => 3..20, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.segundo_apellido')} #{I18n.t('Sistema.Body.Vistas.General.jefe_brigada')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.segundo_apellido')} #{I18n.t('Sistema.Body.Vistas.General.jefe_brigada')} #{I18n.t('errors.messages.too_long.other')}"

  #FIN LISTOS
  after_save :oficina_departamento
  

  attr_accessor :nuevos_departamentos

  def oficina_departamento
    dep = OficinaDepartamento.find_by_sql("delete from oficina_departamento where oficina_id = #{self.id}")
    unless nuevos_departamentos.nil?
      nuevos_departamentos.each { |d|
        departamento = OficinaDepartamento.new
        departamento.oficina_id = self.id
        departamento.departamento_id = d
        departamento.save!
      }
    end
  end

  def estado_id
    ciudad.estado_id unless ciudad.nil?
  end
  
  def estado_id=(estado_id)
  end

  #  def before_destroy
  #    valid = true
  #    for departamento in departamentos
  #      departamento.errors.each() do |a, m|
  #        errors.add(a, m)
  #        valid = false
  #      end if !departamento.errors.empty?
  #    end
  #    valid
  #  end

  def puede_eliminarse?
    departamentos.empty?
  end

  def self.search(search, page, sort, joins)
    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort,
      :select=>'oficina.*, municipio.nombre as municipio_nombre, ciudad.nombre as ciudad_nombre',
      :joins=>joins
  end
  
  
  
  def eliminar(id)
    begin
      area_influencia = OficinaAreaInfluencia.count(:conditions=>"oficina_id = #{self.id}")
      configurador = Configurador.count(:conditions=>"oficina_id = #{self.id}")
      dep = OficinaDepartamento.count(:conditions=>"oficina_id = #{self.id}")
      if (area_influencia > 0 || configurador > 0 || dep > 0)
        errors.add(:oficina, "#{I18n.t('Sistema.Body.General.la')} #{I18n.t('Sistema.Body.Modelos.Oficina.Errores.oficina_usada_configurador')}")
        return false
      else
        oficina = Oficina.find(id)
        transaction do
          oficina.destroy
          return true
        end
      end
    rescue
      errors.add(:oficina, "#{I18n.t('Sistema.Body.General.la')} #{I18n.t('Sistema.Body.Modelos.Oficina.Errores.oficina_usada_configurador')}")
      return false
    end
  end

  
  
end




# == Schema Information
#
# Table name: oficina
#
#  id                               :integer         not null, primary key
#  nombre                           :string(80)      not null
#  municipio_id                     :integer         not null
#  ciudad_id                        :integer         not null
#  cedula_nacionalidad              :string(1)
#  cedula_supervisor                :integer
#  primer_nombre_supervisor         :string(20)
#  segundo_nombre_supervisor        :string(20)
#  primer_apellido_supervisor       :string(20)
#  segundo_apellido_supervisor      :string(20)
#  cedula_nacionalidad_jefe_brigada :string(1)
#  folio_autenticacion              :integer
#  tomo_autenticacion               :integer
#  cedula_jefe_brigada              :integer
#  primer_nombre_jefe_brigada       :string(20)
#  segundo_nombre_jefe_brigada      :string(20)
#  primer_apellido_jefe_brigada     :string(20)
#  segundo_apellido_jefe_brigada    :string(20)
#  empresa_sistema_id               :integer
#


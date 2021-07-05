# encoding: utf-8
class Opcion < ActiveRecord::Base
  
  self.table_name = 'opcion'
  
  attr_accessible   :id,
    :nombre,
    :descripcion,
    :tiene_acciones,
    :ruta,
    :opcion_grupo_id

  has_many :menu, :dependent=>:destroy 
  belongs_to :opcion_grupo
  belongs_to :accion
  has_and_belongs_to_many :roles, :class_name=>'Rol', :join_table=>'rol_opcion'
  has_many :acciones, :dependent => :destroy, :class_name=>'OpcionAccion'
  
  
  validates :nombre, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 4..250, :allow_blank => false,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('errors.messages.too_long.other')}"},
    :uniqueness =>{:uniqueness => true, :message =>"#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Usuario.Errores.cedula_ya_existe')}"}
  
  validates :opcion_grupo, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.Opcion.Errores.opcion_grupo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :ruta, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.Opcion.Errores.ruta')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 4..250, :allow_blank => false,
    :too_short => "#{I18n.t('Sistema.Body.Modelos.Opcion.Errores.ruta')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Modelos.Opcion.Errores.ruta')} #{I18n.t('errors.messages.too_long.other')}"},
    :uniqueness =>{:uniqueness => true, :message =>"#{I18n.t('Sistema.Body.Modelos.Opcion.Errores.ruta')} #{I18n.t('Sistema.Body.Modelos.Usuario.Errores.cedula_ya_existe')}"}
  
  
  
  def ruta_real
    '/'.concat(ruta)
  end
  
  def add_accion(accion)
    if acciones.find(accion.id)
      errors.add(:opcion, I18n.t('Sistema.Body.Modelos.Opcion.Errores.opcion_tiene_accion'))
      false
    end
  rescue
    acciones<<OpcionAccion.new(:accion_id=>accion.id, :opcion_id=>id)
  end
  

  def saveopcion(opcion,opcion_accion_id)    
    if opcion_accion_id.nil? || opcion_accion_id.to_s.empty?
      errors.add(:opcion, I18n.t('Sistema.Body.Modelos.Opcion.Errores.opcion_tiene_accion'))
      return false
    else
      transaction do
        opcion.save
            
        if opcion.id.nil?
          return false
        end
        array_accion=opcion_accion_id.split(',')
        array_accion=array_accion.uniq
            
        deleted=OpcionAccion.delete_all(["opcion_id = ?", opcion.id])
        if deleted
          array_accion.each { |x|
            opcion_accion           = OpcionAccion.new
            opcion_accion.opcion_id = opcion.id
            opcion_accion.accion_id = x
            opcion_accion.autorizacion = false
            opcion_accion.autorizacion_tiempo_tipo = 'D'
            opcion_accion.autorizacion_tiempo = 0
            opcion_accion.autorizacion_extendida = false
            opcion_accion.save!
          }
        end
      end
      return false
    end
  end
  
  def self.search(search, page, sort, joins)
    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => "opcion.nombre",
      :select=>'opcion.*',
      :joins=>joins
  end
  

end


# == Schema Information
#
# Table name: opcion
#
#  id              :integer         not null, primary key
#  nombre          :string(250)     not null
#  descripcion     :string(400)
#  tiene_acciones  :boolean         default(FALSE)
#  ruta            :string(250)     not null
#  opcion_grupo_id :integer         not null
#


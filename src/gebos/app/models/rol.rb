# encoding: utf-8
class Rol < ActiveRecord::Base

  self.table_name = 'rol'
  
  attr_accessible :id, :nombre, :descripcion, :empresa_sistema_id
  
  has_and_belongs_to_many :usuarios, :class_name=>'Usuario', :join_table=>'usuario_rol'
  has_and_belongs_to_many :opciones, :class_name=>'Opcion', :join_table=>'rol_opcion'
  has_and_belongs_to_many :acciones, :class_name=>'OpcionAccion', :join_table=>'rol_opcion_accion'
  has_and_belongs_to_many :autorizaciones, :class_name=>'OpcionAccion', :join_table=>'rol_autorizacion'
  
  validates :nombre, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 4..50, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('errors.messages.too_long.other')}"},
    :format =>{:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio_numero_otro')}/, :allow_blank =>true, :message =>"#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalido')}"},
    :uniqueness =>{:uniqueness => true, :message =>"#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Usuario.Errores.cedula_ya_existe')}"}

  
  def add_accion(accion)
    if acciones.find accion.id
      errors.add(:rol, I18n.t('Sistema.Body.Modelos.Rol.Errores.rol_tiene_accion'))
      false
    end
  rescue
    acciones<<accion
  end
  
  def add_opcion(opcion, nuevas_acciones=nil)
    if opciones.find opcion.id
      errors.add(:rol, I18n.t('Sistema.Body.Modelos.Rol.Errores.rol_tiene_opcion'))
      false
    end
  rescue
    opciones.<<opcion

    update_acciones(opcion.id, nuevas_acciones) unless nuevas_acciones.nil? || nuevas_acciones.empty?
  end
  
  def add_autorizacion(opcion_accion)
    if autorizaciones.find opcion_accion.id
      errors.add(:rol, I18n.t('Sistema.Body.Modelos.Rol.Errores.rol_tiene_autorizacion'))
      false
    end
  rescue
    autorizaciones.<<opcion_accion
  end
  
  def update_opcion(opcion, acciones)
    if opciones.find opcion.id
      update_acciones(opcion.id, acciones)   
    end
  rescue
    errors.add(:opcion, I18n.t('Sistema.Body.Modelos.Opcion.Errores.opcion_no_existe'))
    false
  end
  
  def delete_opcion(opcion)
    opciones.delete(opcion)
    if !acciones.nil? and acciones.find_by_opcion_id(opcion.id)
      acciones.delete(acciones.find_by_opcion_id(opcion.id)) 
    end
    true
  end
  
  
  def check(opcion_grupo_id, id)
    if (id.blank? || opcion_grupo_id.blank?)
      if (id.blank?)
        errors.add(:rol_opcion, "#{I18n.t('Sistema.Body.Controladores.RolOpcion.FormTitles.form_title_record')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
      end
      if (opcion_grupo_id.blank?)
        errors.add(:rol_opcion, "#{I18n.t('Sistema.Body.Vistas.General.grupo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
      end
     return false
    else
      return true
    end
  end
  
  
  private
  def update_acciones(opcion_id, nuevas_acciones)
    for nueva in nuevas_acciones
      if acciones.nil? || !acciones.find_by_accion_id_and_opcion_id(nueva, opcion_id)
        opcion_accion = OpcionAccion.find_by_accion_id_and_opcion_id(nueva, opcion_id)
        acciones<<opcion_accion
      end
    end unless nuevas_acciones.nil?
    acciones_eliminar = []
    for accion in acciones
      if accion.opcion_id == opcion_id
        if nuevas_acciones.nil? || !nuevas_acciones.find {|nueva| accion.accion_id == nueva.to_i }
          acciones_eliminar<<accion
        end
      end
    end
    acciones.delete(acciones_eliminar)
    true
  end
  
  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort,
      :select=>'rol.*'
  end
  
  def self.search_usuario(search, page, sort, joins)
    paginate :per_page => @records_by_page, :page => page,
      :joins=>joins,
      :conditions => search, :order => sort,
      :select=>'rol.*'
  end
  
  
 
end


# == Schema Information
#
# Table name: rol
#
#  id          :integer         not null, primary key
#  nombre      :string(50)      not null
#  descripcion :string(300)
#


# encoding: utf-8
#
# autor: Luis Rojas
# clase: AlmacenMaquinariaSucursal
# descripción: Migración a Rails 3
#
class AlmacenMaquinariaSucursal < ActiveRecord::Base

  self.table_name = 'almacen_maquinaria_sucursal'

  attr_accessible :id, :nombre, :estado_id, :municipio_id, :ciudad_id, :direccion, :persona_contacto, :telefono, :activo, :almacen_maquinaria_id
  
  has_many :catalogo
  belongs_to :estado
  belongs_to :municipio
  belongs_to :ciudad
  
  validates :nombre,
    :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 3..60, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.nombre')}  #{I18n.t('errors.messages.too_long.other')}"},
    :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio')}/, :allow_blank => true,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}"}
  
  validates :direccion,
    :presence => { :message => "#{I18n.t('Sistema.Body.General.direccion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 3..250, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.General.direccion')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.General.direccion')}  #{I18n.t('errors.messages.too_long.other')}"},
    :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio')}/, :allow_blank => true,
    :message => "#{I18n.t('Sistema.Body.General.direccion')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}"}
  
  validates :persona_contacto,
    :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.persona_contacto')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 3..60, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.persona_contacto')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.persona_contacto')}  #{I18n.t('errors.messages.too_long.other')}"},
    :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio')}/, :allow_blank => true,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.persona_contacto')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}"}
  
  validates :estado_id,
    :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.estado')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :municipio_id,
    :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.municipio')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :ciudad_id,
    :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.ciudad')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :telefono,
    :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.numero')} #{I18n.t('Sistema.Body.Vistas.General.telefono')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.validar_telefono_habitacion')}/, :allow_blank => true,
    :message => I18n.t('Sistema.Body.Modelos.Errores.telefono_invalido')}
  
  def self.search(search, page, sort)

    paginate :per_page => @records_by_page, :page => page,
             :conditions => search, :include => ['estado', 'municipio', 'ciudad'],
             :order => sort

  end
  
  def after_initialize
    self.activo = true
  end

  def eliminar(id)
    begin
      catalogo = Catalogo.count(:conditions=>"almacen_maquinaria_id = #{id}")
      if catalogo > 0
        errors.add(nil, "La sucursal del almacen esta siendo utilizado, no puede ser eliminada")
        return false
      else
        almacen_maquinaria = AlmacenMaquinaria.find(id)
        transaction do
          almacen_maquinaria.destroy
          return true
        end
      end
    rescue
      errors.add(nil, "El item esta siendo utilizado en Configuración, no puede ser eliminada")
      return false
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
  
end
# == Schema Information
#
# Table name: almacen_maquinaria_sucursal
#
#  id                    :integer         not null, primary key
#  nombre                :string(100)
#  estado_id             :integer
#  municipio_id          :integer
#  ciudad_id             :integer
#  direccion             :text
#  persona_contacto      :string(100)
#  telefono              :string(11)
#  activo                :boolean
#  almacen_maquinaria_id :integer
#


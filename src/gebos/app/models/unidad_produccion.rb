# encoding: utf-8

#
# autor: Luis Rojas
# clase: UnidadProduccion
# descripción: Migración a Rails 3
#

class UnidadProduccion < ActiveRecord::Base
  
  self.table_name = 'unidad_produccion'

  attr_accessible :id,:codigo,:nombre,:total_hectareas,:ciudad_id,:municipio_id,:parroquia_id,:sector,:direccion,:referencia,:lindero_norte,:lindero_sur,:lindero_este,:lindero_oeste,:cliente_id,:utm_norte,:utm_sur,:utm_este,:utm_oeste, :estado_id, :region_id
  
  
  has_many :registro_mercantil
  has_many :utm_unidad_produccion
  has_many :puerto_base
  belongs_to :ciudad
  belongs_to :municipio
  belongs_to :parroquia
  belongs_to :cliente
  has_many :solicitud

  validates :nombre, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  validates :sector, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.sector')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  validates :ciudad_id, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.ciudad')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  validates :municipio_id, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.municipio')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  validates :parroquia_id, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.parroquia')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  validates :direccion, :presence => {:message => "#{I18n.t('Sistema.Body.General.direccion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  validates :referencia, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.referencia')}/#{I18n.t('Sistema.Body.General.direccion')} #{I18n.t('Sistema.Body.Vistas.General.practica')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  validates :autonomia_pesca, :numericality => {:numericality => true, :allow_blank => true, :message => "#{I18n.t('Sistema.Body.Vistas.General.autonomia_pesca')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}"}
  validates :total_hectareas, :numericality => {:numericality => true, :allow_blank => true, :message => "#{I18n.t('Sistema.Body.Vistas.General.total_hectareas')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}"}

  def total_hectareas_f=(valor)
    self.total_hectareas = formato_valor(valor)
  end

  def total_hectareas_f
    format_fm(self.total_hectareas)
  end

  def estado_nombre
    unless self.municipio.nil?
      self.municipio.estado.nombre
    end
  end

  def ciudad_nombre
    unless self.ciudad_id.nil?
      ciudad = Ciudad.find(:first, :conditions=>['id = ?', self.ciudad_id])
      return ciudad.nombre
    end
  end

  def municipio_nombre
    unless self.municipio_id.nil?
      municipio = Municipio.find(:first, :conditions=>['id = ?', self.municipio_id])
      return municipio.nombre
    end
  end

  def parroquia_nombre
    unless self.parroquia_id.nil?
      parroquia = Parroquia.find(:first, :conditions=>['id = ?', self.parroquia_id])
      return parroquia.nombre
    end
  end

  def estado_id
    unless self.ciudad_id.nil?
      estado = Estado.find(:first, :conditions=>['id in (select estado_id from ciudad where id = ?)', self.ciudad_id])
      return estado.id
    end
  end

  def estado_id=(estado_id)
  end

  def region_id
    unless self.ciudad_id.nil?
      estado = Estado.find(:first, :conditions=>['id in (select estado_id from ciudad where id = ?)', self.ciudad_id])
      return estado.region_id
    end
  end
  
  def region_id=(region_id)
  end
  
  def validate_destroy
    msj = ""
    total = Solicitud.count(:conditions => ['unidad_produccion_id = ?', self.id])
    if total > 0
      msj = I18n.t('Sistema.Body.Modelos.Errores.unidad_produccion_asociada_solicitud')
    end
    total = RegistroMercantil.count(:conditions => ['unidad_produccion_id = ?', self.id])
    if total > 0
      if msj.length > 0
        msj << " #{I18n.t('Sistema.Body.Vistas.General.y')} #{I18n.t('Sistema.Body.Modelos.Errores.unidad_produccion_asociada_registro')}"
      else
        msj = I18n.t('Sistema.Body.Modelos.Errores.unidad_produccion_asociada_registro')
      end
    end
    return msj
  end

  validate :validate
  
  def validate
    cliente = Cliente.find(self.cliente_id)
    if cliente.es_pescador == true
      if cliente.type.to_s == "ClienteEmpresa"
        if self.autonomia_pesca.nil? || self.autonomia_pesca.to_s.empty?
          errors.add(:unidad_produccion, "#{I18n.t('Sistema.Body.Vistas.General.autonomia_pesca')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
        end
        if self.puerto_base.nil? || self.puerto_base.empty?
          errors.add(:unidad_produccion, "#{I18n.t('Sistema.Body.Vistas.General.puerto_base')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
        end
      end
      self.total_hectareas = 0.0
    else
      if self.total_hectareas.nil? || self.total_hectareas.to_s.empty?
        errors.add(:unidad_produccion, "#{I18n.t('Sistema.Body.Vistas.General.total_hectareas')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
      else
        unless self.total_hectareas > 0
          errors.add(:unidad_produccion, "#{I18n.t('Sistema.Body.Vistas.General.total_hectareas')} debe ser mayor a 0.")
        end
      end
    end
  end

  def self.search(search, page, orden)    
    conditions=search  
    paginate :per_page=>@records_by_page, :page=>page, :conditions=>conditions, :order=>orden
  end

end

# == Schema Information
#
# Table name: unidad_produccion
#
#  id              :integer         not null, primary key
#  codigo          :string(20)      not null
#  nombre          :string(150)     not null
#  total_hectareas :float           not null
#  ciudad_id       :integer         not null
#  municipio_id    :integer         not null
#  parroquia_id    :integer         not null
#  sector          :string(100)
#  direccion       :text            not null
#  referencia      :text            not null
#  lindero_norte   :string(200)
#  lindero_sur     :string(200)
#  lindero_este    :string(200)
#  lindero_oeste   :string(200)
#  cliente_id      :integer         not null
#  utm_norte       :string(100)
#  utm_sur         :string(100)
#  utm_este        :string(100)
#  utm_oeste       :string(100)
#  autonomia_pesca :integer
#  puerto_base     :string(250)
#

# == Schema Information
#
# Table name: unidad_produccion
#
#  id              :integer         not null, primary key
#  codigo          :string(20)      not null
#  nombre          :string(150)     not null
#  total_hectareas :float           not null
#  ciudad_id       :integer         not null
#  municipio_id    :integer         not null
#  parroquia_id    :integer         not null
#  sector          :string(100)
#  direccion       :text            not null
#  referencia      :text            not null
#  lindero_norte   :string(200)
#  lindero_sur     :string(200)
#  lindero_este    :string(200)
#  lindero_oeste   :string(200)
#  cliente_id      :integer         not null
#  utm_norte       :string(100)
#  utm_sur         :string(100)
#  utm_este        :string(100)
#  utm_oeste       :string(100)
#  autonomia_pesca :integer
#  puerto_base     :string(250)
#


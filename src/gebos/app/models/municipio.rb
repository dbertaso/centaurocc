# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Municipio
# descripción: Migración a Rails 3
#

class Municipio < ActiveRecord::Base

  self.table_name = 'municipio'
  
  attr_accessible :id,
                  :estado_id,
                  :nombre,
                  :codigo_d3,
                  :eje_id,
                  :codigo_ine,
                  :estado_codigo_ine
                  
  belongs_to :estado
  belongs_to :eje
  has_many :persona_direccion
  has_many :solicitud_constitucion_garantia
  has_many :parroquia
  has_many :unidad_produccion
  has_many :registro_mercantil
  has_many :tecnico_campo
  has_many :area_influencia_tecnico
  has_many :oficina_area_influencia
  has_many :agencia_bancaria
  has_many :comunidad_indigena
  has_many :almacen_maquinaria
  has_many :empresa_transporte_maquinaria

  
  validates_presence_of :nombre,
    :message => I18n.t('Sistema.Body.Vistas.General.nombre') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerido')

  validates_uniqueness_of :nombre,
    :message => I18n.t('Sistema.Body.Vistas.General.nombre') << " " << I18n.t('Sistema.Body.Modelos.Errores.ya_existe'),
    :scope => :estado_id

  def validate
    #unless self.nombre.nil? || self.nombre.empty?
      #a = self.nombre[/^[a-zA-ZñÑáÁéÉíÍóÓúÚüÜÇ']+$/]
      #if a.nil?
        #errors.add(nil, "Nombre es inválido")
      #end
    #end 
  end


  before_destroy :check_for_parroquia
  
  def check_for_parroquia
    
    retorno = true
    
    parroquia = Parroquia.find_by_municipio_id(self.id)    
    unless parroquia.nil?
      errors.add(:municipio,I18n.t('Sistema.Body.Vistas.General.municipio') << " " << I18n.t('Sistema.Body.Modelos.Errores.usado_parroquia')) 
      retorno = false
    end 
    
    return retorno
    
  end



  def self.search(search, page, orden)    

    conditions=search  
  
    logger.info "Conditions ===> " << conditions.to_s
    paginate :per_page=>@records_by_page, :page=>page, :conditions=>conditions, :order=>orden
  end

end


# == Schema Information
#
# Table name: municipio
#
#  id                :integer         not null, primary key
#  estado_id         :integer         not null
#  nombre            :string(40)      not null
#  codigo_d3         :string(5)
#  eje_id            :integer         default(1)
#  codigo_ine        :string(10)
#  estado_codigo_ine :string(10)
#


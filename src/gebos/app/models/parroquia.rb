# encoding: UTF-8

class Parroquia < ActiveRecord::Base
  
  self.table_name = 'parroquia'
  
  attr_accessible :id,
				  :municipio_id,
				  :nombre,
				  :codigo_d3,
				  :codigo_ine ,
				  :municipio_codigo_ine
        
  belongs_to :municipio
  has_many :persona_direccion
  has_many :unidad_produccion
  has_many :tecnico_campo
  has_many :area_influencia_tecnico
  has_many :oficina_area_influencia

  has_many :comunidad_indigena
  
  validates_uniqueness_of :nombre, 
    :message => I18n.t('Sistema.Body.Vistas.General.nombre') << " " << I18n.t('Sistema.Body.Modelos.Errores.ya_existe'),
    :scope => :municipio_id

  validates_presence_of :nombre, 
  :message => I18n.t('Sistema.Body.Vistas.General.nombre') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerido')

  def validate
    #unless self.nombre.nil? || self.nombre.empty?
      #a = self.nombre[/^[a-zA-ZñÑáÁéÉíÍóÓúÚüÜÇ']+$/]
      #if a.nil?
        #errors.add(nil, "Nombre es inválido")
      #end
    #end 
  end

def self.search(search, page, sort)

    paginate :per_page => @records_by_page, :page => page,
             :conditions => search, :order => sort, :include=> [:municipio]
  end

end

# == Schema Information
#
# Table name: parroquia
#
#  id                   :integer         not null, primary key
#  municipio_id         :integer         not null
#  nombre               :string(40)      not null
#  codigo_d3            :string(7)
#  codigo_ine           :string(10)
#  municipio_codigo_ine :string(10)
#


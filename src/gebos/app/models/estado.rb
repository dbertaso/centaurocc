# encoding: utf-8

#
# autor: Diego Bertaso
# clase: estado
# descripción: Migración a Rails 3
#

class Estado < ActiveRecord::Base

  self.table_name = 'estado'
  attr_accessible :pais_id,
                  :region_id,
                  :nombre,
                  :codigo_d3,
                  :numeracion_instancia

  
  belongs_to :pais
  belongs_to :region
  has_many :ciudad
  has_many :registro_mercantil
  has_many :solicitud_constitucion_garantia
  has_many :configurador
  has_many :oficina_area_influencia

  has_many :silo

  has_many :tecnico_campo
  has_many :area_influencia_tecnico
  has_many :sector_tecnico
  has_many :agencia_bancaria
  has_many :comunidad_indigena
  has_many :almacen_maquinaria
  has_many :empresa_transporte_maquinaria
  has_many :casa_proveedora

  
  
   validates :nombre,
    :presence=>{:message => I18n.t('Sistema.Body.Vistas.General.nombre') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerido')},
    :uniqueness=>{:message => I18n.t('Sistema.Body.Vistas.General.nombre') << " " << I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}
   
   validates :region_id,
    :presence=>{:message => I18n.t('Sistema.Body.Vistas.General.region') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerida')}
    
   validates :pais_id, 
    :presence=>{:message => I18n.t('Sistema.Body.Vistas.General.pais') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}

  validate :validate  

  def self.find_by_nombre_and_pais_id(nombre, pais_id)
    self.find(:first, 
      :conditions => [ 'LOWER(nombre) = ? AND pais_id = ?',
      nombre.downcase, pais_id ])  
  end

  def self.oficinas
    estado = Estado.find(:all, :order=>'nombre')
    a = 1
    respuesta = "<tr>"
    res = ""
    estado.each{ |e|
      if a > 3
        a = 1
        respuesta << "</tr><tr class='lista0'>#{res}</tr><tr class='lista1'>"
        res = ""
      end
      respuesta << "<td align='center'>" << e.nombre << "</td>"
      oficinas = Oficina.find(:all, :conditions=>['municipio_id in (select id from municipio where estado_id = ?)', e.id])
      res << "<td style='width: 33% '>"
      oficinas.each{|o|
          res << "<li><input type='checkbox' id='oficina_id' name='oficina_select_id' value='#{o.id}' onClick='GenericcheckOne(this,form.todos," + '"oficinas"' + ");' />&nbsp;" << o.nombre << "</li>"
      }
      res  << "&nbsp;</td>"
      a = a + 1
    }
    respuesta << "</tr><tr class='lista0'>#{res}</tr><tr class='lista1'>"
    return respuesta.html_safe
  end

  def validate
    unless self.nombre.nil? || self.nombre.empty?
      a = self.nombre[/^[a-zA-ZñÑáÁéÉíÍóÓúÚüÜÇ' ]+$/]
      if a.nil?
        errors.add(:estado, I18n.t('Sistema.Body.Modelos.Actividad.Errores.nombre_invalido'))
      end
    end 
  end


before_destroy :check_for_ciudad_municipio
  
  def check_for_ciudad_municipio
    
    retorno = true   
    
    ciudad = Ciudad.find_by_estado_id(self.id)    
    unless ciudad.nil?
      errors.add(:estado,I18n.t('Sistema.Body.Controladores.Estado.Mensajes.no_se_puede_eliminar_ciudad')) 
      retorno = false
    end
    
    municipio = Municipio.find_by_estado_id(self.id)    
    unless municipio.nil?
      errors.add(:estado,I18n.t('Sistema.Body.Controladores.Estado.Mensajes.no_se_puede_eliminar_municipio')) 
      retorno = false
    end



    return retorno
    
  end


  def self.search(search, page, orden)    

    conditions=search  
  
    logger.info "Conditions ===> " << conditions.to_s
    paginate :per_page=>@records_by_page, :page=>page, :conditions=>conditions, :order=>orden, :include=>[:region]
  end


end


# == Schema Information
#
# Table name: estado
#
#  id                   :integer         not null, primary key
#  pais_id              :integer         not null
#  region_id            :integer         not null
#  nombre               :string(40)      not null
#  codigo_d3            :string(2)
#  numeracion_instancia :integer         default(0)
#  codigo_ine           :string(10)
#


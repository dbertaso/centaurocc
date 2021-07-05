# encoding: utf-8

#
# autor: Diego Bertaso
# clase: MiembroComite
# descripción: Migración a Rails 3
#

class MiembroComite < ActiveRecord::Base
  
  self.table_name = 'miembro_comite'

  attr_accessible :id,
                  :nombre,
                  :apellido,
                  :cedula,
                  :area,
                  :comite_reestructuracion

  validate :validate
  
  validates_presence_of :nombre,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"
    
  validates_presence_of :apellido,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.apellido')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"

  validates_presence_of :cedula, 
    :message => "#{I18n.t('Sistema.Body.Vistas.General.cedula')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"
         
  validates_length_of :nombre, :within => 1..60, :allow_nil => false,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('errors.messages.too_long.other')}"
      
  validates_length_of :apellido, :within => 1..60, :allow_nil => false,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.apellido')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.apellido')} #{I18n.t('errors.messages.too_long.other')}"
      
  validates_numericality_of :cedula, :only_integer=>true, :allow_nil => true,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.cedula')} #{I18n.t('Sistema.Body.Modelos.Errores.cedula_sin_decimales')}"
    
  validates_uniqueness_of :cedula, 
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"
  
  def validate
    unless self.nombre.nil? || self.nombre.empty?
      expr = /^[a-zA-ZñÑáÁéÉíÍóÓúÚüÜÇ' ]+$/
      a = expr.match(self.nombre)
      if a.nil?
        errors.add(:miembro_comite, "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}")
      end
    end
    unless self.apellido.nil? || self.apellido.empty?
      expr = /^[a-zA-ZñÑáÁéÉíÍóÓúÚüÜÇ' ]+$/
      a = expr.match(self.apellido)
      if a.nil?
        errors.add(:miembro_comite, "#{I18n.t('Sistema.Body.Vistas.General.apellido')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}")
      end
    end 
  end

  after_initialize :init

  def init
    #activo ya no pertenece como atributo en la tabla
    #self.activo = true
  end

  def eliminar(id)
  
    
    begin
      logger.debug "Entro en begin"
      comite_miembro = ComiteMiembro.count(:conditions=>"miembro_comite_id = #{id.to_s}")
      logger.debug "ComiteMiembro =========> #{comite_miembro.inspect}"
      @miembro_comite = MiembroComite.find(id)
      
      
      if comite_miembro > 0
        errors.add(:miembro_comite, "#{I18n.t('Sistema.Body.Vistas.General.el').capitalize} #{I18n.t('Sistema.Body.Vistas.General.miembro')} 
                                      #{@miembro_comite.nombre} #{@miembro_comite.apellido} #{I18n.t('Sistema.Body.Modelos.Errores.usado_comite_miembro')}")
        return false
      else
        @miembro_comite = MiembroComite.find(id)
        transaction do
          @miembro_comite.destroy
          return true
        end
      end
    rescue
      @miembro_comite = MiembroComite.find(id)
      errors.add(:miembro_comite, "#{I18n.t('Sistema.Body.Vistas.General.el').capitalize} #{I18n.t('Sistema.Body.Vistas.General.miembro')} 
                                      #{@miembro_comite.nombre} #{@miembro_comite.apellido} #{I18n.t('Sistema.Body.Modelos.Errores.usado')}")
      return false
    end
  end
   
  def self.search(search, page, sort)

    unless search.nil?
      paginate  :per_page => @records_by_page, :page => page,
                :conditions => search, :order => sort
    else
      paginate  :per_page => @records_by_page, :page => page,
                :order => sort

    end
    
  end   
end

# == Schema Information
#
# Table name: miembro_comite
#
#  id                      :integer         not null, primary key
#  nombre                  :string(60)      not null
#  apellido                :string(60)      not null
#  cedula                  :integer
#  area                    :string(100)
#  comite_reestructuracion :boolean
#


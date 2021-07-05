# encoding: utf-8
# 
# autor: Luis Rojas
# clase: EmpresaIntegrante
# descripción: Migración a Rails 3
#
class EmpresaIntegranteTipo < ActiveRecord::Base
  
  self.table_name = 'empresa_integrante_tipo'
  
  attr_accessible   :id, :empresa_integrante_id, :tipo

  belongs_to :empresa_integrante

  validates :tipo, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.tipo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort, 
      :joins => "INNER JOIN empresa_integrante ON empresa_integrante_tipo.empresa_integrante_id = empresa_integrante.id 
                 INNER JOIN persona ON empresa_integrante.persona_id = persona.id"
  end

  after_initialize :after_initialize
  def after_initialize    
    self.tipo = 'A' unless self.tipo
  end
  
  def destroy_with_empresa_integrante
    empresa_integrante_id = self.empresa_integrante_id
    self.destroy
    if EmpresaIntegranteTipo.count(:conditions=>"empresa_integrante_id=#{empresa_integrante_id}") == 0
      EmpresaIntegrante.destroy(empresa_integrante_id)
    end
  end
  
  def tipo_w
    tipo_nombre
  end
  
  def tipo_nombre
    case self.tipo
    when 'A'
      I18n.t('Sistema.Body.Vistas.General.accionista')
    when 'S'
      I18n.t('Sistema.Body.Vistas.General.asociado')
    when 'J'
      "#{I18n.t('Sistema.Body.Vistas.General.junta')} #{I18n.t('Sistema.Body.Vistas.General.directiva')}"
    when 'R'
      "#{I18n.t('Sistema.Body.General.representante')} #{I18n.t('Sistema.Body.Vistas.General.legal')}"
    when 'P'
      "#{I18n.t('Sistema.Body.General.representante')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.la')} #{I18n.t('Sistema.Body.Vistas.General.unidad')}  #{I18n.t('Sistema.Body.Vistas.General.productiva')}"
    when 'E'
      I18n.t('Sistema.Body.Vistas.General.empleado')
    when 'V'
      I18n.t('Sistema.Body.Vistas.General.vocero')
    end
  end

  def update_all(entidad, empresa_integrante, empresa_integrante_tipo)
    begin
      transaction do
        
        self.errors.add_errors_with_raise(
          entidad.errors) unless entidad.save
 
        self.errors.add_errors_with_raise(
          empresa_integrante.errors) unless empresa_integrante.save

        self.errors.add_errors_with_raise(
          self.errors) unless self.update_attributes empresa_integrante_tipo

      end
    rescue => detail

      self.errors.add(:empresa_integrante_tipo, detail.message)
 
      return false
    end
  end
end

# == Schema Information
#
# Table name: empresa_integrante_tipo
#
#  id                    :integer         not null, primary key
#  empresa_integrante_id :integer         not null
#  tipo                  :string(1)       default("A")
#


# encoding: utf-8

#
# 
# clase: EmpresaIntegrante
# descripción: Migración a Rails 3
#

class EmpresaIntegrante < ActiveRecord::Base

  self.table_name = 'empresa_integrante'
  
  attr_accessible   :id,
                    :persona_id,
                    :empresa_id,
                    :porcentaje_participacion,
                    :cargo,
                    :departamento,
                    :contacto,
                    :type,
                    :empresa_relacionada_id,
                    :instancia_empresa_id


  belongs_to :empresa
  belongs_to :persona
  #belongs_to :empresa_relacionada, :class_name=>'Empresa', :dependent => :destroy
  has_many :tipos, :class_name=>'EmpresaIntegranteTipo', :dependent => :destroy

  has_many :solicitud_rubro_solicitado

  
  validates :empresa, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.empresa')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerida')}"}  
  

  def valorinstancia    
    instancia = InstanciaEmpresa.find(self.instancia_empresa_id)
    instancia.descripcion
  end
   
end


# == Schema Information
#
# Table name: empresa_integrante
#
#  id                       :integer         not null, primary key
#  persona_id               :integer
#  empresa_id               :integer         not null
#  porcentaje_participacion :float
#  cargo                    :string(40)
#  departamento             :string(40)
#  contacto                 :boolean         default(FALSE)
#  type                     :string(26)      not null
#  empresa_relacionada_id   :integer
#  instancia_empresa_id     :integer
#


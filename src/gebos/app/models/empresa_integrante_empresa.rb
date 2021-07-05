class EmpresaIntegranteEmpresa < EmpresaIntegrante

  belongs_to :empresa_relacionada, :foreign_key=>'empresa_relacionada_id', :class_name=>'Empresa'

  validates_presence_of :empresa_relacionada,
    :message => " es requerido"

  validates_uniqueness_of :empresa_relacionada_id, :scope=>:empresa_id,
    :message => " ya existe"
   
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


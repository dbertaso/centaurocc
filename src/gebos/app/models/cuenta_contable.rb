# encoding: UTF-8

#
# autor: Marvin Alfonzo
# clase: CuentaContable
# descripción: Migración a Rails 3
#

class CuentaContable < ActiveRecord::Base
  
  self.table_name = 'cuenta_contable'
  
  attr_accessible :id,
				  :nombre,
				  :codigo,
				  :parent_id,
				  :auxiliar
  
  acts_as_tree :order => "codigo"
  
  belongs_to :programa 
  
  has_one :cuenta_contable_presupuesto 

  validates_uniqueness_of :codigo, 
    :message => "#{I18n.t('Sistema.Body.Vistas.Filtros.codigo')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}
    "    
  validates_uniqueness_of :nombre, 
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"
    
  validates :codigo,     
    :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.Filtros.codigo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
    
  validates :nombre,
    :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  before_destroy :antes_borrar
  
  def antes_borrar
  
    cuenta = AsientoContable.find_by_sql("select monto from asiento_contable where codigo_contable = '#{self.codigo}'")
    
    if cuenta.size > 0
     
     errors.add(:cuenta_contable, I18n.t('Sistema.Body.Modelos.CuentaContable.Errores.no_puede_eliminar_comprobante'))
     false
    
    end
    #nuevo codigo    
    cuenta_presupuesto = CuentaContablePresupuesto.find(:all,:conditions=>"cuenta_contable_id = #{self.id}")

        if cuenta_presupuesto.length > 0
     
           errors.add(:cuenta_contable,I18n.t('Sistema.Body.Modelos.CuentaContable.Errores.no_puede_eliminar_cta_presupuestaria'))
          false
        end
    #fin nuevo codigo  
 
    regla_contable = ReglaContable.find(:all,:conditions=>"codigo_contable = '#{self.codigo}'")

    if regla_contable.length > 0

       errors.add(:cuenta_contable, I18n.t('Sistema.Body.Modelos.CuentaContable.Errores.no_puede_eliminar_regla_contable'))
      false
    end

    
  end
  
  def self.search(search, page, sort)

    paginate :per_page => @records_by_page, :page => page,
             :conditions => search, :order => sort
  end
  
end



# == Schema Information
#
# Table name: cuenta_contable
#
#  id        :integer         not null, primary key
#  codigo    :string(25)      not null
#  nombre    :string(255)     not null
#  parent_id :integer
#  auxiliar  :boolean         default(FALSE)
#


# encoding: utf-8

#
# autor: Diego Bertaso
# clase: CuentaContablePresupuesto
# descripción: Migración a Rails 3
#

class CuentaContablePresupuesto < ActiveRecord::Base

  self.table_name = 'cuenta_contable_presupuesto'
  
  attr_accessible   :id,
                    :codigo,
                    :cuenta_contable_id,
                    :anio
                    
  belongs_to :cuenta_contable

  validates_presence_of :cuenta_contable, :codigo, :anio,
    :message => " es requerido"
    
  validates_numericality_of :anio, :only_integer=>true,
    :message => " el número es inválido"
    
  validates_uniqueness_of :anio, :scope=>[:cuenta_contable_id, :codigo],
    :message => "^El Año no puede estar repetido por cuenta contable"

    
  def after_initialize
    self.anio = Time.now.year unless self.anio
  end
  


  def validate
      
        #if self.anio==0
          #logger.debug "esto es " << self.anio.to_s         
          #errors.add(nil,"El año es inválido")
        #end

      
        #if self.anio.to_i > Time.now.year
          #logger.debug "esto es " << self.anio.to_s         
          #errors.add(nil,"El Año no puede ser mayor al año actual")
        #end
      

        #logger.debug "esto es eeee" << self.anio.to_s
        #if !(self.anio.is_a? Numeric)
          #logger.debug "esto es " << self.anio.to_s         
          #errors.add(nil,"El año es inválido")
        #end


      #if self.codigo.nil?
        
        #errors.add(nil,"debe introducir un codigo")
      #end
     

      #if self.cuenta_contable.nil?

        #errors.add(nil,"es requerido")
      #end

  end


end

# == Schema Information
#
# Table name: cuenta_contable_presupuesto
#
#  id                 :integer         not null, primary key
#  codigo             :string(20)      not null
#  cuenta_contable_id :integer
#  anio               :integer
#


# encoding: utf-8

#
# autor: Diego Bertaso
# clase: RechazoCobranza
# descripción: Inclusión y Migración a Rails 3

class RechazoCobranza < ActiveRecord::Base

  self.table_name = 'rechazo_cobranza'

  attr_accessible :id,
                  :fecha,
                  :archivo,
                  :prestamo_numero,
                  :solicitud_numero,
                  :cliente_id,
                  :monto_pago,
                  :codigo_error,
                  :descripcion_error,
                  :entidad_financiera_id
#
  
  belongs_to :ControlCobranza

  def self.graba_excepcion(campos)

    puts "Campos --------> " << campos.to_s
    if !campos.empty?

      @rechazo_cobranza = self.new(campos)
      @rechazo_cobranza.save
    end

  end

  def self.search(search, page, sort)

    paginate :per_page => @records_by_page, :page => page,
             :conditions => search, :order => sort
  end

end

# == Schema Information
#
# Table name: rechazo_cobranza
#
#  id                    :integer         not null, primary key
#  fecha                 :date            default(Mon, 01 Jan 1900)
#  archivo               :string(100)
#  prestamo_numero       :integer(8)      default(0)
#  solicitud_numero      :integer(8)      default(0)
#  cliente_id            :integer         default(0)
#  monto_pago            :decimal(, )     default(0.0)
#  codigo_error          :integer         default(0)
#  descripcion_error     :string(255)
#  entidad_financiera_id :integer         default(0)
#


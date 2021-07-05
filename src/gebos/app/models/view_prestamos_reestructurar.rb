# encoding: utf-8

require 'rubygems'
require 'fastercsv'

class ViewPrestamosReestructurar < ActiveRecord::Base

	self.table_name = "view_prestamos_reestructurar"

	attr_accessible :beneficiario,
			:cedula_rif,
            :cliente_id,
            :monto_solicitado,
            :deuda,
            :saldo_deudor,
            :contador_prestamos,
            :capital_vencido,
            :interes_vencido,
            :deuda_calculada,
            :estatus_reestructuracion,
            :reestructuracion_id




def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort
  end
  



end


# == Schema Information
#
# Table name: view_prestamos_reestructurar
#
#  beneficiario             :string
#  cedula_rif               :string
#  cliente_id               :integer
#  monto_solicitado         :decimal(, )
#  deuda                    :decimal(, )
#  saldo_deudor             :decimal(, )
#  contador_prestamos       :integer(8)
#  capital_vencido          :decimal(, )
#  interes_vencido          :decimal(, )
#  deuda_calculada          :decimal(, )
#  estatus_reestructuracion :integer
#  reestructuracion_id      :integer
#


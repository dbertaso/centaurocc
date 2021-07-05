# encoding: utf-8

#
# autor: Diego Bertaso
# clase: TasaConversionMoneda
# creado con Rails 3
#

class TasaConversionMoneda < ActiveRecord::Base

  self.table_name = 'tasa_conversion_moneda'

  attr_accessible :id,
                  :moneda_id,
                  :fecha,
                  :tasa_conversion,
                  :activo

end

# == Schema Information
#
# Table name: tasa_conversion_moneda
#
#  id              :integer         not null, primary key
#  moneda_id       :integer         not null
#  fecha           :date            not null
#  tasa_conversion :decimal(16, 2)  not null
#  activo          :boolean         default(TRUE), not null
#


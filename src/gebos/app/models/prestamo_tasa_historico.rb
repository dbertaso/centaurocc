class PrestamoTasaHistorico < ActiveRecord::Base

  self.table_name = 'prestamo_tasa_historico'

  attr_accessible :id,
                  :tasa_cliente,
                  :prestamo_id,
                  :tasa_id,
                  :fecha,
                  :fecha_f,
                  :tasa_cliente_f

  belongs_to :tasa
  belongs_to :prestamo

  def self.search(search, page, sort)

    unless search.nil?
      paginate  :per_page => @records_by_page, :page => page,
                :conditions => search, :order => sort
    else
      paginate  :per_page => @records_by_page, :page => page,
                :order => sort

    end

  end

  def fecha_f
   format_fecha(fecha)
  end

  def tasa_cliente_f
   format_f(self.tasa_cliente)
  end

  def referencia

   self.tasa.nombre
  end

end

# == Schema Information
#
# Table name: prestamo_tasa_historico
#
#  id           :integer         not null, primary key
#  tasa_cliente :float
#  prestamo_id  :integer         not null
#  tasa_id      :integer
#  fecha        :date            not null
#


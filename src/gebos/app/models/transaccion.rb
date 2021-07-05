# encoding: utf-8
class Transaccion < ActiveRecord::Base
  
  self.table_name = 'transaccion'
  
  attr_accessible :id,
    :meta_transaccion_id,
    :reversada,
    :fecha,
    :usuario_id,
    :prestamo_id,
    :tipo,
    :descripcion,
    :monto,
    :fecha_f

  has_many :acciones, :class_name=>"TransaccionAccion"
  belongs_to :meta_transaccion
  belongs_to :prestamo
  belongs_to :usuario

  def monto_transaccion_fm
    format_fm(self.monto)
  end

  def self.reversar(transaccion_id)
    transaccion = Transaccion.find(transaccion_id)
    if transaccion.prestamo_id==0
      transacciones = Transaccion.find_by_sql("select * from transaccion where id <> #{transaccion_id} and prestamo_id = 0 and reversada = false and id > #{transaccion_id}")  

    else
      transacciones = Transaccion.find_by_sql("select * from transaccion where id <> #{transaccion_id} and prestamo_id = #{transaccion.prestamo.id} and reversada = false and id > #{transaccion_id}")  
    end

    if transacciones.length >= 1
      return ". #{I18n.t('Sistema.Body.Modelos.Transaccion.Errores.error_reversar')}"
    end 

		#==================================================================================
		# LLAMADA DEL CAUSADO PARA SIGA ELABORADO POR ALEX CIOFFI 25/04/2013
		# transaccion.meta_transaccion_id == 17 or
		if (transaccion.meta_transaccion_id == 8)
			if (transaccion.meta_transaccion_id == 17)
				forma_desembolso = 'T'
			else
				forma_desembolso = 'I'
			end
			prestamo = Prestamo.find(transaccion.prestamo_id)
			desembolso = Desembolso.find_by_prestamo_id_and_realizado(prestamo.id,true, :order=>"fecha_valor desc", :limit=>1)
			begin
				transaction do
					SigaCausado.generar(prestamo.solicitud,prestamo,desembolso,'R',forma_desembolso)
				end
			end
		#==================================================================================
		# LLAMADA DEL PAGADO PARA SIGA ELABORADO POR ALEX CIOFFI 25/04/2013
			begin
				transaction do
					SigaPagado.generar(prestamo.solicitud,prestamo,desembolso,'R',forma_desembolso)
				end
			end
		#==================================================================================
		end


    
    begin
      params = {
        :transaccion_id=>transaccion_id,
      }
      transaction do
        valor = execute_sp('reversar_transaccion', params.values_at(:transaccion_id))
      end
      logger.info "Ejecutó la transaccion sin Problemas y retorna true"
      return true
    rescue => detail
      return false
    end
  end
  
  def fecha_f=(fecha)
    self.fecha = fecha
  end

  def fecha_f
    self.fecha.strftime(I18n.t('time.formats.gebos_large')) unless self.fecha.nil?
  end
  
  
  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort,
      :select=>'transaccion.*',
      :include=>["usuario", "meta_transaccion", "prestamo"]
  end

end


# == Schema Information
#
# Table name: transaccion
#
#  id                  :integer         not null, primary key
#  meta_transaccion_id :integer
#  reversada           :boolean         default(FALSE)
#  fecha               :datetime        not null
#  usuario_id          :integer         not null
#  prestamo_id         :integer         not null
#  tipo                :string(1)       default("L")
#  descripcion         :string(300)     not null
#  monto               :decimal(16, 2)
#


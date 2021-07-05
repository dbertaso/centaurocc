# encoding: utf-8

# clase: ReestructuracionCambioEstatus
# autor: Diego Bertaso
# descripción: Migración a Rails 3

class ReestructuracionCambioEstatus < Reestructuracion

  self.table_name = 'reestructuracion_cambio_estatus'


  attr_accessor :_estatus
  attr_accessor :_observaciones
  attr_accessor :_prestamo_id

  validates_presence_of :_estatus,
                        :message => I18n.t('Sistema.Body.Modelos.ReestructuracionCambioEstatus.Errores.estatus_obligatorio')
  validates_presence_of :_observaciones,
                        :message => I18n.t('Sistema.Body.Modelos.ReestructuracionCambioEstatus.Errores.observaciones_obligatorio')

  def self.aplicar_liberar(params,prestamo_id)

    ReestructuracionCambioEstatus.transaction do
      #
      #Agregar logica de negocio de reestructuracion financiera
      #
      prestamo = Prestamo.find(prestamo_id)

      estatus_anterior = prestamo.estatus
      prestamo.estatus = params['cambio']['estatus']
      prestamo.save!
      
      if prestamo.errors.empty?
      
        unless params['cambio']['estatus'] == 'J'
        
          prestamo.ejecutar_contabilizacion(params['cambio']['estatus'], estatus_anterior, prestamo)
        end
      
        #Registro de evento en la tabla detalle de Reestructuracion
        detalle = DetalleReestructuracion.new
        detalle.fecha = Time.now
        detalle.estatus_id = prestamo.solicitud.estatus_id
        detalle.solicitud_id = prestamo.solicitud_id
        detalle.motivo = 1
        detalle.causa_renuncia_id = 0
        detalle.observaciones = params['cambio']['observaciones']
        detalle.prestamo_id = prestamo.id
        detalle.save!
        return true
      end
    end
    
  end

end






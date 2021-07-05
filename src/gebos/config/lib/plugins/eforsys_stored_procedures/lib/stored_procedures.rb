module ActiveRecord
  class Base
  
    def iniciar_transaccion(p_prestamo_id, p_nombre, p_tipo, p_descripcion, p_usuario_id,p_monto)
      params = {
        :p_prestamo_id=>p_prestamo_id,
        :p_usuario_id=>p_usuario_id,
        :p_nombre=>p_nombre,
        :p_descripcion=>p_descripcion,
        :p_tipo=>p_tipo,
        :p_monto=>p_monto
      }
      valor = execute_sp('iniciar_transaccion', params.values_at(
        :p_prestamo_id,
        :p_usuario_id,
        :p_nombre,
        :p_tipo,
        :p_descripcion,
        :p_monto))
    end


    def execute_sp(name, params)
      Base.execute_sp(name, params)
    end


    def self.execute_sp(name, params)
      declaration = 'select ' + name + ' ('
      pass = false
      if !params.nil?
        for param in params
          declaration += "," if pass
          pass = true
          if param.class.to_s == 'String' || param.class.to_s == 'Date' || param.class.to_s == 'Time'
            declaration += "'" + param.to_s + "'"
          else
            declaration += param.to_s
          end
        end
      end
      declaration +=  ')'

      logger.info "DECLARACION FUNCION =====> #{declaration.to_s}"
      
      begin

        logger.info "VA A EMPRESAR"
        connection.execute declaration
        logger.info "deberia terminar"
      rescue
        logger.info "HUNO UN ERRORRRRRRRRRRRRRRRRRRRRRR"
        logger.error $!
        logger.info "YA TERMINO"
      end
    end
  end
end


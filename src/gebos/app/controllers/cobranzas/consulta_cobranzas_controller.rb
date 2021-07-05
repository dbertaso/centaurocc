# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Cobranzas::ConsultaCobranzasController
# descripción:Desarrollado Rails 3
#

class Cobranzas::ConsultaCobranzasController < FormController

  layout 'form_basic'

  def index

    @gestion = GestionCobranzas.find(params[:id])

    unless @gestion.nil?

      @prestamo = Prestamo.find(@gestion.prestamo_id)

      @cliente = Cliente.find(@prestamo.cliente_id)

      @performance = PerformanceCobranzas.find_by_prestamo_id_and_cliente_id(@prestamo.id, @cliente.id)

       if @cliente.class.to_s == 'ClienteEmpresa'

        @telefonos = EmpresaTelefono.find_by_empresa_id(@cliente.empresa_id)
        @correos = EmpresaEmail.find_by_empresa_id(@cliente.empresa_id)
      else
        @telefonos = PersonaTelefono.all(:conditions=>"persona_id = #{@cliente.persona_id.to_s}")
        @correos = PersonaEmail.all(:conditions=>"persona_id = #{@cliente.persona_id.to_s}")

        logger.info "Telefonos Modelo =======>  #{@telefonos.inspect}"
      end

      if @gestion.tipo_gestion_cobranza_id == 3
        @telecobranzas = Telecobranzas.find_by_gestion_cobranzas_id(@gestion.id)

        if @cliente.class.to_s == 'ClienteEmpresa'
          @telefono = EmpresaTelefono.find(@telecobranzas.telefono_id)
          @direccion = EmpresaDireccion.find(@telecobranzas.direccion_id)
        else
          @telefono = PersonaTelefono.find(@telecobranzas.telefono_id)
          @direccion = PersonaDireccion.find(@telecobranzas.direccion_id)
        end

        if @telecobranzas.senal_compromiso
          @compromiso = CompromisoPago.find_by_telecobranzas_id_and_prestamo_id(@telecobranzas.id, @prestamo.id)
        end
      end
    end

  end

end

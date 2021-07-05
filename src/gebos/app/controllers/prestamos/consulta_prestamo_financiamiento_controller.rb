class Prestamos::ConsultaPrestamoFinanciamientoController < FormTabTabsController

  def index
    @prestamo = Prestamo.find(params[:prestamo_id])
    #@prestamo_comentario = PrestamoComentario.find_by_sql("select * from prestamo_comentario where solicitud_id = " + @prestamo.solicitud_id.to_s + " AND partida_id = " + @prestamo.partida_id.to_s )
    #@prestamo_comentario = @prestamo_comentario[0]

    find_tasa_historico
  end

  def view
    list_view
  end

  def list_view
    _list
    form_list_view
  end

  def view_detail
    @prestamo = Prestamo.find(params[:id])
  end



  protected
  def common
    super
    @form_title = 'Consulta de Financiamiento'
    @form_title_record = 'Partida'
    @form_title_records = 'Partidas'
    @form_entity = 'prestamo'
    @form_identity_field = 'producto.partida.nombre'
    #@solicitud = Solicitud.find(params[:solicitud_id])
    @width_layout = '1200'
  end

  def find_tasa_historico

     if @prestamo.solicitud.programa.vinculo_tasa == 'N'

      tasa_historico_list = TasaHistorico.find(:all, :order=>'id',
      :conditions=>"programa_id = #{@prestamo.solicitud.programa.id} and tasa_valor_id in (select id from tasa_valor where tasa_id = #{@prestamo.tasa.id}) ")

      @valor_tasa = tasa_historico_list.last.tasa_cliente
      @fecha_tasa = tasa_historico_list.last.tasa_valor.fecha_resolucion_desde.strftime('%d/%m/%Y')

     else

       @prestamo_tasa = PrestamoTasaHistorico.find_by_prestamo_id(@prestamo.id)

       if !@prestamo_tasa.nil?
            @valor_tasa = @prestamo_tasa.tasa_cliente unless @prestamo_tasa.nil?
            @fecha_tasa = @prestamo_tasa.fecha.strftime('%d/%m/%Y') unless @prestamo_tasa.nil?

       else

          @regimen_tipo_cliente = RegimenTipoCliente.find_by_tipo_cliente_id(@prestamo.solicitud.cliente.tipo_cliente_id)

          logger.info "Regimen Tipo Cliente =====> " << @regimen_tipo_cliente.inspect
          unless @regimen_tipo_cliente.nil?

            @regimen_propiedad = RegimenPropiedad.find_by_id_and_activo(@regimen_tipo_cliente.regimen_propiedad_id,true)

            logger.info "Regimen Propiedad =====> " << @regimen_propiedad.inspect

            unless @regimen_propiedad.nil?
              tasa_valor = TasaValor.find_by_tasa_id(@regimen_propiedad.tasa_id, :order=>'fecha_resolucion_desde desc')

              unless tasa_valor.nil?
                @valor_tasa = tasa_valor.valor
                @fecha_tasa = tasa_valor.fecha_resolucion_desde.strftime("%d/%m/%Y")
              else
                @valor_tasa = 0
                @fecha_tasa = nil
              end

            end

          end

        end
     end
  end

  private

  def _list
    #@solicitud = Solicitud.find(params[:solicitud_id])
    conditions = ["prestamo.solicitud_id = ?", @solicitud.id]
    joins = 'INNER JOIN producto INNER JOIN partida ON producto.partida_id = partida.id ON prestamo.producto_id = producto.id'
    @params['sort'] = "partida.nombre" unless @params['sort']
    @total = Prestamo.count(:conditions=>conditions, :joins=>joins)
    @pages, @list = paginate(:prestamo, :class_name => 'Prestamo',
     :conditions => conditions,
     :per_page => @records_by_page,
     :joins => joins,
     :select=>'prestamo.*',
     :order_by => @params['sort'])

  end

end


# encoding: UTF-8
#
# autor: Luis Rojas
# clase: Solicitudes::SolicitudConsultaDesembolsosController
# descripción: Migración a Rails 3
#
class Solicitudes::SolicitudConsultaDesembolsosController < FormClassicController

  layout 'form_basic'

  def index
    fill
  end

  def list

    params['sort'] = "nombre_cliente" unless params['sort']

    #conditions = ""
    logger.info "PARAMETROS ======> #{params.inspect}"

    unless params[:moneda_id].nil? 
      unless params[:moneda_id][0].to_s==''      
        moneda = Moneda.find(params[:moneda_id][0].to_s)      
        conditions = "moneda_id = #{params[:moneda_id][0]} and estatus_p in ('C', 'E', 'V', 'L', 'K', 'H', 'J', 'P', 'F', 'A')"
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.moneda_igual')} '#{moneda.nombre}'"
      end
    end    

    unless params[:numero].to_s == '' || params[:numero].to_i <= 0
      conditions = " numero_solicitud = #{params[:numero].to_s} and estatus_p in ('C', 'E', 'V', 'L', 'K', 'H', 'J', 'P', 'F', 'A')"
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.nro')} #{I18n.t('Sistema.Body.Vistas.General.solicitud')} igual '#{params[:numero]}'"
    end

    unless params[:identificacion].to_s == ''
      conditions = " LOWER(identificacion) LIKE \'\%#{params[:tipo].downcase+params[:identificacion].to_s.strip.downcase}\%\' and estatus_p in ('C', 'E', 'V', 'L', 'K', 'H', 'J', 'P', 'F', 'A')"
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.nro')} #{I18n.t('Sistema.Body.Vistas.General.cedula')} / #{I18n.t('Sistema.Body.Vistas.General.rif')} contenga '#{params[:tipo]+params[:identificacion]}'"
    end
    unless params[:nombre].to_s == ''
      conditions = " LOWER(nombre_cliente) LIKE \'\%#{params[:nombre].to_s.strip.downcase}\%\' and estatus_p in ('C', 'E', 'V', 'L', 'K', 'H', 'J', 'P', 'F', 'A')"
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Vistas.General.del')} #{I18n.t('Sistema.Body.General.beneficiario')} contenga '#{params[:nombre]}'"
    end

    @list = ViewConsultaPrestamos.search(conditions, params[:page], params['sort'])
    @total=@list.count

    form_list

  end

  protected
  def common
    super
    @form_title = "#{I18n.t('Sistema.Body.Vistas.General.consulta')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.desembolso')}"
    @form_title_record = I18n.t('Sistema.Body.Vistas.General.solicitud')
    @form_title_records = I18n.t('Sistema.Body.Vistas.General.solicitud')
    @form_entity = 'solicitud'
    @form_identity_field = 'numero'
    @width_layout=800;
  end

  private

  def fill

    sentencia="SELECT mon.id AS id, mon.abreviatura,mon.nombre,        
                    CASE
                        WHEN mon.id = par.moneda_id THEN 
                        '1'::text
                        ELSE '0'::text
                    END AS no_va
               FROM moneda mon,parametro_general par 
               where mon.activo=true order by no_va desc, nombre;"
    @moneda_list=Moneda.find_by_sql(sentencia) 
  end
end
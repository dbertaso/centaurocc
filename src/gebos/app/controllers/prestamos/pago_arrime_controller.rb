# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Prestamos::PagoArrimeController
# descripción: Migración a Rails 3
#
class Prestamos::PagoArrimeController < FormTabsController

  skip_before_filter :set_charset, :only=>[:sector_change, :sub_sector_change, :rubro_form_change, :sub_rubro_change, :instruccion_pago, :rubro_change ]
  
  def index

  end

  def list

    params['sort'] = "solicitud_numero" unless params['sort']

    conditions = ""

    unless params[:solicitud_numero] == '' || params[:solicitud_numero].nil?
      conditions << " solicitud_numero =  #{params[:solicitud_numero]}"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.PagoArrime.FormSearch.tramite_igual')} '#{params[:solicitud_numero]}'"
    end

    unless params[:prestamo_numero] == '' || params[:prestamo_numero].nil?
      if conditions.empty?
        conditions << " prestamo_numero =  #{params[:prestamo_numero]} "
      else
        conditions << " AND prestamo_numero =  #{params[:prestamo_numero]}"
      end
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.PagoArrime.FormSearch.financiamiento_igual')} '#{params[:prestamo_numero]}'"
    end

    unless params[:identificacion] =='' ||  params[:identificacion].nil?

      if conditions.empty?
        conditions << " documento_beneficiario = '#{params[:tipo]}#{params[:identificacion]}'"
      else
        conditions << " AND documento_beneficiario = '#{params[:tipo]}#{params[:identificacion]}'"
      end
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.PagoArrime.FormSearch.cedula_rif_contenga')} '#{params[:tipo]}#{params[:identificacion]}'"
    end

    logger.info "Conditions =====> #{conditions}"
    unless  params[:nombre_beneficiario] == '' || params[:nombre_beneficiario].nil?
      if conditions.empty?
        conditions << " LOWER(nombre_beneficiario) LIKE '%#{params[:nombre_beneficiario].strip.downcase}%'"
      else
        conditions << " AND LOWER(nombre_beneficiario) LIKE '%#{params[:nombre_beneficiario].strip.downcase}%'"
      end
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.PagoArrime.FormSearch.beneficiario_semejante')} '#{params[:nombre_beneficiario]}'"
    end

    unless params[:rubro_id][0].to_i == 0 || params[:rubro_id][0].nil?
      rubro = Rubro.find(params[:rubro_id][0].to_i)

      if conditions.empty?
        conditions << " rubro_id = #{params[:rubro_id][0]}"
      else
        conditions << " and rubro_id = #{params[:rubro_id][0]}"
      end

      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.PagoArrime.FormSearch.rubro_igual')} '#{rubro.nombre}'"
    end
    unless params[:sub_rubro_id][0].to_i == 0 || params[:sub_rubro_id][0].nil?
      sub_rubro = SubRubro.find(params[:sub_rubro_id][0].to_i)

      if conditions.empty?
        conditions << " sub_rubro_id = #{params[:sub_rubro_id][0]}"
      else
        conditions << " and sub_rubro_id = #{params[:sub_rubro_id][0]}"
      end

      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.PagoArrime.FormSearch.sub_rubro_igual')} '#{sub_rubro.nombre}'"
    end
    unless params[:actividad_id][0].to_i == 0 || params[:actividad_id][0].nil?
      actividad = Actividad.find(params[:actividad_id][0].to_i)

      if conditions.empty?
        conditions << " actividad_id = #{params[:actividad_id][0]}"
      else
        conditions << " and actividad_id = #{params[:actividad_id][0]}"
      end

      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.PagoArrime.FormSearch.actividad_igual')} '#{actividad.nombre}'"
    end

    unless params[:silo_id][0].to_i == 0 || params[:silo_id][0].nil?
      silo = Silo.find(params[:silo_id][0].to_i)
      if conditions.empty?
        conditions << " silo_id = #{params[:silo_id][0].to_s} "
      else
        conditions << " and silo_id = #{params[:silo_id][0].to_s} "
      end

      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.PagoArrime.FormSearch.silo_igual')} '#{silo.nombre}'"
    end

    
    @list = ViewBoletasArrimeConfirmadas.search(conditions, params[:page], params[:sort])
    @total=@list.count
    form_list
  end

  def instruccion_pago

    if params[:cuenta_id].empty? or params[:cuenta_id].nil?

      render :update do |page|
        page.alert I18n.t('Sistema.Body.Controladores.PagoArrime.Mensajes.debe_seleccionar_boleta')
        return
      end
    end


    boletas = params[:cuenta_id].split(',')

    codigo,ids = BoletaArrime.instruccion_pago(boletas,@usuario.id)

    case codigo

    when 0

      render :update do |page|
        page.hide 'mensaje'
        page.hide 'errores'
        ids = params[:cuenta_id].split(',')
        ids.each {|id|
          page.remove "row_#{id}"
        }
        page.<< 'document.getElementById("cuenta_id").value = "";document.getElementById("cuenta_id1").value = "";'
        page.replace_html 'mensaje', "<div class=\"msg-notice\" id=\"message\" style=\"text-align: center\">#{I18n.t('Sistema.Body.Controladores.PagoArrime.Mensajes.pago_aplicado_con_exito')}</div>"
        page.show 'mensaje'
      end


    when 10100

      render :update do |page|
        page.hide 'mensaje'
        page.hide 'errores'
        page.<< 'document.getElementById("cuenta_id").value = "";document.getElementById("cuenta_id1").value = "";'
        page.replace_html 'mensaje', "<div class=\"msg-notice\" id=\"message\" style=\"text-align: center\">#{I18n.t('Sistema.Body.Controladores.PagoArrime.Mensajes.no_existe_boleta')}</div>"
        page.show 'errores'
      end

    end
  end
  
  def rubro_change
    sub_rubro_fill(params[:rubro_id])
    render :update do |page|
      page.replace_html 'sub-rubro-select', :partial => 'sub_rubro_select'
      page.show 'sub-rubro-select'
    end
  end
  
  def sub_rubro_change
    actividad_fill(params[:sub_rubro_id])
    render :update do |page|
      page.replace_html 'actividad-select', :partial => 'actividad_select'
      page.show 'actividad-select'
    end
  end
  
  def sub_rubro_fill(rubro_id)
    if rubro_id.to_s.length > 0
      @sub_rubro_list = SubRubro.where("rubro_id = ?", rubro_id)
    else
      @sub_rubro_list = SubRubro.where("rubro_id = 0")
    end
    actividad_fill(0)
  end
  
  def actividad_fill(sub_rubro_id)
    if sub_rubro_id.to_s.length > 0
      @actividad_list = Actividad.where("sub_rubro_id = ?", sub_rubro_id)
    else
      @actividad_list = Actividad.where("sub_rubro_id = 0")
    end
  end
  

  protected

  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.PagoArrime.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.PagoArrime.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.PagoArrime.FormTitles.form_title_records')
    @form_entity = 'pago_cliente'
    @form_identity_field = 'numero'
    @width_layout = 1250;
    @records_by_page = 1000
    @silo_list = Silo.where("id in (select silo_id from boleta_arrime)").order('nombre')
    if @silo_list.length == 0 
      @silo_list = []
    end
    @rubro_list = Rubro.where("id in (select rubro_id from boleta_arrime)").order('nombre')
    if @rubro_list.length == 0
      @rubro_list = []
    end
    @sub_rubro_list = SubRubro.where("id in (select sub_rubro_id from boleta_arrime)").order('nombre')
    if @sub_rubro_list.length == 0
      @sub_rubro_list = []
    end
    @actividad_list = Actividad.where("id in (select actividad_id from boleta_arrime)").order('nombre')
    if @actividad_list.length == 0
      @actividad_list = []
    end
  end
end

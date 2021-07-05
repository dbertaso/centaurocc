# encoding: utf-8
# 
# autor: Luis Rojas
# clase: Finanzas::ConsultaAbonoArrimeConfirmacionTransferenciaController
# descripción: Migración a Rails 3

class Finanzas::ConsultaAbonoArrimeConfirmacionTransferenciaController < FormClassicController

  def index

  end
 
  def list
    params['sort'] = "nro_tramite" unless params['sort']
    conditions = ' estatus_excedente > 30000 '

    unless params[:identificacion].nil? ||  params[:identificacion].empty?
      conditions << "  AND cedula_rif LIKE '%#{params[:tipo]+params[:identificacion].strip.downcase}%' "
      @form_search_expression << "Rif o Cédula contenga '#{params[:tipo]+params[:identificacion]}'"
    end
    unless params[:numero].nil? || params[:numero].empty?
      conditions << " AND nro_tramite =  #{params[:numero].to_i}"
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.nro')} #{I18n.t('Sistema.Body.Vistas.General.solicitud')} #{I18n.t('Sistema.Body.Vistas.General.igual')} '#{params[:numero]}'"
    end
    unless params[:nombre].nil? || params[:nombre].empty?
      conditions << " AND LOWER(beneficiario) LIKE  '%#{params[:nombre].strip.downcase}%'"
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Vistas.General.del')} #{I18n.t('Sistema.Body.General.beneficiario')} #{I18n.t('Sistema.Body.Vistas.General.contenga')} '#{params[:nombre]}'"
    end
    errores = ""
	  @fecha_inicio = params[:dfecha]
	  @fecha_fin = params[:hfecha]
	  valores_fecha = false
	  if (!@fecha_inicio.blank? && !@fecha_fin.blank?)
      errores << "<li><b>#{I18n.t('Sistema.Body.Vistas.General.fecha_desde')}</b> - #{I18n.t('Sistema.Body.Vistas.General.fecha_desde')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalida')}</li>" if !fecha?(@fecha_inicio) 
      errores << "<li><b>#{I18n.t('Sistema.Body.Vistas.General.fecha_hasta')}</b> - #{I18n.t('Sistema.Body.Vistas.General.fecha_hasta')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalida')}</li>" if !fecha?(@fecha_fin)
      errores << "<li><b>#{I18n.t('Sistema.Body.Vistas.General.fecha_hasta')}</b> - #{I18n.t('Sistema.Body.Vistas.General.fecha_hasta')} #{I18n.t('Sistema.Body.Vistas.General.debe_ser_mayor_que')} #{I18n.t('Sistema.Body.Vistas.General.fecha_desde')}</li>" if conversionfecha(@fecha_fin) < conversionfecha(@fecha_inicio)		
      valores_fecha = true
	  elsif (!@fecha_inicio.blank? || !@fecha_fin.blank?)
      errores << "<li><b>#{I18n.t('Sistema.Body.Vistas.General.fecha_desde')}</b> - #{I18n.t('Sistema.Body.Vistas.General.fecha_desde')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}</li>" if @fecha_inicio.blank?
      errores << "<li><b>#{I18n.t('Sistema.Body.Vistas.General.fecha_hasta')}</b> - #{I18n.t('Sistema.Body.Vistas.General.fecha_hasta')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}</li>" if @fecha_fin.blank?
	  end  
    if errores.length > 0
      logger.debug "paso por el if" 
      render :update do |page|
        page.hide 'message'
        page.hide 'error'
        page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>" << errores << '</UL></p>'
        page.show 'errorExplanation'
        page.<< "window.scrollTo(0,0);"
        #return false            
      end
    else
      if valores_fecha
        conditions = "#{conditions} and (fecha_valor between '" << @fecha_inicio << "' and '" << @fecha_fin << "')"
      end
      
      @list = ViewExcedenteArrime.search(conditions, params[:page], params[:sort])
      @total=@list.count

      form_list
	  end
	    
  end
  
  protected
  def common
    super
    @form_title = 'Consulta de abono por excedente en arrime'
    @form_title_record = 'Abonos'
    @form_title_records = 'Abonos'
    @form_entity = 'financiamiento'
    @form_identity_field = 'numero'
    @records_by_page = 25
    @width_layout = '1100'
  end

  def fecha?(valor, formato = "%d/%m/%Y")
    Date.strptime(valor, formato)
  rescue ArgumentError
    false
  end
  
  def conversionfecha(valor, formato = "%d/%m/%Y")
    Date.strptime(valor, formato)
  rescue ArgumentError
    return ''
  end
  
end
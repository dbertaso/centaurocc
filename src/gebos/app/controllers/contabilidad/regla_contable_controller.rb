# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Contabilidad::ReglaContableController
# descripción: Migración a Rails 3

class Contabilidad::ReglaContableController < FormAjaxController

  skip_before_filter :set_charset, :only => [:edit, :new, :list]
  
	def index
		list
	end
	
  def list
    fill_all
    
    if params['sort'] == 'button_cancel'
      params['sort'] = ''
    end

    if params['id'] == 'button_cancel'
      params['id'] = 'transaccion_contable_id'
    end
    
    params['sort'] = "transaccion_contable_id, fuente_recursos_id, modalidad_pago, estatus, plazos, secuencia" unless params['sort']
    @condition = "regla_contable.id > 0"

    logger.debug "Parametros =========> #{params.inspect}"
    unless params[:transaccion_contable_id].to_s.empty? or
           params[:transaccion_contable_id].nil?  or
           params[:transaccion_contable_id].to_i == 0

      @condition << " and transaccion_contable_id = #{params[:transaccion_contable_id].to_s}"
      
      if params[:transaccion_contable_id].to_i > 0 
        transaccion_contable = TransaccionContable.find(params[:transaccion_contable_id].to_i, :select=>'nombre') 
        @form_search_expression << " #{I18n.t('Sistema.Body.Controladores.Contabilidad.ReglaContable.FormSearch.codigo_transaccion_igual')} #{transaccion_contable.nombre}" 
      end
    end

    unless params[:modalidad_pago].to_s.empty? || params[:modalidad_pago].nil? || params[:modalidad_pago] == 'X'
      @condition << " and modalidad_pago = \'#{params[:modalidad_pago].to_s}\'"

      @form_search_expression << " #{I18n.t('Sistema.Body.Controladores.Contabilidad.ReglaContable.FormSearch.modalidad_pago_igual')} #{modalidad_pago_helper(params[:modalidad_pago])}" 

    end

    unless params[:estatus].to_s.empty? || params[:estatus].nil? || params[:estatus] == 'X'
      @condition << " and estatus = \'#{params[:estatus].to_s}\'"
      
      @form_search_expression << " #{I18n.t('Sistema.Body.Controladores.Contabilidad.ReglaContable.FormSearch.estatus_igual')} #{estatus_prestamo(params[:estatus])}" 

    end
    
    unless params[:programa_id].nil? || params[:programa_id].to_s.empty? || params[:programa_id].to_i == 0
      @condition << " and programa_id = #{params[:programa_id].to_s}"
      if params[:programa_id].to_i >  0
        programa = Programa.find(params[:programa_id].to_i, :select=>'nombre')
        @form_search_expression << " #{I18n.t('Sistema.Body.Controladores.Contabilidad.ReglaContable.FormSearch.programa_igual')} #{programa.nombre}"
      end
    end

    logger.debug "Fuente Recursos =====> #{params[:fuente_recursos_id].inspect}"
    unless params[:fuente_recursos_id].nil? or
           params[:fuente_recursos_id].to_s.empty? or
           params[:fuente_recursos_id].to_i == 0

      @condition << " and fuente_recursos_id = #{params[:fuente_recursos_id].to_s}"
      @form_search_expression << " #{I18n.t('Sistema.Body.Controladores.Contabilidad.ReglaContable.FormSearch.institucion_igual')} #{fuente_recursos_helper(params[:fuente_recursos_id].to_i)}"
    end
    
    logger.debug "Plazos =====> #{params[:plazos].inspect}"
    plazo = ''
    unless params[:plazos].nil? || params[:plazos].to_s.empty? || params[:plazos] == "0"
      @condition << " and plazos = \'#{params[:plazos].to_s}\'"
      logger.debug "Condicion =====> #{@condition}"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.Contabilidad.ReglaContable.FormSearch.plazo_igual')} #{nombre_plazo_helper(params[:plazos])}"
    end
    
    logger.debug "Condiciones ======> #{@condition.to_s}"

    joins = "JOIN programa ON regla_contable.programa_id = programa.id "
    joins += "JOIN moneda ON programa.moneda_id = moneda.id "
    joins += "JOIN transaccion_contable tc ON regla_contable.transaccion_contable_id = tc.id "
    joins += "JOIN cuenta_contable cc ON cc.codigo = regla_contable.codigo_contable "
    joins += "LEFT JOIN entidad_financiera ef ON regla_contable.entidad_financiera_id = ef.id "

    @list = ReglaContable.search(@condition, params[:page], params[:sort], joins)
    @total=@list.count
    

    form_list
  end
	
  def new
    fill_all
    @regla_contable = ReglaContable.new
		form_new @regla_contable
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def save_new
    @regla_contable = ReglaContable.new(params[:regla_contable])
		form_save_new @regla_contable
  end
  
  def delete
    @regla_contable = ReglaContable.find(params[:id])
		form_delete @regla_contable
  end
  
  def edit
    fill_all
    logger.info "params ========> #{params.inspect}"
    @regla_contable = ReglaContable.find(params[:id])
		form_edit @regla_contable
  end

  def save_edit
    @regla_contable = ReglaContable.find(params[:id])
		form_save_edit @regla_contable
  end

  def cancel_edit
    @regla_contable = ReglaContable.find(params[:id])
		form_cancel_edit @regla_contable
  end


  def fill_all
    @programa_list = Programa.find(:all, :order=>'nombre')
    @transaccion_contable_list = TransaccionContable.find(:all, :order=>'nombre')
    logger.info "Transaccion contable ===========> #{@transaccion_contable_list.inspect}"
    @cuenta_contable_list = CuentaContable.find(:all, :order=> 'codigo')
    @origen_fondo_list = OrigenFondo.find(:all, :order => 'nombre')
    @entidad_financiera_select = EntidadFinanciera.find(:all, :select=> 'DISTINCT entidad_financiera.id, entidad_financiera.nombre',
                                                       :conditions=>'entidad_financiera.activo=true and id in (select entidad_financiera_id from cuenta_bcv where cuenta_bcv.recaudador = true)',
                                                       :order=>"entidad_financiera.nombre")

    logger.info "entidad_financiera ===========> #{@entidad_financiera_select.inspect}"
    
  end

  protected

  def common
    super
    @width_layout=1200;
    @form_title = I18n.t('Sistema.Body.Controladores.Contabilidad.ReglaContable.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.Contabilidad.ReglaContable.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.Contabilidad.ReglaContable.FormTitles.form_title_records')
    @form_entity = 'regla_contable'
    @form_identity_field = 'transaccion_contable_id'
    @form_search_expression = []
    
  end
  
end

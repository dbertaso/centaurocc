# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Basico::ConfiguracionReversoController
# descripción: Build in Rails 3
#
class Basico::ConfiguracionReversoController < FormAjaxController


	def index
    fill
		list
	end
	
  def list

    params['sort'] = "programa_id" unless params['sort']

    @condition = ''
    @form_search_expression = []
    logger.debug "Parametros =========> #{params.inspect}"
    unless params[:programa_id].to_s.empty? or
           params[:programa_id].nil?  or
           params[:programa_id].to_i == 0

    
      @condition = "programa_id = #{params[:programa_id].to_s}"
      
      logger.info "Condition =====> #{@condition.to_s}"
      if params[:programa_id].to_i > 0 
        programa = Programa.find(params[:programa_id].to_i, :select=>'nombre')
        logger.info "Programa =====> #{programa.inspect}"
        unless programa.nil?
          @form_search_expression << " #{I18n.t('Sistema.Body.Controladores.SearchComun.programa_igual')} #{programa.nombre}" 
        end
      end
    end

    unless params[:estatus_origen_id].to_s.empty? || params[:estatus_origen_id].nil? || params[:estatus_origen_id] == 'X'

      unless @condtion == ''
        @condition << " and estatus_origen_id = \'#{params[:estatus_origen_id].to_s}\'"
      else
        @condition = "estatus_origen_id = \'#{params[:estatus_origen_id].to_s}\'"
      end

      if params[:estatus_origen_id].to_i > 0 
        estatus_origen = Estatus.find(params[:estatus_origen_id].to_i, :select=>'nombre')
        unless estatus_origen.nil?
          @form_search_expression << " #{I18n.t('Sistema.Body.Controladores.SearchComun.estatus_origen_igual')} #{estatus_origen.nombre}" 
        end
      end
    end

    unless params[:estatus_destino_id].to_s.empty? || params[:estatus_destino_id].nil? || params[:estatus_destino_id] == 'X'

      unless @condition == ''
        @condition << " and estatus_destino_id = \'#{params[:estatus_destino_id].to_s}\'"
      else
        @condition = "estatus_destino_id = \'#{params[:estatus_destino_id].to_s}\'"
      end

      if params[:estatus_destino_id].to_i > 0

        estatus_destino = Estatus.find(params[:estatus_destino_id].to_i, :select=>'nombre')
        unless estatus_destino.nil?
          @form_search_expression << " #{I18n.t('Sistema.Body.Controladores.SearchComun.estatus_origen_igual')} #{estatus_destino.nombre}" 
        end
      end
    end
    
    unless params[:ruta_primaria].nil? || params[:ruta_primaria].to_s.empty? || params[:ruta_primaria] == ' '

      unless @condition == ''
        @condition << " and ruta_primaria like '%#{params[:ruta_primaria].to_s}%'"
      else
        @condition = "ruta_primaria like '%#{params[:ruta_primaria].to_s}%'"
      end

      @form_search_expression << " #{I18n.t('Sistema.Body.Controladores.SearchComun.main_form_contenga')} #{params[:ruta_primaria].to_s}"

    end

    if @condition == ''
      @condition = "estatus_origen_id > 9000"
    end

    @list = ConfiguracionReverso.search(@condition, 
                                      params[:page], 
                                      params['sort'])

    if @list.nil? or
       @list.empty?

       render :update do |page|
        page.<< "varEnviado=false "
        page.alert "No hay registros que cumplan los criterios solicitados"
       end
       return

    end

    logger.info "@list =====> #{@list.class.to_s}  <----> #{@list.inspect}"
    @total=@list.count
    fill
    form_list

  end
	
  def new
    fill
    @configuracion_reverso = ConfiguracionReverso.new
		form_new @configuracion_reverso
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def save_new
    @configuracion_reverso = ConfiguracionReverso.new(params[:configuracion_reverso])
		form_save_new @configuracion_reverso
  end
  
  def delete
    @configuracion_reverso = ConfiguracionReverso.find(params[:id])
		form_ajaxdelete_refresh @configuracion_reverso
  end
  
  def edit
    fill
    @configuracion_reverso = ConfiguracionReverso.find(params[:id])
		form_edit @configuracion_reverso
  end
  def save_edit
    @configuracion_reverso = ConfiguracionReverso.find(params[:id])
		form_save_edit @configuracion_reverso
  end
  def cancel_edit
    @configuracion_reverso = ConfiguracionReverso.find(params[:id])
		form_cancel_edit @configuracion_reverso
  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.ConfiguracionReverso.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.ConfiguracionReverso.FormTitles.form_title')
    @form_title_records = I18n.t('Sistema.Body.Controladores.ConfiguracionReverso.FormTitles.form_title_records')
    @form_entity = 'configuracion_reverso'
    @form_identity_field = 'programa_id'
  end
  
  def fill
    @ruta = ViewRutaTramite.all
    @estatus_origen = Estatus.all(:conditions=>"id < 20000 and id > 9000", :order=>"id")
    @estatus_destino = Estatus.all(:conditions=>"id < 20000 and id > 9000", :order => "id")
    @programa = Programa.all(:conditions=>"activo = true", :order=>"nombre", :select=>"id, nombre")
  end

end

class Basico::CronogramaDesembolsoController < FormAjaxTabsController

  def index

    @rubro = Rubro.find(params[:id])
    @sector = Sector.find(@rubro.sector_id)
    list
  end

  def list
    rubro_id = params[:id]
    @cronograma_desembolso = CronogramaDesembolso.find(:all, :conditions => "rubro_id = #{params[:id]}")
    params['sort'] = "numero_desembolso" unless params['sort']
    @condition = "rubro_id = #{params[:id]}"
    @list = CronogramaDesembolso.search(@condition, params[:page], params['sort'])
    @total=@list.count
    @pages = @list.clone

    form_list

  end

  def new

    rubro_id = params[:id]
    @cronograma_desembolso = CronogramaDesembolso.new(:rubro_id => rubro_id, :numero_desembolso => @numero_desembolso)

    # generando el nro de desembolso
    ultimo_desembolso =  CronogramaDesembolso.find_by_sql("select id, numero_desembolso from cronograma_desembolso where rubro_id = #{rubro_id} order by id desc")
    unless ultimo_desembolso.empty?
      ultimo_desembolso = ultimo_desembolso[0].numero_desembolso
    else
      ultimo_desembolso = 1
    end
    @numero_desembolso = ultimo_desembolso += 1


    @cronograma_desembolso.dias = 0
    logger.debug @numero_desembolso.to_s
    form_new @cronograma_desembolso
  end

  def save_new

    rubro_id = params[:id]
    # generando el nro de desembolso
    ultimo_desembolso =  CronogramaDesembolso.find_by_sql("select id, numero_desembolso from cronograma_desembolso where rubro_id = #{rubro_id} order by id desc")
    unless ultimo_desembolso.empty?
      ultimo_desembolso = ultimo_desembolso[0].numero_desembolso
    else
      ultimo_desembolso = 1
    end
    @numero_desembolso = ultimo_desembolso += 1
    # Fin generación del nro de desembolso

    @cronograma_desembolso = CronogramaDesembolso.new(params[:cronograma_desembolso])
    @cronograma_desembolso.rubro_id = rubro_id
    @cronograma_desembolso.numero_desembolso = @numero_desembolso

    form_save_ajaxnew @cronograma_desembolso

  end

  def cancel_new
    form_cancel_new
  end

  def edit

    logger.info "Parametros =======> #{params.inspect}"
    @cronograma_desembolso = CronogramaDesembolso.find(params[:id])

    logger.info "Cronograma =======> #{@cronograma_desembolso.inspect}"
    @numero_desembolso = @cronograma_desembolso.numero_desembolso
    form_edit @cronograma_desembolso
  end

  def save_edit
    @cronograma_desembolso = CronogramaDesembolso.find(params[:id])
    form_save_edit @cronograma_desembolso
  end

  def cancel_edit
    @cronograma_desembolso = CronogramaDesembolso.find(params[:id])
    form_cancel_edit @cronograma_desembolso
  end

  def delete

    id = params[:id]
    rubro_id = params[:rubro_id]
    @cronograma_desembolso = CronogramaDesembolso.find(params[:id])
    logger.debug @cronograma_desembolso.inspect
    success = true
    success &&=@cronograma_desembolso.valida_eliminar_desembolso(id,rubro_id)
    if success
      form_ajaxdelete_refresh @cronograma_desembolso
    else
      render :update do |page|
        page.hide 'message'
        page.form_error
      end
      return false
    end

  end

  protected
  def common
   super
    @form_title = I18n.t('Sistema.Body.Controladores.CronogramaDesembolso.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.CronogramaDesembolso.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.CronogramaDesembolso.FormTitles.form_title_records')
    @form_entity = 'cronograma_desembolso'
    @form_identity_field = 'numero_desembolso'

  end


end

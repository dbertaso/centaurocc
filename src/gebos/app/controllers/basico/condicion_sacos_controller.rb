# encoding: utf-8
class Basico::CondicionSacosController < FormTabTabsController

  skip_before_filter :set_charset, :only=>[:tabs]
  
  def index
    
    @acta_silo = ActaSilo.find(params[:acta_silo_id])
    list
  end

  def list
    @silo = Silo.find(params[:silo_id])
    params['sort'] = "silo.nombre, acta_silo.nro_acta, condicion_saco.nombre" unless params['sort']
    conditions = "silo.id =#{params[:silo_id]} and acta_silo.id =#{params[:acta_silo_id]}"
    
    @list = CondicionSaco.search(conditions, params[:page], params[:sort])
    @total=@list.count

#    @pages, @list = paginate(:condicion_saco, :class_name => 'CondicionSaco',
#     :include => [:silo, :acta_silo],
#     :conditions => @condition,
#     :select=>'condicion_saco.*',
#     :per_page => @records_by_page,
#     :order_by => @params['sort'])
#    @total=@pages.item_count
    form_list
  end

  def new
    @silo = Silo.find(params[:silo_id])
    @acta_silo = ActaSilo.find(params[:acta_silo_id])
    @condicion_saco = CondicionSaco.new
  end

  def save_new
    @condicion_saco = CondicionSaco.new(params[:condicion_saco])
    @condicion_saco.silo_id = (params[:silo_id])
    @condicion_saco.acta_silo_id = (params[:acta_silo_id])
    logger.info"XXXXX==============>>>>"<<params[:acta_silo_id].inspect
    form_save_new @condicion_saco
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def delete
    @condicion_saco = CondicionSaco.find(params[:id])
    result = @condicion_saco.eliminar(params[:id])
    if result == false
      render :update do |page|
        page.form_error
      end
      return
    else
      render :update do |page|
        page.form_delete @condicion_saco, 'condicion_saco'
      end
    end
  end
  
  def edit
    @condicion_saco = CondicionSaco.find(params[:id])
    @silo = @condicion_saco.silo
    @acta_silo = @condicion_saco.acta_silo
  end

  def save_edit
    @condicion_saco = CondicionSaco.find(params[:id])
    form_save_edit @condicion_saco
  end

  def cancel_edit
    @condicion_saco = CondicionSaco.find(params[:id])
    form_cancel_edit @condicion_saco
  end

  protected
  def common
   super
    @form_title = I18n.t('Sistema.Body.Vistas.Arrime.HeaderCondicionSaco.form_title')
    @form_title_record = I18n.t('Sistema.Body.Vistas.Arrime.HeaderCondicionSaco.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Vistas.Arrime.HeaderCondicionSaco.form_title_records')
    @form_entity = 'condicion_saco'
    @form_identity_field = 'nombre'
    @width_layout = '850'
  end
  
end

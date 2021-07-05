class Basico::TasaValorController < FormAjaxTabsController

  def index

    list
  end

  def list
    _list

    form_list

  end

  def new
    @tasa = Tasa.find(params[:tasa_id])
    @tasa_valor = TasaValor.new
    form_new @tasa_valor
  end

  def view
    list_view
  end

  def list_view
    _list
    form_list_view
  end

  def save_new
    @tasa = Tasa.find(params[:tasa_id])
    @tasa_valor = TasaValor.new(params[:tasa_valor])
    @tasa_valor.fecha_actualizacion_f = Date.today

    if @tasa.add_tasa_valor(@tasa_valor)

      identity_field = entity_field(@tasa_valor, @form_identity_field) unless @form_identity_field.nil?
      render :update do |page|
        message = "#{@form_title_record} '#{identity_field}' #{I18n.t('Sistema.Body.Controladores.Mensaje.insercion')}"
        page.hide 'error'
        page.hide 'form_new'
        page.show 'button_new'
        page.replace_html 'message', message
        page.<< "new Ajax.Request('/basico/tasa_valor?sort=tasa_valor.fecha_resolucion_desde+DESC&;tasa_id=#{@tasa.id}', {asynchronous:true, evalScripts:true, onComplete:function(request){eval(\"Element.show('message')\") } } );"
        options={:action=>'index', :tasa_id=>params[:tasa_id]}
        page.redirect_to options
      end
    else
      render :update do |page|
        page.form_error 'form_new'
      end
    end
  end

  def cancel_new
    form_cancel_new
  end

  def delete
    @tasa = Tasa.find(params[:tasa_id])
    @tasa_valor = TasaValor.find(params[:id])
    form_delete @tasa_valor
  end

  def edit
    @tasa = Tasa.find(params[:tasa_id])
    @tasa_valor = TasaValor.find(params[:id])
    form_edit @tasa_valor
  end
  def save_edit
    @tasa = Tasa.find(params[:tasa_id])
    @tasa_valor = TasaValor.find(params[:id])
    form_save_edit @tasa_valor
  end
  def cancel_edit
    @tasa = Tasa.find(params[:tasa_id])
    @tasa_valor = TasaValor.find(params[:id])
    form_cancel_edit @tasa_valor
  end
  private

  def _list

    @tasa = Tasa.find(params[:tasa_id])
    conditions = ["tasa_valor.tasa_id = ?", @tasa.id]
    params['sort'] = "tasa_valor.fecha_resolucion_desde DESC" unless params['sort']
    
    @list = TasaValor.search(conditions, params[:page], params[:sort])
    @total=@list.count

  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.TasaValor.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.TasaValor.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.TasaValor.FormTitles.form_title_records')
    @form_entity = 'tasa_valor'
    @form_identity_field = 'resolucion'
  end

  def protect
    action = super
    return action unless action.nil?
    case action_name
    when 'list'
      nil
    when /^_/
      'edit'
    end
  end


end


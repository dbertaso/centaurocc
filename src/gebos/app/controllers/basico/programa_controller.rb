# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Basico::ProgramaController
# descripción: Migración a Rails 3
#

class Basico::ProgramaController < FormTabsController

  def list
    params['sort'] = "programa.nombre" unless params['sort']
    @condition = "programa.id > 0"
    unless params[:nombre].blank?
      @condition << [" and LOWER(programa.nombre) LIKE ?", "%#{params[:nombre].strip.downcase}%"]
      @form_search_expression << "Nombre contenga '#{params[:nombre]}'"
    end
    unless params[:alias].blank?
      @condition << [" and LOWER(programa.alias) LIKE ?", "%#{params[:alias].strip.downcase}%"]
      @form_search_expression << "Nombre Corto contenga '#{params[:alias]}'"
    end
    @list = Programa.search(@condition, params[:page], params[:sort])
    @total=@list.count
    form_list
  end

  def new
    @programa = Programa.new
    @programa.ultimo_desembolso = 2
    fill
  end

  def save_new
    @programa = Programa.new(params[:programa])
    @programa.tasa_id = 0
    @programa.tasa_mora_id = 0
    @programa.vinculo_tasa = 'f'
    form_save_new @programa

  end

  def delete
    @programa = Programa.find(params[:id])
    form_delete @programa
  end

  def edit
    @programa = Programa.find(params[:id])
    @vinculo = 'N'
    fill
  end

  def save_edit

    @programa = Programa.find(params[:id])

    success = true

    success &&= @programa.update_attributes(params[:programa])
    logger.debug @programa.inspect
    form_save_edit @programa
  end

   def view
    @programa = Programa.find(params[:id])
  end

  def tipo_credito_change
    @programa = Programa.new
    if  params[:tipo_credito_id] == "2"
      render :update do |page|
        page.hide 'error'
        page.replace_html "intermediado", :partial => "intermediado"
        page.show "intermediado"
      end
    else
      render :update do |page|
        page.hide 'error'
        page.hide "intermediado"
      end
    end
  end

  def tipocliente_list
    _tipocliente_list
  end

  def _tipocliente_list
    @programa = Programa.find(params[:id])
    @condition = ["tipocliente.programa_id = ?", @programa.id]
    joins = ["INNER JOIN tipocliente ON tipo_cliente.id = tipocliente.id"]
    params['sort'] = "tipo_cliente.nombre DESC" unless params['sort']
    @tipocliente_total = TipoCliente.count(:conditions=>conditions, :joins=>joins)
    @tipocliente_list = TipoCliente.search(@condition, params[:page], params[:sort])

    if request.xml_http_request?
      render :update do |page|
        page.replace_html "tipocliente_list", :partial => "basico/programa/tipocliente/list"
      end
    end
  end

  def tasa_historico_list
    _tasa_historico_list
  end
  def tasa_historico_list_view
    _tasa_historico_list
  end
  def _tasa_historico_list
    @programa = Programa.find(params[:id])
    @condition = ["tasa_id = ?", @programa.tasa_id]
    params['sort'] = "tasa_valor.id DESC" unless params['sort']
    @tasa_valor_total = TipoCliente.count(:conditions=>conditions, :joins=>joins)
    @tasa_valor_list = TasaValor.search(@condition, params[:page], params[:sort])

    if request.xml_http_request?
      render :update do |page|
        page.replace_html "tasa_historico_list", :partial => "basico/programa/tasa_historico/list"
      end
    end
  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.Programa.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.Programa.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.Programa.FormTitles.form_title_records')
    @form_entity = 'programa'
    @form_identity_field = 'alias'
    @width_layout = 850
  end

  private
  def fill
    @tipo_credito_list = TipoCredito.find(:all, :order=>'nombre')
    @tasa_list = Tasa.find(:all, :order=>'nombre')
    @moneda_select = Moneda.all(:conditions=>'activo = true', :order=>'nombre')
  end

  def fill_modalidad_financiamiento
    @modalidad_financiamiento_select = ModalidadFinanciamiento.find(:all, :order=>'nombre', :conditions=>"activo = true")
  end

  def fill_origen_fondo
    @origen_fondo_select = OrigenFondo.find(:all, :order=>'nombre', :conditions=>"activo = true")
  end

  def fill_recaudo
    @recaudo_select = Recaudo.find(:all, :order=>'nombre', :conditions=>"activo = true")
  end

  def fill_mision
    @mision_select = Mision.find(:all, :order=>'nombre', :conditions=>"activo = true")
  end

  def producto_fill
    @formula_select = Formula.find(:all, :order=>'nombre')
    @partida_select = Partida.find(:all, :order=>'nombre')
    if @producto.rubro
      partida_id = @producto.rubro.partida_id
    else
      partida_id = @partida_select.first.id
    end
    rubro_fill(partida_id)
  end

  def rubro_fill(partida_id)
    @rubro_select = Rubro.find_all_by_partida_id_and_activo(partida_id, true, :order=>'nombre')
    @rubro_select.first
  end

end


# encoding: utf-8
class Basico::ConfiguracionExistenciaController < FormAjaxController
  
  skip_before_filter :set_charset, :only=>[:clase_search]

  def index
    list
  end

  def list
    
    params['sort'] = "tipo_maquinaria.nombre" unless params['sort']
    conditions = "stock_maquinaria.id > 0"
    
    @list = StockMaquinaria.search(conditions, params[:page], params[:sort])
    @total=@list.count

    form_list
  end

  def new
    @tipo_maquinaria = TipoMaquinaria.find(:all, :order => "nombre")
    @marca = MarcaMaquinaria.find(:all, :conditions=>"activo = true", :order => "nombre")
    @modelo = Modelo.find(:all, :conditions => "activo = true", :order => "nombre")
    @clase = []
    @stock_maquinaria = StockMaquinaria.new
    @stock_maquinaria.id = 0
    form_new @stock_maquinaria
  end
  
  def clase_search
    if !params[:id].nil? && !params[:id].empty?
      @clase = Clase.find(:all, :conditions=>["tipo_maquinaria_id = ?", params[:id].to_s],:order=>"nombre",:select=>"id,nombre,activo")
      render :update do |page|
        page.replace_html params[:div].to_s, :partial => 'clase_search'
        page.show params[:div].to_s
      end
    else
      render :update do |page|
        @clase = []
        page.replace_html params[:div].to_s, :partial => 'clase_search'
        page.show params[:div].to_s
      end
    end
  end

  def save_new
    @stock_maquinaria = StockMaquinaria.new(params[:stock_maquinaria])
    form_save_new @stock_maquinaria
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def delete
    @stock_maquinaria = StockMaquinaria.find(params[:id])
    form_delete @stock_maquinaria
  end
  
  def edit
    @tipo_maquinaria = TipoMaquinaria.find(:all, :order => "nombre")
    @marca = MarcaMaquinaria.find(:all, :conditions=>"activo = true", :order => "nombre")
    @modelo = Modelo.find(:all, :conditions => "activo = true", :order => "nombre")
    @stock_maquinaria = StockMaquinaria.find(params[:id])
    @clase = Clase.find(:all, :conditions => "tipo_maquinaria_id = #{@stock_maquinaria.tipo_maquinaria_id}", :order => "nombre")
    form_edit @stock_maquinaria
  end
  
  def save_edit
    @stock_maquinaria = StockMaquinaria.find(params[:id])
    @stock_maquinaria.tipo_maquinaria_id = params[:stock_maquinaria][:tipo_maquinaria_id]
    @stock_maquinaria.clase_id = params[:stock_maquinaria][:clase_id]
    @stock_maquinaria.marca_maquinaria_id = params[:stock_maquinaria][:marca_maquinaria_id]
    @stock_maquinaria.modelo_id = params[:stock_maquinaria][:modelo_id]
    @stock_maquinaria.minimo = params[:stock_maquinaria][:minimo]
    @stock_maquinaria.maximo = params[:stock_maquinaria][:maximo]
    @stock_maquinaria.save
    form_save_edit @stock_maquinaria
  end

  def cancel_edit
    @stock_maquinaria = StockMaquinaria.find(params[:id])
    form_cancel_edit @stock_maquinaria
  end

  protected
  def common
   super
    @form_title = I18n.t('Sistema.Body.Controladores.ConfiguracionExistencia.FormTitles.form_title')
    @form_title_records = I18n.t('Sistema.Body.Controladores.ConfiguracionExistencia.FormTitles.form_title_records')
    @form_entity = 'abogado'
    @form_identity_field = 'clase.nombre'
    @width_layout = '950'
  end
  
end

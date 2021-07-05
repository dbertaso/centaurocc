# encoding: UTF-8

#
# autor: Diego Bertaso
# clase: Basico::AgenciaBancariaController
# descripción: Migración a Rails 3
#

class Basico::AgenciaBancariaController < FormTabsController
  
  def list
    
    params['sort'] = "agencia_bancaria.codigo" unless params['sort']

    unless params[:nombre].nil?
      conditions = ["LOWER(agencia_bancaria.nombre) LIKE ?", "%#{params[:nombre].strip.downcase}%"]
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.nombre')} '#{params[:nombre]}'"
    end
    
    unless params[:codigo].nil?
      conditions = ["LOWER(agencia_bancaria.codigo) LIKE ?", "%#{params[:codigo].strip.downcase}%"]
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.codigo')} '#{params[:nombre]}'"
    end
    logger.debug "----------------------------------------- " + params[:entidad_financiera].class.name
    unless params[:entidad_financiera].nil?
      conditions = ["entidad_financiera_id = ?", "#{params[:entidad_financiera]}"]
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.AgenciaBancariaSearch.id_entidad')} '#{params[:entidad_financiera]}'"
    end
    
    #@total = AgenciaBancaria.count(:conditions=>conditions, :include =>'entidad_financiera') 
    #@pages, @list = paginate(:agencia_bancaria, :class_name => 'AgenciaBancaria',
     #:include =>'entidad_financiera',
     #:conditions => conditions,
     #:per_page => @records_by_page,
     #:select=>'entidad_financiera.*',
     #:order_by => params['sort'])
     
    @list = AgenciaBancaria.search(conditions, params[:page], params[:sort])
    @total=@list.count
     
    form_list
  end

  def initialize
     fill_entidad_financiera
  end
 
  def new
    @agencia_bancaria = AgenciaBancaria.new
    fill
  end

  def save_new
    @agencia_bancaria = AgenciaBancaria.new(params[:agencia_bancaria])
    form_save_new @agencia_bancaria
  end
  
  def delete
    @agencia_bancaria = AgenciaBancaria.find(params[:id])
    form_delete @agencia_bancaria
  end
  
  def edit
    fill_entidad_financiera
    @agencia_bancaria = AgenciaBancaria.find(params[:id])
    fill
  end
  
  def view
    @agencia_bancaria = AgenciaBancaria.find(params[:id])
  end
  
  def save_edit
    @agencia_bancaria = AgenciaBancaria.find(params[:id])
    form_save_edit @agencia_bancaria
  end


  def fill
    @estado_list = Estado.find(:all, :order=>'nombre')
    unless @agencia_bancaria.id.nil?
      if @agencia_bancaria.estado_id
        estado_id = @agencia_bancaria.estado_id
      else
        estado_id = @estado_list[0].id
      end
    else
      estado_id = @estado_list[0].id
    end
    municipio_fill(estado_id)
  end

  def municipio_fill(estado_id)
      @municipio_list = Municipio.find(:all, :conditions=>['estado_id = ?', estado_id], :order=>'nombre')
      @ciudad_list = Ciudad.find(:all, :conditions=>['estado_id = ?', estado_id], :order=>'nombre')
  end

  def estado_change
    @municipio_list = Municipio.find(:all, :conditions=>"estado_id = #{params[:estado_id]}")
    render :update do |page|
      page.replace_html 'municipio-search', :partial => 'municipio_search'
    end
  end
  def municipio_change
    @municipio = Municipio.find(params[:municipio_id])
    @ciudad_list = Ciudad.find(:all, :conditions=>"estado_id = #{@municipio.estado_id}")
    render :update do |page|
      page.replace_html 'ciudad-search', :partial => 'ciudad_search'
    end
  end


  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.AgenciaBancaria.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.AgenciaBancaria.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.AgenciaBancaria.FormTitles.form_title_records')
    @form_entity = 'agencia_bancaria'
    @form_identity_field = 'nombre'
    @width_layout = '800'
  end
  
  private
  def fill_entidad_financiera
   @entidad_financiera_list = EntidadFinanciera.find(:all, :order=>'nombre')    
  end

end

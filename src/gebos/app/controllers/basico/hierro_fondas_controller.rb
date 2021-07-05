# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Basico::HierroFondasController
# descripción: Migración a Rails 3
#

class Basico::HierroFondasController < FormAjaxController

  skip_before_filter :set_charset, :only=>[:estado_change, :calendar]
  
  def index
    fill()
    list()
  end
  
  def list

    params['sort'] = "hierro_fondas.nombre_registro" unless params['sort']

    conditions = 'id > 0'
    
    @list = HierroFondas.search(conditions, params[:page], params[:sort])
    @total=@list.count

    form_list

  end
  
  def new
    @estado_select = Estado.find(:all, :order=>'nombre')
    @ciudad_select = []
    @municipio_select = []
    @hierro_fondas = HierroFondas.new
    form_new @hierro_fondas
  end
  
  def cancel_new
    form_cancel_new
  end
  
  def save_new
    params[:hierro_fondas][:nombre_registro].upcase!
    @hierro_fondas = HierroFondas.new(params[:hierro_fondas])
    form_save_new @hierro_fondas
    
  end
  
  def delete
    @hierro_fondas = HierroFondas.find(params[:id])
    form_delete @hierro_fondas
  end
  
  def edit
    fill()
    @hierro_fondas = HierroFondas.find(params[:id])
    form_edit @hierro_fondas
  end

  def save_edit
    params[:hierro_fondas][:nombre_registro].upcase!
    @hierro_fondas = HierroFondas.find(params[:id])
    form_save_edit @hierro_fondas
  end

  def cancel_edit
    @hierro_fondas = HierroFondas.find(params[:id])
    form_cancel_edit @hierro_fondas
  end

  def estado_change

    puts "Estado =========> " << params.inspect
    @ciudad_select = Ciudad.find(:all, :conditions=>"estado_id = #{params[:id]}", :order=>"nombre")
    logger.debug "CIUDAD SELECT ===========================> " << @ciudad_select.inspect
    @municipio_select = Municipio.find(:all, :conditions=>"estado_id = #{params[:id]}", :order=>"nombre")
    #@municipio_select = Municipio.find_by_estado_id(params[:id], :order=>"nombre")
    #@ciudad_select = Ciudad.find_by_sql("select id,nombre from sub_sector where sector_id = #{params[:id].to_s} order by nombre")
    
    render :update do |page|
      page.replace_html 'ciudad-select', :partial => 'ciudad_select'
      page.replace_html 'municipio-select', :partial => 'municipio_select'
    end
  end
  
  protected
  
  def fill
    
    @estado_select = Estado.find(:all, :order=>'nombre')
    
    if @estado_select.length == 0
       @estado_select = []
    end 

    @ciudad_select = Ciudad.find(:all, :order=>'nombre')
    
    if @ciudad_select.length == 0
       @ciudad_select = []
    end
    logger.debug "Ciudad select ==============> " <<@ciudad_select.inspect
    @municipio_select = Municipio.find(:all, :order=>'nombre')

    if @municipio_select.length == 0
       @municipio_select = []
    end
    
  end
  
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.HierroFondas.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.HierroFondas.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.HierroFondas.FormTitles.form_title_records')
    @form_entity = 'hierro_fondas'
    @form_identity_field = 'nombre_registro'
    @width_layout = '850'
  end
  
end

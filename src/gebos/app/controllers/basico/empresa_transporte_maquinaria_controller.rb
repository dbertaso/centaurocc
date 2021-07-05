# encoding: UTF-8

#
# autor: Marvin Alfonzo
# clase: Basico::EmpresaTransporteMaquinariaController
# descripción: Migración a Rails 3
#

class Basico::EmpresaTransporteMaquinariaController < FormAjaxController

    skip_before_filter :set_charset, :only=>[:estado_change]

	def index
		list
	end
	
  def list
    params['sort'] = "nombre" unless params['sort']
    
    
    conditions=''
	@list = EmpresaTransporteMaquinaria.search(conditions, 
                            params[:page], 
                            params['sort'])
    @total=@list.count
    form_list
  end
	
  def new
    fill
    @empresa_transporte_maquinaria = EmpresaTransporteMaquinaria.new
		form_new @empresa_transporte_maquinaria
  end
  
  def cancel_new
		form_cancel_new
  end

  def save_new
    @empresa_transporte_maquinaria = EmpresaTransporteMaquinaria.new(params[:empresa_transporte_maquinaria])
    @empresa_transporte_maquinaria.rif = params[:empresa_transporte_maquinaria][:rif_1] + '-' + params[:empresa_transporte_maquinaria][:rif_2] + '-' + params[:empresa_transporte_maquinaria][:rif_3]
		form_save_new @empresa_transporte_maquinaria
  end
  
  def delete
    @empresa_transporte_maquinaria = EmpresaTransporteMaquinaria.find(params[:id])
    result = @empresa_transporte_maquinaria.eliminar(params[:id])
    if result == false
      render :update do |page|
        page.form_error
      end
      return
    else
      render :update do |page|
        page.form_delete @empresa_transporte_maquinaria, 'empresa_transporte_maquinaria'
      end
    end
  end
  
  def edit
    fill
    @empresa_transporte_maquinaria = EmpresaTransporteMaquinaria.find(params[:id])
	  @ciudad_select = Ciudad.find(:all,:conditions=>"estado_id = #{@empresa_transporte_maquinaria.estado_id}", :order=>'nombre')    
    @municipio_select = Municipio.find(:all,:conditions=>"estado_id = #{@empresa_transporte_maquinaria.estado_id}", :order=>'nombre')
	form_edit @empresa_transporte_maquinaria
  end
  
  def save_edit
    @empresa_transporte_maquinaria = EmpresaTransporteMaquinaria.find(params[:id])
		form_save_edit @empresa_transporte_maquinaria
  end
  
  def cancel_edit
    @empresa_transporte_maquinaria = EmpresaTransporteMaquinaria.find(params[:id])
		form_cancel_edit @empresa_transporte_maquinaria
  end
  
  def estado_change
    if params[:id]!="" 
      @ciudad_select = Ciudad.find(:all, :conditions=>"estado_id = #{params[:id]}", :order=> "nombre")
      @municipio_select = Municipio.find(:all, :conditions=>"estado_id = #{params[:id]}", :order=> "nombre")   
    else
      @ciudad_select = []
      @municipio_select = []
    end
    render :update do |page|
      page.replace_html 'ciudad-select', :partial => 'ciudad_select'
      page.replace_html 'municipio-select', :partial => 'municipio_select'
    end
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.EmpresaTransporteMaquinaria.FormTitles.form_title')#'Empresas de Transporte de Maquinarias'
    @form_title_record = I18n.t('Sistema.Body.Controladores.EmpresaTransporteMaquinaria.FormTitles.form_title_record')#'Empresa de transporte de maquinarias'
    @form_title_records = I18n.t('Sistema.Body.Controladores.EmpresaTransporteMaquinaria.FormTitles.form_title_records')#'Empresa de transporte de maquinarias'
    @form_entity = 'empresa_transporte_maquinaria'
    @form_identity_field = 'nombre'
    @width_layout = '1000'
  end
  
  def fill
	@estado_select = Estado.find(:all, :order=>'nombre')    
    @ciudad_select = []   
    @municipio_select = []
    
  end
  
end

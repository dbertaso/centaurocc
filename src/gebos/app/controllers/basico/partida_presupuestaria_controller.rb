# encoding: utf-8
class Basico::PartidaPresupuestariaController < FormAjaxController

  def index
    list
  end
  
  def list

    params['sort'] = "nombre" unless params['sort']
    conditions = "id > 0"
    
    @list = PartidaPresupuestaria.search(conditions, params[:page], params[:sort])
    @total=@list.count

    form_list

  end

  def new
    @programas_list=Programa.find(:all,:conditions=>"activo=true",:order=>"nombre")
    @partida_presupuestaria = PartidaPresupuestaria.new
    form_new @partida_presupuestaria
  end

  def save_new
    @partida_presupuestaria = PartidaPresupuestaria.new(params[:partida_presupuestaria])
    form_save_new @partida_presupuestaria
  end

  def cancel_new
		form_cancel_new
  end
  
  def delete
    @partida_presupuestaria = PartidaPresupuestaria.find(params[:id])
    form_delete @partida_presupuestaria
  end
  
  def edit
    @programas_list=Programa.find(:all,:conditions=>"activo=true",:order=>"nombre")
    @partida_presupuestaria = PartidaPresupuestaria.find(params[:id])
    form_edit @partida_presupuestaria
  end
  
  def save_edit
    @partida_presupuestaria = PartidaPresupuestaria.find(params[:id])
    form_save_edit @partida_presupuestaria
  end
  
  def cancel_edit
    @partida_presupuestaria = PartidaPresupuestaria.find(params[:id])
    form_cancel_edit @partida_presupuestaria
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.PartidaPresupuestaria.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.PartidaPresupuestaria.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.PartidaPresupuestaria.FormTitles.form_title_records')
    @form_entity = 'partida_presupuestaria'
    @form_identity_field = 'nombre'
  end
  
end

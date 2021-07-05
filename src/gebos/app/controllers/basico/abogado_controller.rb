# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Basico::AbogadoController
# descripción: Migración a Rails 3

class Basico::AbogadoController < FormAjaxController

  def index    
    list
  end

  def list
    
    params['sort'] = "abogado.nombre" unless params['sort']
    @oficina = Oficina.find(:all, :order => 'nombre')

    conditions = "oficina_id > 0"
    
    logger.info params[:oficina_id].class.to_s
    unless params[:oficina_id].blank? 
      unless params[:oficina_id][0].blank?
        conditions = ["oficina_id = ? ", params[:oficina_id]]
        #@form_search_expression << "Id oficina '#{params[:oficina_id]}'"
      end
    end

    unless (params[:nombre].blank?)
      conditions = " LOWER(abogado.nombre) LIKE '%#{params[:nombre].strip.downcase}%'"
      #@form_search_expression << " Nombre contenga '#{params[:nombre]}'"
    end

    unless (params[:impreabogado].blank?)
      conditions = " LOWER(abogado.impreabogado) LIKE '%#{params[:impreabogado].strip.downcase}%'"
      #@form_search_expression << " impreabogado contenga '#{params[:impreabogado]}'"
    end

    if conditions.empty?
      conditions = ""
    end
    
    @list = Abogado.search(conditions, params[:page], params[:sort])
    @total=@list.count

    form_list
    
  end

  def new
    @oficina_list = Oficina.find(:all, :order=>"nombre")
    @abogado = Abogado.new
    form_new @abogado
  end

  def save_new
    @abogado = Abogado.new(params[:abogado])
    form_save_new @abogado
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def delete
    @abogado = Abogado.find(params[:id])
    form_delete @abogado
  end
  
  def edit
    @oficina_list = Oficina.find(:all, :order=>"nombre")
    @abogado = Abogado.find(params[:id])
    form_edit @abogado
  end
  
  def save_edit
    @abogado = Abogado.find(params[:id])
    form_save_edit @abogado
  end

  def cancel_edit
    @abogado = Abogado.find(params[:id])
    form_cancel_edit @abogado
  end

  protected
  def common
   super
    @form_title = I18n.t('Sistema.Body.Controladores.Abogado.FormTitles.form_title')
    @form_title_records = I18n.t('Sistema.Body.Controladores.Abogado.FormTitles.form_title_records')
    @form_entity = 'abogado'
    @form_identity_field = 'nombre'
    @form_search_expression = []
    @width_layout = '850'
  end
  
end

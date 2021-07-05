# encoding: UTF-8

#
# autor: Luis Rojas
# clase: Basico::NemonicoController
# descripción: Migración a Rails 3
#
class Basico::NemonicoController < FormAjaxController

	def index
    list
	end

  def list

    params['sort'] = "nemonico" unless params['sort']
    
    @condition = "id > 0"    
    @list = Nemonico.search(@condition, params[:page], params[:sort])
    @total=@list.count

    form_list

  end

  def new
    @nemonico = Nemonico.new
    form_new @nemonico    
  end
  
  def cancel_new
		form_cancel_new
  end

  def save_new
    @nemonico = Nemonico.new(params[:nemonico])
    form_save_new @nemonico
  end

  def delete
    @nemonico = Nemonico.find(params[:id])
    form_delete @nemonico
  end

  def edit
    @nemonico = Nemonico.find(params[:id])		
		form_edit @nemonico
  end

  def save_edit
    @nemonico = Nemonico.find(params[:id])
    form_save_edit @nemonico
  end

  def cancel_edit
    @nemonico = Nemonico.find(params[:id])
		form_cancel_edit @nemonico
  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Vistas.General.nemonico')
    @form_title_record = I18n.t('Sistema.Body.Vistas.General.nemonico')
    @form_title_records = I18n.t('Sistema.Body.Vistas.General.nemonico')
    @form_entity = 'nemonico'
    @form_identity_field = 'nombre'
    @width_layout = '955'
  end
  
end

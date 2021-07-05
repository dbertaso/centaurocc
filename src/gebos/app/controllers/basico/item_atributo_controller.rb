# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Basico::ItemAtributoController
# descripción: Migración a Rails 3
#
class Basico::ItemAtributoController < FormTabTabsController

  def index
    @item = Item.find(params[:item_id])
    @partida = Partida.find(@item.partida_id)
    @actividad = @partida.actividad
    @sub_rubro = @actividad.sub_rubro
    @rubro = @sub_rubro.rubro
    @sub_sector = @rubro.sub_sector
    @sector = @sub_sector.sector
    list
  end

  def list
    _list
    form_list
  end

  def new
    @item = Item.find(params[:item_id])
    @item_atributo = ItemAtributo.new
    @partida = @item.partida
    @actividad = @partida.actividad
    @sub_rubro = @actividad.sub_rubro
    @rubro = @sub_rubro.rubro
    @sub_sector = @rubro.sub_sector
    @sector = @sub_sector.sector
  end

  def view
    list_view
  end

  def list_view
    _list
    form_list_view
  end

  def save_new
    if params[:item_atributo]["tipo"] == 'C'
      if params[:item_atributo]["tabla_combo"].nil? ||
        params[:item_atributo]["tabla_combo"] == ''
        render :update do |page|
          page.alert('El nombre de la tabla es obligatorio')
        end
        return
      end
    end
    @item = Item.find(params[:item_id])
    @item_atributo = ItemAtributo.new(params[:item_atributo])
    @item_atributo.item = @item
    form_save_new @item_atributo
  end

  def edit
    @item_atributo = ItemAtributo.find(params[:id])
    @item = @item_atributo.item
    @partida = @item.partida
    @actividad = @partida.actividad
    @sub_rubro = @actividad.sub_rubro
    @rubro = @sub_rubro.rubro
    @sub_sector = @rubro.sub_sector
    @sector = @sub_sector.sector
  end

  def save_edit
    if params[:item_atributo]["tipo"] == 'C'
      if params[:item_atributo]["tabla_combo"].nil? ||
        params[:item_atributo]["tabla_combo"] == ''
        render :update do |page|
          page.alert('El nombre de la tabla es obligatorio')
        end
        return
      end
    end
    @item_atributo = ItemAtributo.find(params[:id])
    form_save_edit @item_atributo
  end

  def cancel_edit
    @item_atributo = ItemAtributo.find(params[:id])
    form_cancel_edit @item_atributo
  end

  def cancel_new
    form_cancel_new
  end

  def delete
    @item_atributo = ItemAtributo.find(params[:id])
    form_delete @item_atributo
  end

  private
  def _list
    @item = Item.find(params[:item_id])
    conditions = ["item_atributo.item_id = ?", @item.id]
    params['sort'] = "id ASC" unless params['sort']
    
    @list = ItemAtributo.search(conditions, params[:page], params[:sort])
    @total=@list.count
  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.ItemAtributo.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.ItemAtributo.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.ItemAtributo.FormTitles.form_title_records')
    @form_entity = 'item_atributo'
    @form_identity_field = 'nombre'
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


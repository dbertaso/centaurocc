# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Basico::ItemController
# descripción: Migración a Rails 3
#
class Basico::ItemController < FormTabTabsController

  def index
    @partida = Partida.find(params[:partida_id])
    @actividad = @partida.actividad
    @sub_rubro = @actividad.sub_rubro
    @rubro = @sub_rubro.rubro
    @sub_sector = @rubro.sub_sector
    @sector = @sub_sector.sector
    list
  end

  def list
    params['sort'] = "item.nombre" unless params['sort']
    @condition = "partida_id = #{params[:partida_id]} and actividad_id = #{@partida.actividad.id.to_s}"
    
    @list = Item.search(@condition, params[:page], params[:sort])
    @total=@list.count
    form_list

  end

  def new
    @partida = Partida.find(params[:partida_id])
    @actividad = @partida.actividad
    @sub_rubro = @actividad.sub_rubro
    @rubro = @sub_rubro.rubro
    @sub_sector = @rubro.sub_sector
    @sector = @sub_sector.sector
    @unidad_medida_select = UnidadMedida.find(:all, :order=>"nombre")
    @codigo_actual = Item.find(:first, :order=>"codigo DESC")
    @item = Item.new
  end

  def save_new
    nombre = eliminar_acentos(params[:item][:nombre])
    params[:item][:nombre] = nombre.upcase
    @item = Item.new(params[:item])
    @item.partida_id = params[:partida_id]
    @item.actividad_id = @item.partida.actividad.id
    form_save_new @item
  end

  def delete
    @item = Item.find(params[:id])
    result = @item.eliminar(params[:id])
    if result == false
      render :update do |page|
        page.form_error
      end
      return
    else
      render :update do |page|
        page.form_delete @item, 'item'
      end
    end
  end

  def edit
    @item = Item.find(params[:id])
    @partida = Partida.find(@item.partida_id)
    @actividad = @partida.actividad
    @unidad_medida_select = UnidadMedida.find(:all, :order=>"nombre")
    @sub_rubro = @actividad.sub_rubro
    @rubro = @sub_rubro.rubro
    @sub_sector = @rubro.sub_sector
    @sector = @sub_sector.sector
  end

  def view
    @partida = Partida.find(params[:partida_id])
    @rubro = @partida.rubro
    @sub_sector = @rubro.sub_sector
    @sector = @sub_sector.sector
    @item = Item.find(params[:id])

  end

  def save_edit
    nombre = eliminar_acentos(params[:item][:nombre])
    params[:item][:nombre] = nombre.upcase
    @item = Item.find(params[:id])
    form_save_edit @item
  end


  protected
  def item_fill
    @item = Item.find
    @unidad_medida_select = UnidadMedida.find(:all, :order=>"nombre")
  end

  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.Item.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.Item.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.Item.FormTitles.form_title_records')
    @form_entity = 'item'
    @form_identity_field = 'nombre'
    @width_layout = 1000
  end


end

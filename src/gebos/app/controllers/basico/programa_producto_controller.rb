# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Basico::ProgramaProductoController
# descripción: Migración a Rails 3
#
class Basico::ProgramaProductoController < FormTabTabsController

  skip_before_filter :set_charset, :only=>[:sector_change, :permitir_abonos_change, :meses_gracia_si_change, :meses_muertos_si_change]

  def index
    list
  end

  def list
    _list
    form_list
  end

  def view
    list_view
  end

  def list_view
    _list
    form_list_view
  end

  def view_detail
    @programa = Programa.find(params[:programa_id])
    @producto = Producto.find(params[:id])
  end

  def new
    @programa = Programa.find(params[:programa_id])
    @producto = Producto.new
    producto_fill
  end

  def save_new
    @programa = Programa.find(params[:programa_id])
    @producto = Producto.new(params[:producto])

    form_save_new @producto,
      :value=>@programa.add_producto(@producto),
      :params=> { :id=>@producto.id, :programa_id => @programa.id }
  end

  def edit
    @programa = Programa.find(params[:programa_id])
    @producto = Producto.find(params[:id])
    producto_fill
  end

  def save_edit
    @programa = Programa.find(params[:programa_id])
    @producto = Producto.find(params[:id])

    form_save_edit @producto, :params=> { :id=>@producto.id, :programa_id => @programa.id }
  end

  def delete
    @programa = Programa.find(params[:programa_id])
    @producto = Producto.find(params[:id])
    form_delete @producto
  end

  def permitir_abonos_change
    @producto = Producto.new
    if  params[:permitir_abonos] == "true"
      render :update do |page|
        page.hide 'error'
        page.replace_html "abonos", :partial => "abonos"
        page.show "abonos"
      end
    else
      render :update do |page|
        page.hide 'error'
        page.hide "abonos"
      end
    end
  end

  def meses_gracia_si_change
    @producto = Producto.new
    if  params[:meses_gracia_si] == "true"
      render :update do |page|
        page.hide 'error'
        page.replace_html "gracia", :partial => "gracia", :locals=>{:producto => @producto}
        page.show "gracia"
      end
    else
      render :update do |page|
        page.hide 'error'
        page.hide "gracia"
      end
    end
  end

  def meses_muertos_si_change
    @producto = Producto.new
    if  params[:meses_muertos_si] == "true"
      render :update do |page|
        page.hide 'error'
        page.replace_html "muertos", :partial => "muertos", :locals=>{:producto => @producto}
        page.show "muertos"
      end
    else
      render :update do |page|
        page.hide 'error'
        page.hide "muertos"
      end
    end
  end

  def diferir_intereses_change
    if  params[:diferir_intereses] == "true"
      render :update do |page|
        page.hide 'error'
        page.replace_html "diferimiento", :partial => "diferimiento"
        page.show "diferimiento"
      end
    else
      render :update do |page|
        page.hide 'error'
        page.hide "diferimiento"
      end
    end
  end

  def sector_change

    @sub_sector_select = SubSector.find(:all,
      :conditions=> ["sector_id = #{params[:id].to_s} and id not in (select sub_sector_id from producto where programa_id = #{params[:programa_id].to_s})"])

    render :update do |page|
      page.replace_html 'sub-sector-select', :partial => 'sub_sector_select'
    end
  end


  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.ProgramaProducto.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.ProgramaProducto.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.ProgramaProducto.FormTitles.form_title_records')
    @form_entity = 'producto'
    @form_identity_field = 'sector.nombre'
    @width_layout = 850
  end

  private
  def producto_fill
    @sector_select = Sector.find(:all, :order=>'nombre')
    @sub_sector_select = SubSector.find(:all, :order=>'nombre',
      :conditions=>[" id not in (select sub_sector_id from producto where programa_id = ?) ", @programa.id])

    if @producto.sector
      sector_id = @producto.sector_id
    elsif @sector_select.length > 0
      sector_id = @sector_select.first.id
    end
    if @producto.sub_sector
      sub_sector_id = @producto.sub_sector_id
    elsif @sub_sector_select.length > 0
      sub_sector_id = @sub_sector_select.first.id
    end
  end

  def _list
    @programa = Programa.find(params[:programa_id])
    conditions = ["producto.programa_id = ?", @programa.id]
    params['sort'] = "nombre_sector" unless params['sort']
    @list = Producto.search(conditions, params[:page], params[:sort])
    @total=@list.count
  end

end

